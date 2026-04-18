import 'package:flutter/material.dart';
import '../../../../models/rdv_model.dart';

class RdvListItem extends StatefulWidget {
  final RdvModel rdv;
  final bool isExpanded;
  final bool isLast;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  const RdvListItem({
    super.key,
    required this.rdv,
    required this.isExpanded,
    required this.isLast,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  State<RdvListItem> createState() => _RdvListItemState();
}

class _RdvListItemState extends State<RdvListItem>
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
    if (widget.isExpanded) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(RdvListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded)
        _controller.forward();
      else
        _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.rdv;
    final dateFullStr =
        "${r.dateRdv.day.toString().padLeft(2, '0')}/${r.dateRdv.month.toString().padLeft(2, '0')}/${r.dateRdv.year}";

    return Column(
      children: [
        // --- LIGNE PRINCIPALE ---
        InkWell(
          onTap: widget.onToggle,
          child: Padding(
            // Réduction du padding horizontal à 16 pour gagner de la place
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    r.titre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  r.heure,
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

        // --- SECTION DÉTAILS ---
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: -1,
          child: Container(
            color: Colors.grey.withOpacity(0.02),
            // Alignement du padding avec la ligne principale (16)
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date',
                  value: dateFullStr,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Lieu',
                  value: r.lieu,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.person_outline,
                  label: 'Contact',
                  value: r.contact,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.info_outline,
                  label: 'Statut',
                  value: r.statut,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: widget.onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Modifier'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      // Compactage du bouton
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- SÉPARATEUR ---
        if (!widget.isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade100,
            indent: 12,
            endIndent: 12,
          ),
      ],
    );
  }
}

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
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}