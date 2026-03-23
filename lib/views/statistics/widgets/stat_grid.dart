import 'package:flutter/material.dart';
import '../../../models/carte_models.dart';
import 'stat_card.dart';

class StatsGridWidget extends StatelessWidget {
  final List<CarteModels> carteList;

  const StatsGridWidget({super.key, required this.carteList});

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
        itemCount: carteList.length,
        itemBuilder: (context, index) {
          return StatCard(carte: carteList[index]);
        },
      ),
    );
  }
}