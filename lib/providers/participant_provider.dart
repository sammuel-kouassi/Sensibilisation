import 'package:flutter/material.dart';

import '../models/participant_model.dart';
import '../data/participant_data.dart';

class ParticipantProvider extends ChangeNotifier {
  // --- États ---
  bool _isLoading = false;
  List<ParticipantModel> _allParticipants = [];
  List<ParticipantModel> _filteredParticipants = [];

  // --- Getters ---
  bool get isLoading => _isLoading;
  List<ParticipantModel> get filteredParticipants => _filteredParticipants;

  // --- Initialisation ---
  ParticipantProvider() {
    loadParticipants();
  }

  // --- Méthodes ---
  Future<void> loadParticipants() async {
    _isLoading = true;
    notifyListeners();

    // Simulation de chargement (API ou SQLite)
    await Future.delayed(const Duration(milliseconds: 600));

    _allParticipants = ParticipantData.getParticipants();
    _filteredParticipants = List.from(_allParticipants);

    _isLoading = false;
    notifyListeners();
  }

  void filterParticipants(String query) {
    if (query.isEmpty) {
      _filteredParticipants = List.from(_allParticipants);
    } else {
      final searchLower = query.toLowerCase();
      _filteredParticipants = _allParticipants.where((participant) {
        return participant.id.toLowerCase().contains(searchLower) ||
            participant.name.toLowerCase().contains(searchLower) ||
            participant.location.toLowerCase().contains(searchLower);
      }).toList();
    }
    notifyListeners();
  }

  void addParticipant(ParticipantModel participant) {
    _allParticipants.insert(0, participant);

    _filteredParticipants = List.from(_allParticipants);
    notifyListeners();
  }
}