import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'local_db.g.dart';

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();
  @override
  List<String> fromSql(String fromDb) => List<String>.from(json.decode(fromDb));
  @override
  String toSql(List<String> value) => json.encode(value);
}

class NullableStringListConverter
    extends TypeConverter<List<String>?, String?> {
  const NullableStringListConverter();

  @override
  List<String>? fromSql(String? fromDb) {
    if (fromDb == null) return null;
    return List<String>.from(json.decode(fromDb));
  }

  @override
  String? toSql(List<String>? value) {
    if (value == null) return null;
    return json.encode(value);
  }
}

// --- TABLE DES PARTICIPANTS ---
class ParticipantsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serverId => integer().nullable()();
  IntColumn get seanceId => integer()();
  TextColumn get nom => text()();
  TextColumn get prenom => text()();
  TextColumn get telephone => text()();
  TextColumn get profession => text().nullable()();
  TextColumn get statutLogement => text()();
  TextColumn get lieu => text().nullable()();
  TextColumn get localite => text()();
  TextColumn get quartier => text().nullable()();
  TextColumn get besoinsExprimes => text().map(const StringListConverter())();
  TextColumn get ressenti => text().nullable()();
  BoolColumn get consentement => boolean()();
  TextColumn get statut => text()();
  DateTimeColumn get dateInscription => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

// --- TABLE DE L'HISTORIQUE DE SYNCHRONISATION ---
class SyncHistoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get time => text()();
  TextColumn get status => text()();
  TextColumn get type => text()();
}

// --- TABLE DES PRISES DE CONTACT ---
class PriseContactsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serverId => integer().nullable()();
  IntColumn get seanceId => integer()();
  TextColumn get nomContact => text()();
  TextColumn get telephone => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get objetMission => text()();
  TextColumn get directionRegionale => text()();
  TextColumn get agence => text().nullable()();
  TextColumn get quartier => text().nullable()();
  TextColumn get site => text().nullable()();
  TextColumn get pointsAbordes => text().map(const StringListConverter())();
  TextColumn get observations => text().nullable()();
  TextColumn get signatureBase64 => text().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

// --- TABLE DES RENDEZ-VOUS ---
class RdvsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serverId => integer().nullable()();
  IntColumn get seanceId => integer()();
  TextColumn get titre => text()();
  TextColumn get contact => text()();
  DateTimeColumn get dateRdv => dateTime()();
  TextColumn get heure => text()();
  TextColumn get lieu => text()();
  TextColumn get statut => text()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

// --- TABLE DES SÉANCES ---
class SeancesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serverId => integer().nullable().unique()();

  // --- INFOS GÉNÉRALES ---
  TextColumn get nom => text()();
  TextColumn get motifs => text().nullable()();
  TextColumn get typeSeance => text().nullable()();
  TextColumn get cible => text().nullable()();

  // --- LOCALISATION ---
  TextColumn get zone => text().nullable()();
  TextColumn get ville => text().nullable()();
  TextColumn get quartier => text().nullable()();

  // --- ORGANISATION ---
  IntColumn get objectifParticipants => integer()();
  TextColumn get organisateur => text()();
  TextColumn get presentateur => text().nullable()();
  TextColumn get assistants =>
      text().nullable().map(const NullableStringListConverter())();
  // --- PLANNING ---
  DateTimeColumn get datePrevue => dateTime()();
  TextColumn get heureDebut => text().nullable()();
  TextColumn get heureFin => text().nullable()();
  BoolColumn get estTerminee => boolean().withDefault(const Constant(false))();

  // --- LOGISTIQUE ---
  IntColumn get gadgetsPrevus => integer().withDefault(const Constant(0))();
  IntColumn get gadgetsDistribues => integer().withDefault(const Constant(0))();
  RealColumn get totalLogistique => real().withDefault(const Constant(0.0))();

  // --- BILAN ---
  IntColumn get nbParticipantsEstime => integer().nullable()();
  BoolColumn get evaluation => boolean().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();
}

