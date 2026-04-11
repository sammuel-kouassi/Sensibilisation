import 'package:flutter/material.dart';
import '../core/api_client.dart';
import 'package:dlf_backend_client/dlf_backend_client.dart' as sp;

class AuthProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _role = '';
  bool _isAuthenticated = false;
  bool _isLoading = false;

  String get name => _name;
  String get email => _email;
  String get role => _role;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get isAdmin => _role.toLowerCase() == 'admin';

  Future<String?> login(String email, String password) async {
    try {
      final user = await apiClient.auth.login(email, password);
      if (user != null) {
        _name = user.nom;
        _email = user.email;
        _role = user.role;
        _isAuthenticated = true;
        notifyListeners();
        return null;
      } else {
        return 'Email ou mot de passe incorrect.';
      }
    } catch (e) {
      return 'Impossible de joindre le serveur.';
    }
  }

  // ✅ CORRIGÉ : Utilisation de sp.Utilisateur
  Future<bool> updateProfile(String newName, String newRole) async {
    _isLoading = true;
    notifyListeners();

    try {
      // On crée l'objet Utilisateur attendu par le serveur
      final success = await apiClient.auth.updateUser(
        sp.Utilisateur(
          nom: newName,
          role: newRole,
          email: _email,
          motDePasse: '', // Le mot de passe n'est pas modifié ici
        ),
      );

      if (success) {
        _name = newName;
        _role = newRole;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('❌ Erreur update : $e');
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
    notifyListeners();
  }
}
