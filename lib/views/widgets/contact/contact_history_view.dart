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

    const months = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];
    const days = ['lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche'];

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
      padding: const EdgeInsets.only(bottom: 40),
      itemCount: groupLabels.length,
      itemBuilder: (context, index) {
        final label = groupLabels[index];
        final items = groupedData[label]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 16, bottom: 8),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: items.asMap().entries.map((entry) {
                  final i = entry.key;
                  final contact = entry.value;
                  final uniqueId = contact.id?.toString() ?? contact.hashCode.toString();

                  return ContactListItem(
                    contact: contact,
                    isExpanded: _expandedContactId == uniqueId,
                    isLast: i == items.length - 1,
                    onToggle: () {
                      setState(() {
                        _expandedContactId =
                        _expandedContactId == uniqueId ? null : uniqueId;
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