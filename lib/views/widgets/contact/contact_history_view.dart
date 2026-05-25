import 'package:flutter/material.dart';
import '../../../models/prise_contact_model.dart';
import 'contact_list_item.dart';

class ContactHistoryView extends StatefulWidget {
  final List<PriseContactModel> contacts;
  final Function(PriseContactModel) onEdit;

  const ContactHistoryView({
    super.key,
    required this.contacts,
    required this.onEdit,
  });

  @override
  State<ContactHistoryView> createState() => _ContactHistoryViewState();
}

class _ContactHistoryViewState extends State<ContactHistoryView> {
  String? _expandedContactId;

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final itemDate = DateTime(date.year, date.month, date.day);

    if (itemDate == today) return 'Aujourd\'hui';
    if (itemDate == yesterday) return 'Hier';

    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
    ];
    const days = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi',
      'Vendredi', 'Samedi', 'Dimanche',
    ];
    return '${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]}';
  }

  Map<String, List<PriseContactModel>> _getGroupedContacts() {
    final sortedList = List<PriseContactModel>.from(widget.contacts)
      ..sort((a, b) => b.dateInscription.compareTo(a.dateInscription));

    final Map<String, List<PriseContactModel>> grouped = {};
    for (var c in sortedList) {
      final label = _getDateLabel(c.dateInscription);
      if (!grouped.containsKey(label)) grouped[label] = [];
      grouped[label]!.add(c);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = _getGroupedContacts();
    final groupLabels = groupedData.keys.toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: groupLabels.length,
      itemBuilder: (context, index) {
        final label = groupLabels[index];
        final items = groupedData[label]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Label date ──
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10, left: 4),
              child: Row(
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF8000),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFF8000),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: const Color(0xFFFF8000).withValues(alpha: 0.15),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8000).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${items.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFF8000),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Carte groupe ──
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFFEEF0F3), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: items.asMap().entries.map((entry) {
                  final i = entry.key;
                  final contact = entry.value;
                  final uniqueId =
                      contact.id?.toString() ?? contact.hashCode.toString();

                  return ContactListItem(
                    contact: contact,
                    isExpanded: _expandedContactId == uniqueId,
                    isLast: i == items.length - 1,
                    onToggle: () {
                      setState(() {
                        _expandedContactId = _expandedContactId == uniqueId
                            ? null
                            : uniqueId;
                      });
                    },
                    onEdit: () => widget.onEdit(contact),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}