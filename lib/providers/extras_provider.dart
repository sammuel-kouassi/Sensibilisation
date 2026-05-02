import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import '../core/api_client.dart';
import 'package:dlf_backend_client/dlf_backend_client.dart' as sp;
import '../core/database/local_db.dart';
import '../models/seance_statut.dart';
import '../services/image_upload_service.dart';

class ExtrasProvider extends ChangeNotifier {
  List<SeancesTableData> _seances = [];
  SeancesTableData? _selectedSeance;
  bool _isLoading = true;
  bool _isSaving = false;

  List<SeancesTableData> get seances => _seances;
  SeancesTableData? get selectedSeance => _selectedSeance;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  // ─── Getters filtrés par statut ───────────────────────────

  List<SeancesTableData> get seancesEnCours => _seances.where((s) =>
  calculerStatut(datePrevue: s.datePrevue, estTerminee: s.estTerminee) ==
      SeanceStatut.enCours).toList();

  List<SeancesTableData> get seancesPlanifiees => _seances.where((s) =>
  calculerStatut(datePrevue: s.datePrevue, estTerminee: s.estTerminee) ==
      SeanceStatut.planifiee).toList();

  List<SeancesTableData> get seancesTerminees => _seances.where((s) =>
  calculerStatut(datePrevue: s.datePrevue, estTerminee: s.estTerminee) ==
      SeanceStatut.terminee).toList();

  ExtrasProvider() {
    loadSeances();
  }

  // ─── Chargement + sync ────────────────────────────────────

  Future<void> loadSeances() async {
    _isLoading = true;
    notifyListeners();

    // 1. Sync estTerminee depuis le serveur avant de lire le local
    await _syncTermineeFromServer();

    // 2. Lecture locale
    final all = await localDb.getAllSeances();
    all.sort((a, b) {
      final sa = calculerStatut(datePrevue: a.datePrevue, estTerminee: a.estTerminee);
      final sb = calculerStatut(datePrevue: b.datePrevue, estTerminee: b.estTerminee);
      int order(SeanceStatut s) {
        switch (s) {
          case SeanceStatut.enCours:   return 0;
          case SeanceStatut.planifiee: return 1;
          case SeanceStatut.terminee:  return 2;
        }
      }
      return order(sa).compareTo(order(sb));
    });

    _seances = all;
    _isLoading = false;
    notifyListeners();
  }

  // ─── Sync estTerminee depuis le serveur ───────────────────
  //
  // On récupère toutes les séances depuis le serveur et on
  // compare avec les séances locales non encore terminées.
  // Si le serveur dit estTerminee = true → on met à jour local.

  Future<void> _syncTermineeFromServer() async {
    try {
      // Séances locales pas encore terminées et ayant un serverId
      final localNonTerminees = (await localDb.getAllSeances())
          .where((s) => !s.estTerminee && s.serverId != null)
          .toList();

      if (localNonTerminees.isEmpty) return;

      // Récupère toutes les séances depuis le serveur
      final serverSeances = await apiClient.seance.getAllSeances();

      if (serverSeances.isEmpty) return;

      // Indexe les séances serveur par leur id pour lookup O(1)
      final serverMap = <int, sp.Seance>{
        for (final s in serverSeances)
          if (s.id != null) s.id!: s,
      };

      for (final local in localNonTerminees) {
        final serverSeance = serverMap[local.serverId];

        if (serverSeance != null && serverSeance.estTerminee == true) {
          // Mise à jour locale
          final updated = local.copyWith(estTerminee: true);
          await localDb.updateSeance(updated);
          localDb.notifyDataChanged();

          // Si cette séance était sélectionnée, on la désélectionne
          if (_selectedSeance?.id == local.id) {
            _selectedSeance = null;
          }

          debugPrint('✅ Séance "${local.nom}" passée à terminée via sync serveur');
        }
      }
    } catch (e) {
      // Silencieux : pas de réseau ou serveur indisponible,
      // on continue avec les données locales
      debugPrint('⚠️ _syncTermineeFromServer échouée : $e');
    }
  }

  // ─── Sélection / désélection d'une séance ────────────────

  void toggleSeance(SeancesTableData seance) {
    if (seance.estTerminee) return;
    _selectedSeance = (_selectedSeance?.id == seance.id) ? null : seance;
    notifyListeners();
  }

  // ─── Enregistrement des photos et participants ─────────────

  Future<bool> saveImagesAndParticipants({
    required List<String> imagePaths,
    required String? legende,
    required int nbParticipants,
  }) async {
    if (_selectedSeance == null) return false;

    _isSaving = true;
    notifyListeners();

    try {
      final seanceLocalId  = _selectedSeance!.id;
      final seanceServerId = _selectedSeance!.serverId;

      // 1. Upload des images vers le back Spring Boot
      List<String> publicUrls = imagePaths;
      if (imagePaths.isNotEmpty) {
        try {
          publicUrls = await ImageUploadService().uploadImages(imagePaths);
        } catch (e) {
          debugPrint('⚠️ Upload images échoué, utilisation des chemins locaux');
          publicUrls = imagePaths;
        }
      }

      // 2. Sauvegarde locale des images
      await localDb.addImage(
        SeanceImagesTableCompanion.insert(
          seanceId: seanceLocalId,
          urls: publicUrls,
          legende: drift.Value(legende?.isNotEmpty == true ? legende : null),
          date: DateTime.now(),
          isSynced: const drift.Value(false),
        ),
      );

      // 3. Mise à jour du nombre estimé de participants (localement)
      final updatedLocal = _selectedSeance!.copyWith(
        nbParticipantsEstime: drift.Value(nbParticipants),
      );
      await localDb.updateSeance(updatedLocal);
      localDb.notifyDataChanged();

      // 4. Synchronisation avec Serverpod
      if (seanceServerId != null) {
        try {
          // 4a. Mettre à jour le nombre estimé de participants
          await apiClient.seance.updateNbParticipants(seanceServerId, nbParticipants);
          debugPrint('✅ nbParticipantsEstime synchronisé avec le serveur');

          // 4b. Enregistrer les images
          if (publicUrls.isNotEmpty) {
            await apiClient.image.addImage(
              sp.Image(
                seanceId: seanceServerId,
                url: publicUrls,
                legende: legende?.isNotEmpty == true ? legende : null,
                date: DateTime.now(),
              ),
            );
          }

          // Marquer comme synchronisé
          await localDb.updateSeance(updatedLocal.copyWith(isSynced: true));
          final images = await localDb.getImagesBySeance(seanceLocalId);
          if (images.isNotEmpty) {
            await localDb.updateImage(images.last.copyWith(isSynced: true));
          }
          localDb.notifyDataChanged();
        } catch (e) {
          debugPrint('⚠️ Sync Serverpod échouée (sera retentée) : $e');
        }
      }

      _selectedSeance = null;
      await loadSeances();

      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Erreur enregistrement : $e');
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }
}