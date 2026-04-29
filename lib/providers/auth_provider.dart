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

  bool get isAdmin => _role.toLowerCase() == 'administrateur';

  bool get isUtilisateur => _role.toLowerCase() == 'utilisateur';


  Future<bool> _hasInternetConnection() async {
    try {
      final results = await Connectivity().checkConnectivity();
      return results.isNotEmpty &&
          results.any((r) => r != ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }

  ///Mot de passe ashé pour le local
  String _hashPassword(String password) {
    int hash = 0;
    for (int i = 0; i < password.length; i++) {
      hash = (hash * 31 + password.codeUnitAt(i)) & 0xFFFFFFFF;
    }
    return hash.toString();
  }

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

  Future<bool> _checkLocalCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final hasCreds = prefs.getBool(_keyHasSavedCredentials) ?? false;
    if (!hasCreds) return false;

    final savedEmail = prefs.getString(_keyEmail) ?? '';
    final savedHash = prefs.getString(_keyPasswordHash) ?? '';

    return savedEmail == email && savedHash == _hashPassword(password);
  }

  Future<void> _loadLocalProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString(_keyName) ?? 'Utilisateur';
    _email = prefs.getString(_keyEmail) ?? '';
    _role = prefs.getString(_keyRole) ?? 'utilisateur';
  }

  Future<bool> hasSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasSavedCredentials) ?? false;
  }


  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    String? result;
    final isConnected = await _hasInternetConnection();

    if (isConnected) {
      result = await _loginOnline(email, password);
    } else {
      result = await _loginOffline(email, password);
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<String?> _loginOnline(String email, String password) async {
    try {
      debugPrint('🌐 Tentative de connexion online pour : $email');

      final user = await apiClient.auth.login(email, password);

      if (user != null) {
        debugPrint('✅ Connexion réussie : ${user.email} (rôle: ${user.role})');

        _name = user.nom;
        _email = user.email;
        _role = user.role;
        _isAuthenticated = true;
        _isOfflineMode = false;

        // Sauvegarde pour futures connexions offline
        await _saveCredentialsLocally(email, password, user.nom, user.role);

        notifyListeners();
        return null;
      } else {
        debugPrint('❌ Serveur a retourné null pour $email');
        return 'Email ou mot de passe incorrect.';
      }
    } catch (e) {
      debugPrint('❌ Exception lors du login online : $e');
      // Le serveur est injoignable → tentative offline
      return await _loginOffline(email, password);
    }
  }

  Future<String?> _loginOffline(String email, String password) async {
    debugPrint('📴 Tentative de connexion offline pour : $email');

    final isValid = await _checkLocalCredentials(email, password);

    if (isValid) {
      await _loadLocalProfile();
      _isAuthenticated = true;
      _isOfflineMode = true;
      notifyListeners();
      debugPrint('✅ Connexion offline réussie pour $email');
      return null;
    } else {
      final hasCreds = await hasSavedCredentials();
      if (!hasCreds) {
        return 'Première connexion impossible hors ligne.\n'
            'Veuillez vous connecter au moins une fois avec internet.';
      }
      return 'Email ou mot de passe incorrect.';
    }
  }

  Future<bool> updateProfile(String newName, String newRole) async {
    if (_isOfflineMode) {
      debugPrint('❌ Mise à jour impossible en mode hors ligne.');
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final isConnected = await _hasInternetConnection();
      if (!isConnected) {
        debugPrint('❌ Pas de connexion pour mettre à jour le profil.');
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final success = await apiClient.auth.updateUser(
        sp.Utilisateur(
          nom: newName,
          role: newRole,
          email: _email,
          motDePasse: '',
        ),
      );

      if (success) {
        _name = newName;
        _role = newRole;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyName, newName);
        await prefs.setString(_keyRole, newRole);

        debugPrint('✅ Profil mis à jour : $newName / $newRole');
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('❌ Erreur update profil : $e');
    }

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