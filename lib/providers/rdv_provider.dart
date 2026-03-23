import 'package:flutter/material.dart';

import '../models/rdv_model.dart';
import '../data/rdv_data.dart';

class RdvProvider extends ChangeNotifier {
  // --- États ---
  bool _isLoading = false;
  List<RdvModel> _rdvs = [];

  // --- Getters ---
  bool get isLoading => _isLoading;
  List<RdvModel> get rdvs => _rdvs;

  // --- Initialisation ---
  RdvProvider() {
    loadRdvs();
  }

  // --- Méthodes ---
  Future<void> loadRdvs() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _rdvs = RdvData.getRdvs();

    _isLoading = false;
    notifyListeners();
  }

  void addRdv(RdvModel rdv) {
    _rdvs.insert(0, rdv);
    notifyListeners();
  }
}