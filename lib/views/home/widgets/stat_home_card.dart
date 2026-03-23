import 'package:flutter/material.dart';
import '../../../models/stat_card_home_models.dart';

class StatHomeCard extends StatelessWidget {
  final StatCardHomeModels statCardHomeModels;

  const StatHomeCard({super.key, required this.statCardHomeModels});

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
          Icon(statCardHomeModels.icon, color: statCardHomeModels.iconColor, size: 28),
          const SizedBox(height: 12),
          Text(
            statCardHomeModels.number,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            statCardHomeModels.label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}