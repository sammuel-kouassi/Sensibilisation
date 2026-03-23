import 'package:flutter/material.dart';
import '../../../models/stat_card_home_models.dart';
import 'stat_home_card.dart';

class HomeHeader extends StatelessWidget {
  final List<StatCardHomeModels> statCardList;

  const HomeHeader({super.key, required this.statCardList});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF8000), Color(0xFFFFB84D)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... Le haut du header (Bienvenue sur GS2E) reste inchangé ...
          // (Je le raccourcis ici pour la lisibilité, garde ton code actuel pour la ligne du haut)

          const SizedBox(height: 30),

          // L'astuce pour avoir des cartes de hauteur identique :
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Étire les cartes en hauteur
              children: statCardList.asMap().entries.map((entry) {
                final index = entry.key;
                final statModel = entry.value;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == statCardList.length - 1 ? 0 : 16.0,
                    ),
                    child: StatHomeCard(statCardHomeModels: statModel),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}