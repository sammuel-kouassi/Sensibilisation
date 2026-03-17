import 'package:flutter/material.dart';

class RdvHeader extends StatelessWidget {
  final VoidCallback onPlanifierPressed;

  const RdvHeader({super.key, required this.onPlanifierPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 18),
                onPressed: () {
                  Navigator.pop(context); // Action de retour native
                },
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Rendez-vous',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),

        // Bouton Planifier
        ElevatedButton(
          onPressed: onPlanifierPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF97316),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.add, size: 18, color: Colors.white),
              SizedBox(width: 4),
              Text(
                'Planifier',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}