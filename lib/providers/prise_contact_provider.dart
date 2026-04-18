import 'dart:async';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

import '../core/api_client.dart';
import 'package:dlf_backend_client/dlf_backend_client.dart' as sp;
import '../core/database/local_db.dart';
import '../models/prise_contact_model.dart';

class PriseContactProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<PriseContactModel> _allContacts = [];
  List<PriseContactModel> _filteredContacts = [];
  StreamSubscription? _dbSubscription;

  bool get isLoading => _isLoading;
  List<PriseContactModel> get filteredContacts => _filteredContacts;

  PriseContactProvider() {
    loadContacts();
    _dbSubscription = localDb.changeStream.listen((_) => loadContacts());
  }

  @override
  void dispose() {
    _dbSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadContacts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final localData = await localDb.getAllPriseContacts();
      _allContacts = localData
          .map((row) {
            return PriseContactModel(
              id: row.id,
              seanceId: row.seanceId,
              nomContact: row.nomContact,
              telephone: row.telephone,
              date: row.date,
              objetMission: row.objetMission,
              directionRegionale: row.directionRegionale,
              agence: row.agence,
              quartier: row.quartier,
              site: row.site,
              pointsAbordes: row.pointsAbordes,
              observations: row.observations,
              signatureBase64: row.signatureBase64,
            );
          })
          .toList()
          .reversed
          .toList();
    } catch (e) {
      debugPrint('❌ ERREUR lecture SQLite PriseContact : $e');
    }

    _filteredContacts = List.from(_allContacts);
    _isLoading = false;
    notifyListeners();
  }

  void filterContacts(String query) {
    if (query.isEmpty) {
      _filteredContacts = List.from(_allContacts);
    } else {
      final searchLower = query.toLowerCase();
      _filteredContacts = _allContacts.where((contact) {
        return contact.nomContact.toLowerCase().contains(searchLower) ||
            contact.objetMission.toLowerCase().contains(searchLower);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> addContact(PriseContactModel localContact) async {
    try {
      final newDbContact = PriseContactsTableCompanion.insert(
        seanceId: localContact.seanceId,
        nomContact: localContact.nomContact,
        telephone: localContact.telephone,
        date: localContact.date,
        objetMission: localContact.objetMission,
        directionRegionale: localContact.directionRegionale,
        agence: drift.Value(localContact.agence),
        quartier: drift.Value(localContact.quartier),
        site: drift.Value(localContact.site),
        pointsAbordes: localContact.pointsAbordes,
        observations: drift.Value(localContact.observations),
        signatureBase64: drift.Value(localContact.signatureBase64),
        isSynced: const drift.Value(false),
      );

      final generatedLocalId = await localDb.addPriseContact(newDbContact);

      // 📣 TEMPS RÉEL : On annonce l'ajout local
      localDb.notifyDataChanged();

      final serverContact = sp.PriseContact(
        seanceId: localContact.seanceId,
        nomContact: localContact.nomContact,
        telephone: localContact.telephone,
        date: localContact.date,
        objetMission: localContact.objetMission,
        directionRegionale: localContact.directionRegionale,
        agence: localContact.agence,
        quartier: localContact.quartier,
        site: localContact.site,
        pointsAbordes: localContact.pointsAbordes,
        observations: localContact.observations,
        signatureBase64: localContact.signatureBase64,
      );

      final savedServerContact = await apiClient.priseContact.addPriseContact(
        serverContact,
      );

      await localDb.updatePriseContact(
        PriseContactsTableData(
          id: generatedLocalId,
          serverId: savedServerContact.id,
          seanceId: localContact.seanceId,
          nomContact: localContact.nomContact,
          telephone: localContact.telephone,
          date: localContact.date,
          objetMission: localContact.objetMission,
          directionRegionale: localContact.directionRegionale,
          agence: localContact.agence,
          quartier: localContact.quartier,
          site: localContact.site,
          pointsAbordes: localContact.pointsAbordes,
          observations: localContact.observations,
          signatureBase64: localContact.signatureBase64,
          isSynced: true,
        ),
      );

      localDb.notifyDataChanged();
    } catch (e) {
      debugPrint('⚠️ Mode hors-ligne actif (Prise contact)');
    }
  }

  Future<void> updateContact(PriseContactModel contact) async {
    if (contact.id == null) return;
    try {
      final localDataList = await localDb.getAllPriseContacts();
      final existingData = localDataList.firstWhere((c) => c.id == contact.id);

      final updatedData = PriseContactsTableData(
        id: contact.id!,
        serverId: existingData.serverId,
        seanceId: contact.seanceId,
        nomContact: contact.nomContact,
        telephone: contact.telephone,
        date: contact.date,
        objetMission: contact.objetMission,
        directionRegionale: contact.directionRegionale,
        agence: contact.agence,
        quartier: contact.quartier,
        site: contact.site,
        pointsAbordes: contact.pointsAbordes,
        observations: contact.observations,
        signatureBase64: contact.signatureBase64,
        isSynced: false,
      );

      await localDb.updatePriseContact(updatedData);

      // 📣 TEMPS RÉEL
      localDb.notifyDataChanged();

      if (existingData.serverId != null) {
        final serverContact = sp.PriseContact(
          id: existingData.serverId,
          seanceId: contact.seanceId,
          nomContact: contact.nomContact,
          telephone: contact.telephone,
          date: contact.date,
          objetMission: contact.objetMission,
          directionRegionale: contact.directionRegionale,
          agence: contact.agence,
          quartier: contact.quartier,
          site: contact.site,
          pointsAbordes: contact.pointsAbordes,
          observations: contact.observations,
          signatureBase64: contact.signatureBase64,
        );
        await apiClient.priseContact.updatePriseContact(serverContact);
        await localDb.updatePriseContact(updatedData.copyWith(isSynced: true));
        localDb.notifyDataChanged();
      }
    } catch (e) {
      debugPrint('⚠️ Erreur update contact');
    }
  }
}
