import 'package:flutter/material.dart';

import '../models/gadget_model.dart';
import '../data/gadget_data.dart';

class GadgetProvider extends ChangeNotifier {
  // --- États ---
  bool _isLoading = false;
  List<GadgetModel> _allGadgets = [];
  List<GadgetModel> _filteredGadgets = [];

  // --- Getters ---
  bool get isLoading => _isLoading;
  List<GadgetModel> get filteredGadgets => _filteredGadgets;

  // --- Initialisation ---
  GadgetProvider() {
    loadGadgets();
  }

  // --- Méthodes ---
  Future<void> loadGadgets() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _allGadgets = GadgetData.getGadgets();
    _filteredGadgets = List.from(_allGadgets);

    _isLoading = false;
    notifyListeners();
  }

  void filterGadgets(String query) {
    if (query.isEmpty) {
      _filteredGadgets = List.from(_allGadgets);
    } else {
      final searchLower = query.toLowerCase();
      _filteredGadgets = _allGadgets.where((gadget) {
        return gadget.name.toLowerCase().contains(searchLower) ||
            gadget.category.toLowerCase().contains(searchLower);
      }).toList();
    }
    notifyListeners();
  }

  void updateGadgetStock(String gadgetId, int quantityDistributed) {
    notifyListeners();
  }
}