import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/repart_zone_model.dart';

class RepartZone extends StatefulWidget {
  final List<RepartzoneModels> zoneData;

  const RepartZone({super.key, required this.zoneData});

  @override
  State<RepartZone> createState() => _RepartZoneState();
}

class _RepartZoneState extends State<RepartZone> {
  int touchedIndex = -1;

  static const _blue = Color(0xFF1565C0);
  static const _dark = Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    if (widget.zoneData.isEmpty) return const SizedBox.shrink();

    final total = widget.zoneData.fold<int>(
      0,
          (sum, z) => sum + z.valeurExacte,
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEF0F3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── En-tête ──
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.pie_chart_outline_rounded,
                  color: _blue,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Répartition par zone',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: _dark,
                      ),
                    ),
                    Text(
                      '$total participants au total',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Donut + légende ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Donut ──
              SizedBox(
                height: 160,
                width: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (event, response) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  response == null ||
                                  response.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = response
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _buildSections(),
                      ),
                    ),
                    // ── Centre du donut ──
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (touchedIndex != -1) ...[
                          Text(
                            '${widget.zoneData[touchedIndex].valeurExacte}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: _dark,
                            ),
                          ),
                          Text(
                            'pers.',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ] else ...[
                          Text(
                            '$total',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: _dark,
                            ),
                          ),
                          Text(
                            'total',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // ── Légende ──
              Expanded(
                child: SizedBox(
                  height: 160,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.zoneData
                          .asMap()
                          .entries
                          .map((entry) {
                        final i = entry.key;
                        final zone = entry.value;
                        final isSelected = touchedIndex == i;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              touchedIndex =
                              (touchedIndex == i) ? -1 : i;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? zone.color.withValues(alpha: 0.08)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? zone.color.withValues(alpha: 0.4)
                                    : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: zone.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    zone.zoneName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: _dark,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${zone.percentage.toInt()}%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: zone.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return List.generate(widget.zoneData.length, (i) {
      final isTouched = i == touchedIndex;
      final data = widget.zoneData[i];

      return PieChartSectionData(
        color: data.color,
        value: data.percentage,
        title: '',
        radius: isTouched ? 50 : 44,
        badgeWidget: isTouched
            ? Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: data.color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${data.percentage.toInt()}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        )
            : null,
        badgePositionPercentageOffset: 1.3,
      );
    });
  }
}