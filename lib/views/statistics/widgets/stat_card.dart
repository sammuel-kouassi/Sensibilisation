import 'package:flutter/material.dart';
import '../../../models/kpi_model.dart';

class StatCard extends StatelessWidget {
  final KpiModel kpiModel;

  const StatCard({super.key, required this.kpiModel});

  static const _dark = Color(0xFF1E293B);

  IconData get _icon {
    final l = kpiModel.label.toLowerCase();
    if (l.contains('participant')) return Icons.people_alt_rounded;
    if (l.contains('séance') || l.contains('seance')) {
      return Icons.event_note_rounded;
    }
    if (l.contains('gadget') || l.contains('stock')) {
      return Icons.card_giftcard_rounded;
    }
    if (l.contains('taux')) return Icons.percent_rounded;
    return Icons.bar_chart_rounded;
  }

  Color get _iconColor {
    final l = kpiModel.label.toLowerCase();
    if (l.contains('participant')) return const Color(0xFFFF8000);
    if (l.contains('séance') || l.contains('seance')) {
      return const Color(0xFF21951D);
    }
    if (l.contains('gadget') || l.contains('stock')) {
      return const Color(0xFF1565C0);
    }
    return Colors.grey.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEF0F3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: _iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(_icon, color: _iconColor, size: 22),
          ),
          const Spacer(),
          Text(
            kpiModel.value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: _dark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            kpiModel.label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}