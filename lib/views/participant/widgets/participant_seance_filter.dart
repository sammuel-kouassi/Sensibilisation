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
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: seances.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          // ── Chip "Tous" ──
          if (index == 0) {
            return _FilterChip(
              label: 'Tous',
              isSelected: selectedSeanceId == null,
              color: const Color(0xFFFF8000),
              statut: null,
              isDisabled: false,
              onTap: () => onSelected(null),
            );
          }

          final seance = seances[index - 1];
          final statut = calculerStatut(
            datePrevue: seance.datePrevue,
            estTerminee: seance.estTerminee,
          );
          final isDisabled = statut == SeanceStatut.terminee;

          // ✅ Compare avec serverId OU id local selon ce qui est dispo
          final matchId = seance.serverId ?? seance.id;
          final isSelected = selectedSeanceId == matchId ||
              selectedSeanceId == seance.id;

          return _FilterChip(
            label: seance.nom,
            isSelected: isSelected,
            color: statut.color,
            statut: statut,
            isDisabled: isDisabled,
            onTap: isDisabled
                ? () {}
                : () => onSelected(isSelected ? null : seance.id),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final SeanceStatut? statut;
  final bool isDisabled;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.statut,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _pressed = false;

  String get _statutLabel {
    switch (widget.statut) {
      case SeanceStatut.enCours:
        return 'En cours';
      case SeanceStatut.planifiee:
        return 'Planifiée';
      case SeanceStatut.terminee:
        return 'Terminée';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
    widget.isDisabled ? Colors.grey[400]! : widget.color;

    return GestureDetector(
      onTapDown: (_) {
        if (!widget.isDisabled) setState(() => _pressed = true);
      },
      onTapUp: (_) {
        if (!widget.isDisabled) {
          setState(() => _pressed = false);
          widget.onTap();
        }
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        transform: _pressed
            ? (Matrix4.identity()..scale(0.94))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          // ✅ Effet enfoncé : assombrit légèrement
          color: widget.isDisabled
              ? Colors.grey[100]
              : widget.isSelected
              ? (_pressed
              ? effectiveColor.withValues(alpha: 0.75)
              : effectiveColor)
              : (_pressed
              ? effectiveColor.withValues(alpha: 0.1)
              : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.isDisabled
                ? Colors.grey[300]!
                : widget.isSelected || _pressed
                ? effectiveColor
                : Colors.grey.shade200,
            width: widget.isSelected ? 2 : 1.5,
          ),
          boxShadow: widget.isSelected && !widget.isDisabled && !_pressed
              ? [
            BoxShadow(
              color: effectiveColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Point de statut ──
            if (widget.statut != null) ...[
              Container(
                width: 7, height: 7,
                decoration: BoxDecoration(
                  color: widget.isDisabled
                      ? Colors.grey[400]
                      : widget.isSelected
                      ? Colors.white.withValues(alpha: 0.9)
                      : effectiveColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],

            // ── Nom séance ──
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: widget.isSelected
                    ? FontWeight.w800
                    : FontWeight.w600,
                color: widget.isDisabled
                    ? Colors.grey[400]
                    : widget.isSelected
                    ? Colors.white
                    : _pressed
                    ? effectiveColor
                    : Colors.grey[700],
              ),
              overflow: TextOverflow.ellipsis,
            ),

            // ── Badge statut ──
            if (widget.statut != null && !widget.isSelected) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.isDisabled
                      ? Colors.grey[200]
                      : _pressed
                      ? effectiveColor.withValues(alpha: 0.2)
                      : effectiveColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _statutLabel,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: widget.isDisabled
                        ? Colors.grey[400]
                        : effectiveColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}