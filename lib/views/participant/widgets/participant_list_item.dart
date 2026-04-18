import 'package:flutter/material.dart';

import '../../../models/participant_model.dart';

class ParticipantListItem extends StatefulWidget {
  final ParticipantModel participant;
  final bool isExpanded;
  final bool isLast;
  final VoidCallback onToggle;
  final VoidCallback? onEdit;

  const ParticipantListItem({
    super.key,
    required this.participant,
    required this.isExpanded,
    required this.isLast,
    required this.onToggle,
    this.onEdit,
  });

  @override
  State<ParticipantListItem> createState() => _ParticipantListItemState();
}

class _ParticipantListItemState extends State<ParticipantListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ParticipantListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.participant;

    // Formatage de l'heure pour la ligne principale
    final timeStr =
        "${p.registrationDate.hour.toString().padLeft(2, '0')}:${p.registrationDate.minute.toString().padLeft(2, '0')}";

    // Formatage de la date complète pour les détails
    final dateFullStr =
        "${p.registrationDate.day.toString().padLeft(2, '0')}/${p.registrationDate.month.toString().padLeft(2, '0')}/${p.registrationDate.year}";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- LIGNE PRINCIPALE (Épurée) ---
        InkWell(
          onTap: widget.onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ), // Padding ajusté sans icône
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${p.firstName} ${p.lastName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  timeStr,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- SECTION DÉTAILS (Mise à jour) ---
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: -1,
          child: Container(
            color: Colors.grey.withOpacity(0.02),
            padding: const EdgeInsets.fromLTRB(24, 4, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(
                  icon: Icons.phone_outlined,
                  label: 'Téléphone',
                  value: p.phone,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.home_outlined,
                  label: 'Logement',
                  value: p.residenceLocation ?? 'Non défini',
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Localité',
                  value: p.locality,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Inscrit le',
                  value: dateFullStr,
                ),

                if (widget.onEdit != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: widget.onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Modifier'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        if (!widget.isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade100,
            indent: 24, // Aligné sur le début du texte
            endIndent: 16,
          ),
      ],
    );
  }
}

// --- WIDGET UTILITAIRE POUR LES LIGNES DE DÉTAIL ---
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[400]),
        const SizedBox(width: 10),
        Text(
          '$label : ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
