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

  static const _vert = Color(0xFF21951D);
  static const _dark = Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    if (widget.isExpanded) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(RdvListItem oldWidget) {
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

  Color _getStatutColor(String statut) {
    switch (statut.toLowerCase()) {
      case 'planifié':
        return const Color(0xFF1565C0);
      case 'confirmé':
        return _vert;
      case 'annulé':
        return Colors.red[600]!;
      case 'terminé':
        return Colors.grey[600]!;
      default:
        return const Color(0xFFFF8000);
    }
  }

  IconData _getStatutIcon(String statut) {
    switch (statut.toLowerCase()) {
      case 'planifié':
        return Icons.schedule_rounded;
      case 'confirmé':
        return Icons.check_circle_rounded;
      case 'annulé':
        return Icons.cancel_rounded;
      case 'terminé':
        return Icons.task_alt_rounded;
      default:
        return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.rdv;
    final dateStr =
        "${r.dateRdv.day.toString().padLeft(2, '0')}/${r.dateRdv.month.toString().padLeft(2, '0')}/${r.dateRdv.year}";
    final statutColor = _getStatutColor(r.statut);

    return Column(
      children: [
        // ── Ligne principale ──
        InkWell(
          onTap: widget.onToggle,
          splashColor: _vert.withValues(alpha: 0.05),
          highlightColor: _vert.withValues(alpha: 0.03),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icône statut
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: statutColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getStatutIcon(r.statut),
                    color: statutColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                // Titre + heure
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.titre,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _dark,
                          letterSpacing: -0.1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 12, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            r.heure,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.person_outline_rounded,
                              size: 12, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            r.contact,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Chevron animé
                AnimatedBuilder(
                  animation: _expandAnimation,
                  builder: (context, child) => Transform.rotate(
                    angle: _expandAnimation.value * 3.14159,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey[400],
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Détails expansibles ──
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: -1,
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: const Color(0xFFEEF0F3), width: 1),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date',
                  value: dateStr,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Lieu',
                  value: r.lieu,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.person_outline_rounded,
                  label: 'Contact',
                  value: r.contact,
                ),
                const SizedBox(height: 10),
                // Statut avec badge coloré
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 15, color: Colors.grey[400]),
                    const SizedBox(width: 8),
                    Text(
                      'Statut : ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statutColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getStatutIcon(r.statut),
                              size: 12, color: statutColor),
                          const SizedBox(width: 5),
                          Text(
                            r.statut,
                            style: TextStyle(
                              fontSize: 12,
                              color: statutColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Bouton modifier
                GestureDetector(
                  onTap: widget.onEdit,
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _vert.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _vert.withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit_outlined,
                            color: _vert, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Modifier ce rendez-vous',
                          style: TextStyle(
                            color: _vert,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Séparateur ──
        if (!widget.isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade100,
            indent: 16,
            endIndent: 16,
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
        Icon(icon, size: 15, color: Colors.grey[400]),
        const SizedBox(width: 8),
        Text(
          '$label : ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}