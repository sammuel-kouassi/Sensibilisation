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
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
    ];
    const days = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi',
      'Vendredi', 'Samedi', 'Dimanche',
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
              padding: const EdgeInsets.only(top: 16, bottom: 10, left: 4),
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
                  final p = entry.value;
                  final uniqueId =
                      p.id?.toString() ?? p.hashCode.toString();

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