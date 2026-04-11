import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/bar_chart_model.dart';

class MonthlyChartWidget extends StatefulWidget {
  final List<BarchartModel> chartData;

  const MonthlyChartWidget({super.key, required this.chartData});

  @override
  State<MonthlyChartWidget> createState() => _MonthlyChartWidgetState();
}

class _MonthlyChartWidgetState extends State<MonthlyChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {

    double maxY = 0;
    for (var data in widget.chartData) {
      // ✅ CORRECTION 1 : On cherche le max avec "data.count" (la vraie valeur)
      if (data.count.toDouble() > maxY) maxY = data.count.toDouble();
    }
    // Sécurité : si on n'a aucun participant, on met un plafond à 10 pour l'esthétique
    if (maxY == 0) {
      maxY = 10;
    } else {
      maxY = maxY + (maxY * 0.2); // Ajoute 20% d'espace en haut
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
            'Évolution mensuelle des participants',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  enabled: true,

                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.white,
                    tooltipBorder: const BorderSide(color: Colors.grey, width: 0.5),
                    tooltipBorderRadius: BorderRadius.circular(8), // Correction pour les bords arrondis
                    tooltipPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final month = widget.chartData[groupIndex].label;
                      final value = rod.toY.toInt(); // Récupère la vraie valeur

                      return BarTooltipItem(
                        '$month\n',
                        const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'participants : $value',
                            style: const TextStyle(color: Color(0xFFFF8000), fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      );
                    },
                  ),

                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                    });
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final isTouched = touchedIndex == value.toInt();
                        final style = TextStyle(
                          color: isTouched ? const Color(0xFFFF8000) : Colors.grey[500],
                          fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
                          fontSize: 11,
                        );
                        // Sécurité pour éviter les erreurs d'index
                        if (value.toInt() < 0 || value.toInt() >= widget.chartData.length) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          space: 10,
                          child: Text(widget.chartData[value.toInt()].label, style: style),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: widget.chartData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  final isTouched = index == touchedIndex;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        // ✅ CORRECTION 2 : On donne la vraie valeur au graphique "toY: data.count"
                        toY: data.count.toDouble(),
                        color: const Color(0xFFFF8000),
                        width: 40,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),

                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxY,
                          color: isTouched ? Colors.grey.withValues(alpha: 0.2) : Colors.transparent,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}