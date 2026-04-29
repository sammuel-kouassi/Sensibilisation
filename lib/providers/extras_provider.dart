import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import '../core/api_client.dart';
import 'package:dlf_backend_client/dlf_backend_client.dart' as sp;
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

  List<SeancesTableData> get seancesEnCours => _seances
      .where(
        (s) =>
            calculerStatut(
              datePrevue: s.datePrevue,
              estTerminee: s.estTerminee,
            ) ==
            SeanceStatut.enCours,
      )
      .toList();

  List<SeancesTableData> get seancesPlanifiees => _seances
      .where(
        (s) =>
            calculerStatut(
              datePrevue: s.datePrevue,
              estTerminee: s.estTerminee,
            ) ==
            SeanceStatut.planifiee,
      )
      .toList();

  List<SeancesTableData> get seancesTerminees => _seances
      .where(
        (s) =>
            calculerStatut(
              datePrevue: s.datePrevue,
              estTerminee: s.estTerminee,
            ) ==
            SeanceStatut.terminee,
      )
      .toList();

  ExtrasProvider() {
    loadSeances();
  }

  Future<void> loadSeances() async {
    _isLoading = true;
    notifyListeners();

    final all = await localDb.getAllSeances();
    all.sort((a, b) {
      final sa = calculerStatut(
        datePrevue: a.datePrevue,
        estTerminee: a.estTerminee,
      );
      final sb = calculerStatut(
        datePrevue: b.datePrevue,
        estTerminee: b.estTerminee,
      );
      int order(SeanceStatut s) {
        switch (s) {
          case SeanceStatut.enCours:
            return 0;
          case SeanceStatut.planifiee:
            return 1;
          case SeanceStatut.terminee:
            return 2;
        }
      }

      return order(sa).compareTo(order(sb));
    });

    _seances = all;
    _isLoading = false;
    notifyListeners();
  }

  void toggleSeance(SeancesTableData seance) {
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
      final seanceLocalId = _selectedSeance!.id;
      final seanceServerId = _selectedSeance!.serverId;

      await localDb.addImage(
        SeanceImagesTableCompanion.insert(
          seanceId: seanceLocalId,
          urls: imagePaths,
          legende: drift.Value(legende?.isNotEmpty == true ? legende : null),
          date: DateTime.now(),
          isSynced: const drift.Value(false),
        ),
      );

      final updatedLocal = _selectedSeance!.copyWith(
        estTerminee: true,
        evaluation: const drift.Value(true),
        nbParticipantsEstime: drift.Value(nbParticipants),
        isSynced: false,
      );
      await localDb.updateSeance(updatedLocal);
      localDb.notifyDataChanged();

      if (seanceServerId != null) {
        try {
          await apiClient.seance.cloreSeance(seanceServerId, nbParticipants);

          if (imagePaths.isNotEmpty) {
            await apiClient.image.addImage(
              sp.Image(
                seanceId: seanceServerId,
                url: imagePaths, // ← chemins locaux directs
                legende: legende?.isNotEmpty == true ? legende : null,
                date: DateTime.now(),
              ),
            );
            debugPrint(
              '✅ Images enregistrées en BD : ${imagePaths.length} image(s)',
            );
          }

          // 3c. Marquer comme synced localement
          await localDb.updateSeance(updatedLocal.copyWith(isSynced: true));
          final images = await localDb.getImagesBySeance(seanceLocalId);
          if (images.isNotEmpty) {
            await localDb.updateImage(images.last.copyWith(isSynced: true));
          }
          localDb.notifyDataChanged();

          debugPrint('✅ Séance clôturée et synchronisée.');
        } catch (e) {
          debugPrint('⚠️ Sync serveur échouée : $e');
        }
      }

      _selectedSeance = null;
      await loadSeances();

      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Erreur clôture : $e');
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }
}
