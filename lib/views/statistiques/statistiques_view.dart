import 'package:cie_services/views/statistiques/widgets/stat_grid.dart';
import 'package:flutter/material.dart';

// Imports de tes données
import '../../data/carte_data.dart';
import '../../data/period_data.dart';
import '../../data/chart_data.dart'; // Contient maintenant getBarchartModels

// Imports de tes widgets
import 'widgets/statistics_header.dart';
import 'widgets/period_selector.dart';

import 'widgets/monthly_chart_widget.dart';
import 'widgets/export_section.dart';

class StatistiquesView extends StatefulWidget {
  const StatistiquesView({super.key});

  @override
  State<StatistiquesView> createState() => _StatistiquesViewState();
}

class _StatistiquesViewState extends State<StatistiquesView> {
  String _selectedPeriod = PeriodData.defaultPeriod;

  @override
  Widget build(BuildContext context) {
    // 🛠️ CORRECTION ICI : On utilise getBarchartModels(context) au lieu de l'ancienne méthode
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