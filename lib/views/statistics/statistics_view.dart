import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/statistics_provider.dart';

import '../home/home_view.dart';
import '../widgets/animated_section.dart';
import 'widgets/statistics_header.dart';
import 'widgets/period_selector.dart';
import 'widgets/stat_grid.dart';
import 'widgets/monthly_chart_widget.dart';
import 'widgets/export_section.dart';

// N'oublie pas d'importer ton widget d'animation natif !
// import '../../widgets/animated_section.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StatisticsProvider()..init(context),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea( // Empêche le header de passer sous l'encoche du téléphone
          child: Consumer<StatisticsProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  // 1. EN-TÊTE FIXE (Apparaît immédiatement)
                  const AnimatedSection(
                    delayMs: 0,
                    child: StatisticsHeader(),
                  ),

                  // 2. ZONE DE DÉFILEMENT (Prend le reste de l'écran)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Sélecteur de période (Apparaît à 150ms)
                          AnimatedSection(
                            delayMs: 150,
                            child: PeriodSelector(
                              selectedPeriod: provider.selectedPeriod,
                              onPeriodChanged: (newPeriod) {
                                provider.updatePeriod(context, newPeriod);
                              },
                            ),
                          ),

                          // Espacement pour faire respirer la page
                          const SizedBox(height: 8),

                          // Gestion du chargement
                          if (provider.isLoading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 60.0),
                              child: CircularProgressIndicator(color: Color(0xFFFF9500)),
                            )
                          else ...[
                            // Grille de statistiques (Apparaît à 300ms)
                            AnimatedSection(
                              delayMs: 300,
                              child: StatsGridWidget(carteList: provider.carteList),
                            ),

                            // Espacement entre la grille et le graphique
                            const SizedBox(height: 8),

                            // Graphique d'évolution (Apparaît à 450ms)
                            AnimatedSection(
                              delayMs: 450,
                              child: MonthlyChartWidget(chartData: provider.chartData),
                            ),
                          ],

                          // Espacement avant la section d'export
                          const SizedBox(height: 8),

                          // Section d'export (Apparaît à 600ms)
                          const AnimatedSection(
                            delayMs: 600,
                            child: ExportSection(),
                          ),

                          // Espace vide en bas pour pouvoir scroller confortablement
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}