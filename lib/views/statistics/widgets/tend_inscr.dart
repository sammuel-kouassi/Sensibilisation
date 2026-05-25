import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/tendency_model.dart';

class TendInscr extends StatefulWidget {
  final List<TendencyModels> trendData;

  const TendInscr({super.key, required this.trendData});

  @override
  State<TendInscr> createState() => _TendInscrState();
}

class _TendInscrState extends State<TendInscr> {
  static const _vert = Color(0xFF21951D);
  static const _dark = Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    if (widget.trendData.isEmpty) return const SizedBox.shrink();

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
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: _vert.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.trending_up_rounded,
                    color: _vert, size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tendance d\'inscriptions',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: _dark,
                      ),
                    ),
                    Text(
                      'Évolution sur la période',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => Colors.white,
                    tooltipBorder: const BorderSide(
                        color: Color(0xFFEEF0F3), width: 1),
                    tooltipBorderRadius: BorderRadius.circular(12),
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        final value = spot.y.toInt();
                        final trend = widget.trendData.firstWhere(
                              (t) => t.monthIndex == spot.x.toInt(),
                        );
                        return LineTooltipItem(
                          '${trend.monthName}\n',
                          const TextStyle(
                            color: _dark,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: '$value participants',
                              style: const TextStyle(
                                color: _vert,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: const Color(0xFFF0F1F5),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final trend = widget.trendData.firstWhere(
                              (t) => t.monthIndex == value.toInt(),
                          orElse: () => TendencyModels(
                            monthIndex: -1,
                            monthName: '',
                            participants: 0,
                          ),
                        );
                        return SideTitleWidget(
                          meta: meta,
                          space: 8,
                          child: Text(
                            trend.monthName,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: widget.trendData
                        .map((t) => FlSpot(
                        t.monthIndex.toDouble(),
                        t.participants))
                        .toList(),
                    isCurved: true,
                    color: _vert,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2.5,
                            strokeColor: _vert,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _vert.withValues(alpha: 0.15),
                          _vert.withValues(alpha: 0.0),
                        ],
                      ),
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