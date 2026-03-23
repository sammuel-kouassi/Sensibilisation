import 'package:flutter/material.dart';

class GadgetHeader extends StatelessWidget {
  final VoidCallback onScannerPressed;

  const GadgetHeader({super.key, required this.onScannerPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gadgets',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 25, // Uniformisé avec les autres pages
                ),
              ),
              GestureDetector(
                onTap: onScannerPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9500),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.qr_code, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Scanner',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Ligne de séparation subtile en bas du header
        Container(
          height: 1,
          color: Colors.grey.withValues(alpha: 0.2),
        ),
      ],
    );
  }
}