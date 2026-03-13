import 'package:flutter/material.dart';

import '../../data/barchart_data.dart';
import '../../data/quickAccessData.dart';
import '../../data/statcard_data.dart';
import '../../models/barchart_models.dart';
import '../../models/quickAccessItem_models.dart';
import 'package:cie_services/views/accueil/widgets/barchart.dart';
import 'package:cie_services/views/accueil/widgets/quickAccessItem.dart';

import '../../models/startcard_home_models.dart';
import 'widgets/stat_home_card.dart';

class AccueilView extends StatefulWidget {
  const AccueilView({super.key});

  @override
  State<AccueilView> createState() => _AccueilViewState();
}

class _AccueilViewState extends State<AccueilView> {
  @override
  Widget build(BuildContext context) {
    final List<QuickAccessModel> quickAccessList = getQuickAccessModels(context);
    final List<StartCardHomeModels> statCardList = getStartcardModels(context);
    final List<BarchartModels> barChartList = getBarchartModels(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bienvenue sur',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'GS2E',
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    '2',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  Row(
                    children: statCardList.map((statModel) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: statModel == statCardList.last ? 0 : 16.0,
                          ),
                          child: StatCard(startcardModels: statModel),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ), // FIN DU CONTAINER ORANGE

            // --- LE RESTE DE LA PAGE ---
            Transform.translate(
              offset: const Offset(0, -40),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Accès rapide',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                          children: quickAccessList.map((model) {
                            return QuickAccess(quickAccessModel: model);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Participants / mois',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '6 derniers mois',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: barChartList.map((barchartModels) {
                              return Expanded(
                                  child: BarChart(barchartModels: barchartModels),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 150),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4F1E4),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.sync_outlined,
                                    size: 28,
                                    color: Color(0xFF4CAF50),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Synchronisation',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '12 opérations en attente',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Connecté',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}