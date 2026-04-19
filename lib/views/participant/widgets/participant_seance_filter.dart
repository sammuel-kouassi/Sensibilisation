import 'package:flutter/material.dart';
import '../../../core/database/local_db.dart';
import '../../../models/seance_statut.dart';

class ParticipantSeanceFilter extends StatelessWidget {
  final List<SeancesTableData> seances;
  final int? selectedSeanceId;
  final ValueChanged<int?> onSelected;

  const ParticipantSeanceFilter({
    super.key,
    required this.seances,
    required this.selectedSeanceId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (seances.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: seances.length + 1, // +1 pour le chip "Tous"
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          // --- Chip "Tous" ---
          if (index == 0) {
            final isSelected = selectedSeanceId == null;
            return _FilterChip(
              label: 'Tous',
              isSelected: isSelected,
              color: const Color(0xFFFF9500),
              onTap: () => onSelected(null),
            );
          }

          // --- Chips séances ---
          final seance = seances[index - 1];
          final isSelected = selectedSeanceId == seance.id;
          final statut = calculerStatut(
            datePrevue: seance.datePrevue,
            estTerminee: seance.estTerminee,
          );

          return _FilterChip(
            label: seance.nom,
            isSelected: isSelected,
            color: statut.color,
            onTap: () => onSelected(isSelected ? null : seance.id),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.25), blurRadius: 6, offset: const Offset(0, 2))]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}