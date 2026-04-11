import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

import '../core/api_client.dart';
import '../core/database/local_db.dart';
import 'package:dlf_backend_client/dlf_backend_client.dart' as sp;

import '../models/sync_history_model.dart';
import '../models/sync_queue_model.dart';

class SyncProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isSyncing = false;
  bool _isOnline = true;

  StreamSubscription? _connectivitySubscription;
  StreamSubscription? _dbSubscription;

  List<SyncQueueModel> _waitingQueue = [];
  List<SyncHistoryModel> _lastSync = [];

  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;
  bool get isOnline => _isOnline;
  List<SyncQueueModel> get waitingQueue => _waitingQueue;
  List<SyncHistoryModel> get lastSync => _lastSync;

  int get totalWaiting =>
      _waitingQueue.fold<int>(0, (sum, item) => sum + item.count);

  SyncProvider() {
    loadSyncData();
    _initConnectivity();
    _dbSubscription = localDb.changeStream.listen((_) {
      if (!_isSyncing) loadSyncData();
    });
  }

  Future<void> _initConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _updateConnectionState(result);
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (result) => _updateConnectionState(result),
    );
  }

  void _updateConnectionState(dynamic result) {
    bool hasConnection = true;
    if (result is List<ConnectivityResult>) {
      hasConnection = !result.contains(ConnectivityResult.none);
    } else if (result is ConnectivityResult) {
      hasConnection = result != ConnectivityResult.none;
    }
    if (_isOnline != hasConnection) {
      _isOnline = hasConnection;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _dbSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadSyncData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _waitingQueue = [];
      final unsyncedParts = await localDb.getUnsyncedParticipants();
      if (unsyncedParts.isNotEmpty) {
        _waitingQueue.add(
          SyncQueueModel(
            id: 1,
            title: 'Participants',
            type: 'participant',
            count: unsyncedParts.length,
            status: 'En attente',
          ),
        );
      }

      final unsyncedContacts = await localDb.getUnsyncedPriseContacts();
      if (unsyncedContacts.isNotEmpty) {
        _waitingQueue.add(
          SyncQueueModel(
            id: 2,
            title: 'Prises de contact',
            type: 'contact',
            count: unsyncedContacts.length,
            status: 'En attente',
          ),
        );
      }

      final unsyncedRdvs = await localDb.getUnsyncedRdvs();
      if (unsyncedRdvs.isNotEmpty) {
        _waitingQueue.add(
          SyncQueueModel(
            id: 3,
            title: 'Rendez-vous',
            type: 'rdv',
            count: unsyncedRdvs.length,
            status: 'En attente',
          ),
        );
      }

      final historyData = await localDb.getHistory();
      _lastSync = historyData
          .map(
            (h) => SyncHistoryModel(
              type: h.type,
              title: h.title,
              time: h.time,
              status: h.status,
            ),
          )
          .toList()
          .reversed
          .toList();
    } catch (e) {
      debugPrint("Erreur chargement synchro: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> synchronizeNow() async {
    if (!_isOnline || _waitingQueue.isEmpty) return false;
    _isSyncing = true;
    notifyListeners();
    int successCount = 0;
    bool hasError = false;

    try {
      // 1. Synchronisation des Participants
      final unsyncedParts = await localDb.getUnsyncedParticipants();
      for (final item in unsyncedParts) {
        final serverObj = sp.Participant(
          id: item.serverId,
          seanceId: item.seanceId,
          nom: item.nom,
          prenom: item.prenom,
          telephone: item.telephone,
          profession: item.profession,
          statutLogement: item.statutLogement,
          lieu: item.lieu,
          localite: item.localite,
          quartier: item.quartier,
          besoinsExprimes: item.besoinsExprimes,
          ressenti: item.ressenti,
          consentement: item.consentement,
          statut: item.statut,
          dateInscription: item.dateInscription,
        );
        if (item.serverId == null) {
          final saved = await apiClient.participant.addParticipant(serverObj);
          await localDb.updateParticipant(
            item.copyWith(serverId: drift.Value(saved.id), isSynced: true),
          );
        } else {
          await apiClient.participant.updateParticipant(serverObj);
          await localDb.updateParticipant(item.copyWith(isSynced: true));
        }
        successCount++;
      }

      // 2. Synchronisation des Prises de Contact
      final unsyncedContacts = await localDb.getUnsyncedPriseContacts();
      for (final item in unsyncedContacts) {
        final serverObj = sp.PriseContact(
          id: item.serverId,
          seanceId: item.seanceId,
          nomContact: item.nomContact,
          telephone: item.telephone,
          date: item.date,
          objetMission: item.objetMission,
          directionRegionale: item.directionRegionale,
          agence: item.agence,
          quartier: item.quartier,
          site: item.site,
          pointsAbordes: item.pointsAbordes,
          observations: item.observations,
          signatureBase64: item.signatureBase64,
        );
        if (item.serverId == null) {
          final saved = await apiClient.priseContact.addPriseContact(serverObj);
          await localDb.updatePriseContact(
            item.copyWith(serverId: drift.Value(saved.id), isSynced: true),
          );
        } else {
          await apiClient.priseContact.updatePriseContact(serverObj);
          await localDb.updatePriseContact(item.copyWith(isSynced: true));
        }
        successCount++;
      }

      // 3. Synchronisation des Rendez-vous
      final unsyncedRdvs = await localDb.getUnsyncedRdvs();
      for (final item in unsyncedRdvs) {
        final serverObj = sp.RendezVous(
          id: item.serverId,
          seanceId: item.seanceId,
          titre: item.titre,
          contact: item.contact,
          dateRdv: item.dateRdv,
          heure: item.heure,
          lieu: item.lieu,
          statut: item.statut,
        );
        if (item.serverId == null) {
          final saved = await apiClient.rdv.addRdv(serverObj);
          await localDb.updateRdv(
            item.copyWith(serverId: drift.Value(saved.id), isSynced: true),
          );
        } else {
          await apiClient.rdv.updateRdv(serverObj);
          await localDb.updateRdv(item.copyWith(isSynced: true));
        }
        successCount++;
      }

      if (successCount > 0) {
        final now = DateTime.now();
        final timeStr =
            "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')} à ${now.hour.toString().padLeft(2, '0')}h${now.minute.toString().padLeft(2, '0')}";
        await localDb.insertHistory(
          SyncHistoryTableCompanion.insert(
            type: 'global',
            title: '$successCount éléments synchronisés',
            time: timeStr,
            status: 'success',
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Erreur synchro: $e');
      hasError = true;
      final now = DateTime.now();
      await localDb.insertHistory(
        SyncHistoryTableCompanion.insert(
          type: 'global',
          title: 'Échec de synchronisation',
          time: "Le ${now.day}/${now.month}",
          status: 'error',
        ),
      );
    } finally {
      await loadSyncData();
      _isSyncing = false;
      localDb.notifyDataChanged();
      notifyListeners();
    }
    return !hasError;
  }
}
