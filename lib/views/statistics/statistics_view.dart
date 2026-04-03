import 'package:cie_services/views/statistics/widgets/repart_zone.dart';
import 'package:cie_services/views/statistics/widgets/tend_inscr.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/statistics_provider.dart';

import '../widgets/animated_section.dart';
import 'widgets/statistics_header.dart';
import 'widgets/period_selector.dart';
import 'widgets/stat_grid.dart';
import 'widgets/monthly_chart_widget.dart';
import 'widgets/export_section.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StatisticsProvider()..init(context),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Consumer<StatisticsProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [

                  const AnimatedSection(
                    delayMs: 0,
                    child: StatisticsHeader(),
                  ),

                  Expanded(
                    child: SingleChildScrollView(

                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          AnimatedSection(
                            delayMs: 150,
                            child: PeriodSelector(
                              selectedPeriod: provider.selectedPeriod,
                              onPeriodChanged: (newPeriod) {
                                provider.updatePeriod(context, newPeriod);
                              },
                            ),
                          ),

                          const SizedBox(height: 8),

                          if (provider.isLoading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 60.0),
                              child: CircularProgressIndicator(color: Color(0xFFFF9500)),
                            )
                          else ...[

                            AnimatedSection(
                              delayMs: 300,
                              child: StatsGridWidget(carteList: provider.carteList),
                            ),

                            const SizedBox(height: 8),

                            AnimatedSection(
                              delayMs: 450,
                              child: MonthlyChartWidget(chartData: provider.chartData),
                            ),

                            const AnimatedSection(
                              delayMs: 550,
                              child: RepartZone(),
                            ),

                            const SizedBox(height: 8),

                            const AnimatedSection(
                              delayMs: 650,
                              child: TendInscr(),
                            ),
                          ],

                          const SizedBox(height: 8),

                          const AnimatedSection(
                            delayMs: 750,
                            child: ExportSection(),
                          ),

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