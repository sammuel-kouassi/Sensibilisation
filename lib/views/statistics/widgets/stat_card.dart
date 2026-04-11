import 'package:flutter/material.dart';
import '../../../models/kpi_model.dart';

class StatCard extends StatelessWidget {
  final KpiModel kpiModel;

  const StatCard({super.key, required this.kpiModel});

  IconData get _icon {
    final labelLower = kpiModel.label.toLowerCase();
    if (labelLower.contains('participant')) return Icons.people_alt;
    if (labelLower.contains('séance') || labelLower.contains('seance')) {
      return Icons.event_note;
    }
    if (labelLower.contains('gadget') || labelLower.contains('stock')) {
      return Icons.card_giftcard;
    }
    if (labelLower.contains('taux')) return Icons.percent_rounded;
    return Icons.bar_chart_rounded;
  }

  Color get _iconColor {
    final labelLower = kpiModel.label.toLowerCase();
    if (labelLower.contains('participant')) {
      return const Color(0xFFFF9500); // Orange
    }
    if (labelLower.contains('séance') || labelLower.contains('seance')) {
      return const Color(0xFF21951D); // Vert
    }
    if (labelLower.contains('gadget') || labelLower.contains('stock')) {
      return Colors.blue;
    }
    return Colors.grey.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_icon, color: _iconColor, size: 32),
          const SizedBox(height: 12),
          Text(
            kpiModel.value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            kpiModel.label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
