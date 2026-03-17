import 'package:flutter/material.dart';

// Imports Data
import '../../data/chart_data.dart';
import '../../data/quickAccessData.dart';
import '../../data/statcard_data.dart';

// Imports Widgets
import 'widgets/accueil_header.dart';
import 'widgets/quick_access_section.dart';
import 'widgets/participants_chart_section.dart';
import 'widgets/sync_status_card.dart';

class AccueilView extends StatefulWidget {
  const AccueilView({super.key});

  @override
  State<AccueilView> createState() => _AccueilViewState();
}

class _AccueilViewState extends State<AccueilView> {
  @override
  Widget build(BuildContext context) {
    // 1. Récupération des données injectées
    final quickAccessList = getQuickAccessModels(context);
    final statCardList = getStartcardModels(context);
    final barChartList = getBarchartModels(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 2. En-tête avec les cartes de statistiques (Partie Orange)
            AccueilHeader(statCardList: statCardList),

            // 3. Le reste de la page, légèrement remonté sur l'en-tête
            Transform.translate(
              offset: const Offset(0, -40),
              child: Column(
                children: [
                  QuickAccessSection(quickAccessList: quickAccessList),
                  ParticipantsChartSection(barChartList: barChartList),
                  const SyncStatusCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}