import 'package:flutter/material.dart';
// Importe ta barre de navigation (l'écran d'accueil après connexion)
import 'package:cie_services/views/widgets/bottomNavigationBarWidgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- LOGIQUE DE CONNEXION ---
  Future<void> _onLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavigationBarWidget()),
      );
    }
  }

  void _onForgotPassword() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer votre email pour réinitialiser le mot de passe.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Un lien de réinitialisation a été envoyé à ${_emailController.text}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // --- 1. LE FOND DÉGRADÉ ---
          Container(
            width: double.infinity,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF21951D), Color(0xFFFF8000)], // Orange CIE -> Vert SODECI
              ),
            ),
          ),

          // --- 2. LE LOGO ET LES TITRES ---
          Positioned(
            top: size.height * 0.10, // S'adapte à la taille de l'écran
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.bolt, color: Color(0xFFFF8000), size: 45),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'CIE - SODECI',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'DLF | Sensibilisation',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.60,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Connexion',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Entrez vos identifiants pour continuer',
                          style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 32),

                        // --- CHAMP EMAIL ---
                        const Text('Email', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration(hint: 'votre.email@cie.ci'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Veuillez entrer votre email';
                            // Regex pour forcer un vrai format email
                            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(v)) return 'Format d\'email invalide';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // --- CHAMP MOT DE PASSE ---
                        const Text('Mot de passe', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: _inputDecoration(
                            hint: '••••••••',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey[500],
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (v) => v == null || v.isEmpty ? 'Veuillez entrer votre mot de passe' : null,
                        ),
                        const SizedBox(height: 12),

                        // --- MOT DE PASSE OUBLIÉ ---
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _onForgotPassword,
                            child: const Text(
                              'Mot de passe oublié ?',
                              style: TextStyle(color: Color(0xFFFF8000), fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _onLogin, // Désactivé pendant le chargement
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF8000),
                              disabledBackgroundColor: const Color(0xFFFF8000).withValues(alpha: 0.6),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                            )
                                : const Text(
                              'Se connecter',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),

                        // Espace pour repousser le copyright vers le bas
                        const SizedBox(height: 40),

                        // --- COPYRIGHT ---
                        Center(
                          child: Text(
                            'CIE-SODECI © 2026 - Tous droits réservés',
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 40),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- DESIGN DES CHAMPS DE SAISIE ---
  InputDecoration _inputDecoration({required String hint, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFF8000), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }
}