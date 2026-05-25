import 'package:cie_services/views/statistics/widgets/trimestre_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/statistics_provider.dart';
import '../widgets/animated_section.dart';
import 'widgets/period_selector.dart';
import 'widgets/stat_grid.dart';
import 'widgets/monthly_chart_widget.dart';
import 'widgets/export_section.dart';
import 'widgets/repart_zone.dart';
import 'widgets/tend_inscr.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  static const _orange = Color(0xFFFF8000);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StatisticsProvider()..init(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: Consumer<StatisticsProvider>(
          builder: (context, provider, child) {
            return CustomScrollView(
              slivers: [
                // ── AppBar gradient ──
                SliverAppBar(
                  expandedHeight: 120,
                  pinned: true,
                  backgroundColor: _orange,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [_orange, Color(0xFFe06b00)],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20, top: -20,
                            child: Container(
                              width: 140, height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.07),
                              ),
                            ),
                          ),
                          Positioned(
                            left: -30, bottom: -10,
                            child: Container(
                              width: 100, height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Statistiques',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Analyse et rapports de performance',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Contenu ──
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      AnimatedSection(
                        delayMs: 100,
                        child: PeriodSelector(
                          selectedPeriod: provider.selectedPeriod,
                          availablePeriods: const [
                            '7 derniers jours',
                            '30 derniers jours',
                            'Cette année',
                          ],
                          onPeriodChanged: provider.updatePeriod,
                        ),
                      ),

                      AnimatedSection(
                        delayMs: 150,
                        child: TrimestreSelector(
                          selectedPeriod: provider.selectedPeriod,
                          onSelected: provider.updatePeriod,
                        ),
                      ),

                      const SizedBox(height: 8),

                      if (provider.isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 80),
                          child: CircularProgressIndicator(color: _orange),
                        )
                      else ...[
                        AnimatedSection(
                          delayMs: 200,
                          child: StatsGridWidget(
                              kpiList: provider.kpiList),
                        ),
                        AnimatedSection(
                          delayMs: 300,
                          child: MonthlyChartWidget(
                              chartData: provider.chartData),
                        ),
                        AnimatedSection(
                          delayMs: 400,
                          child: RepartZone(
                              zoneData: provider.zoneData),
                        ),
                        AnimatedSection(
                          delayMs: 500,
                          child: TendInscr(
                              trendData: provider.trendData),
                        ),
                      ],

                      const SizedBox(height: 8),

                      const AnimatedSection(
                        delayMs: 600,
                        child: ExportSection(),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}