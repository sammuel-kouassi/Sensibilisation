import 'package:cie_services/views/statistiques/widgets/stat_grid.dart';
import 'package:flutter/material.dart';

// Imports de tes données
import '../../data/carte_data.dart';
import '../../data/period_data.dart';
import '../../data/barchart_data.dart'; // Contient maintenant getBarchartModels

// Imports de tes widgets
import 'widgets/statistics_header.dart';
import 'widgets/period_selector.dart';

import 'widgets/monthly_chart_widget.dart';
import 'widgets/export_section.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  String _selectedPeriod = PeriodData.defaultPeriod;

  @override
  Widget build(BuildContext context) {
    final carteList = getCarteModels(context);
    final chartData = getBarchartModels(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const StatisticsHeader(),

            PeriodSelector(
              selectedPeriod: _selectedPeriod,
              onPeriodChanged: (newPeriod) {
                setState(() {
                  _selectedPeriod = newPeriod;
                });
              },
            ),

            StatsGridWidget(carteList: carteList),

            // Le graphique reçoit maintenant les bonnes données
            MonthlyChartWidget(chartData: chartData),

            const ExportSection(),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}