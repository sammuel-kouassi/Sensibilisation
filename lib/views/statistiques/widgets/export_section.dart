import 'package:flutter/material.dart';
import 'export_button.dart';

class ExportSection extends StatelessWidget {
  const ExportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: ExportButton(
              icon: Icons.description_outlined,
              iconColor: const Color(0xFFFF9500),
              title: 'Export PDF',
              subtitle: 'Rapport complet',
              onTap: () => debugPrint('Export PDF clicked'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ExportButton(
              icon: Icons.bar_chart_outlined,
              iconColor: const Color(0xFF4CAF50),
              title: 'Export Excel',
              subtitle: 'Données brutes',
              onTap: () => debugPrint('Export Excel clicked'),
            ),
          ),
        ],
      ),
    );
  }
}