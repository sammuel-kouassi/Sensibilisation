import 'package:flutter/material.dart';

import '../models/carte_models.dart';
import '../models/barchart_models.dart';
import '../data/carte_data.dart';
import '../data/barchart_data.dart';
import '../data/period_data.dart';

class StatisticsProvider extends ChangeNotifier {
  // --- États ---
  bool _isLoading = false;
  String _selectedPeriod = PeriodData.defaultPeriod;

  List<CarteModels> _carteList = [];
  List<BarchartModels> _chartData = [];

  // --- Getters ---
  bool get isLoading => _isLoading;
  String get selectedPeriod => _selectedPeriod;
  List<CarteModels> get carteList => _carteList;
  List<BarchartModels> get chartData => _chartData;

  // --- Initialisation ---
  void init(BuildContext context) {
    if (_carteList.isEmpty && !_isLoading) {
      loadStatistics(context);
    }
  }

  // --- Méthodes ---
  Future<void> loadStatistics(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _carteList = getCarteModels(context);
    _chartData = getBarchartModels(context);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updatePeriod(BuildContext context, String newPeriod) async {
    if (_selectedPeriod == newPeriod) return;

    _selectedPeriod = newPeriod;
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _carteList = getCarteModels(context);
    _chartData = getBarchartModels(context);

    _isLoading = false;
    notifyListeners();
  }
}