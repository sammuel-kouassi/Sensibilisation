import 'package:flutter/material.dart';

import '../../../models/bar_chart_model.dart';

class BarChart extends StatelessWidget {
  final BarchartModel barchartModels;

  const BarChart({super.key, required this.barchartModels});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: barchartModels.height,
          decoration: BoxDecoration(
            color: const Color(0xFFFF9500),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          barchartModels.label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
