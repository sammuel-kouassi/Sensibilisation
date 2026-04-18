import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

import '../core/api_client.dart';
import '../core/database/local_db.dart';
import '../models/kpi_model.dart';
import '../models/bar_chart_model.dart';
import '../models/quick_access_model.dart';
import '../data/home_data.dart';

class HomeProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool _isOnline = true;
  bool _isFetching = false;

  int _pendingSyncOperations = 0;

  List<KpiModel> _statCards = [];
  List<QuickAccessModel> _quickAccess = [];
  List<BarchartModel> _barCharts = [];

  StreamSubscription? _connectivitySubscription;
  StreamSubscription? _dbSubscription;

  bool get isLoading => _isLoading;
  bool get isOnline => _isOnline;
  int get pendingSyncOperations => _pendingSyncOperations;
  List<KpiModel> get statCards => _statCards;
  List<QuickAccessModel> get quickAccess => _quickAccess;
  List<BarchartModel> get barCharts => _barCharts;

  void init(BuildContext context) {
    _initConnectivity();
    loadHomeData(context);

    _dbSubscription?.cancel();
    _dbSubscription = localDb.changeStream.listen((_) {
      loadHomeData(context, isRefresh: true);
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

  Future<void> loadHomeData(
      BuildContext context, {
        bool isRefresh = false,
      }) async {
    if (_isFetching) return;

    if (!isRefresh) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      _isFetching = true;

      // Stratégie serveur-first : si en ligne, on merge TOUT depuis PostgreSQL
      if (_isOnline) {
        await _fetchAndMergeAll();
      }

      // Lecture depuis le local (toujours à jour après le merge)
      final participants = await localDb.getAllParticipants();
      final seances = await localDb.getAllSeances();

      final unsyncedParts = await localDb.getUnsyncedParticipants();
      final unsyncedContacts = await localDb.getUnsyncedPriseContacts();
      final unsyncedRdvs = await localDb.getUnsyncedRdvs();
      final unsyncedSeances = await localDb.getUnsyncedSeances();

      _pendingSyncOperations =
          unsyncedParts.length +
              unsyncedContacts.length +
              unsyncedRdvs.length +
              unsyncedSeances.length;

      _quickAccess = HomeData.getQuickAccess(context, _pendingSyncOperations);

      _statCards = [
        KpiModel(
          label: 'Total Participants',
          value: participants.length.toString(),
        ),
        KpiModel(label: 'Séances Prévues', value: seances.length.toString()),
      ];

      _barCharts = _generateChartData(participants);
    } catch (e) {
      debugPrint('Erreur HomeProvider : $e');
    } finally {
      _isFetching = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Merge complet depuis PostgreSQL → local (séances + participants).
  /// ✅ Vérification stricte : n'insère que si l'enregistrement n'existe pas déjà
  Future<void> _fetchAndMergeAll() async {
    await _mergeSeances();
    await _mergeParticipants();
  }

  Future<void> _mergeSeances() async {
    try {
      final serverSeances = await apiClient.seance.getAllSeances();
      final localSeances = await localDb.getAllSeances();

      // Créer un set des serverId locaux pour comparaison rapide
      final localServerIds = localSeances
          .where((s) => s.serverId != null)
          .map((s) => s.serverId)
          .toSet();

      int newCount = 0;
      for (var s in serverSeances) {
        // ✅ Vérifier STRICTEMENT que le serverId n'existe pas en local
        if (!localServerIds.contains(s.id)) {
          await localDb
              .into(localDb.seancesTable)
              .insert(
            SeancesTableCompanion(
              serverId: drift.Value(s.id),
              nom: drift.Value(s.nom),
              objectifs: drift.Value(s.objectifs),
              zone: drift.Value(s.zone),
              objectifParticipants: drift.Value(s.objectifParticipants),
              organisateur: drift.Value(s.organisateur),
              datePrevue: drift.Value(s.datePrevue),
              heureDebut: drift.Value(s.heureDebut),
              heureFin: drift.Value(s.heureFin),
              statut: drift.Value(s.statut),
              gadgetsPrevus: drift.Value(s.gadgetsPrevus ?? 0),
              gadgetsDistribues: drift.Value(s.gadgetsDistribues ?? 0),
              totalLogistique: drift.Value(s.totalLogistique ?? 0.0),
              isSynced: const drift.Value(true),
            ),
          );
          newCount++;
        } else {
          // ⚠️ Optionnel : mettre à jour si les données ont changé
          // (décommenter si nécessaire)
          // await _updateSeanceIfChanged(s, localSeances);
        }
      }

      if (newCount > 0) {
        debugPrint('✅ Home: $newCount nouvelle(s) séance(s) importée(s)');
      } else {
        debugPrint('ℹ️ Home: Toutes les séances sont déjà en local');
      }
    } catch (e) {
      debugPrint('⚠️ Home mergeSeances échoué : $e');
    }
  }

  Future<void> _mergeParticipants() async {
    try {
      final serverParticipants = await apiClient.participant.getAllParticipants();
      final localParticipants = await localDb.getAllParticipants();

      // ✅ Créer une clé unique combinée : serverId (pas de doublons par serverId)
      final localServerIds = localParticipants
          .where((p) => p.serverId != null)
          .map((p) => p.serverId)
          .toSet();

      int newCount = 0;
      for (var p in serverParticipants) {
        // ✅ Vérifier STRICTEMENT que ce serverId n'existe pas en local
        if (!localServerIds.contains(p.id)) {
          await localDb
              .into(localDb.participantsTable)
              .insert(
            ParticipantsTableCompanion(
              serverId: drift.Value(p.id),
              seanceId: drift.Value(p.seanceId),
              nom: drift.Value(p.nom),
              prenom: drift.Value(p.prenom),
              telephone: drift.Value(p.telephone),
              profession: drift.Value(p.profession),
              statutLogement: drift.Value(p.statutLogement),
              lieu: drift.Value(p.lieu),
              localite: drift.Value(p.localite),
              quartier: drift.Value(p.quartier),
              besoinsExprimes: drift.Value(p.besoinsExprimes),
              ressenti: drift.Value(p.ressenti),
              consentement: drift.Value(p.consentement),
              statut: drift.Value(p.statut),
              dateInscription: drift.Value(p.dateInscription),
              isSynced: const drift.Value(true),
            ),
          );
          newCount++;
        } else {
          // ⚠️ Optionnel : mettre à jour si les données ont changé
          // (décommenter si nécessaire)
          // await _updateParticipantIfChanged(p, localParticipants);
        }
      }

      if (newCount > 0) {
        debugPrint('✅ Home: $newCount nouveau(x) participant(s) importé(s)');
      } else {
        debugPrint('ℹ️ Home: Tous les participants sont déjà en local');
      }
    } catch (e) {
      debugPrint('⚠️ Home mergeParticipants échoué : $e');
    }
  }

  List<BarchartModel> _generateChartData(
      List<ParticipantsTableData> participants,
      ) {
    List<BarchartModel> chartData = [];
    final now = DateTime.now();
    final monthNames = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
      'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc',
    ];

    int maxCount = 0;
    List<int> counts = List.filled(6, 0);

    for (int i = 5; i >= 0; i--) {
      final targetDate = DateTime(now.year, now.month - i, 1);
      int count = participants
          .where(
            (p) =>
        p.dateInscription.month == targetDate.month &&
            p.dateInscription.year == targetDate.year,
      )
          .length;
      counts[5 - i] = count;
      if (count > maxCount) maxCount = count;
    }

    for (int i = 5; i >= 0; i--) {
      final targetDate = DateTime(now.year, now.month - i, 1);
      double height = maxCount > 0 ? (counts[5 - i] / maxCount) * 150.0 : 0;
      if (height < 10 && counts[5 - i] > 0) height = 10;
      chartData.add(
        BarchartModel(
          label: monthNames[targetDate.month - 1],
          height: height,
          count: counts[5 - i],
        ),
      );
    }

    return chartData;
  }
}