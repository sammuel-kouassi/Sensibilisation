import 'package:flutter/material.dart';
import '../../../core/database/local_db.dart';
import '../../../models/seance_statut.dart';

class ParticipantSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final List<SeancesTableData> seances;
  final int? selectedSeanceId;
  final ValueChanged<int?> onSeanceSelected;

  const ParticipantSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.seances,
    required this.selectedSeanceId,
    required this.onSeanceSelected,
  });

  List<SeancesTableData> _getSortedSeances() {
    final sorted = List<SeancesTableData>.from(seances);
    sorted.sort((a, b) {
      final sa = calculerStatut(
        datePrevue: a.datePrevue,
        estTerminee: a.estTerminee,
      );
      final sb = calculerStatut(
        datePrevue: b.datePrevue,
        estTerminee: b.estTerminee,
      );
      return _statutOrder(sa).compareTo(_statutOrder(sb));
    });
    return sorted;
  }

  int _statutOrder(SeanceStatut s) {
    switch (s) {
      case SeanceStatut.enCours:
        return 0;
      case SeanceStatut.planifiee:
        return 1;
      case SeanceStatut.terminee:
        return 2;
    }
  }

  SeancesTableData? _getSelectedSeance() {
    if (selectedSeanceId == null) return null;
    try {
      return seances.firstWhere((s) => s.id == selectedSeanceId);
    } catch (_) {
      return null;
    }
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _SeanceFilterSheet(
        seances: _getSortedSeances(),
        selectedSeanceId: selectedSeanceId,
        onSelected: (id) {
          onSeanceSelected(id);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasFilter = selectedSeanceId != null;
    final selectedSeance = _getSelectedSeance();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        children: [
          // --- BARRE PRINCIPALE ---
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: hasFilter
                      ? const Color(0xFFFF9500).withOpacity(0.35)
                      : Colors.grey.withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icône recherche fixe à gauche
                  Padding(
                    padding: const EdgeInsets.only(left: 14, right: 8),
                    child: Icon(
                      Icons.search,
                      color: hasFilter
                          ? const Color(0xFFFF9500)
                          : Colors.grey[400],
                      size: 20,
                    ),
                  ),

                  // Tag séance (si filtre actif)
                  if (hasFilter && selectedSeance != null) ...[
                    _SeanceTag(
                      seance: selectedSeance,
                      onClear: () => onSeanceSelected(null),
                      onTap: () => _openFilterSheet(context),
                    ),
                    const SizedBox(width: 6),
                  ],

                  // Champ de saisie — toujours visible
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: hasFilter
                            ? 'Chercher dans cette séance...'
                            : 'Nom, localité, ID...',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  // Croix pour vider le texte (si texte saisi)
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller,
                    builder: (_, value, __) {
                      if (value.text.isEmpty) return const SizedBox(width: 12);
                      return GestureDetector(
                        onTap: () {
                          controller.clear();
                          onChanged('');
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.grey[400],
                            size: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // --- BOUTON FILTRE ---
          GestureDetector(
            onTap: () => _openFilterSheet(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: hasFilter ? const Color(0xFFFF9500) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: hasFilter
                      ? const Color(0xFFFF9500)
                      : Colors.grey.withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: hasFilter
                        ? const Color(0xFFFF9500).withOpacity(0.3)
                        : Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: hasFilter ? Colors.white : Colors.grey[500],
                    size: 22,
                  ),
                  if (hasFilter)
                    Positioned(
                      top: 9,
                      right: 9,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- TAG SÉANCE INLINE (style WhatsApp) ---
class _SeanceTag extends StatelessWidget {
  final SeancesTableData seance;
  final VoidCallback onClear;
  final VoidCallback onTap;

  const _SeanceTag({
    required this.seance,
    required this.onClear,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statut = calculerStatut(
      datePrevue: seance.datePrevue,
      estTerminee: seance.estTerminee,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 160),
        padding: const EdgeInsets.only(left: 8, right: 4, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: statut.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: statut.color.withOpacity(0.25), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_outlined, color: statut.color, size: 13),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                seance.nom,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statut.color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onClear,
              behavior: HitTestBehavior.opaque,
              child: Icon(Icons.close, size: 13, color: statut.color),
            ),
          ],
        ),
      ),
    );
  }
}

// --- BOTTOM SHEET ---
class _SeanceFilterSheet extends StatelessWidget {
  final List<SeancesTableData> seances;
  final int? selectedSeanceId;
  final ValueChanged<int?> onSelected;

  const _SeanceFilterSheet({
    required this.seances,
    required this.selectedSeanceId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final enCours = seances
        .where(
          (s) =>
              calculerStatut(
                datePrevue: s.datePrevue,
                estTerminee: s.estTerminee,
              ) ==
              SeanceStatut.enCours,
        )
        .toList();
    final planifies = seances
        .where(
          (s) =>
              calculerStatut(
                datePrevue: s.datePrevue,
                estTerminee: s.estTerminee,
              ) ==
              SeanceStatut.planifiee,
        )
        .toList();
    final termines = seances
        .where(
          (s) =>
              calculerStatut(
                datePrevue: s.datePrevue,
                estTerminee: s.estTerminee,
              ) ==
              SeanceStatut.terminee,
        )
        .toList();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Filtrer par séance',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          _SheetItem(
            label: 'Toutes les séances',
            subtitle: 'Afficher tous les participants',
            isSelected: selectedSeanceId == null,
            color: const Color(0xFFFF9500),
            icon: Icons.people_alt_outlined,
            onTap: () => onSelected(null),
          ),

          if (enCours.isNotEmpty) ...[
            _SectionLabel(label: 'En cours', color: SeanceStatut.enCours.color),
            ...enCours.map((s) => _buildItem(s)),
          ],
          if (planifies.isNotEmpty) ...[
            _SectionLabel(
              label: 'Planifiées',
              color: SeanceStatut.planifiee.color,
            ),
            ...planifies.map((s) => _buildItem(s)),
          ],
          if (termines.isNotEmpty) ...[
            _SectionLabel(
              label: 'Terminées',
              color: SeanceStatut.terminee.color,
            ),
            ...termines.map((s) => _buildItem(s)),
          ],
        ],
      ),
    );
  }

  Widget _buildItem(SeancesTableData seance) {
    final isSelected = selectedSeanceId == seance.id;
    final statut = calculerStatut(
      datePrevue: seance.datePrevue,
      estTerminee: seance.estTerminee,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: _SheetItem(
        label: seance.nom,
        subtitle: seance.zone ?? '',
        isSelected: isSelected,
        color: statut.color,
        icon: Icons.event_outlined,
        onTap: () => onSelected(isSelected ? null : seance.id),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetItem extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isSelected;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _SheetItem({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.07) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color.withOpacity(0.3) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 17),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
