import 'package:flutter/material.dart';
import '../../../models/stat_card_home_models.dart';

class StatHomeCard extends StatelessWidget {
  final StatCardHomeModels statCardHomeModels;

  const StatHomeCard({super.key, required this.statCardHomeModels});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
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
        mainAxisAlignment: MainAxisAlignment.center, // Centre le texte verticalement
        children: [
          Text(
            statCardHomeModels.number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF8000), // On met le chiffre en couleur pour attirer l'oeil
            ),
          ),
          const SizedBox(height: 6),
          Text(
            statCardHomeModels.label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}