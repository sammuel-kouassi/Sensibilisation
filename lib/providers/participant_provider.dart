import 'dart:async';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../core/api_client.dart';
import 'package:dlf_backend_client/dlf_backend_client.dart' as sp;
import '../core/database/local_db.dart';
import '../models/participant_model.dart';

class ParticipantProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<ParticipantModel> _allParticipants = [];
  List<ParticipantModel> _filteredParticipants = [];
  List<SeancesTableData> _seances = [];
  int? _selectedSeanceId;

  List<SeancesTableData> get seances => _seances;
  int? get selectedSeanceId => _selectedSeanceId;

  StreamSubscription? _dbSubscription;

  bool get isLoading => _isLoading;
  List<ParticipantModel> get filteredParticipants => _filteredParticipants;



  ParticipantProvider() {
    loadParticipants();

    _dbSubscription = localDb.changeStream.listen((_) {
      loadParticipants();
    });
  }

  @override
  void dispose() {
    _dbSubscription?.cancel();
    super.dispose();
  }

  // Ajouter cette méthode dans ParticipantProvider
  Future<void> syncFromServer() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Récupérer tous les participants depuis le serveur
      final serverParticipants = await apiClient.participant
          .getAllParticipants();

      // 2. Pour chaque participant serveur, insérer/mettre à jour en local
      for (final sp in serverParticipants) {
        final localList = await localDb.getAllParticipants();
        final existing = localList.where((p) => p.serverId == sp.id).toList();

        if (existing.isEmpty) {
          // Nouveau participant venant d'un autre téléphone → on l'insère
          await localDb.addParticipant(
            ParticipantsTableCompanion.insert(
              serverId: drift.Value(sp.id),
              seanceId: sp.seanceId,
              nom: sp.nom,
              prenom: sp.prenom,
              telephone: sp.telephone,
              profession: drift.Value(sp.profession),
              statutLogement: sp.statutLogement,
              lieu: drift.Value(sp.lieu),
              localite: sp.localite,
              quartier: drift.Value(sp.quartier),
              besoinsExprimes: sp.besoinsExprimes,
              ressenti: drift.Value(sp.ressenti),
              consentement: sp.consentement,
              statut: sp.statut,
              dateInscription: sp.dateInscription,
              isSynced: const drift.Value(true),
            ),
          );
        }
      }

      localDb.notifyDataChanged();
    } catch (e) {
      debugPrint('⚠️ Erreur sync serveur : $e');
    }

    await loadParticipants();
  }

  // --- 1. CHARGEMENT ---
  Future<void> loadParticipants() async {
    _isLoading = true;
    notifyListeners();

    try {
      final localData = await localDb.getAllParticipants();
      final seancesData = await localDb.getAllSeances();
      _seances = seancesData;

      _allParticipants = localData.map((row) {
        return ParticipantModel(
          id: row.id,
          sessionId: row.seanceId,
          lastName: row.nom,
          firstName: row.prenom,
          phone: row.telephone,
          profession: row.profession,
          housingStatus: row.statutLogement,
          residenceLocation: row.lieu,
          locality: row.localite,
          neighborhood: row.quartier,
          needs: row.besoinsExprimes,
          feedback: row.ressenti,
          consent: row.consentement,
          status: row.statut,
          registrationDate: row.dateInscription,
        );
      }).toList();

      _allParticipants = _allParticipants.reversed.toList();
    } catch (e) {
      debugPrint('❌ ERREUR lecture SQLite : $e');
    }

    _filteredParticipants = List.from(_allParticipants);
    _isLoading = false;
    notifyListeners();
  }

  // --- 2. FILTRAGE ---
  void filterParticipants(String query) {
    _applyFilters(query: query);
  }

  void filterBySeance(int? seanceId) {
    _selectedSeanceId = seanceId;
    _applyFilters(query: ''); // reset texte
    notifyListeners();
  }

  void _applyFilters({required String query}) {
    List<ParticipantModel> base = List.from(_allParticipants);

    // Filtre par séance d'abord
    if (_selectedSeanceId != null) {
      base = base.where((p) => p.sessionId == _selectedSeanceId).toList();
    }

    // Puis filtre texte
    if (query.isNotEmpty) {
      final searchLower = query.toLowerCase();
      base = base.where((p) {
        final fullName = '${p.firstName} ${p.lastName}'.toLowerCase();
        return fullName.contains(searchLower) ||
            p.locality.toLowerCase().contains(searchLower) ||
            (p.id?.toString() ?? '').contains(searchLower);
      }).toList();
    }

    _filteredParticipants = base;
    notifyListeners();
  }

  // --- 3. AJOUT ---
  Future<void> addParticipant(ParticipantModel localParticipant) async {
    try {
      final newDbParticipant = ParticipantsTableCompanion.insert(
        seanceId: localParticipant.sessionId,
        nom: localParticipant.lastName,
        prenom: localParticipant.firstName,
        telephone: localParticipant.phone,
        profession: drift.Value(localParticipant.profession),
        statutLogement: localParticipant.housingStatus,
        lieu: drift.Value(localParticipant.residenceLocation),
        localite: localParticipant.locality,
        quartier: drift.Value(localParticipant.neighborhood),
        besoinsExprimes: localParticipant.needs,
        ressenti: drift.Value(localParticipant.feedback),
        consentement: localParticipant.consent,
        statut: localParticipant.status,
        dateInscription: localParticipant.registrationDate,
        isSynced: const drift.Value(false),
      );

      final generatedLocalId = await localDb.addParticipant(newDbParticipant);

      localDb.notifyDataChanged();

      // Synchronisation avec le serveur
      final serverParticipant = sp.Participant(
        seanceId: localParticipant.sessionId,
        nom: localParticipant.lastName,
        prenom: localParticipant.firstName,
        telephone: localParticipant.phone,
        profession: localParticipant.profession,
        statutLogement: localParticipant.housingStatus,
        lieu: localParticipant.residenceLocation,
        localite: localParticipant.locality,
        quartier: localParticipant.neighborhood,
        besoinsExprimes: localParticipant.needs,
        ressenti: localParticipant.feedback,
        consentement: localParticipant.consent,
        statut: localParticipant.status,
        dateInscription: localParticipant.registrationDate,
      );

      final savedServerParticipant = await apiClient.participant.addParticipant(
        serverParticipant,
      );

      await localDb.updateParticipant(
        ParticipantsTableData(
          id: generatedLocalId,
          serverId: savedServerParticipant.id,
          seanceId: localParticipant.sessionId,
          nom: localParticipant.lastName,
          prenom: localParticipant.firstName,
          telephone: localParticipant.phone,
          profession: localParticipant.profession,
          statutLogement: localParticipant.housingStatus,
          lieu: localParticipant.residenceLocation,
          localite: localParticipant.locality,
          quartier: localParticipant.neighborhood,
          besoinsExprimes: localParticipant.needs,
          ressenti: localParticipant.feedback,
          consentement: localParticipant.consent,
          statut: localParticipant.status,
          dateInscription: localParticipant.registrationDate,
          isSynced: true,
        ),
      );

      localDb.notifyDataChanged();
    } catch (e) {
      debugPrint('⚠️ Mode hors-ligne actif (Ajout).');
    }
  }

  // --- 4. MISE À JOUR ---
  Future<void> updateParticipant(ParticipantModel participant) async {
    if (participant.id == null) return;

    try {
      final localDataList = await localDb.getAllParticipants();
      final existingData = localDataList.firstWhere(
        (p) => p.id == participant.id,
      );
      final trueServerId = existingData.serverId;

      // C'est cette variable qui te manquait !
      final updatedData = ParticipantsTableData(
        id: participant.id!,
        serverId: trueServerId,
        seanceId: participant.sessionId,
        nom: participant.lastName,
        prenom: participant.firstName,
        telephone: participant.phone,
        profession: participant.profession,
        statutLogement: participant.housingStatus,
        lieu: participant.residenceLocation,
        localite: participant.locality,
        quartier: participant.neighborhood,
        besoinsExprimes: participant.needs,
        ressenti: participant.feedback,
        consentement: participant.consent,
        statut: participant.status,
        dateInscription: participant.registrationDate,
        isSynced: false,
      );

      await localDb.updateParticipant(updatedData);

      localDb.notifyDataChanged();

      if (trueServerId != null) {
        final serverParticipant = sp.Participant(
          id: trueServerId,
          seanceId: participant.sessionId,
          nom: participant.lastName,
          prenom: participant.firstName,
          telephone: participant.phone,
          profession: participant.profession,
          statutLogement: participant.housingStatus,
          lieu: participant.residenceLocation,
          localite: participant.locality,
          quartier: participant.neighborhood,
          besoinsExprimes: participant.needs,
          ressenti: participant.feedback,
          consentement: participant.consent,
          statut: participant.status,
          dateInscription: participant.registrationDate,
        );

        await apiClient.participant.updateParticipant(serverParticipant);
        await localDb.updateParticipant(updatedData.copyWith(isSynced: true));

        localDb.notifyDataChanged();
      }
    } catch (e) {
      debugPrint('⚠️ Mode hors-ligne actif (Modification).');
    }
  }
}
