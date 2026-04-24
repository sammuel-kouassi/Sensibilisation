import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import '../core/database/local_db.dart';
import '../models/seance_statut.dart';

class ExtrasProvider extends ChangeNotifier {
  List<SeancesTableData> _seances = [];
  SeancesTableData? _selectedSeance;
  bool _isLoading = true;
  bool _isSaving = false;

  List<SeancesTableData> get seances => _seances;
  SeancesTableData? get selectedSeance => _selectedSeance;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  // Getters groupés par statut
  List<SeancesTableData> get seancesEnCours => _seances
      .where((s) => calculerStatut(datePrevue: s.datePrevue, estTerminee: s.estTerminee) == SeanceStatut.enCours)
      .toList();

  List<SeancesTableData> get seancesPlanifiees => _seances
      .where((s) => calculerStatut(datePrevue: s.datePrevue, estTerminee: s.estTerminee) == SeanceStatut.planifiee)
      .toList();

  List<SeancesTableData> get seancesTerminees => _seances
      .where((s) => calculerStatut(datePrevue: s.datePrevue, estTerminee: s.estTerminee) == SeanceStatut.terminee)
      .toList();

  ExtrasProvider() {
    loadSeances();
  }

  Future<void> loadSeances() async {
    _isLoading = true;
    notifyListeners();

    // ✅ Charger TOUTES les séances (pas seulement actives)
    final all = await localDb.getAllSeances();
    all.sort((a, b) {
      final sa = calculerStatut(datePrevue: a.datePrevue, estTerminee: a.estTerminee);
      final sb = calculerStatut(datePrevue: b.datePrevue, estTerminee: b.estTerminee);
      int order(SeanceStatut s) {
        switch (s) {
          case SeanceStatut.enCours: return 0;
          case SeanceStatut.planifiee: return 1;
          case SeanceStatut.terminee: return 2;
        }
      }
      return order(sa).compareTo(order(sb));
    });

    _seances = all;
    _isLoading = false;
    notifyListeners();
  }

  void toggleSeance(SeancesTableData seance) {
    // Ne pas sélectionner une séance terminée
    if (seance.estTerminee) return;
    _selectedSeance = (_selectedSeance?.id == seance.id) ? null : seance;
    notifyListeners();
  }

  Future<bool> saveImagesAndClose({
    required List<String> imagePaths,
    required String? legende,
    required int nbParticipants,
  }) async {
    if (_selectedSeance == null) return false;

    _isSaving = true;
    notifyListeners();

    try {
      // 1. Sauvegarder toutes les images en un seul enregistrement
      if (imagePaths.isNotEmpty) {
        await localDb.addImage(
          SeanceImagesTableCompanion.insert(
            seanceId: _selectedSeance!.id,
            urls: imagePaths,
            legende: drift.Value(legende?.isNotEmpty == true ? legende : null),
            date: DateTime.now(),
          ),
        );
      }

      // 2. Clore la séance — evaluation passe à true
      final updated = _selectedSeance!.copyWith(
        estTerminee: true,
        evaluation: const drift.Value(true),
        nbParticipantsEstime: drift.Value(nbParticipants),
      );
      await localDb.updateSeance(updated);
      localDb.notifyDataChanged();

      _selectedSeance = null;
      await loadSeances();

      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erreur clôture : $e');
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }
}