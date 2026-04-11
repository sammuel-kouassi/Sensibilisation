import 'package:flutter/material.dart';
import '../../../models/bar_chart_model.dart';

class BarchartItem extends StatelessWidget {
  final BarchartModel barchartModels;

  const BarchartItem({super.key, required this.barchartModels});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (barchartModels.count > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              barchartModels.count.toString(),
              style: const TextStyle(
                color: Color(0xFFFF9500),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        Tooltip(
          message:
              '${barchartModels.count} participants en ${barchartModels.label}',
          triggerMode: TooltipTriggerMode.tap,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: 40,
            height: barchartModels.height,
            decoration: const BoxDecoration(
              color: Color(0xFFFF9500),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
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
