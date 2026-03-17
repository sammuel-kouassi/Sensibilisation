import 'package:flutter/material.dart';
import '../../../models/startcard_home_models.dart';

class StatHomeCard extends StatelessWidget {
  final StartCardHomeModels startcardModels;

  const StatHomeCard({super.key, required this.startcardModels});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(startcardModels.icon, color: startcardModels.iconColor, size: 28),
          const SizedBox(height: 12),
          Text(
            startcardModels.number,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            startcardModels.label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}