import 'package:flutter/material.dart';

import '../../../models/barchart_models.dart';
import 'bar_chart.dart';

class MonthlyChartWidget extends StatelessWidget {
  final List<BarchartModels> chartData;

  const MonthlyChartWidget({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Évolution mensuelle',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: chartData.map((data) => Expanded(
                child: BarChart(barchartModels: data),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}