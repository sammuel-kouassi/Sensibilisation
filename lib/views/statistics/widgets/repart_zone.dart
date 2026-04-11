import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/repart_zone_model.dart';
// 🗑️ ANCIEN IMPORT SUPPRIMÉ : import '../../../data/repartzone_data.dart';

class RepartZone extends StatefulWidget {
  final List<RepartzoneModels> zoneData; // ✅ NOUVEAU : On reçoit les vraies données

  const RepartZone({super.key, required this.zoneData});

  @override
  State<RepartZone> createState() => _RepartZoneState();
}

class _RepartZoneState extends State<RepartZone> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Sécurité : Si aucune donnée sur la période, on cache le bloc
    if (widget.zoneData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Répartition par zone des participants',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: 0,
                    sections: showingSections(),
                  ),
                ),

                if (touchedIndex != -1)
                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              // ✅ Utilisation de widget.zoneData
                              text: '${widget.zoneData[touchedIndex].zoneName} : ',
                              style: const TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            TextSpan(
                              // ✅ Utilisation de widget.zoneData
                              text: '${widget.zoneData[touchedIndex].valeurExacte}',
                              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.zoneData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 110.0 : 100.0;
      const shadows = [Shadow(color: Colors.black26, blurRadius: 2)];

      // ✅ Utilisation de widget.zoneData
      final data = widget.zoneData[i];

      return PieChartSectionData(
        color: data.color,
        value: data.percentage,
        title: isTouched ? '' : '${data.zoneName} ${data.percentage.toInt()}%',
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: shadows),
      );
    });
  }
}