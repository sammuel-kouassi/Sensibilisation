import 'dart:async';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

import '../core/api_client.dart';
import 'package:dlf_backend_client/dlf_backend_client.dart' as sp;
import '../core/database/local_db.dart';
import '../models/rdv_model.dart';
import '../services/notification_service.dart';

class RdvProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<RdvModel> _rdvs = [];
  StreamSubscription? _dbSubscription;

  bool get isLoading => _isLoading;
  List<RdvModel> get rdvs => _rdvs;

  RdvProvider() {
    loadRdvs();
    _dbSubscription = localDb.changeStream.listen((_) => loadRdvs());
  }

  @override
  void dispose() {
    _dbSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadRdvs() async {
    _isLoading = true;
    notifyListeners();
    try {
      final localData = await localDb.getAllRdvs();
      _rdvs = localData
          .map(
            (row) => RdvModel(
              id: row.id,
              seanceId: row.seanceId,
              titre: row.titre,
              contact: row.contact,
              dateRdv: row.dateRdv,
              heure: row.heure,
              lieu: row.lieu,
              statut: row.statut,
            ),
          )
          .toList()
          .reversed
          .toList();
    } catch (e) {
      debugPrint('❌ Erreur RDV SQLite');
    }
    _isLoading = false;
    notifyListeners();
  }

  // --- AJOUT ---
  Future<void> addRdv(RdvModel localRdv) async {
    try {
      final newDbRdv = RdvsTableCompanion.insert(
        seanceId: localRdv.seanceId,
        titre: localRdv.titre,
        contact: localRdv.contact,
        dateRdv: localRdv.dateRdv,
        heure: localRdv.heure,
        lieu: localRdv.lieu,
        statut: localRdv.statut,
        isSynced: const drift.Value(false),
      );

      final generatedLocalId = await localDb.addRdv(newDbRdv);

      // 🔔 Programmation des alertes
      await NotificationService().scheduleAllRdvNotifications(
        generatedLocalId,
        localRdv,
      );

      // 📣 Signal Temps Réel
      localDb.notifyDataChanged();

      // Synchro Serveur
      final serverRdv = sp.RendezVous(
        seanceId: localRdv.seanceId,
        titre: localRdv.titre,
        contact: localRdv.contact,
        dateRdv: localRdv.dateRdv,
        heure: localRdv.heure,
        lieu: localRdv.lieu,
        statut: localRdv.statut,
      );
      final savedServerRdv = await apiClient.rdv.addRdv(serverRdv);

      await localDb.updateRdv(
        RdvsTableData(
          id: generatedLocalId,
          serverId: savedServerRdv.id,
          seanceId: localRdv.seanceId,
          titre: localRdv.titre,
          contact: localRdv.contact,
          dateRdv: localRdv.dateRdv,
          heure: localRdv.heure,
          lieu: localRdv.lieu,
          statut: localRdv.statut,
          isSynced: true,
        ),
      );

      localDb.notifyDataChanged();
    } catch (e) {
      debugPrint('⚠️ Erreur ajout RDV');
    }
  }

  // --- MISE À JOUR ---
  Future<void> updateRdv(RdvModel rdv) async {
    if (rdv.id == null) return;
    try {
      final localDataList = await localDb.getAllRdvs();
      final existingData = localDataList.firstWhere((r) => r.id == rdv.id);

      final updatedData = RdvsTableData(
        id: rdv.id!,
        serverId: existingData.serverId,
        seanceId: rdv.seanceId,
        titre: rdv.titre,
        contact: rdv.contact,
        dateRdv: rdv.dateRdv,
        heure: rdv.heure,
        lieu: rdv.lieu,
        statut: rdv.statut,
        isSynced: false,
      );

      await localDb.updateRdv(updatedData);

      await NotificationService().cancelAllRdvNotifications(rdv.id!);
      await NotificationService().scheduleAllRdvNotifications(rdv.id!, rdv);

      localDb.notifyDataChanged();

      if (existingData.serverId != null) {
        final serverRdv = sp.RendezVous(
          id: existingData.serverId,
          seanceId: rdv.seanceId,
          titre: rdv.titre,
          contact: rdv.contact,
          dateRdv: rdv.dateRdv,
          heure: rdv.heure,
          lieu: rdv.lieu,
          statut: rdv.statut,
        );
        await apiClient.rdv.updateRdv(serverRdv);
        await localDb.updateRdv(updatedData.copyWith(isSynced: true));
        localDb.notifyDataChanged();
      }
    } catch (e) {
      debugPrint('⚠️ Erreur update RDV');
    }
  }

  // --- SUPPRESSION ---
  // --- SUPPRESSION ---
  Future<void> deleteRdv(int localId, int? serverId) async {
    try {
      // 1. Récupérer le vrai serverId depuis la base locale
      final localDataList = await localDb.getAllRdvs();
      final existingData = localDataList.firstWhere((r) => r.id == localId);
      final trueServerId = serverId ?? existingData.serverId;

      // 2. Supprimer d'abord sur PostgreSQL
      if (trueServerId != null) {
        await apiClient.rdv.deleteRdv(trueServerId);
      }

      // 3. Supprimer localement et annuler les notifications
      await NotificationService().cancelAllRdvNotifications(localId);
      await localDb.deleteRdv(localId);
      localDb.notifyDataChanged();

    } catch (e) {
      debugPrint('⚠️ Erreur suppression RDV (Serveur/Local) : $e');
    }
  }
}
