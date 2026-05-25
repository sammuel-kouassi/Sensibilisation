import 'package:flutter/material.dart';
import '../../../models/prise_contact_model.dart';

class ContactListItem extends StatefulWidget {
  final PriseContactModel contact;
  final bool isExpanded;
  final bool isLast;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  const ContactListItem({
    super.key,
    required this.contact,
    required this.isExpanded,
    required this.isLast,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  State<ContactListItem> createState() => _ContactListItemState();
}

class _ContactListItemState extends State<ContactListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  static const _orange = Color(0xFFFF8000);
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
  void didUpdateWidget(ContactListItem oldWidget) {
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
    final c = widget.contact;
    final timeStr =
        "${c.date.hour.toString().padLeft(2, '0')}:${c.date.minute.toString().padLeft(2, '0')}";
    final dateFullStr =
        "${c.date.day.toString().padLeft(2, '0')}/${c.date.month.toString().padLeft(2, '0')}/${c.date.year}";
    final isSigned =
        c.signatureBase64 != null && c.signatureBase64!.isNotEmpty;

    return Column(
      children: [
        // ── Ligne principale ──
        InkWell(
          onTap: widget.onToggle,
          splashColor: _orange.withValues(alpha: 0.05),
          highlightColor: _orange.withValues(alpha: 0.03),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Avatar initiales
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: _orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      c.nomContact.isNotEmpty
                          ? c.nomContact[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: _orange,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Nom + infos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              c.nomContact,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: _dark,
                                letterSpacing: -0.1,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isSigned) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.draw_rounded,
                                      size: 10,
                                      color: Colors.green[600]),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Signé',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green[600],
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.business_outlined,
                              size: 12, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            c.directionRegionale,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.access_time_rounded,
                              size: 12, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            timeStr,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

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
                  icon: Icons.phone_outlined,
                  label: 'Téléphone',
                  value: c.telephone,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.assignment_outlined,
                  label: 'Objet',
                  value: c.objetMission,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.business_outlined,
                  label: 'DR / Agence',
                  value:
                  '${c.directionRegionale}${c.agence != null ? " / ${c.agence}" : ""}',
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date',
                  value: dateFullStr,
                ),

                // Points abordés
                if (c.pointsAbordes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Divider(height: 1, color: Colors.grey[200]),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.checklist_rounded,
                          size: 15, color: Colors.grey[400]),
                      const SizedBox(width: 8),
                      Text(
                        'Points abordés : ',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6, runSpacing: 6,
                    children: c.pointsAbordes.map((point) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _orange.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _orange.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          point,
                          style: TextStyle(
                            fontSize: 11,
                            color: _orange.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 12),

                // Bouton modifier
                GestureDetector(
                  onTap: widget.onEdit,
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _orange.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _orange.withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit_outlined,
                            color: _orange, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Modifier ce contact',
                          style: TextStyle(
                            color: _orange,
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