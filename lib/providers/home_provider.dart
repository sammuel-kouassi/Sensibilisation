import 'package:flutter/material.dart';
import '../models/barchart_models.dart';
import '../models/quickAccessItem_models.dart';
import '../models/startcard_home_models.dart';

class HomeProvider extends ChangeNotifier {
  // --- États ---
  bool _isLoading = true;
  bool _isOnline = true; // Simule l'état du réseau
  int _pendingSyncOperations = 12; // Opérations en attente de synchro

  List<StartCardHomeModels> _statCards = [];
  List<QuickAccessModel> _quickAccess = [];
  List<BarchartModels> _barCharts = [];

  // --- Getters ---
  bool get isLoading => _isLoading;
  bool get isOnline => _isOnline;
  int get pendingSyncOperations => _pendingSyncOperations;

  List<StartCardHomeModels> get statCards => _statCards;
  List<QuickAccessModel> get quickAccess => _quickAccess;
  List<BarchartModels> get barCharts => _barCharts;

  // --- Initialisation ---
  HomeProvider() {
    loadHomeData();
  }

  // --- Méthodes ---
  Future<void> loadHomeData() async {
    _isLoading = true;
    notifyListeners();

    // TODO: Plus tard, remplacer par l'appel au Repository (ex: HomeRepository.getDashboardData())
    // Pour l'instant, on simule un chargement depuis tes anciennes fonctions
    await Future.delayed(const Duration(milliseconds: 800)); // Simule latence

    // Remplacer ces lignes par tes vraies données d'initialisation
    _statCards = []; // getStartcardModels()
    _quickAccess = []; // getQuickAccessModels()
    _barCharts = []; // getBarchartModels()

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
    // Logique de synchronisation avec le backend (à implémenter plus tard)
    await Future.delayed(const Duration(seconds: 2));
    _pendingSyncOperations = 0;
    notifyListeners();
  }
}