import 'package:flutter/material.dart';
import '../../../models/barchart_models.dart';

class BarchartItem extends StatelessWidget {
  final BarchartModels barchartModels;

  const BarchartItem({super.key, required this.barchartModels});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
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
        const SizedBox(height: 5),
        Text(
          barchartModels.label,
          style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}