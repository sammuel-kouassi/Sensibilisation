import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../core/api_client.dart';
import 'package:dlf_backend_client/dlf_backend_client.dart' as sp;

class AuthProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _role = '';
  bool _isAuthenticated = false;
  bool _isLoading = false;
  bool _isOfflineMode = false;

  // Clés SharedPreferences
  static const String _keyName = 'auth_name';
  static const String _keyEmail = 'auth_email';
  static const String _keyRole = 'auth_role';
  static const String _keyPasswordHash = 'auth_password_hash';
  static const String _keyHasSavedCredentials = 'auth_has_credentials';

  String get name => _name;
  String get email => _email;
  String get role => _role;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get isOfflineMode => _isOfflineMode;
  bool get isAdmin => _role.toLowerCase() == 'admin';

  /// Vérifie si une connexion réseau est disponible
  Future<bool> _hasInternetConnection() async {
    try {
      final results = await Connectivity().checkConnectivity();
      return results.isNotEmpty &&
          results.any((r) => r != ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }

  /// Hash simple du mot de passe pour stockage local (non transmis)
  String _hashPassword(String password) {
    int hash = 0;
    for (int i = 0; i < password.length; i++) {
      hash = (hash * 31 + password.codeUnitAt(i)) & 0xFFFFFFFF;
    }
    return hash.toString();
  }

  /// Sauvegarde les credentials localement après une connexion online réussie
  Future<void> _saveCredentialsLocally(
      String email,
      String password,
      String name,
      String role,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyRole, role);
    await prefs.setString(_keyPasswordHash, _hashPassword(password));
    await prefs.setBool(_keyHasSavedCredentials, true);
  }

  /// Vérifie les credentials sauvegardés localement
  Future<bool> _checkLocalCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final hasCreds = prefs.getBool(_keyHasSavedCredentials) ?? false;
    if (!hasCreds) return false;

    final savedEmail = prefs.getString(_keyEmail) ?? '';
    final savedHash = prefs.getString(_keyPasswordHash) ?? '';

    return savedEmail == email && savedHash == _hashPassword(password);
  }

  /// Charge le profil local sauvegardé
  Future<void> _loadLocalProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString(_keyName) ?? 'Utilisateur';
    _email = prefs.getString(_keyEmail) ?? '';
    _role = prefs.getString(_keyRole) ?? 'agent';
  }

  /// Vérifie s'il y a des credentials sauvegardés (pour afficher l'option offline)
  Future<bool> hasSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasSavedCredentials) ?? false;
  }

  /// Connexion principale — tente online, bascule offline si nécessaire
  Future<String?> login(String email, String password) async {
    final isConnected = await _hasInternetConnection();

    if (isConnected) {
      return await _loginOnline(email, password);
    } else {
      return await _loginOffline(email, password);
    }
  }

  /// Connexion online via l'API
  Future<String?> _loginOnline(String email, String password) async {
    try {
      final user = await apiClient.auth.login(email, password);
      if (user != null) {
        _name = user.nom;
        _email = user.email;
        _role = user.role;
        _isAuthenticated = true;
        _isOfflineMode = false;

        // ✅ On sauvegarde les credentials pour les futures connexions offline
        await _saveCredentialsLocally(email, password, user.nom, user.role);

        notifyListeners();
        return null;
      } else {
        return 'Email ou mot de passe incorrect.';
      }
    } catch (e) {
      // Le serveur est injoignable malgré la connexion — on tente offline
      return await _loginOffline(email, password);
    }
  }

  /// Connexion offline avec les credentials sauvegardés
  Future<String?> _loginOffline(String email, String password) async {
    final isValid = await _checkLocalCredentials(email, password);

    if (isValid) {
      await _loadLocalProfile();
      _isAuthenticated = true;
      _isOfflineMode = true;
      notifyListeners();
      return null;
    } else {
      final hasCreds = await hasSavedCredentials();
      if (!hasCreds) {
        return 'Aucune session sauvegardée. Une connexion internet est requise pour la première connexion.';
      }
      return 'Email ou mot de passe incorrect.';
    }
  }

  /// ✅ Mise à jour du profil avec vérification de la connectivité
  Future<bool> updateProfile(String newName, String newRole) async {
    // 1. Empêcher la modification si on est sciemment en mode hors ligne
    if (_isOfflineMode) {
      debugPrint('❌ Impossible de mettre à jour le profil en mode hors ligne.');
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // 2. Double vérification du réseau avant l'appel Serverpod
      final isConnected = await _hasInternetConnection();
      if (!isConnected) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // 3. Appel au backend
      // Si ta méthode est dans UtilisateurEndpoint au lieu de AuthEndpoint,
      // remplace apiClient.auth.updateUser par apiClient.utilisateur.updateUser
      final success = await apiClient.auth.updateUser(
        sp.Utilisateur(
          nom: newName,
          role: newRole,
          email: _email,
          motDePasse: '', // Requis par le modèle, mais ignoré par la mise à jour
        ),
      );

      if (success) {
        // 4. Mise à jour de l'état local
        _name = newName;
        _role = newRole;

        // 5. Mise à jour des SharedPreferences (pour le prochain login offline)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyName, newName);
        await prefs.setString(_keyRole, newRole);

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('❌ Erreur update : $e');
    }

    // En cas d'échec ou d'exception
    _isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _name = '';
    _email = '';
    _role = '';
    _isAuthenticated = false;
    _isOfflineMode = false;
    notifyListeners();
  }
}