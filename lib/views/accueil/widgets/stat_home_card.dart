import 'package:flutter/material.dart';
import '../../../models/startcard_home_models.dart';

class StatCard extends StatelessWidget {

final StartCardHomeModels startcardModels;

  const StatCard({
    super.key, required this.startcardModels,
  });

  @override
  Widget build(BuildContext context) {

    final IconData finalIcon =
        startcardModels.icon ?? Icons.help_outline;

    final Color finalColor =
        startcardModels.iconColor ?? startcardModels.iconColor;

    final String finalNumber =
        startcardModels.number ?? startcardModels.number;

    final String finalLabel =
        startcardModels.label ?? startcardModels.label;

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

          Icon(finalIcon, color: finalColor, size: 28),

          const SizedBox(height: 12),

          Text(
            finalNumber,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            finalLabel,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}