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

  @override
  Widget build(BuildContext context) {
    if (widget.zoneData.isEmpty) return const SizedBox.shrink();

    final total = widget.zoneData.fold<int>(
      0,
      (sum, z) => sum + z.valeurExacte,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- TITRE ---
          const Text(
            'Répartition par zone',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$total participants au total',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),

          // --- DONUT + LÉGENDE ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // DONUT
              SizedBox(
                height: 180,
                width: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!
                                      .touchedSectionIndex;
                                });
                              },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 3,
                        centerSpaceRadius: 52,
                        sections: _buildSections(),
                      ),
                    ),
                    // Centre du donut
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (touchedIndex != -1) ...[
                          Text(
                            '${widget.zoneData[touchedIndex].valeurExacte}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'pers.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ] else ...[
                          Text(
                            '$total',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'total',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // LÉGENDE SCROLLABLE
              Expanded(
                child: SizedBox(
                  height: 180,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.zoneData.asMap().entries.map((entry) {
                        final i = entry.key;
                        final zone = entry.value;
                        final isSelected = touchedIndex == i;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              touchedIndex = (touchedIndex == i) ? -1 : i;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Carré couleur (aligné avec la première ligne du texte)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: zone.color,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Nom de la zone (retour à la ligne si long)
                                Flexible(
                                  child: Text(
                                    zone.zoneName,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: Colors.black87,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                // Pourcentage
                                Text(
                                  '${zone.percentage.toInt()}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
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
        radius: isTouched ? 62 : 56,
        badgeWidget: isTouched
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: data.color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${data.percentage.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        badgePositionPercentageOffset: 1.25,
      );
    });
  }
}
