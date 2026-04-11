import 'package:flutter/material.dart';

class SettingItemClickable extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDivider;
  final bool isEnabled;

  const SettingItemClickable({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDivider = true,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: isEnabled ? onTap : () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('🔒 Accès réservé aux Administrateurs.')),
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Opacity(
            opacity: isEnabled ? 1.0 : 0.4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Icon(icon, color: Colors.grey[600], size: 24),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                        ),
                      ],
                    ),
                  ),
                  if (isEnabled) Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
                  if (!isEnabled) Icon(Icons.lock_outline, color: Colors.grey[400], size: 20), // Affiche un cadenas si bloqué
                ],
              ),
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