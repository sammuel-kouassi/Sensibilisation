import 'package:cie_services/views/widgets/rdv/widgets/rdv_list_item.dart';
import 'package:flutter/material.dart';

import '../../../../models/rdv_model.dart';

class RdvHistoryView extends StatefulWidget {
  final List<RdvModel> rdvs;
  final Function(RdvModel) onEdit;

  const RdvHistoryView({super.key, required this.rdvs, required this.onEdit});

  @override
  State<RdvHistoryView> createState() => _RdvHistoryViewState();
}

class _RdvHistoryViewState extends State<RdvHistoryView> {
  String? _expandedRdvId;

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

  Map<String, List<RdvModel>> _getGroupedRdvs() {
    final sortedList = List<RdvModel>.from(widget.rdvs)
      ..sort((a, b) => b.dateInscription.compareTo(a.dateInscription));

    final Map<String, List<RdvModel>> grouped = {};
    for (var r in sortedList) {
      final label = _getDateLabel(r.dateInscription);
      if (!grouped.containsKey(label)) grouped[label] = [];
      grouped[label]!.add(r);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = _getGroupedRdvs();
    final groupLabels = groupedData.keys.toList();

    return ListView.builder(
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
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                  final rdv = entry.value;
                  final uniqueId =
                      rdv.id?.toString() ?? rdv.hashCode.toString();

                  return RdvListItem(
                    rdv: rdv,
                    isExpanded: _expandedRdvId == uniqueId,
                    isLast: i == items.length - 1,
                    onToggle: () {
                      setState(() {
                        _expandedRdvId = (_expandedRdvId == uniqueId)
                            ? null
                            : uniqueId;
                      });
                    },
                    onEdit: () => widget.onEdit(rdv),
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
