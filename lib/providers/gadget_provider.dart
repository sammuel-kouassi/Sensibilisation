import 'dart:async';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

import '../core/api_client.dart';
import 'package:dlf_backend_client/dlf_backend_client.dart' as sp;
import '../core/database/local_db.dart';
import '../models/gadget_model.dart';

class GadgetProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<GadgetModel> _allGadgets = [];
  List<GadgetModel> _filteredGadgets = [];

  StreamSubscription? _dbSubscription;

  bool get isLoading => _isLoading;
  List<GadgetModel> get filteredGadgets => _filteredGadgets;

  GadgetProvider() {
    loadGadgets(forceSync: true);

    _dbSubscription = localDb.changeStream.listen((_) {
      loadGadgets(forceSync: false);
    });
  }

  @override
  void dispose() {
    _dbSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadGadgets({bool forceSync = false}) async {
    if (forceSync) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      if (forceSync) {
        try {
          final serverSeances = await apiClient.seance.getAllSeances();

          await localDb.clearSeances();

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
        } catch (e) {
          debugPrint(
            '⚠️ Hors-ligne : Impossible de télécharger les séances pour Gadgets.',
          );
        }
      }

      final localData = await localDb.getAllSeances();

      _allGadgets = localData.map((row) {
        return GadgetModel(
          id: row.id,
          serverId: row.serverId,
          seanceNom: row.nom,
          zone: row.zone,
          gadgetsPrevus: row.gadgetsPrevus,
          gadgetsDistribues: row.gadgetsDistribues,
        );
      }).toList();
    } catch (e) {
      debugPrint('❌ ERREUR lecture SQLite Gadgets : $e');
    }

    _filteredGadgets = List.from(_allGadgets);

    if (_isLoading) {
      _isLoading = false;
    }
    notifyListeners();
  }

  // --- 2. RECHERCHE ET FILTRES ---
  void filterGadgets(String query) {
    if (query.isEmpty) {
      _filteredGadgets = List.from(_allGadgets);
    } else {
      final searchLower = query.toLowerCase();
      _filteredGadgets = _allGadgets.where((g) {
        return g.seanceNom.toLowerCase().contains(searchLower) ||
            g.zone.toLowerCase().contains(searchLower);
      }).toList();
    }
    notifyListeners();
  }

  // --- 3. DISTRIBUTION ---
  Future<void> distributeGadget(GadgetModel gadget, int quantity) async {
    if (quantity <= 0 || quantity > gadget.restants) return;

    try {
      final newDistributed = gadget.gadgetsDistribues + quantity;

      final allLocal = await localDb.getAllSeances();
      final existingSeance = allLocal.firstWhere((s) => s.id == gadget.id);

      final updatedData = existingSeance.copyWith(
        gadgetsDistribues: newDistributed,
        isSynced: false,
      );

      await localDb.updateSeance(updatedData);

      localDb.notifyDataChanged();

      if (gadget.serverId != null) {
        try {
          final serverSeance = sp.Seance(
            id: existingSeance.serverId,
            nom: existingSeance.nom,
            objectifs: existingSeance.objectifs,
            zone: existingSeance.zone,
            objectifParticipants: existingSeance.objectifParticipants,
            organisateur: existingSeance.organisateur,
            datePrevue: existingSeance.datePrevue,
            heureDebut: existingSeance.heureDebut,
            heureFin: existingSeance.heureFin,
            statut: existingSeance.statut,
            gadgetsPrevus: existingSeance.gadgetsPrevus,
            gadgetsDistribues: newDistributed,
            totalLogistique: existingSeance.totalLogistique,
          );

          await apiClient.seance.updateSeance(serverSeance);
          await localDb.updateSeance(updatedData.copyWith(isSynced: true));

          localDb.notifyDataChanged();
        } catch (e) {
          debugPrint(
            '⚠️ Serveur inaccessible. Distribution gardée en file d\'attente.',
          );
        }
      }
    } catch (e) {
      debugPrint('⚠️ Erreur lors de la distribution locale : $e');
    }
  }
}
