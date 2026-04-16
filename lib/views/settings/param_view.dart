import 'package:cie_services/views/settings/widgets/data_management_view.dart';
import 'package:cie_services/views/settings/widgets/edit_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../login/login_views.dart';
import '../widgets/animated_section.dart';
import 'widgets/param_header.dart';
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

  void _showChangePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sécurité',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                labelText: 'Ancien mot de passe',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Demande de changement envoyée'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text(
                  'Mettre à jour',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showAppearanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apparence'),
        content: const Text(
          'Le mode sombre sera disponible dans la prochaine version (v1.1.0).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isAdmin = authProvider.isAdmin;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            const AnimatedSection(delayMs: 0, child: ParamHeader()),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    AnimatedSection(
                      delayMs: 150,
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

                    // --- SECTION COMPTE ---
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
                    ], delay: 300),

                    // --- SECTION APPLICATION ---
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
                    ], delay: 450),

                    // --- SECTION INFORMATIONS ---
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
                              color: Colors.orange,
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
                            builder: (ctx) => AlertDialog(
                              title: const Text('Déconnexion'),
                              content: const Text(
                                'Voulez-vous vraiment vous déconnecter ?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text(
                                    'Annuler',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    authProvider.logout();

                                    Navigator.pop(ctx);

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginView(),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                  child: const Text(
                                    'Se déconnecter',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ], delay: 600),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items, {required int delay}) {
    return AnimatedSection(
      delayMs: delay,
      child: Column(
        children: [
          const SizedBox(height: 24),
          SettingSection(title: title, children: items),
        ],
      ),
    );
  }
}
