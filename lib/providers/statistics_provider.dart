import 'dart:async';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

import '../core/api_client.dart';
import '../core/database/local_db.dart';
import '../models/bar_chart_model.dart';
import '../models/kpi_model.dart';
import '../models/repart_zone_model.dart';
import '../models/tendency_model.dart';

class StatisticsProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _selectedPeriod = '30 derniers jours';
  StreamSubscription? _dbSubscription;

  List<KpiModel> _kpiList = [];
  List<BarchartModel> _chartData = [];
  List<RepartzoneModels> _zoneData = [];
  List<TendencyModels> _trendData = [];

  bool get isLoading => _isLoading;
  String get selectedPeriod => _selectedPeriod;
  List<KpiModel> get kpiList => _kpiList;
  List<BarchartModel> get chartData => _chartData;
  List<RepartzoneModels> get zoneData => _zoneData;
  List<TendencyModels> get trendData => _trendData;

  void init(BuildContext context) {
    if (_kpiList.isEmpty && !_isLoading) {
      loadStatistics();
    }
    _dbSubscription?.cancel();
    _dbSubscription = localDb.changeStream.listen((_) {
      loadStatistics(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _dbSubscription?.cancel();
    super.dispose();
  }

  DateTime _getStartDate() {
    final now = DateTime.now();
    if (_selectedPeriod == '7 derniers jours')
      return now.subtract(const Duration(days: 7));
    if (_selectedPeriod == '30 derniers jours')
      return now.subtract(const Duration(days: 30));
    return DateTime(now.year, 1, 1);
  }

  Future<void> loadStatistics({bool isRefresh = false}) async {
    if (!isRefresh) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final startDate = _getStartDate();
      final allParticipants = await localDb.getAllParticipants();
      var allSeances = await localDb.getAllSeances();

      // AUTO FETCH SI VIDE
      if (allSeances.isEmpty) {
        try {
          final serverSeances = await apiClient.seance.getAllSeances();
          if (serverSeances.isNotEmpty) {
            for (var s in serverSeances) {
              await localDb.insertSeance(
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
            allSeances = await localDb.getAllSeances();
          }
        } catch (e) {
          debugPrint('Erreur Fetch Stats');
        }
      }

      final filteredParts = allParticipants
          .where((p) => p.dateInscription.isAfter(startDate))
          .toList();
      final filteredSeances = allSeances
          .where((s) => s.datePrevue.isAfter(startDate))
          .toList();

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
      zoneCounts[p.localite] = (zoneCounts[p.localite] ?? 0) + 1;
    }
    List<Color> colors = [
      const Color(0xFFFF9500),
      const Color(0xFF21951D),
      Colors.blue,
      Colors.red,
      Colors.purple,
    ];
    List<RepartzoneModels> zones = [];
    int i = 0;
    zoneCounts.forEach((zoneName, count) {

      final formattedZoneName = zoneName.isNotEmpty
          ? zoneName[0].toUpperCase() + zoneName.substring(1).toLowerCase()
          : zoneName;

      zones.add(
        RepartzoneModels(
          zoneName: formattedZoneName,
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
