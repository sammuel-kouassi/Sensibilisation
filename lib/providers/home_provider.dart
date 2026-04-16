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
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      _updateConnectionState(result);
    });
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

      final participants = await localDb.getAllParticipants();
      var seances = await localDb.getAllSeances();

      if (_isOnline) {
        await _syncNewSeancesOnly(seances);
        seances = await localDb.getAllSeances();
      }

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

  Future<void> _syncNewSeancesOnly(List<SeancesTableData> localSeances) async {
    try {
      final localIds = localSeances
          .map((s) => s.serverId)
          .whereType<int>()
          .toSet();

      final serverSeances = await apiClient.seance.getAllSeances();

      final newSeances = serverSeances
          .where((s) => !localIds.contains(s.id))
          .toList();

      if (newSeances.isEmpty) {
        debugPrint('✅ Sync : aucune nouvelle séance à importer');
        return;
      }

      debugPrint(
        '⬇️ Sync : ${newSeances.length} nouvelle(s) séance(s) détectée(s)',
      );

      for (var s in newSeances) {
        await localDb
            .into(localDb.seancesTable)
            .insertOnConflictUpdate(
              SeancesTableCompanion.insert(
                serverId: drift.Value(s.id),
                nom: s.nom,
                objectifs: drift.Value(s.objectifs),
                zone: s.zone,
                objectifParticipants: s.objectifParticipants,
                organisateur: s.organisateur,
                datePrevue: s.datePrevue,
                heureDebut: drift.Value(s.heureDebut),
                heureFin: drift.Value(s.heureFin),
                statut: s.statut,
                gadgetsPrevus: drift.Value(s.gadgetsPrevus ?? 0),
                gadgetsDistribues: drift.Value(s.gadgetsDistribues ?? 0),
                totalLogistique: drift.Value(s.totalLogistique ?? 0.0),
                isSynced: const drift.Value(true),
              ),
            );
      }

      debugPrint('✅ Sync terminée : ${newSeances.length} séance(s) insérée(s)');
    } catch (e) {
      debugPrint('⚠️ Sync serveur échouée (mode hors-ligne conservé) : $e');
    }
  }

  List<BarchartModel> _generateChartData(
    List<ParticipantsTableData> participants,
  ) {
    List<BarchartModel> chartData = [];
    final now = DateTime.now();
    final monthNames = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Juin',
      'Juil',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc',
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
