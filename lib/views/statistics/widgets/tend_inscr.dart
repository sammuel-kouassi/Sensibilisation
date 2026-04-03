import 'package:cie_services/models/tendinsc_models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../data/tendinsc_data.dart';

class TendInscr extends StatefulWidget {
  const TendInscr({super.key});

  @override
  State<TendInscr> createState() => _TendInscrState();
}

class _TendInscrState extends State<TendInscr> {

  final List<TendinscModels> trendData = TendinscData.getTrendStats();

  @override
  Widget build(BuildContext context) {
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
            'Tendance d\'inscriptions des participants',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.white,
                    tooltipBorder: const BorderSide(color: Colors.grey, width: 0.5),
                    tooltipBorderRadius: BorderRadius.circular(8),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final value = touchedSpot.y.toInt();

                        final trend = trendData.firstWhere((t) => t.monthIndex == touchedSpot.x.toInt());

                        return LineTooltipItem(
                          '${trend.monthName}\n',
                          const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: 'participants : $value',
                              style: const TextStyle(color: Color(0xFF21951D), fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13);

                        final trend = trendData.firstWhere(
                                (t) => t.monthIndex == value.toInt(),
                            orElse: () => TendinscModels(monthIndex: -1, monthName: '', participants: 0)
                        );
                        return SideTitleWidget(meta: meta, space: 10, child: Text(trend.monthName, style: style));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(

                    spots: trendData.map((t) => FlSpot(t.monthIndex.toDouble(), t.participants)).toList(),
                    isCurved: true,
                    color: const Color(0xFF21951D),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF21951D).withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}