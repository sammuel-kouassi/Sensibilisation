import 'package:flutter/material.dart';

import '../data/stat_card_home_data.dart';
import '../models/barchart_models.dart';
import '../models/quick_access_models.dart';
import '../models/stat_card_home_models.dart';
import '../data/barchart_data.dart';
import '../data/quick_access_data.dart';

class HomeProvider extends ChangeNotifier {

  bool _isLoading = true;
  bool _isOnline = true;
  int _pendingSyncOperations = 12;

  List<StatCardHomeModels> _statCards = [];
  List<QuickAccessModel> _quickAccess = [];
  List<BarchartModels> _barCharts = [];

  bool get isLoading => _isLoading;
  bool get isOnline => _isOnline;
  int get pendingSyncOperations => _pendingSyncOperations;

  List<StatCardHomeModels> get statCards => _statCards;
  List<QuickAccessModel> get quickAccess => _quickAccess;
  List<BarchartModels> get barCharts => _barCharts;

  // --- Initialisation ---
  void init(BuildContext context) {
    if (_statCards.isEmpty && _isLoading) {
      loadHomeData(context);
    }
  }

  // --- Méthodes ---
  Future<void> loadHomeData(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _statCards = getStatCardModels(context);
    _quickAccess = getQuickAccessModels(context);
    _barCharts = getBarchartModels(context);

    _isLoading = false;
    notifyListeners();
  }

  void updateConnectionStatus(bool status) {
    _isOnline = status;
    notifyListeners();
    if (_isOnline && _pendingSyncOperations > 0) {
      syncData();
    }
  }

  Future<void> syncData() async {
    await Future.delayed(const Duration(seconds: 2));
    _pendingSyncOperations = 0;
    notifyListeners();
  }
}