// --- TABLE DES IMAGES DE SÉANCE ---
class SeanceImagesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serverId => integer().nullable()();
  IntColumn get seanceId => integer()();
  TextColumn get urls => text().map(const StringListConverter())();
  TextColumn get legende => text().nullable()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(
  tables: [
    ParticipantsTable,
    SyncHistoryTable,
    PriseContactsTable,
    RdvsTable,
    SeancesTable,
    SeanceImagesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  final _changeController = StreamController<void>.broadcast();
  Stream<void> get changeStream => _changeController.stream;

  void notifyDataChanged() => _changeController.add(null);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 3) {
        await migrator.addColumn(seancesTable, seancesTable.motifs);
        await migrator.addColumn(seancesTable, seancesTable.typeSeance);
        await migrator.addColumn(seancesTable, seancesTable.cible);
        await migrator.addColumn(seancesTable, seancesTable.ville);
        await migrator.addColumn(seancesTable, seancesTable.quartier);
        await migrator.addColumn(seancesTable, seancesTable.presentateur);
        await migrator.addColumn(seancesTable, seancesTable.assistants);
        await migrator.addColumn(
          seancesTable,
          seancesTable.nbParticipantsEstime,
        );
        await migrator.addColumn(seancesTable, seancesTable.evaluation);
        await migrator.createTable(seanceImagesTable);
      }
    },
  );

  // --- REQUÊTES PARTICIPANTS ---
  Future<List<ParticipantsTableData>> getAllParticipants() =>
      select(participantsTable).get();
  Future<List<ParticipantsTableData>> getUnsyncedParticipants() =>
      (select(participantsTable)..where((t) => t.isSynced.equals(false))).get();
  Future<int> addParticipant(ParticipantsTableCompanion entry) =>
      into(participantsTable).insert(entry);
  Future<bool> updateParticipant(ParticipantsTableData entry) =>
      update(participantsTable).replace(entry);
  Future deleteParticipant(int id) =>
      (delete(participantsTable)..where((t) => t.id.equals(id))).go();

  // --- REQUÊTES HISTORIQUE ---
  Future<List<SyncHistoryTableData>> getHistory() =>
      select(syncHistoryTable).get();
  Future insertHistory(SyncHistoryTableCompanion entry) =>
      into(syncHistoryTable).insert(entry);

  // --- REQUÊTES PRISE DE CONTACT ---
  Future<List<PriseContactsTableData>> getAllPriseContacts() =>
      select(priseContactsTable).get();
  Future<List<PriseContactsTableData>> getUnsyncedPriseContacts() => (select(
    priseContactsTable,
  )..where((t) => t.isSynced.equals(false))).get();
  Future<int> addPriseContact(PriseContactsTableCompanion entry) =>
      into(priseContactsTable).insert(entry);
  Future<bool> updatePriseContact(PriseContactsTableData entry) =>
      update(priseContactsTable).replace(entry);
  Future deletePriseContact(int id) =>
      (delete(priseContactsTable)..where((t) => t.id.equals(id))).go();

  // --- REQUÊTES RDV ---
  Future<List<RdvsTableData>> getAllRdvs() => select(rdvsTable).get();
  Future<List<RdvsTableData>> getUnsyncedRdvs() =>
      (select(rdvsTable)..where((t) => t.isSynced.equals(false))).get();
  Future<int> addRdv(RdvsTableCompanion entry) => into(rdvsTable).insert(entry);
  Future<bool> updateRdv(RdvsTableData entry) =>
      update(rdvsTable).replace(entry);
  Future deleteRdv(int id) =>
      (delete(rdvsTable)..where((t) => t.id.equals(id))).go();

  // --- REQUÊTES SÉANCES (LOGISTIQUE) ---
  Future<List<SeancesTableData>> getAllSeances() => select(seancesTable).get();

  Future<List<SeancesTableData>> getUnsyncedSeances() =>
      (select(seancesTable)..where((t) => t.isSynced.equals(false))).get();

  Future<int> insertSeance(SeancesTableCompanion entry) =>
      into(seancesTable).insert(entry);

  Future<bool> updateSeance(SeancesTableData entry) =>
      update(seancesTable).replace(entry);
  Future<void> clearSeances() => delete(seancesTable).go();

  Future<void> clearParticipants() => delete(participantsTable).go();
  Future<void> clearRdvs() => delete(rdvsTable).go();
  Future<void> clearPriseContacts() => delete(priseContactsTable).go();

  // --- REQUÊTES IMAGES ---
  Future<List<SeanceImagesTableData>> getImagesBySeance(int seanceId) =>
      (select(
        seanceImagesTable,
      )..where((t) => t.seanceId.equals(seanceId))).get();

  Future<int> addImage(SeanceImagesTableCompanion entry) =>
      into(seanceImagesTable).insert(entry);

  Future<bool> updateImage(SeanceImagesTableData entry) =>
      update(seanceImagesTable).replace(entry);

  Future deleteImage(int id) =>
      (delete(seanceImagesTable)..where((t) => t.id.equals(id))).go();

  Future<void> clearImagesBySeance(int seanceId) => (delete(
    seanceImagesTable,
  )..where((t) => t.seanceId.equals(seanceId))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'dlf_local.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

final localDb = AppDatabase();
