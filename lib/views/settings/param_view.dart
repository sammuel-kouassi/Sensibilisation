import 'package:flutter/material.dart';

// Imports Model & Data
import '../../data/param_data.dart';

// Imports Widgets
import '../widgets/animated_section.dart';
import 'widgets/param_header.dart';
import 'widgets/profile_card.dart';
import 'widgets/setting_section.dart';
import 'widgets/setting_item_clickable.dart';
import 'widgets/setting_item_toggle.dart';
import 'widgets/setting_item_logout.dart';

// Import de ton widget d'animation réutilisable !
// import '../../widgets/animated_section.dart';

class ParamView extends StatefulWidget {
  const ParamView({super.key});

  @override
  State<ParamView> createState() => _ParamViewState();
}

class _ParamViewState extends State<ParamView> {
  bool _notificationsEnabled = true;

  void _onProfileTap() {
    debugPrint('👤 Profil utilisateur cliqué');
  }

  void _onNotificationsToggle(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    debugPrint('🔔 Notifications: ${value ? "Activées" : "Désactivées"}');
  }

  @override
  Widget build(BuildContext context) {
    // Récupération des données depuis le fichier data
    final currentUser = ParamData.getCurrentUser();
    final appInfo = ParamData.getAppInfo();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // 1. LE HEADER FIXE (Apparaît immédiatement)
            const AnimatedSection(
              delayMs: 0,
              child: ParamHeader(),
            ),

            // 2. LA ZONE DE DÉFILEMENT ANIMÉE
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Carte de profil (Cascade à 150ms)
                    AnimatedSection(
                      delayMs: 150,
                      child: ProfileCard(
                        user: currentUser,
                        onTap: _onProfileTap,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section Compte (Cascade à 300ms)
                    AnimatedSection(
                      delayMs: 300,
                      child: SettingSection(
                        title: 'COMPTE',
                        children: [
                          SettingItemClickable(
                            icon: Icons.person_outline,
                            title: 'Profil utilisateur',
                            subtitle: 'Modifier vos informations',
                            onTap: _onProfileTap,
                            showDivider: true,
                          ),
                          SettingItemToggle(
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            subtitle: 'Gérer les alertes',
                            value: _notificationsEnabled,
                            onChanged: _onNotificationsToggle,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Section Application (Cascade à 450ms)
                    AnimatedSection(
                      delayMs: 450,
                      child: SettingSection(
                        title: 'APPLICATION',
                        children: [
                          SettingItemClickable(
                            icon: Icons.palette_outlined,
                            title: 'Apparence',
                            subtitle: 'Thème et affichage',
                            onTap: () => debugPrint('🎨 Apparence cliqué'),
                            showDivider: true,
                          ),
                          SettingItemClickable(
                            icon: Icons.storage_outlined,
                            title: 'Données & confidentialité',
                            subtitle: 'Gestion des données locales',
                            onTap: () => debugPrint('💾 Données & confidentialité cliqué'),
                            showDivider: true,
                          ),
                          SettingItemClickable(
                            icon: Icons.shield_outlined,
                            title: 'Sécurité',
                            subtitle: 'Mot de passe et accès',
                            onTap: () => debugPrint('🔐 Sécurité cliqué'),
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Section Informations (Cascade à 600ms)
                    AnimatedSection(
                      delayMs: 600,
                      child: SettingSection(
                        title: 'INFORMATIONS',
                        children: [
                          SettingItemClickable(
                            icon: Icons.info_outlined,
                            title: 'À propos',
                            subtitle: 'CIE App v${appInfo.version}',
                            onTap: () => debugPrint('ℹ️ À propos cliqué'),
                            showDivider: true,
                          ),
                          SettingItemLogout(
                            icon: Icons.logout,
                            title: 'Déconnexion',
                            onTap: () => debugPrint('🚪 Déconnexion cliqué'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 105),

                    // Footer / Copyright (Cascade à 750ms)
                    AnimatedSection(
                      delayMs: 750,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'CIE App v${appInfo.version} — © ${appInfo.copyrightYear}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
}