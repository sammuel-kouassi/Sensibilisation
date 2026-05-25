import 'package:flutter/material.dart';
import 'package:cie_services/views/widgets/bottomNavigationBarWidgets.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import '../../providers/auth_provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const routeName = '/login';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isOffline = false;
  bool _hasSavedCredentials = false;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  static const _orange = Color(0xFFFF8000);
  static const _vert = Color(0xFF21951D);
  static const _dark = Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _checkSavedCredentials();

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) {
          if (mounted) {
            setState(() => _isOffline =
                results.isEmpty ||
                    results.every((r) => r == ConnectivityResult.none));
          }
        });
  }

  Future<void> _checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() => _isOffline =
          results.isEmpty ||
              results.every((r) => r == ConnectivityResult.none));
    }
  }

  Future<void> _checkSavedCredentials() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final has = await authProvider.hasSavedCredentials();
    if (mounted) setState(() => _hasSavedCredentials = has);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final errorMessage = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (errorMessage == null) {
        if (authProvider.isOfflineMode) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.wifi_off_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Connecté en mode hors ligne. Synchronisation dès le retour du réseau.',
                    ),
                  ),
                ],
              ),
              backgroundColor: _orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 4),
            ),
          );
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavigationBarWidget(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  void _onForgotPassword() {
    if (_isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.wifi_off_rounded, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text('Impossible en mode hors ligne.'),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text('Entrez votre email pour réinitialiser.'),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                    'Lien envoyé à ${_emailController.text}'),
              ),
            ],
          ),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
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
          // ── Fond dégradé ──
          Container(
            width: double.infinity,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_vert, Color(0xFF167013), _orange],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Cercles décoratifs
          Positioned(
            right: -50, top: -50,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            left: -30, top: size.height * 0.15,
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),

          // ── En-tête ──
          Positioned(
            top: size.height * 0.06,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Logo
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/images/logo_gs2e.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                    children: [
                      TextSpan(
                        text: 'DLF ',
                        style: TextStyle(color: _orange),
                      ),
                      TextSpan(
                        text: '| ',
                        style: TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      TextSpan(
                        text: 'Sensibilisation',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Text(
                    'CIE - SODECI',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.5,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Bandeau hors ligne
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _isOffline
                      ? Container(
                    key: const ValueKey('offline'),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wifi_off_rounded,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mode hors ligne',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                _hasSavedCredentials
                                    ? 'Connexion possible avec vos identifiants sauvegardés'
                                    : 'Première connexion impossible sans réseau',
                                style: TextStyle(
                                  color: _hasSavedCredentials
                                      ? Colors.white70
                                      : Colors.orangeAccent,
                                  fontSize: 11,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox.shrink(key: ValueKey('online')),
                ),
              ],
            ),
          ),

          // ── Formulaire ──
          Positioned(
            bottom: 0, left: 0, right: 0,
            height: size.height * 0.58,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: 0.0),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => Transform.translate(
                offset: Offset(0, value * 80),
                child: Opacity(opacity: 1.0 - value, child: child),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 24,
                      offset: Offset(0, -6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 30, 28, 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Titre formulaire ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Connexion',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: _dark,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              if (_isOffline) ...[
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _orange.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Hors ligne',
                                    style: TextStyle(
                                      color: _orange,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 24),

                          // ── Email ──
                          _fieldLabel('Email professionnel'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDecoration(
                              hint: 'votre.email@cie.ci',
                              prefixIcon: Icons.email_outlined,
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Veuillez entrer votre email';
                              }
                              final emailRegex = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(v)) {
                                return 'Format d\'email invalide';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          // ── Mot de passe ──
                          _fieldLabel('Mot de passe'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: _inputDecoration(
                              hint: '••••••••',
                              prefixIcon: Icons.lock_outline_rounded,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                                onPressed: () => setState(() =>
                                _isPasswordVisible =
                                !_isPasswordVisible),
                              ),
                            ),
                            validator: (v) =>
                            v == null || v.isEmpty
                                ? 'Veuillez entrer votre mot de passe'
                                : null,
                          ),

                          // ── Mot de passe oublié ──
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _onForgotPassword,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 8),
                                minimumSize: Size.zero,
                                tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Mot de passe oublié ?',
                                style: TextStyle(
                                  color: _isOffline
                                      ? Colors.grey[400]
                                      : _orange,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ── Bouton connexion ──
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _onLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _orange,
                                disabledBackgroundColor:
                                _orange.withValues(alpha: 0.6),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 24, height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                                  : Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  if (_isOffline) ...[
                                    const Icon(Icons.wifi_off_rounded,
                                        color: Colors.white, size: 18),
                                    const SizedBox(width: 8),
                                  ],
                                  Text(
                                    _isOffline
                                        ? 'Se connecter hors ligne'
                                        : 'Se connecter',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          Center(
                            child: Text(
                              'CIE-SODECI © 2026 — Tous droits réservés',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
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

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: _dark,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Icon(prefixIcon,
          color: Colors.grey[400], size: 20),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
            color: Color(0xFFEEF0F3), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _orange, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
            color: Colors.red.withValues(alpha: 0.5), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
        const BorderSide(color: Colors.red, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
          vertical: 16, horizontal: 16),
    );
  }
}