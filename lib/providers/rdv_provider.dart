import 'package:flutter/material.dart';

import '../models/rdv_model.dart';
import '../data/rdv_data.dart';

class RdvProvider extends ChangeNotifier {

  bool _isLoading = false;
  List<RdvModel> _rdvs = [];

  bool get isLoading => _isLoading;
  List<RdvModel> get rdvs => _rdvs;

  RdvProvider() {
    loadRdvs();
  }

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