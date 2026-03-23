import 'package:flutter/material.dart';
import '../../../models/quick_access_models.dart';
import '../../widgets/animated_section.dart';
import 'quick_access_widget.dart';

// N'oublie pas d'importer ton widget d'animation ici aussi

class QuickAccessSection extends StatelessWidget {
  final List<QuickAccessModel> quickAccessList;

  const QuickAccessSection({super.key, required this.quickAccessList});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Accès rapide',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,

            // On transforme la liste pour avoir accès à l'INDEX
            children: quickAccessList.asMap().entries.map((entry) {
              final index = entry.key;
              final model = entry.value;

              return AnimatedSection(
                // Effet domino : chaque bouton met 50ms de plus que le précédent à apparaître
                delayMs: 150 + (index * 50),
                child: QuickAccessWidget(quickAccessModel: model),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}