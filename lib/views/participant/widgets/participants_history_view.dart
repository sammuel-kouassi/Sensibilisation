import 'package:cie_services/views/participant/widgets/participant_list_item.dart';
import 'package:flutter/material.dart';
import '../../../models/participant_model.dart';

class ParticipantsHistoryView extends StatefulWidget {
  final List<ParticipantModel> participants;
  final Function(ParticipantModel) onEdit;

  const ParticipantsHistoryView({
    super.key,
    required this.participants,
    required this.onEdit,
  });

  @override
  State<ParticipantsHistoryView> createState() =>
      _ParticipantsHistoryViewState();
}

class _ParticipantsHistoryViewState extends State<ParticipantsHistoryView> {
  String? _expandedParticipantId;

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final itemDate = DateTime(date.year, date.month, date.day);

    if (itemDate == today) return 'Aujourd\'hui';
    if (itemDate == yesterday) return 'Hier';

    const months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];
    const days = [
      'lundi',
      'mardi',
      'mercredi',
      'jeudi',
      'vendredi',
      'samedi',
      'dimanche',
    ];

    return '${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]}';
  }

  Map<String, List<ParticipantModel>> _getGroupedParticipants() {
    final sortedList = List<ParticipantModel>.from(widget.participants)
      ..sort((a, b) => b.registrationDate.compareTo(a.registrationDate));

    final Map<String, List<ParticipantModel>> grouped = {};
    for (var p in sortedList) {
      final label = _getDateLabel(p.registrationDate);
      if (!grouped.containsKey(label)) grouped[label] = [];
      grouped[label]!.add(p);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = _getGroupedParticipants();
    final groupLabels = groupedData.keys.toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                  final p = entry.value;
                  final uniqueId = p.id?.toString() ?? p.hashCode.toString();

                  return ParticipantListItem(
                    participant: p,
                    isExpanded: _expandedParticipantId == uniqueId,
                    isLast: i == items.length - 1,
                    onToggle: () {
                      setState(() {
                        _expandedParticipantId =
                            _expandedParticipantId == uniqueId
                            ? null
                            : uniqueId;
                      });
                    },
                    onEdit: () => widget.onEdit(p),
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
