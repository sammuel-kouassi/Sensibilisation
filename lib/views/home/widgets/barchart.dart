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
          width: 36,
          height: barchartModels.height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xFFFF8000), Color(0xFFFFB347)],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          barchartModels.label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}