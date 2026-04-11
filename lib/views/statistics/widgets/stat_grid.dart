import 'package:flutter/material.dart';
import '../../../models/kpi_model.dart';
import 'stat_card.dart';

class StatsGridWidget extends StatelessWidget {
  final List<KpiModel> kpiList;

  const StatsGridWidget({super.key, required this.kpiList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: kpiList.length,
        itemBuilder: (context, index) {
          return StatCard(kpiModel: kpiList[index]);
        },
      ),
    );
  }
}