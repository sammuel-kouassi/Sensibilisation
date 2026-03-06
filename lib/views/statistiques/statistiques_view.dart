import 'package:cie_services/views/statistiques/widgets/export_button.dart';
import 'package:cie_services/views/statistiques/widgets/lineChartPainter.dart';
import 'package:cie_services/views/statistiques/widgets/period_option.dart';
import 'package:cie_services/views/statistiques/widgets/pieChartPainter.dart';
import 'package:flutter/material.dart';

import '../accueil/widgets/barchart.dart';
import '../accueil/widgets/stat_card.dart';

class StatistiquesView extends StatefulWidget {
  const StatistiquesView({super.key});

  @override
  State<StatistiquesView> createState() => _StatistiquesViewState();
}

class _StatistiquesViewState extends State<StatistiquesView> {
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              color: Colors.grey.withOpacity(0.2),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isDropdownOpen = !_isDropdownOpen;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFF8000),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedPeriod,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        _isDropdownOpen
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: Colors.grey[600],
                        size: 14,
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
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.15),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PeriodOption(
                      title: 'Ce mois',
                      isSelected: _selectedPeriod == 'Ce mois',
                      onTap: () {
                        setState(() {
                          _selectedPeriod = 'Ce mois';
                          _isDropdownOpen = false;
                        });
                        debugPrint('📊 Période sélectionnée: Ce mois');
                      },
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    PeriodOption(
                      title: '3 derniers mois',
                      isSelected: _selectedPeriod == '3 derniers mois',
                      onTap: () {
                        setState(() {
                          _selectedPeriod = '3 derniers mois';
                          _isDropdownOpen = false;
                        });
                        debugPrint('📊 Période sélectionnée: 3 derniers mois');
                      },
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    PeriodOption(
                      title: '6 derniers mois',
                      isSelected: _selectedPeriod == '6 derniers mois',
                      onTap: () {
                        setState(() {
                          _selectedPeriod = '6 derniers mois';
                          _isDropdownOpen = false;
                        });
                        debugPrint('📊 Période sélectionnée: 6 derniers mois');
                      },
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    PeriodOption(
                      title: 'Cette année',
                      isSelected: _selectedPeriod == 'Cette année',
                      onTap: () {
                        setState(() {
                          _selectedPeriod = 'Cette année';
                          _isDropdownOpen = false;
                        });
                        debugPrint('📊 Période sélectionnée: Cette année');
                      },
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.people_outline,
                          iconColor: const Color(0xFF21951D),
                          number: '1247',
                          label: 'Total participants',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          icon: Icons.radio_button_unchecked,
                          iconColor: const Color(0xFF21951D),
                          number: '78%',
                          label: 'Taux réalisation',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.bookmark_outline,
                          iconColor: const Color(0xFF21951D),
                          number: '24',
                          label: 'Agents actifs',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          icon: Icons.trending_up,
                          iconColor: const Color(0xFF21951D),
                          number: '3456',
                          label: 'Gadgets distribués',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Évolution mensuelle',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    height: 220,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        BarChart(height: 100, label: 'Sept'),
                        BarChart(height: 130, label: 'Oct'),
                        BarChart(height: 150, label: 'Nov'),
                        BarChart(height: 170, label: 'Déc'),
                        BarChart(height: 140, label: 'Jan'),
                        BarChart(height: 180, label: 'Févr'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(75),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Répartition par zone',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(200, 200),
                          painter: PieChartPainter(),
                        ),

                        Positioned(
                          top: 0,
                          right: 0,
                          child: Text(
                            'Abobo 27%',
                            style: const TextStyle(
                              color: Color(0xFFFF9500),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 110,
                          right: 0,
                          child: Text(
                            'Plateau 5%',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Text(
                            'Marcory 10%',
                            style: const TextStyle(
                              color: Color(0xFFE74C3C),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Text(
                            'Cocody 37%',
                            style: const TextStyle(
                              color: Color(0xFFFFC107),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Text(
                            'Yopougon 21%',
                            style: const TextStyle(
                              color: Color(0xFF4CAF50),
                              fontSize: 14,
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

            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tendance des inscriptions',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    height: 220,
                    child: CustomPaint(
                      size: const Size(double.infinity, 220),
                      painter: LineChartPainter(),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Row(
                children: [
                  Expanded(
                    child: ExportButton(
                      icon: Icons.description_outlined,
                      iconColor: const Color(0xFFFF9500),
                      title: 'Export PDF',
                      subtitle: 'Rapport complet',
                      onTap: () {
                        debugPrint('📄 Export PDF cliqué');
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ExportButton(
                      icon: Icons.bar_chart_outlined,
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Export Excel',
                      subtitle: 'Données brutes',
                      onTap: () {
                        debugPrint('📊 Export Excel cliqué');
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }
}