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
          width: 45,
          height: barchartModels.height,
          decoration: const BoxDecoration(
            color: Color(0xFFFF8000),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          barchartModels.label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}