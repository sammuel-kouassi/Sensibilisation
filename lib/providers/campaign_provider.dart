import 'package:flutter/material.dart';

import '../models/campaign_model.dart';
import '../data/campaign_data.dart';

class CampaignProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<CampaignModel> _allCampaigns = [];
  List<CampaignModel> _filteredCampaigns = [];

  // --- Getters ---
  bool get isLoading => _isLoading;
  List<CampaignModel> get filteredCampaigns => _filteredCampaigns;

  // --- Initialisation ---
  CampaignProvider() {
    loadCampaigns();
  }

  // --- Méthodes ---
  Future<void> loadCampaigns() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _allCampaigns = CampaignData.getCampaigns();
    _filteredCampaigns = List.from(_allCampaigns);

    _isLoading = false;
    notifyListeners();
  }

  void filterCampaigns(String query) {
    if (query.isEmpty) {
      _filteredCampaigns = List.from(_allCampaigns);
    } else {
      final searchLower = query.toLowerCase();
      _filteredCampaigns = _allCampaigns.where((campaign) {
        final titleLower = campaign.title.toLowerCase();
        final locationLower = campaign.location.toLowerCase();
        return titleLower.contains(searchLower) ||
            locationLower.contains(searchLower);
      }).toList();
    }
    notifyListeners();
  }

  void addCampaign(CampaignModel campaign) {
    _allCampaigns.insert(0, campaign);

    _filteredCampaigns = List.from(_allCampaigns);
    notifyListeners();
  }
}
