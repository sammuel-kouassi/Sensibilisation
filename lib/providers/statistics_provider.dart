import 'dart:async';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../core/api_client.dart';
import '../core/database/local_db.dart';
import '../models/bar_chart_model.dart';
import '../models/kpi_model.dart';
import '../models/repart_zone_model.dart';
import '../models/tendency_model.dart';

class StatisticsProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isOnline = false;
  String _selectedPeriod = '30 derniers jours';

  StreamSubscription? _dbSubscription;
  StreamSubscription? _connectivitySubscription;

  List<KpiModel> _kpiList = [];
  List<BarchartModel> _chartData = [];
  List<RepartzoneModels> _zoneData = [];
  List<TendencyModels> _trendData = [];

  bool get isLoading => _isLoading;
  bool get isOnline => _isOnline;
  String get selectedPeriod => _selectedPeriod;
  List<KpiModel> get kpiList => _kpiList;
  List<BarchartModel> get chartData => _chartData;
  List<RepartzoneModels> get zoneData => _zoneData;
  List<TendencyModels> get trendData => _trendData;

  void init(BuildContext context) {
    _initConnectivity();

    _dbSubscription?.cancel();
    _dbSubscription = localDb.changeStream.listen((_) {
      loadStatistics(isRefresh: true);
    });

    // Premier lancement : toujours charger
    loadStatistics();
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
    _dbSubscription?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  // Remplacer _getStartDate() par cette version :
  DateTime _getStartDate() {
    final now = DateTime.now();
    if (_selectedPeriod == '7 derniers jours')
      return now.subtract(const Duration(days: 7));
    if (_selectedPeriod == '30 derniers jours')
      return now.subtract(const Duration(days: 30));
    if (_selectedPeriod == 'T1') return DateTime(now.year, 1, 1);
    if (_selectedPeriod == 'T2') return DateTime(now.year, 4, 1);
    if (_selectedPeriod == 'T3') return DateTime(now.year, 7, 1);
    if (_selectedPeriod == 'T4') return DateTime(now.year, 10, 1);
    return DateTime(now.year, 1, 1); // Cette année
  }

// Ajouter cette méthode pour la date de fin
  DateTime _getEndDate() {
    final now = DateTime.now();
    if (_selectedPeriod == 'T1') return DateTime(now.year, 3, 31, 23, 59);
    if (_selectedPeriod == 'T2') return DateTime(now.year, 6, 30, 23, 59);
    if (_selectedPeriod == 'T3') return DateTime(now.year, 9, 30, 23, 59);
    if (_selectedPeriod == 'T4') return DateTime(now.year, 12, 31, 23, 59);
    return now; // Pour les autres périodes, jusqu'à maintenant
  }

  Future<void> _fetchAndMergeFromServer() async {
    try {
      // --- Séances ---
      final serverSeances = await apiClient.seance.getAllSeances();
      final localSeances = await localDb.getAllSeances();

      // ✅ Créer un set des serverId existants pour comparaison rapide
      final localServerIds = localSeances
          .where((s) => s.serverId != null)
          .map((s) => s.serverId)
          .toSet();

      int newSeancesCount = 0;
      for (var s in serverSeances) {
        // ✅ N'insérer QUE si ce serverId n'existe pas localement
        if (!localServerIds.contains(s.id)) {
          await localDb
              .into(localDb.seancesTable)
              .insert(
                SeancesTableCompanion(
                  serverId: drift.Value(s.id),
                  nom: drift.Value(s.nom),
                  motifs: drift.Value(s.motifs),
                  zone: drift.Value(s.zone),
                  objectifParticipants: drift.Value(s.objectifParticipants),
                  organisateur: drift.Value(s.organisateur),
                  datePrevue: drift.Value(s.datePrevue),
                  heureDebut: drift.Value(s.heureDebut),
                  heureFin: drift.Value(s.heureFin),
                  estTerminee: drift.Value(s.estTerminee),
                  gadgetsPrevus: drift.Value(s.gadgetsPrevus ?? 0),
                  gadgetsDistribues: drift.Value(s.gadgetsDistribues ?? 0),
                  totalLogistique: drift.Value(s.totalLogistique ?? 0.0),
                  isSynced: const drift.Value(true),
                ),
              );
          newSeancesCount++;
        }
      }
      if (newSeancesCount > 0) {
        debugPrint(
          '✅ Stats: $newSeancesCount nouvelle(s) séance(s) importée(s)',
        );
      } else {
        debugPrint('ℹ️ Stats: Toutes les séances sont déjà en local');
      }

      // --- Participants ---
      final serverParticipants = await apiClient.participant
          .getAllParticipants();
      final localParticipants = await localDb.getAllParticipants();

      // ✅ Créer un set des serverId locaux
      final localParticipantIds = localParticipants
          .where((p) => p.serverId != null)
          .map((p) => p.serverId)
          .toSet();

      int newParticipantsCount = 0;
      for (var p in serverParticipants) {
        // ✅ N'insérer QUE si ce serverId n'existe pas localement
        if (!localParticipantIds.contains(p.id)) {
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
          newParticipantsCount++;
        }
      }
      if (newParticipantsCount > 0) {
        debugPrint(
          '✅ Stats: $newParticipantsCount nouveau(x) participant(s) importé(s)',
        );
      } else {
        debugPrint('ℹ️ Stats: Tous les participants sont déjà en local');
      }
    } catch (e) {
      // Pas de crash : on tombera sur le cache local
      debugPrint(
        '⚠️ Stats fetch serveur échoué, données locales utilisées : $e',
      );
    }
  }

  Future<void> loadStatistics({bool isRefresh = false}) async {
    if (!isRefresh) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      // Stratégie serveur-first : si en ligne, on merge depuis PostgreSQL d'abord
      if (_isOnline) {
        await _fetchAndMergeFromServer();
      }

      final startDate = _getStartDate();
      final endDate = _getEndDate();
      final allParticipants = await localDb.getAllParticipants();
      final allSeances = await localDb.getAllSeances();

      final filteredParts = allParticipants.where((p) {
        return p.dateInscription.isAfter(startDate) &&
            p.dateInscription.isBefore(endDate);
      }).toList();

      final filteredSeances = allSeances.where((s) {
        return s.datePrevue.isAfter(startDate) &&
            s.datePrevue.isBefore(endDate);
      }).toList();

      int totalGadgets = filteredSeances.fold(
        0,
        (sum, s) => sum + s.gadgetsDistribues,
      );
      int totalBesoins = filteredParts.fold(
        0,
        (sum, p) => sum + p.besoinsExprimes.length,
      );

      _kpiList = [
        KpiModel(
          label: 'Nouveaux Participants',
          value: filteredParts.length.toString(),
        ),
        KpiModel(
          label: 'Séances Effectuées',
          value: filteredSeances.length.toString(),
        ),
        KpiModel(label: 'Gadgets Distribués', value: totalGadgets.toString()),
        KpiModel(label: 'Besoins Recueillis', value: totalBesoins.toString()),
      ];

      _chartData = _generateBarChart(filteredParts);
      _zoneData = _generateZoneChart(filteredParts);
      _trendData = _generateTrendChart(filteredParts);
    } catch (e) {
      debugPrint('Erreur Stats: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updatePeriod(String newPeriod) async {
    if (_selectedPeriod == newPeriod) return;
    _selectedPeriod = newPeriod;
    await loadStatistics();
  }

  List<BarchartModel> _generateBarChart(List<ParticipantsTableData> parts) {
    List<BarchartModel> chartData = [];
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
    Map<int, int> counts = {};
    int maxCount = 0;
    for (var p in parts) {
      counts[p.dateInscription.month] =
          (counts[p.dateInscription.month] ?? 0) + 1;
      if (counts[p.dateInscription.month]! > maxCount)
        maxCount = counts[p.dateInscription.month]!;
    }
    counts.forEach((month, count) {
      double height = maxCount > 0 ? (count / maxCount) * 150.0 : 10;
      if (height < 10 && count > 0) height = 10;
      chartData.add(
        BarchartModel(
          label: monthNames[month - 1],
          height: height,
          count: count,
        ),
      );
    });
    return chartData.isEmpty
        ? [BarchartModel(label: 'Aucun', height: 10, count: 0)]
        : chartData;
  }

  List<RepartzoneModels> _generateZoneChart(List<ParticipantsTableData> parts) {
    if (parts.isEmpty) return [];

    Map<String, int> zoneCounts = {};

    for (var p in parts) {
      String cleanName = p.localite.trim().toLowerCase();

      // 2. On ignore les saisies vides si l'utilisateur n'a rien mis
      if (cleanName.isEmpty) {
        cleanName = "Non spécifié";
      }

      // 3. On compte cette valeur nettoyée
      zoneCounts[cleanName] = (zoneCounts[cleanName] ?? 0) + 1;
    }

    List<Color> colors = [
      const Color(0xFFFF9500),
      const Color(0xFF21951D),
      const Color(0xFF2196F3),
      const Color(0xFFF44336),
      const Color(0xFF9C27B0),
      const Color(0xFF4CAF50),
    ];

    List<RepartzoneModels> zones = [];
    int i = 0;

    zoneCounts.forEach((name, count) {
      final displayName = name.isNotEmpty
          ? name[0].toUpperCase() + name.substring(1)
          : name;

      zones.add(
        RepartzoneModels(
          zoneName: displayName,
          percentage: (count / parts.length) * 100,
          valeurExacte: count,
          color: colors[i % colors.length],
        ),
      );
      i++;
    });

    return zones;
  }

  List<TendencyModels> _generateTrendChart(List<ParticipantsTableData> parts) {
    if (parts.isEmpty) return [];
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
    Map<int, int> trendCounts = {};
    for (var p in parts) {
      trendCounts[p.dateInscription.month] =
          (trendCounts[p.dateInscription.month] ?? 0) + 1;
    }
    List<TendencyModels> trends = [];
    trendCounts.forEach((month, count) {
      trends.add(
        TendencyModels(
          monthIndex: month,
          monthName: monthNames[month - 1],
          participants: count.toDouble(),
        ),
      );
    });
    trends.sort((a, b) => a.monthIndex.compareTo(b.monthIndex));
    return trends;
  }
}
