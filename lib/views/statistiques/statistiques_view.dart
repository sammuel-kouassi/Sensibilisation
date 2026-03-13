import 'package:cie_services/data/carte_data.dart';
import 'package:cie_services/models/carte_models.dart';
import 'package:cie_services/views/statistiques/widgets/export_button.dart';
import 'package:cie_services/views/statistiques/widgets/period_option.dart';
import 'package:flutter/material.dart';

import '../../models/barchart_models.dart';
import '../accueil/widgets/barchart.dart';
import '../accueil/widgets/stat_home_card.dart';

class StatistiquesView extends StatefulWidget {
  const StatistiquesView({super.key});

  @override
  State<StatistiquesView> createState() => _StatistiquesViewState();
}

class _StatistiquesViewState extends State<StatistiquesView> {

}
  String _selectedPeriod = 'Ce mois';
  bool _isDropdownOpen = false;

  final List<String> _periods = [
    'Ce mois',
    '3 derniers mois',
    '6 derniers mois',
    'Cette année',
  ];

  @override
  Widget build(BuildContext context) {
    final List<CarteModels> carteList = getCarteModels(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Row(
                children: [
                  Text(
                    'Statistiques',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 1,
              color: Colors.grey.withValues(alpha: 0.2),
            ),

            // DROPDOWN PERIODE
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: GestureDetector(
                onTap: () => setState(() => _isDropdownOpen = !_isDropdownOpen),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                    Border.all(color: const Color(0xFFFF8000), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedPeriod,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        _isDropdownOpen
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (_isDropdownOpen)
              Container(
                margin: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border:
                  Border.all(color: Colors.grey.withValues(alpha: 0.15), width: 1.5),
                ),
                child: Column(
                  children: _periods.map((period) {
                    return Column(
                      children: [
                        PeriodOption(
                          title: period,
                          isSelected: _selectedPeriod == period,
                          onTap: () {
                            setState(() {
                              _selectedPeriod = period;
                              _isDropdownOpen = false;
                            });
                          },
                        ),
                        if (period != _periods.last)
                          Container(
                            height: 1,
                            color: Colors.grey.withValues(alpha: 0.1),
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),

            // CARTES STATISTIQUES
            Padding(
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
                  return StatCard(carte: carteList[index]);                },
              ),
            ),

            // GRAPHIQUE
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Évolution mensuelle',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBarChart(100, 'Sept'),
                        _buildBarChart(130, 'Oct'),
                        _buildBarChart(150, 'Nov'),
                        _buildBarChart(170, 'Déc'),
                        _buildBarChart(140, 'Jan'),
                        _buildBarChart(180, 'Févr'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // EXPORT
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ExportButton(
                      icon: Icons.description_outlined,
                      iconColor: const Color(0xFFFF9500),
                      title: 'Export PDF',
                      subtitle: 'Rapport complet',
                      onTap: () => debugPrint('PDF'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ExportButton(
                      icon: Icons.bar_chart_outlined,
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Export Excel',
                      subtitle: 'Données brutes',
                      onTap: () => debugPrint('Excel'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }



  Widget _buildBarChart(double height, String label) {
    return Expanded(
      child: BarChart(
        barchartModels: BarchartModels(height: height, label: label),
      ),
    );
  }
