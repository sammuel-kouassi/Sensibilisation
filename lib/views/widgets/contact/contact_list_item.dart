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
    required this.onEdit
  });

  @override
  State<ContactListItem> createState() => _ContactListItemState();
}

class _ContactListItemState extends State<ContactListItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
    _expandAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    if (widget.isExpanded) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(ContactListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) _controller.forward(); else _controller.reverse();
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
    final timeStr = "${c.date.hour.toString().padLeft(2, '0')}:${c.date.minute.toString().padLeft(2, '0')}";
    final dateFullStr = "${c.date.day.toString().padLeft(2, '0')}/${c.date.month.toString().padLeft(2, '0')}/${c.date.year}";
    final isSigned = c.signatureBase64 != null && c.signatureBase64!.isNotEmpty;

    return Column(
      children: [
        InkWell(
          onTap: widget.onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          c.nomContact,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSigned) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.draw_rounded, size: 14, color: Colors.green[400]),
                      ]
                    ],
                  ),
                ),
                Text(
                  timeStr,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: -1,
          child: Container(
            color: Colors.grey.withOpacity(0.02),
            padding: const EdgeInsets.fromLTRB(24, 4, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(icon: Icons.phone_outlined, label: 'Téléphone', value: c.telephone),
                const SizedBox(height: 10),
                _DetailRow(icon: Icons.assignment_outlined, label: 'Objet', value: c.objetMission),
                const SizedBox(height: 10),
                _DetailRow(icon: Icons.business_outlined, label: 'DR / Agence', value: '${c.directionRegionale}${c.agence != null ? " / ${c.agence}" : ""}'),
                const SizedBox(height: 10),
                _DetailRow(icon: Icons.calendar_today_outlined, label: 'Date', value: dateFullStr),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: widget.onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Modifier'),
                    style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!widget.isLast) Divider(height: 1, thickness: 1, color: Colors.grey.shade100, indent: 24, endIndent: 16),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[400]),
        const SizedBox(width: 10),
        Text('$label : ', style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87))),
      ],
    );
  }
}