import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 20, 214, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paramètres',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 1,
              color: Colors.grey.withOpacity(0.2),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: GestureDetector(
                onTap: _onProfileTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.15),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        children: [

                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF9500),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.bolt,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Admin Principal',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'admin@cie.ci',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Administrateur',
                                style: const TextStyle(
                                  color: Color(0xFFFF9500),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Flèche
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
            ),


            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    'COMPTE',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),


                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.15),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [

                        _SettingItemClickable(
                          icon: Icons.person_outline,
                          title: 'Profil utilisateur',
                          subtitle: 'Modifier vos informations',
                          onTap: _onProfileTap,
                          showDivider: true,
                        ),

                        _SettingItemToggle(
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
                ],
              ),
            ),


            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    'APPLICATION',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),


                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.15),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [

                        _SettingItemClickable(
                          icon: Icons.palette_outlined,
                          title: 'Apparence',
                          subtitle: 'Thème et affichage',
                          onTap: () => debugPrint('🎨 Apparence cliqué'),
                          showDivider: true,
                        ),

                        _SettingItemClickable(
                          icon: Icons.storage_outlined,
                          title: 'Données & confidentialité',
                          subtitle: 'Gestion des données locales',
                          onTap: () => debugPrint('💾 Données & confidentialité cliqué'),
                          showDivider: true,
                        ),
                        // Sécurité
                        _SettingItemClickable(
                          icon: Icons.shield_outlined,
                          title: 'Sécurité',
                          subtitle: 'Mot de passe et accès',
                          onTap: () => debugPrint('🔐 Sécurité cliqué'),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),


            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    'INFORMATIONS',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),


                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.15),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [

                        _SettingItemClickable(
                          icon: Icons.info_outlined,
                          title: 'À propos',
                          subtitle: 'CIE App v1.0.0',
                          onTap: () => debugPrint('ℹ️ À propos cliqué'),
                          showDivider: true,
                        ),

                        _SettingItemLogout(
                          icon: Icons.logout,
                          title: 'Déconnexion',
                          onTap: () => debugPrint('🚪 Déconnexion cliqué'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 105),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'CIE App v1.0.0 — © 2026',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}


class _SettingItemClickable extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDivider;

  const _SettingItemClickable({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  children: [

                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          color: Colors.grey[600],
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.15),
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
      ],
    );
  }
}


class _SettingItemToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const _SettingItemToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [

                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        color: Colors.grey[600],
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: const Color(0xFFFF9500),
                  activeTrackColor: const Color(0xFFFF9500),
                  inactiveThumbColor: Colors.grey[300],
                  inactiveTrackColor: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.15),
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
      ],
    );
  }
}


class _SettingItemLogout extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingItemLogout({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Row(
              children: [

                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.red[500],
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.red[500],
                    fontSize: 15,
                  ),
                ),
              ],
            ),

            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}