import 'package:cie_services/views/settings/widgets/data_management_view.dart';
import 'package:cie_services/views/settings/widgets/edit_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../login/login_views.dart';
import '../widgets/animated_section.dart';
import 'widgets/profile_card.dart';
import 'widgets/setting_section.dart';
import 'widgets/setting_item_clickable.dart';
import 'widgets/setting_item_toggle.dart';
import 'widgets/setting_item_logout.dart';

class ParamView extends StatefulWidget {
  const ParamView({super.key});

  @override
  State<ParamView> createState() => _ParamViewState();
}

class _ParamViewState extends State<ParamView> {
  bool _notificationsEnabled = true;

  static const _orange = Color(0xFFFF8000);
  static const _dark = Color(0xFF1E293B);

  void _showChangePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 24,
          right: 24,
          top: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: _orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.shield_outlined,
                      color: _orange, size: 18),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Sécurité',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _dark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildPasswordField('Ancien mot de passe', Icons.lock_outline_rounded),
            const SizedBox(height: 14),
            _buildPasswordField('Nouveau mot de passe', Icons.lock_reset_rounded),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _orange,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: Colors.white, size: 18),
                          SizedBox(width: 10),
                          Text('Demande de changement envoyée'),
                        ],
                      ),
                      backgroundColor: Colors.green[700],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Mettre à jour',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, IconData icon) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEEF0F3), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _orange, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
      ),
    );
  }

  void _showAppearanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: _orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.palette_outlined,
                        color: _orange, size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Apparence',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: _dark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Le mode sombre sera disponible dans la prochaine version (v1.1.0).',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: _orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Compris',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isAdmin = authProvider.isAdmin;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(
        slivers: [
          // ── AppBar gradient ──
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: _orange,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_orange, Color(0xFFe06b00)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20, top: -20,
                      child: Container(
                        width: 140, height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.07),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30, bottom: -10,
                      child: Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Paramètres',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.3,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Gérez votre compte et l\'application',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Contenu ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  // ── Carte profil ──
                  AnimatedSection(
                    delayMs: 100,
                    child: ProfileCard(
                      name: authProvider.name,
                      email: authProvider.email,
                      role: authProvider.role,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileView(),
                        ),
                      ),
                    ),
                  ),

                  // ── Compte ──
                  _buildSection('COMPTE', [
                    SettingItemClickable(
                      icon: Icons.person_outline,
                      title: 'Profil utilisateur',
                      subtitle: 'Modifier vos informations',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileView(),
                        ),
                      ),
                      showDivider: true,
                    ),
                    SettingItemToggle(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Gérer les alertes push',
                      value: _notificationsEnabled,
                      onChanged: (v) =>
                          setState(() => _notificationsEnabled = v),
                      showDivider: false,
                    ),
                  ], delay: 200),

                  // ── Application ──
                  _buildSection('APPLICATION', [
                    SettingItemClickable(
                      icon: Icons.palette_outlined,
                      title: 'Apparence',
                      subtitle: 'Thème et affichage',
                      onTap: () => _showAppearanceDialog(context),
                      showDivider: true,
                    ),
                    SettingItemClickable(
                      icon: Icons.storage_outlined,
                      title: 'Données & rapports',
                      subtitle: 'Gestion des exports CSV',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DataManagementView(),
                        ),
                      ),
                      showDivider: true,
                      isEnabled: isAdmin,
                    ),
                    SettingItemClickable(
                      icon: Icons.shield_outlined,
                      title: 'Sécurité',
                      subtitle: 'Modifier le mot de passe',
                      onTap: () => _showChangePasswordSheet(context),
                      showDivider: false,
                      isEnabled: isAdmin,
                    ),
                  ], delay: 300),

                  // ── Informations ──
                  _buildSection('INFORMATIONS', [
                    SettingItemClickable(
                      icon: Icons.info_outlined,
                      title: 'À propos',
                      subtitle: 'CIE App v1.0.0',
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'DLF Sensibilisation',
                          applicationVersion: '1.0.0',
                          applicationIcon: const Icon(
                            Icons.bolt,
                            color: Color(0xFFFF8000),
                            size: 40,
                          ),
                          children: [
                            const Text(
                              'Application officielle de sensibilisation pour les agents CIE-SODECI.',
                            ),
                          ],
                        );
                      },
                      showDivider: true,
                    ),
                    SettingItemLogout(
                      icon: Icons.logout,
                      title: 'Déconnexion',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 36, height: 36,
                                        decoration: BoxDecoration(
                                          color: Colors.red
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                            Icons.logout_rounded,
                                            color: Colors.red,
                                            size: 18),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Déconnexion',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: _dark,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8F9FA),
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Voulez-vous vraiment vous déconnecter ?',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () =>
                                              Navigator.pop(ctx),
                                          child: Container(
                                            height: 46,
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                  0xFFF5F6FA),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  14),
                                              border: Border.all(
                                                color: const Color(
                                                    0xFFEEF0F3),
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Annuler',
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.w700,
                                                  color: _dark,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            authProvider.logout();
                                            Navigator.pop(ctx);
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                const LoginView(),
                                              ),
                                                  (route) => false,
                                            );
                                          },
                                          child: Container(
                                            height: 46,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  14),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.red
                                                      .withValues(
                                                      alpha: 0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(
                                                      0, 3),
                                                ),
                                              ],
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Se déconnecter',
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.w800,
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ], delay: 400),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      String title,
      List<Widget> items, {
        required int delay,
      }) {
    return AnimatedSection(
      delayMs: delay,
      child: Column(
        children: [
          const SizedBox(height: 20),
          SettingSection(title: title, children: items),
        ],
      ),
    );
  }
}