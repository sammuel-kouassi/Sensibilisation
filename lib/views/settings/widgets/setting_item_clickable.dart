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

  static const _dark = Color(0xFF1E293B);
  static const _orange = Color(0xFFFF8000);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: isEnabled
              ? onTap
              : () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.lock_rounded,
                        color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text('Accès réservé aux Administrateurs.'),
                  ],
                ),
                backgroundColor: Colors.orange[700],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Opacity(
            opacity: isEnabled ? 1.0 : 0.45,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Icône
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: _orange.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: _orange, size: 20),
                  ),
                  const SizedBox(width: 14),
                  // Texte
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _dark,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isEnabled
                        ? Icons.chevron_right_rounded
                        : Icons.lock_outline_rounded,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: Colors.grey[100],
            indent: 72,
            endIndent: 16,
          ),
      ],
    );
  }
}