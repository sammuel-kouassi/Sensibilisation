import 'package:flutter/material.dart';

class QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String label;
  final VoidCallback onTap;

  const QuickAccessItem({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min, // S'adapte au contenu
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 28,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // ❌ ON A RETIRÉ LE SizedBox(width: 700) QUI ÉTAIT TROP GRAND
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}