// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_db.dart';

// ignore_for_file: type=lint
class $ParticipantsTableTable extends ParticipantsTable
    with TableInfo<$ParticipantsTableTable, ParticipantsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParticipantsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seanceIdMeta = const VerificationMeta(
    'seanceId',
  );
  @override
  late final GeneratedColumn<int> seanceId = GeneratedColumn<int>(
    'seance_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
    'nom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prenomMeta = const VerificationMeta('prenom');
  @override
  late final GeneratedColumn<String> prenom = GeneratedColumn<String>(
    'prenom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telephoneMeta = const VerificationMeta(
    'telephone',
  );
  @override
  late final GeneratedColumn<String> telephone = GeneratedColumn<String>(
    'telephone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _professionMeta = const VerificationMeta(
    'profession',
  );
  @override
  late final GeneratedColumn<String> profession = GeneratedColumn<String>(
    'profession',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statutLogementMeta = const VerificationMeta(
    'statutLogement',
  );
  @override
  late final GeneratedColumn<String> statutLogement = GeneratedColumn<String>(
    'statut_logement',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lieuMeta = const VerificationMeta('lieu');
  @override
  late final GeneratedColumn<String> lieu = GeneratedColumn<String>(
    'lieu',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localiteMeta = const VerificationMeta(
    'localite',
  );
  @override
  late final GeneratedColumn<String> localite = GeneratedColumn<String>(
    'localite',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quartierMeta = const VerificationMeta(
    'quartier',
  );
  @override
  late final GeneratedColumn<String> quartier = GeneratedColumn<String>(
    'quartier',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  besoinsExprimes =
      GeneratedColumn<String>(
        'besoins_exprimes',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $ParticipantsTableTable.$converterbesoinsExprimes,
      );
  static const VerificationMeta _ressentiMeta = const VerificationMeta(
    'ressenti',
  );
  @override
  late final GeneratedColumn<String> ressenti = GeneratedColumn<String>(
    'ressenti',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _consentementMeta = const VerificationMeta(
    'consentement',
  );
  @override
  late final GeneratedColumn<bool> consentement = GeneratedColumn<bool>(
    'consentement',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("consentement" IN (0, 1))',
    ),
  );
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
    'statut',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateInscriptionMeta = const VerificationMeta(
    'dateInscription',
  );
  @override
  late final GeneratedColumn<DateTime> dateInscription =
      GeneratedColumn<DateTime>(
        'date_inscription',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    seanceId,
    nom,
    prenom,
    telephone,
    profession,
    statutLogement,
    lieu,
    localite,
    quartier,
    besoinsExprimes,
    ressenti,
    consentement,
    statut,
    dateInscription,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'participants_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParticipantsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('seance_id')) {
      context.handle(
        _seanceIdMeta,
        seanceId.isAcceptableOrUnknown(data['seance_id']!, _seanceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seanceIdMeta);
    }
    if (data.containsKey('nom')) {
      context.handle(
        _nomMeta,
        nom.isAcceptableOrUnknown(data['nom']!, _nomMeta),
      );
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('prenom')) {
      context.handle(
        _prenomMeta,
        prenom.isAcceptableOrUnknown(data['prenom']!, _prenomMeta),
      );
    } else if (isInserting) {
      context.missing(_prenomMeta);
    }
    if (data.containsKey('telephone')) {
      context.handle(
        _telephoneMeta,
        telephone.isAcceptableOrUnknown(data['telephone']!, _telephoneMeta),
      );
    } else if (isInserting) {
      context.missing(_telephoneMeta);
    }
    if (data.containsKey('profession')) {
      context.handle(
        _professionMeta,
        profession.isAcceptableOrUnknown(data['profession']!, _professionMeta),
      );
    }
    if (data.containsKey('statut_logement')) {
      context.handle(
        _statutLogementMeta,
        statutLogement.isAcceptableOrUnknown(
          data['statut_logement']!,
          _statutLogementMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_statutLogementMeta);
    }
    if (data.containsKey('lieu')) {
      context.handle(
        _lieuMeta,
        lieu.isAcceptableOrUnknown(data['lieu']!, _lieuMeta),
      );
    }
    if (data.containsKey('localite')) {
      context.handle(
        _localiteMeta,
        localite.isAcceptableOrUnknown(data['localite']!, _localiteMeta),
      );
    } else if (isInserting) {
      context.missing(_localiteMeta);
    }
    if (data.containsKey('quartier')) {
      context.handle(
        _quartierMeta,
        quartier.isAcceptableOrUnknown(data['quartier']!, _quartierMeta),
      );
    }
    if (data.containsKey('ressenti')) {
      context.handle(
        _ressentiMeta,
        ressenti.isAcceptableOrUnknown(data['ressenti']!, _ressentiMeta),
      );
    }
    if (data.containsKey('consentement')) {
      context.handle(
        _consentementMeta,
        consentement.isAcceptableOrUnknown(
          data['consentement']!,
          _consentementMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_consentementMeta);
    }
    if (data.containsKey('statut')) {
      context.handle(
        _statutMeta,
        statut.isAcceptableOrUnknown(data['statut']!, _statutMeta),
      );
    } else if (isInserting) {
      context.missing(_statutMeta);
    }
    if (data.containsKey('date_inscription')) {
      context.handle(
        _dateInscriptionMeta,
        dateInscription.isAcceptableOrUnknown(
          data['date_inscription']!,
          _dateInscriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateInscriptionMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ParticipantsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParticipantsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      seanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seance_id'],
      )!,
      nom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom'],
      )!,
      prenom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prenom'],
      )!,
      telephone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telephone'],
      )!,
      profession: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profession'],
      ),
      statutLogement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}statut_logement'],
      )!,
      lieu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lieu'],
      ),
      localite: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}localite'],
      )!,
      quartier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quartier'],
      ),
      besoinsExprimes: $ParticipantsTableTable.$converterbesoinsExprimes
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}besoins_exprimes'],
            )!,
          ),
      ressenti: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ressenti'],
      ),
      consentement: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}consentement'],
      )!,
      statut: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}statut'],
      )!,
      dateInscription: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_inscription'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $ParticipantsTableTable createAlias(String alias) {
    return $ParticipantsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterbesoinsExprimes =
      const StringListConverter();
}

class ParticipantsTableData extends DataClass
    implements Insertable<ParticipantsTableData> {
  final int id;
  final int? serverId;
  final int seanceId;
  final String nom;
  final String prenom;
  final String telephone;
  final String? profession;
  final String statutLogement;
  final String? lieu;
  final String localite;
  final String? quartier;
  final List<String> besoinsExprimes;
  final String? ressenti;
  final bool consentement;
  final String statut;
  final DateTime dateInscription;
  final bool isSynced;
  const ParticipantsTableData({
    required this.id,
    this.serverId,
    required this.seanceId,
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.profession,
    required this.statutLogement,
    this.lieu,
    required this.localite,
    this.quartier,
    required this.besoinsExprimes,
    this.ressenti,
    required this.consentement,
    required this.statut,
    required this.dateInscription,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['seance_id'] = Variable<int>(seanceId);
    map['nom'] = Variable<String>(nom);
    map['prenom'] = Variable<String>(prenom);
    map['telephone'] = Variable<String>(telephone);
    if (!nullToAbsent || profession != null) {
      map['profession'] = Variable<String>(profession);
    }
    map['statut_logement'] = Variable<String>(statutLogement);
    if (!nullToAbsent || lieu != null) {
      map['lieu'] = Variable<String>(lieu);
    }
    map['localite'] = Variable<String>(localite);
    if (!nullToAbsent || quartier != null) {
      map['quartier'] = Variable<String>(quartier);
    }
    {
      map['besoins_exprimes'] = Variable<String>(
        $ParticipantsTableTable.$converterbesoinsExprimes.toSql(
          besoinsExprimes,
        ),
      );
    }
    if (!nullToAbsent || ressenti != null) {
      map['ressenti'] = Variable<String>(ressenti);
    }
    map['consentement'] = Variable<bool>(consentement);
    map['statut'] = Variable<String>(statut);
    map['date_inscription'] = Variable<DateTime>(dateInscription);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  ParticipantsTableCompanion toCompanion(bool nullToAbsent) {
    return ParticipantsTableCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      seanceId: Value(seanceId),
      nom: Value(nom),
      prenom: Value(prenom),
      telephone: Value(telephone),
      profession: profession == null && nullToAbsent
          ? const Value.absent()
          : Value(profession),
      statutLogement: Value(statutLogement),
      lieu: lieu == null && nullToAbsent ? const Value.absent() : Value(lieu),
      localite: Value(localite),
      quartier: quartier == null && nullToAbsent
          ? const Value.absent()
          : Value(quartier),
      besoinsExprimes: Value(besoinsExprimes),
      ressenti: ressenti == null && nullToAbsent
          ? const Value.absent()
          : Value(ressenti),
      consentement: Value(consentement),
      statut: Value(statut),
      dateInscription: Value(dateInscription),
      isSynced: Value(isSynced),
    );
  }

  factory ParticipantsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParticipantsTableData(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      seanceId: serializer.fromJson<int>(json['seanceId']),
      nom: serializer.fromJson<String>(json['nom']),
      prenom: serializer.fromJson<String>(json['prenom']),
      telephone: serializer.fromJson<String>(json['telephone']),
      profession: serializer.fromJson<String?>(json['profession']),
      statutLogement: serializer.fromJson<String>(json['statutLogement']),
      lieu: serializer.fromJson<String?>(json['lieu']),
      localite: serializer.fromJson<String>(json['localite']),
      quartier: serializer.fromJson<String?>(json['quartier']),
      besoinsExprimes: serializer.fromJson<List<String>>(
        json['besoinsExprimes'],
      ),
      ressenti: serializer.fromJson<String?>(json['ressenti']),
      consentement: serializer.fromJson<bool>(json['consentement']),
      statut: serializer.fromJson<String>(json['statut']),
      dateInscription: serializer.fromJson<DateTime>(json['dateInscription']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int?>(serverId),
      'seanceId': serializer.toJson<int>(seanceId),
      'nom': serializer.toJson<String>(nom),
      'prenom': serializer.toJson<String>(prenom),
      'telephone': serializer.toJson<String>(telephone),
      'profession': serializer.toJson<String?>(profession),
      'statutLogement': serializer.toJson<String>(statutLogement),
      'lieu': serializer.toJson<String?>(lieu),
      'localite': serializer.toJson<String>(localite),
      'quartier': serializer.toJson<String?>(quartier),
      'besoinsExprimes': serializer.toJson<List<String>>(besoinsExprimes),
      'ressenti': serializer.toJson<String?>(ressenti),
      'consentement': serializer.toJson<bool>(consentement),
      'statut': serializer.toJson<String>(statut),
      'dateInscription': serializer.toJson<DateTime>(dateInscription),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  ParticipantsTableData copyWith({
    int? id,
    Value<int?> serverId = const Value.absent(),
    int? seanceId,
    String? nom,
    String? prenom,
    String? telephone,
    Value<String?> profession = const Value.absent(),
    String? statutLogement,
    Value<String?> lieu = const Value.absent(),
    String? localite,
    Value<String?> quartier = const Value.absent(),
    List<String>? besoinsExprimes,
    Value<String?> ressenti = const Value.absent(),
    bool? consentement,
    String? statut,
    DateTime? dateInscription,
    bool? isSynced,
  }) => ParticipantsTableData(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    seanceId: seanceId ?? this.seanceId,
    nom: nom ?? this.nom,
    prenom: prenom ?? this.prenom,
    telephone: telephone ?? this.telephone,
    profession: profession.present ? profession.value : this.profession,
    statutLogement: statutLogement ?? this.statutLogement,
    lieu: lieu.present ? lieu.value : this.lieu,
    localite: localite ?? this.localite,
    quartier: quartier.present ? quartier.value : this.quartier,
    besoinsExprimes: besoinsExprimes ?? this.besoinsExprimes,
    ressenti: ressenti.present ? ressenti.value : this.ressenti,
    consentement: consentement ?? this.consentement,
    statut: statut ?? this.statut,
    dateInscription: dateInscription ?? this.dateInscription,
    isSynced: isSynced ?? this.isSynced,
  );
  ParticipantsTableData copyWithCompanion(ParticipantsTableCompanion data) {
    return ParticipantsTableData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      seanceId: data.seanceId.present ? data.seanceId.value : this.seanceId,
      nom: data.nom.present ? data.nom.value : this.nom,
      prenom: data.prenom.present ? data.prenom.value : this.prenom,
      telephone: data.telephone.present ? data.telephone.value : this.telephone,
      profession: data.profession.present
          ? data.profession.value
          : this.profession,
      statutLogement: data.statutLogement.present
          ? data.statutLogement.value
          : this.statutLogement,
      lieu: data.lieu.present ? data.lieu.value : this.lieu,
      localite: data.localite.present ? data.localite.value : this.localite,
      quartier: data.quartier.present ? data.quartier.value : this.quartier,
      besoinsExprimes: data.besoinsExprimes.present
          ? data.besoinsExprimes.value
          : this.besoinsExprimes,
      ressenti: data.ressenti.present ? data.ressenti.value : this.ressenti,
      consentement: data.consentement.present
          ? data.consentement.value
          : this.consentement,
      statut: data.statut.present ? data.statut.value : this.statut,
      dateInscription: data.dateInscription.present
          ? data.dateInscription.value
          : this.dateInscription,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParticipantsTableData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('seanceId: $seanceId, ')
          ..write('nom: $nom, ')
          ..write('prenom: $prenom, ')
          ..write('telephone: $telephone, ')
          ..write('profession: $profession, ')
          ..write('statutLogement: $statutLogement, ')
          ..write('lieu: $lieu, ')
          ..write('localite: $localite, ')
          ..write('quartier: $quartier, ')
          ..write('besoinsExprimes: $besoinsExprimes, ')
          ..write('ressenti: $ressenti, ')
          ..write('consentement: $consentement, ')
          ..write('statut: $statut, ')
          ..write('dateInscription: $dateInscription, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    seanceId,
    nom,
    prenom,
    telephone,
    profession,
    statutLogement,
    lieu,
    localite,
    quartier,
    besoinsExprimes,
    ressenti,
    consentement,
    statut,
    dateInscription,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParticipantsTableData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.seanceId == this.seanceId &&
          other.nom == this.nom &&
          other.prenom == this.prenom &&
          other.telephone == this.telephone &&
          other.profession == this.profession &&
          other.statutLogement == this.statutLogement &&
          other.lieu == this.lieu &&
          other.localite == this.localite &&
          other.quartier == this.quartier &&
          other.besoinsExprimes == this.besoinsExprimes &&
          other.ressenti == this.ressenti &&
          other.consentement == this.consentement &&
          other.statut == this.statut &&
          other.dateInscription == this.dateInscription &&
          other.isSynced == this.isSynced);
}

class ParticipantsTableCompanion
    extends UpdateCompanion<ParticipantsTableData> {
  final Value<int> id;
  final Value<int?> serverId;
  final Value<int> seanceId;
  final Value<String> nom;
  final Value<String> prenom;
  final Value<String> telephone;
  final Value<String?> profession;
  final Value<String> statutLogement;
  final Value<String?> lieu;
  final Value<String> localite;
  final Value<String?> quartier;
  final Value<List<String>> besoinsExprimes;
  final Value<String?> ressenti;
  final Value<bool> consentement;
  final Value<String> statut;
  final Value<DateTime> dateInscription;
  final Value<bool> isSynced;
  const ParticipantsTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.seanceId = const Value.absent(),
    this.nom = const Value.absent(),
    this.prenom = const Value.absent(),
    this.telephone = const Value.absent(),
    this.profession = const Value.absent(),
    this.statutLogement = const Value.absent(),
    this.lieu = const Value.absent(),
    this.localite = const Value.absent(),
    this.quartier = const Value.absent(),
    this.besoinsExprimes = const Value.absent(),
    this.ressenti = const Value.absent(),
    this.consentement = const Value.absent(),
    this.statut = const Value.absent(),
    this.dateInscription = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  ParticipantsTableCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required int seanceId,
    required String nom,
    required String prenom,
    required String telephone,
    this.profession = const Value.absent(),
    required String statutLogement,
    this.lieu = const Value.absent(),
    required String localite,
    this.quartier = const Value.absent(),
    required List<String> besoinsExprimes,
    this.ressenti = const Value.absent(),
    required bool consentement,
    required String statut,
    required DateTime dateInscription,
    this.isSynced = const Value.absent(),
  }) : seanceId = Value(seanceId),
       nom = Value(nom),
       prenom = Value(prenom),
       telephone = Value(telephone),
       statutLogement = Value(statutLogement),
       localite = Value(localite),
       besoinsExprimes = Value(besoinsExprimes),
       consentement = Value(consentement),
       statut = Value(statut),
       dateInscription = Value(dateInscription);
  static Insertable<ParticipantsTableData> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<int>? seanceId,
    Expression<String>? nom,
    Expression<String>? prenom,
    Expression<String>? telephone,
    Expression<String>? profession,
    Expression<String>? statutLogement,
    Expression<String>? lieu,
    Expression<String>? localite,
    Expression<String>? quartier,
    Expression<String>? besoinsExprimes,
    Expression<String>? ressenti,
    Expression<bool>? consentement,
    Expression<String>? statut,
    Expression<DateTime>? dateInscription,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (seanceId != null) 'seance_id': seanceId,
      if (nom != null) 'nom': nom,
      if (prenom != null) 'prenom': prenom,
      if (telephone != null) 'telephone': telephone,
      if (profession != null) 'profession': profession,
      if (statutLogement != null) 'statut_logement': statutLogement,
      if (lieu != null) 'lieu': lieu,
      if (localite != null) 'localite': localite,
      if (quartier != null) 'quartier': quartier,
      if (besoinsExprimes != null) 'besoins_exprimes': besoinsExprimes,
      if (ressenti != null) 'ressenti': ressenti,
      if (consentement != null) 'consentement': consentement,
      if (statut != null) 'statut': statut,
      if (dateInscription != null) 'date_inscription': dateInscription,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  ParticipantsTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? serverId,
    Value<int>? seanceId,
    Value<String>? nom,
    Value<String>? prenom,
    Value<String>? telephone,
    Value<String?>? profession,
    Value<String>? statutLogement,
    Value<String?>? lieu,
    Value<String>? localite,
    Value<String?>? quartier,
    Value<List<String>>? besoinsExprimes,
    Value<String?>? ressenti,
    Value<bool>? consentement,
    Value<String>? statut,
    Value<DateTime>? dateInscription,
    Value<bool>? isSynced,
  }) {
    return ParticipantsTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      seanceId: seanceId ?? this.seanceId,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      profession: profession ?? this.profession,
      statutLogement: statutLogement ?? this.statutLogement,
      lieu: lieu ?? this.lieu,
      localite: localite ?? this.localite,
      quartier: quartier ?? this.quartier,
      besoinsExprimes: besoinsExprimes ?? this.besoinsExprimes,
      ressenti: ressenti ?? this.ressenti,
      consentement: consentement ?? this.consentement,
      statut: statut ?? this.statut,
      dateInscription: dateInscription ?? this.dateInscription,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (seanceId.present) {
      map['seance_id'] = Variable<int>(seanceId.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (prenom.present) {
      map['prenom'] = Variable<String>(prenom.value);
    }
    if (telephone.present) {
      map['telephone'] = Variable<String>(telephone.value);
    }
    if (profession.present) {
      map['profession'] = Variable<String>(profession.value);
    }
    if (statutLogement.present) {
      map['statut_logement'] = Variable<String>(statutLogement.value);
    }
    if (lieu.present) {
      map['lieu'] = Variable<String>(lieu.value);
    }
    if (localite.present) {
      map['localite'] = Variable<String>(localite.value);
    }
    if (quartier.present) {
      map['quartier'] = Variable<String>(quartier.value);
    }
    if (besoinsExprimes.present) {
      map['besoins_exprimes'] = Variable<String>(
        $ParticipantsTableTable.$converterbesoinsExprimes.toSql(
          besoinsExprimes.value,
        ),
      );
    }
    if (ressenti.present) {
      map['ressenti'] = Variable<String>(ressenti.value);
    }
    if (consentement.present) {
      map['consentement'] = Variable<bool>(consentement.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (dateInscription.present) {
      map['date_inscription'] = Variable<DateTime>(dateInscription.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParticipantsTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('seanceId: $seanceId, ')
          ..write('nom: $nom, ')
          ..write('prenom: $prenom, ')
          ..write('telephone: $telephone, ')
          ..write('profession: $profession, ')
          ..write('statutLogement: $statutLogement, ')
          ..write('lieu: $lieu, ')
          ..write('localite: $localite, ')
          ..write('quartier: $quartier, ')
          ..write('besoinsExprimes: $besoinsExprimes, ')
          ..write('ressenti: $ressenti, ')
          ..write('consentement: $consentement, ')
          ..write('statut: $statut, ')
          ..write('dateInscription: $dateInscription, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $SyncHistoryTableTable extends SyncHistoryTable
    with TableInfo<$SyncHistoryTableTable, SyncHistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, time, status, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_history_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncHistoryTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncHistoryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncHistoryTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $SyncHistoryTableTable createAlias(String alias) {
    return $SyncHistoryTableTable(attachedDatabase, alias);
  }
}

class SyncHistoryTableData extends DataClass
    implements Insertable<SyncHistoryTableData> {
  final int id;
  final String title;
  final String time;
  final String status;
  final String type;
  const SyncHistoryTableData({
    required this.id,
    required this.title,
    required this.time,
    required this.status,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['time'] = Variable<String>(time);
    map['status'] = Variable<String>(status);
    map['type'] = Variable<String>(type);
    return map;
  }

  SyncHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return SyncHistoryTableCompanion(
      id: Value(id),
      title: Value(title),
      time: Value(time),
      status: Value(status),
      type: Value(type),
    );
  }

  factory SyncHistoryTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncHistoryTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      time: serializer.fromJson<String>(json['time']),
      status: serializer.fromJson<String>(json['status']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'time': serializer.toJson<String>(time),
      'status': serializer.toJson<String>(status),
      'type': serializer.toJson<String>(type),
    };
  }

  SyncHistoryTableData copyWith({
    int? id,
    String? title,
    String? time,
    String? status,
    String? type,
  }) => SyncHistoryTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    time: time ?? this.time,
    status: status ?? this.status,
    type: type ?? this.type,
  );
  SyncHistoryTableData copyWithCompanion(SyncHistoryTableCompanion data) {
    return SyncHistoryTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      time: data.time.present ? data.time.value : this.time,
      status: data.status.present ? data.status.value : this.status,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncHistoryTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('time: $time, ')
          ..write('status: $status, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, time, status, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncHistoryTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.time == this.time &&
          other.status == this.status &&
          other.type == this.type);
}

class SyncHistoryTableCompanion extends UpdateCompanion<SyncHistoryTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> time;
  final Value<String> status;
  final Value<String> type;
  const SyncHistoryTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.time = const Value.absent(),
    this.status = const Value.absent(),
    this.type = const Value.absent(),
  });
  SyncHistoryTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String time,
    required String status,
    required String type,
  }) : title = Value(title),
       time = Value(time),
       status = Value(status),
       type = Value(type);
  static Insertable<SyncHistoryTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? time,
    Expression<String>? status,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (time != null) 'time': time,
      if (status != null) 'status': status,
      if (type != null) 'type': type,
    });
  }

  SyncHistoryTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? time,
    Value<String>? status,
    Value<String>? type,
  }) {
    return SyncHistoryTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('time: $time, ')
          ..write('status: $status, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $PriseContactsTableTable extends PriseContactsTable
    with TableInfo<$PriseContactsTableTable, PriseContactsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriseContactsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seanceIdMeta = const VerificationMeta(
    'seanceId',
  );
  @override
  late final GeneratedColumn<int> seanceId = GeneratedColumn<int>(
    'seance_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomContactMeta = const VerificationMeta(
    'nomContact',
  );
  @override
  late final GeneratedColumn<String> nomContact = GeneratedColumn<String>(
    'nom_contact',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telephoneMeta = const VerificationMeta(
    'telephone',
  );
  @override
  late final GeneratedColumn<String> telephone = GeneratedColumn<String>(
    'telephone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _objetMissionMeta = const VerificationMeta(
    'objetMission',
  );
  @override
  late final GeneratedColumn<String> objetMission = GeneratedColumn<String>(
    'objet_mission',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionRegionaleMeta =
      const VerificationMeta('directionRegionale');
  @override
  late final GeneratedColumn<String> directionRegionale =
      GeneratedColumn<String>(
        'direction_regionale',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _agenceMeta = const VerificationMeta('agence');
  @override
  late final GeneratedColumn<String> agence = GeneratedColumn<String>(
    'agence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quartierMeta = const VerificationMeta(
    'quartier',
  );
  @override
  late final GeneratedColumn<String> quartier = GeneratedColumn<String>(
    'quartier',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _siteMeta = const VerificationMeta('site');
  @override
  late final GeneratedColumn<String> site = GeneratedColumn<String>(
    'site',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  pointsAbordes =
      GeneratedColumn<String>(
        'points_abordes',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $PriseContactsTableTable.$converterpointsAbordes,
      );
  static const VerificationMeta _observationsMeta = const VerificationMeta(
    'observations',
  );
  @override
  late final GeneratedColumn<String> observations = GeneratedColumn<String>(
    'observations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signatureBase64Meta = const VerificationMeta(
    'signatureBase64',
  );
  @override
  late final GeneratedColumn<String> signatureBase64 = GeneratedColumn<String>(
    'signature_base64',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    seanceId,
    nomContact,
    telephone,
    date,
    objetMission,
    directionRegionale,
    agence,
    quartier,
    site,
    pointsAbordes,
    observations,
    signatureBase64,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prise_contacts_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PriseContactsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('seance_id')) {
      context.handle(
        _seanceIdMeta,
        seanceId.isAcceptableOrUnknown(data['seance_id']!, _seanceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seanceIdMeta);
    }
    if (data.containsKey('nom_contact')) {
      context.handle(
        _nomContactMeta,
        nomContact.isAcceptableOrUnknown(data['nom_contact']!, _nomContactMeta),
      );
    } else if (isInserting) {
      context.missing(_nomContactMeta);
    }
    if (data.containsKey('telephone')) {
      context.handle(
        _telephoneMeta,
        telephone.isAcceptableOrUnknown(data['telephone']!, _telephoneMeta),
      );
    } else if (isInserting) {
      context.missing(_telephoneMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('objet_mission')) {
      context.handle(
        _objetMissionMeta,
        objetMission.isAcceptableOrUnknown(
          data['objet_mission']!,
          _objetMissionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_objetMissionMeta);
    }
    if (data.containsKey('direction_regionale')) {
      context.handle(
        _directionRegionaleMeta,
        directionRegionale.isAcceptableOrUnknown(
          data['direction_regionale']!,
          _directionRegionaleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_directionRegionaleMeta);
    }
    if (data.containsKey('agence')) {
      context.handle(
        _agenceMeta,
        agence.isAcceptableOrUnknown(data['agence']!, _agenceMeta),
      );
    }
    if (data.containsKey('quartier')) {
      context.handle(
        _quartierMeta,
        quartier.isAcceptableOrUnknown(data['quartier']!, _quartierMeta),
      );
    }
    if (data.containsKey('site')) {
      context.handle(
        _siteMeta,
        site.isAcceptableOrUnknown(data['site']!, _siteMeta),
      );
    }
    if (data.containsKey('observations')) {
      context.handle(
        _observationsMeta,
        observations.isAcceptableOrUnknown(
          data['observations']!,
          _observationsMeta,
        ),
      );
    }
    if (data.containsKey('signature_base64')) {
      context.handle(
        _signatureBase64Meta,
        signatureBase64.isAcceptableOrUnknown(
          data['signature_base64']!,
          _signatureBase64Meta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PriseContactsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriseContactsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      seanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seance_id'],
      )!,
      nomContact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom_contact'],
      )!,
      telephone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telephone'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      objetMission: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}objet_mission'],
      )!,
      directionRegionale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction_regionale'],
      )!,
      agence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}agence'],
      ),
      quartier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quartier'],
      ),
      site: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site'],
      ),
      pointsAbordes: $PriseContactsTableTable.$converterpointsAbordes.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}points_abordes'],
        )!,
      ),
      observations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observations'],
      ),
      signatureBase64: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signature_base64'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $PriseContactsTableTable createAlias(String alias) {
    return $PriseContactsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterpointsAbordes =
      const StringListConverter();
}

class PriseContactsTableData extends DataClass
    implements Insertable<PriseContactsTableData> {
  final int id;
  final int? serverId;
  final int seanceId;
  final String nomContact;
  final String telephone;
  final DateTime date;
  final String objetMission;
  final String directionRegionale;
  final String? agence;
  final String? quartier;
  final String? site;
  final List<String> pointsAbordes;
  final String? observations;
  final String? signatureBase64;
  final bool isSynced;
  const PriseContactsTableData({
    required this.id,
    this.serverId,
    required this.seanceId,
    required this.nomContact,
    required this.telephone,
    required this.date,
    required this.objetMission,
    required this.directionRegionale,
    this.agence,
    this.quartier,
    this.site,
    required this.pointsAbordes,
    this.observations,
    this.signatureBase64,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['seance_id'] = Variable<int>(seanceId);
    map['nom_contact'] = Variable<String>(nomContact);
    map['telephone'] = Variable<String>(telephone);
    map['date'] = Variable<DateTime>(date);
    map['objet_mission'] = Variable<String>(objetMission);
    map['direction_regionale'] = Variable<String>(directionRegionale);
    if (!nullToAbsent || agence != null) {
      map['agence'] = Variable<String>(agence);
    }
    if (!nullToAbsent || quartier != null) {
      map['quartier'] = Variable<String>(quartier);
    }
    if (!nullToAbsent || site != null) {
      map['site'] = Variable<String>(site);
    }
    {
      map['points_abordes'] = Variable<String>(
        $PriseContactsTableTable.$converterpointsAbordes.toSql(pointsAbordes),
      );
    }
    if (!nullToAbsent || observations != null) {
      map['observations'] = Variable<String>(observations);
    }
    if (!nullToAbsent || signatureBase64 != null) {
      map['signature_base64'] = Variable<String>(signatureBase64);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  PriseContactsTableCompanion toCompanion(bool nullToAbsent) {
    return PriseContactsTableCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      seanceId: Value(seanceId),
      nomContact: Value(nomContact),
      telephone: Value(telephone),
      date: Value(date),
      objetMission: Value(objetMission),
      directionRegionale: Value(directionRegionale),
      agence: agence == null && nullToAbsent
          ? const Value.absent()
          : Value(agence),
      quartier: quartier == null && nullToAbsent
          ? const Value.absent()
          : Value(quartier),
      site: site == null && nullToAbsent ? const Value.absent() : Value(site),
      pointsAbordes: Value(pointsAbordes),
      observations: observations == null && nullToAbsent
          ? const Value.absent()
          : Value(observations),
      signatureBase64: signatureBase64 == null && nullToAbsent
          ? const Value.absent()
          : Value(signatureBase64),
      isSynced: Value(isSynced),
    );
  }

  factory PriseContactsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriseContactsTableData(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      seanceId: serializer.fromJson<int>(json['seanceId']),
      nomContact: serializer.fromJson<String>(json['nomContact']),
      telephone: serializer.fromJson<String>(json['telephone']),
      date: serializer.fromJson<DateTime>(json['date']),
      objetMission: serializer.fromJson<String>(json['objetMission']),
      directionRegionale: serializer.fromJson<String>(
        json['directionRegionale'],
      ),
      agence: serializer.fromJson<String?>(json['agence']),
      quartier: serializer.fromJson<String?>(json['quartier']),
      site: serializer.fromJson<String?>(json['site']),
      pointsAbordes: serializer.fromJson<List<String>>(json['pointsAbordes']),
      observations: serializer.fromJson<String?>(json['observations']),
      signatureBase64: serializer.fromJson<String?>(json['signatureBase64']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int?>(serverId),
      'seanceId': serializer.toJson<int>(seanceId),
      'nomContact': serializer.toJson<String>(nomContact),
      'telephone': serializer.toJson<String>(telephone),
      'date': serializer.toJson<DateTime>(date),
      'objetMission': serializer.toJson<String>(objetMission),
      'directionRegionale': serializer.toJson<String>(directionRegionale),
      'agence': serializer.toJson<String?>(agence),
      'quartier': serializer.toJson<String?>(quartier),
      'site': serializer.toJson<String?>(site),
      'pointsAbordes': serializer.toJson<List<String>>(pointsAbordes),
      'observations': serializer.toJson<String?>(observations),
      'signatureBase64': serializer.toJson<String?>(signatureBase64),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  PriseContactsTableData copyWith({
    int? id,
    Value<int?> serverId = const Value.absent(),
    int? seanceId,
    String? nomContact,
    String? telephone,
    DateTime? date,
    String? objetMission,
    String? directionRegionale,
    Value<String?> agence = const Value.absent(),
    Value<String?> quartier = const Value.absent(),
    Value<String?> site = const Value.absent(),
    List<String>? pointsAbordes,
    Value<String?> observations = const Value.absent(),
    Value<String?> signatureBase64 = const Value.absent(),
    bool? isSynced,
  }) => PriseContactsTableData(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    seanceId: seanceId ?? this.seanceId,
    nomContact: nomContact ?? this.nomContact,
    telephone: telephone ?? this.telephone,
    date: date ?? this.date,
    objetMission: objetMission ?? this.objetMission,
    directionRegionale: directionRegionale ?? this.directionRegionale,
    agence: agence.present ? agence.value : this.agence,
    quartier: quartier.present ? quartier.value : this.quartier,
    site: site.present ? site.value : this.site,
    pointsAbordes: pointsAbordes ?? this.pointsAbordes,
    observations: observations.present ? observations.value : this.observations,
    signatureBase64: signatureBase64.present
        ? signatureBase64.value
        : this.signatureBase64,
    isSynced: isSynced ?? this.isSynced,
  );
  PriseContactsTableData copyWithCompanion(PriseContactsTableCompanion data) {
    return PriseContactsTableData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      seanceId: data.seanceId.present ? data.seanceId.value : this.seanceId,
      nomContact: data.nomContact.present
          ? data.nomContact.value
          : this.nomContact,
      telephone: data.telephone.present ? data.telephone.value : this.telephone,
      date: data.date.present ? data.date.value : this.date,
      objetMission: data.objetMission.present
          ? data.objetMission.value
          : this.objetMission,
      directionRegionale: data.directionRegionale.present
          ? data.directionRegionale.value
          : this.directionRegionale,
      agence: data.agence.present ? data.agence.value : this.agence,
      quartier: data.quartier.present ? data.quartier.value : this.quartier,
      site: data.site.present ? data.site.value : this.site,
      pointsAbordes: data.pointsAbordes.present
          ? data.pointsAbordes.value
          : this.pointsAbordes,
      observations: data.observations.present
          ? data.observations.value
          : this.observations,
      signatureBase64: data.signatureBase64.present
          ? data.signatureBase64.value
          : this.signatureBase64,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriseContactsTableData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('seanceId: $seanceId, ')
          ..write('nomContact: $nomContact, ')
          ..write('telephone: $telephone, ')
          ..write('date: $date, ')
          ..write('objetMission: $objetMission, ')
          ..write('directionRegionale: $directionRegionale, ')
          ..write('agence: $agence, ')
          ..write('quartier: $quartier, ')
          ..write('site: $site, ')
          ..write('pointsAbordes: $pointsAbordes, ')
          ..write('observations: $observations, ')
          ..write('signatureBase64: $signatureBase64, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    seanceId,
    nomContact,
    telephone,
    date,
    objetMission,
    directionRegionale,
    agence,
    quartier,
    site,
    pointsAbordes,
    observations,
    signatureBase64,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriseContactsTableData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.seanceId == this.seanceId &&
          other.nomContact == this.nomContact &&
          other.telephone == this.telephone &&
          other.date == this.date &&
          other.objetMission == this.objetMission &&
          other.directionRegionale == this.directionRegionale &&
          other.agence == this.agence &&
          other.quartier == this.quartier &&
          other.site == this.site &&
          other.pointsAbordes == this.pointsAbordes &&
          other.observations == this.observations &&
          other.signatureBase64 == this.signatureBase64 &&
          other.isSynced == this.isSynced);
}

class PriseContactsTableCompanion
    extends UpdateCompanion<PriseContactsTableData> {
  final Value<int> id;
  final Value<int?> serverId;
  final Value<int> seanceId;
  final Value<String> nomContact;
  final Value<String> telephone;
  final Value<DateTime> date;
  final Value<String> objetMission;
  final Value<String> directionRegionale;
  final Value<String?> agence;
  final Value<String?> quartier;
  final Value<String?> site;
  final Value<List<String>> pointsAbordes;
  final Value<String?> observations;
  final Value<String?> signatureBase64;
  final Value<bool> isSynced;
  const PriseContactsTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.seanceId = const Value.absent(),
    this.nomContact = const Value.absent(),
    this.telephone = const Value.absent(),
    this.date = const Value.absent(),
    this.objetMission = const Value.absent(),
    this.directionRegionale = const Value.absent(),
    this.agence = const Value.absent(),
    this.quartier = const Value.absent(),
    this.site = const Value.absent(),
    this.pointsAbordes = const Value.absent(),
    this.observations = const Value.absent(),
    this.signatureBase64 = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  PriseContactsTableCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required int seanceId,
    required String nomContact,
    required String telephone,
    required DateTime date,
    required String objetMission,
    required String directionRegionale,
    this.agence = const Value.absent(),
    this.quartier = const Value.absent(),
    this.site = const Value.absent(),
    required List<String> pointsAbordes,
    this.observations = const Value.absent(),
    this.signatureBase64 = const Value.absent(),
    this.isSynced = const Value.absent(),
  }) : seanceId = Value(seanceId),
       nomContact = Value(nomContact),
       telephone = Value(telephone),
       date = Value(date),
       objetMission = Value(objetMission),
       directionRegionale = Value(directionRegionale),
       pointsAbordes = Value(pointsAbordes);
  static Insertable<PriseContactsTableData> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<int>? seanceId,
    Expression<String>? nomContact,
    Expression<String>? telephone,
    Expression<DateTime>? date,
    Expression<String>? objetMission,
    Expression<String>? directionRegionale,
    Expression<String>? agence,
    Expression<String>? quartier,
    Expression<String>? site,
    Expression<String>? pointsAbordes,
    Expression<String>? observations,
    Expression<String>? signatureBase64,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (seanceId != null) 'seance_id': seanceId,
      if (nomContact != null) 'nom_contact': nomContact,
      if (telephone != null) 'telephone': telephone,
      if (date != null) 'date': date,
      if (objetMission != null) 'objet_mission': objetMission,
      if (directionRegionale != null) 'direction_regionale': directionRegionale,
      if (agence != null) 'agence': agence,
      if (quartier != null) 'quartier': quartier,
      if (site != null) 'site': site,
      if (pointsAbordes != null) 'points_abordes': pointsAbordes,
      if (observations != null) 'observations': observations,
      if (signatureBase64 != null) 'signature_base64': signatureBase64,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  PriseContactsTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? serverId,
    Value<int>? seanceId,
    Value<String>? nomContact,
    Value<String>? telephone,
    Value<DateTime>? date,
    Value<String>? objetMission,
    Value<String>? directionRegionale,
    Value<String?>? agence,
    Value<String?>? quartier,
    Value<String?>? site,
    Value<List<String>>? pointsAbordes,
    Value<String?>? observations,
    Value<String?>? signatureBase64,
    Value<bool>? isSynced,
  }) {
    return PriseContactsTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      seanceId: seanceId ?? this.seanceId,
      nomContact: nomContact ?? this.nomContact,
      telephone: telephone ?? this.telephone,
      date: date ?? this.date,
      objetMission: objetMission ?? this.objetMission,
      directionRegionale: directionRegionale ?? this.directionRegionale,
      agence: agence ?? this.agence,
      quartier: quartier ?? this.quartier,
      site: site ?? this.site,
      pointsAbordes: pointsAbordes ?? this.pointsAbordes,
      observations: observations ?? this.observations,
      signatureBase64: signatureBase64 ?? this.signatureBase64,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (seanceId.present) {
      map['seance_id'] = Variable<int>(seanceId.value);
    }
    if (nomContact.present) {
      map['nom_contact'] = Variable<String>(nomContact.value);
    }
    if (telephone.present) {
      map['telephone'] = Variable<String>(telephone.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (objetMission.present) {
      map['objet_mission'] = Variable<String>(objetMission.value);
    }
    if (directionRegionale.present) {
      map['direction_regionale'] = Variable<String>(directionRegionale.value);
    }
    if (agence.present) {
      map['agence'] = Variable<String>(agence.value);
    }
    if (quartier.present) {
      map['quartier'] = Variable<String>(quartier.value);
    }
    if (site.present) {
      map['site'] = Variable<String>(site.value);
    }
    if (pointsAbordes.present) {
      map['points_abordes'] = Variable<String>(
        $PriseContactsTableTable.$converterpointsAbordes.toSql(
          pointsAbordes.value,
        ),
      );
    }
    if (observations.present) {
      map['observations'] = Variable<String>(observations.value);
    }
    if (signatureBase64.present) {
      map['signature_base64'] = Variable<String>(signatureBase64.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriseContactsTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('seanceId: $seanceId, ')
          ..write('nomContact: $nomContact, ')
          ..write('telephone: $telephone, ')
          ..write('date: $date, ')
          ..write('objetMission: $objetMission, ')
          ..write('directionRegionale: $directionRegionale, ')
          ..write('agence: $agence, ')
          ..write('quartier: $quartier, ')
          ..write('site: $site, ')
          ..write('pointsAbordes: $pointsAbordes, ')
          ..write('observations: $observations, ')
          ..write('signatureBase64: $signatureBase64, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $RdvsTableTable extends RdvsTable
    with TableInfo<$RdvsTableTable, RdvsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RdvsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seanceIdMeta = const VerificationMeta(
    'seanceId',
  );
  @override
  late final GeneratedColumn<int> seanceId = GeneratedColumn<int>(
    'seance_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titreMeta = const VerificationMeta('titre');
  @override
  late final GeneratedColumn<String> titre = GeneratedColumn<String>(
    'titre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactMeta = const VerificationMeta(
    'contact',
  );
  @override
  late final GeneratedColumn<String> contact = GeneratedColumn<String>(
    'contact',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateRdvMeta = const VerificationMeta(
    'dateRdv',
  );
  @override
  late final GeneratedColumn<DateTime> dateRdv = GeneratedColumn<DateTime>(
    'date_rdv',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heureMeta = const VerificationMeta('heure');
  @override
  late final GeneratedColumn<String> heure = GeneratedColumn<String>(
    'heure',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lieuMeta = const VerificationMeta('lieu');
  @override
  late final GeneratedColumn<String> lieu = GeneratedColumn<String>(
    'lieu',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
    'statut',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    seanceId,
    titre,
    contact,
    dateRdv,
    heure,
    lieu,
    statut,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rdvs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RdvsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('seance_id')) {
      context.handle(
        _seanceIdMeta,
        seanceId.isAcceptableOrUnknown(data['seance_id']!, _seanceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seanceIdMeta);
    }
    if (data.containsKey('titre')) {
      context.handle(
        _titreMeta,
        titre.isAcceptableOrUnknown(data['titre']!, _titreMeta),
      );
    } else if (isInserting) {
      context.missing(_titreMeta);
    }
    if (data.containsKey('contact')) {
      context.handle(
        _contactMeta,
        contact.isAcceptableOrUnknown(data['contact']!, _contactMeta),
      );
    } else if (isInserting) {
      context.missing(_contactMeta);
    }
    if (data.containsKey('date_rdv')) {
      context.handle(
        _dateRdvMeta,
        dateRdv.isAcceptableOrUnknown(data['date_rdv']!, _dateRdvMeta),
      );
    } else if (isInserting) {
      context.missing(_dateRdvMeta);
    }
    if (data.containsKey('heure')) {
      context.handle(
        _heureMeta,
        heure.isAcceptableOrUnknown(data['heure']!, _heureMeta),
      );
    } else if (isInserting) {
      context.missing(_heureMeta);
    }
    if (data.containsKey('lieu')) {
      context.handle(
        _lieuMeta,
        lieu.isAcceptableOrUnknown(data['lieu']!, _lieuMeta),
      );
    } else if (isInserting) {
      context.missing(_lieuMeta);
    }
    if (data.containsKey('statut')) {
      context.handle(
        _statutMeta,
        statut.isAcceptableOrUnknown(data['statut']!, _statutMeta),
      );
    } else if (isInserting) {
      context.missing(_statutMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RdvsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RdvsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      seanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seance_id'],
      )!,
      titre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titre'],
      )!,
      contact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact'],
      )!,
      dateRdv: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_rdv'],
      )!,
      heure: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}heure'],
      )!,
      lieu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lieu'],
      )!,
      statut: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}statut'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $RdvsTableTable createAlias(String alias) {
    return $RdvsTableTable(attachedDatabase, alias);
  }
}

class RdvsTableData extends DataClass implements Insertable<RdvsTableData> {
  final int id;
  final int? serverId;
  final int seanceId;
  final String titre;
  final String contact;
  final DateTime dateRdv;
  final String heure;
  final String lieu;
  final String statut;
  final bool isSynced;
  const RdvsTableData({
    required this.id,
    this.serverId,
    required this.seanceId,
    required this.titre,
    required this.contact,
    required this.dateRdv,
    required this.heure,
    required this.lieu,
    required this.statut,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['seance_id'] = Variable<int>(seanceId);
    map['titre'] = Variable<String>(titre);
    map['contact'] = Variable<String>(contact);
    map['date_rdv'] = Variable<DateTime>(dateRdv);
    map['heure'] = Variable<String>(heure);
    map['lieu'] = Variable<String>(lieu);
    map['statut'] = Variable<String>(statut);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  RdvsTableCompanion toCompanion(bool nullToAbsent) {
    return RdvsTableCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      seanceId: Value(seanceId),
      titre: Value(titre),
      contact: Value(contact),
      dateRdv: Value(dateRdv),
      heure: Value(heure),
      lieu: Value(lieu),
      statut: Value(statut),
      isSynced: Value(isSynced),
    );
  }

  factory RdvsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RdvsTableData(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      seanceId: serializer.fromJson<int>(json['seanceId']),
      titre: serializer.fromJson<String>(json['titre']),
      contact: serializer.fromJson<String>(json['contact']),
      dateRdv: serializer.fromJson<DateTime>(json['dateRdv']),
      heure: serializer.fromJson<String>(json['heure']),
      lieu: serializer.fromJson<String>(json['lieu']),
      statut: serializer.fromJson<String>(json['statut']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int?>(serverId),
      'seanceId': serializer.toJson<int>(seanceId),
      'titre': serializer.toJson<String>(titre),
      'contact': serializer.toJson<String>(contact),
      'dateRdv': serializer.toJson<DateTime>(dateRdv),
      'heure': serializer.toJson<String>(heure),
      'lieu': serializer.toJson<String>(lieu),
      'statut': serializer.toJson<String>(statut),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  RdvsTableData copyWith({
    int? id,
    Value<int?> serverId = const Value.absent(),
    int? seanceId,
    String? titre,
    String? contact,
    DateTime? dateRdv,
    String? heure,
    String? lieu,
    String? statut,
    bool? isSynced,
  }) => RdvsTableData(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    seanceId: seanceId ?? this.seanceId,
    titre: titre ?? this.titre,
    contact: contact ?? this.contact,
    dateRdv: dateRdv ?? this.dateRdv,
    heure: heure ?? this.heure,
    lieu: lieu ?? this.lieu,
    statut: statut ?? this.statut,
    isSynced: isSynced ?? this.isSynced,
  );
  RdvsTableData copyWithCompanion(RdvsTableCompanion data) {
    return RdvsTableData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      seanceId: data.seanceId.present ? data.seanceId.value : this.seanceId,
      titre: data.titre.present ? data.titre.value : this.titre,
      contact: data.contact.present ? data.contact.value : this.contact,
      dateRdv: data.dateRdv.present ? data.dateRdv.value : this.dateRdv,
      heure: data.heure.present ? data.heure.value : this.heure,
      lieu: data.lieu.present ? data.lieu.value : this.lieu,
      statut: data.statut.present ? data.statut.value : this.statut,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RdvsTableData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('seanceId: $seanceId, ')
          ..write('titre: $titre, ')
          ..write('contact: $contact, ')
          ..write('dateRdv: $dateRdv, ')
          ..write('heure: $heure, ')
          ..write('lieu: $lieu, ')
          ..write('statut: $statut, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    seanceId,
    titre,
    contact,
    dateRdv,
    heure,
    lieu,
    statut,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RdvsTableData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.seanceId == this.seanceId &&
          other.titre == this.titre &&
          other.contact == this.contact &&
          other.dateRdv == this.dateRdv &&
          other.heure == this.heure &&
          other.lieu == this.lieu &&
          other.statut == this.statut &&
          other.isSynced == this.isSynced);
}

class RdvsTableCompanion extends UpdateCompanion<RdvsTableData> {
  final Value<int> id;
  final Value<int?> serverId;
  final Value<int> seanceId;
  final Value<String> titre;
  final Value<String> contact;
  final Value<DateTime> dateRdv;
  final Value<String> heure;
  final Value<String> lieu;
  final Value<String> statut;
  final Value<bool> isSynced;
  const RdvsTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.seanceId = const Value.absent(),
    this.titre = const Value.absent(),
    this.contact = const Value.absent(),
    this.dateRdv = const Value.absent(),
    this.heure = const Value.absent(),
    this.lieu = const Value.absent(),
    this.statut = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  RdvsTableCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required int seanceId,
    required String titre,
    required String contact,
    required DateTime dateRdv,
    required String heure,
    required String lieu,
    required String statut,
    this.isSynced = const Value.absent(),
  }) : seanceId = Value(seanceId),
       titre = Value(titre),
       contact = Value(contact),
       dateRdv = Value(dateRdv),
       heure = Value(heure),
       lieu = Value(lieu),
       statut = Value(statut);
  static Insertable<RdvsTableData> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<int>? seanceId,
    Expression<String>? titre,
    Expression<String>? contact,
    Expression<DateTime>? dateRdv,
    Expression<String>? heure,
    Expression<String>? lieu,
    Expression<String>? statut,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (seanceId != null) 'seance_id': seanceId,
      if (titre != null) 'titre': titre,
      if (contact != null) 'contact': contact,
      if (dateRdv != null) 'date_rdv': dateRdv,
      if (heure != null) 'heure': heure,
      if (lieu != null) 'lieu': lieu,
      if (statut != null) 'statut': statut,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  RdvsTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? serverId,
    Value<int>? seanceId,
    Value<String>? titre,
    Value<String>? contact,
    Value<DateTime>? dateRdv,
    Value<String>? heure,
    Value<String>? lieu,
    Value<String>? statut,
    Value<bool>? isSynced,
  }) {
    return RdvsTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      seanceId: seanceId ?? this.seanceId,
      titre: titre ?? this.titre,
      contact: contact ?? this.contact,
      dateRdv: dateRdv ?? this.dateRdv,
      heure: heure ?? this.heure,
      lieu: lieu ?? this.lieu,
      statut: statut ?? this.statut,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (seanceId.present) {
      map['seance_id'] = Variable<int>(seanceId.value);
    }
    if (titre.present) {
      map['titre'] = Variable<String>(titre.value);
    }
    if (contact.present) {
      map['contact'] = Variable<String>(contact.value);
    }
    if (dateRdv.present) {
      map['date_rdv'] = Variable<DateTime>(dateRdv.value);
    }
    if (heure.present) {
      map['heure'] = Variable<String>(heure.value);
    }
    if (lieu.present) {
      map['lieu'] = Variable<String>(lieu.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RdvsTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('seanceId: $seanceId, ')
          ..write('titre: $titre, ')
          ..write('contact: $contact, ')
          ..write('dateRdv: $dateRdv, ')
          ..write('heure: $heure, ')
          ..write('lieu: $lieu, ')
          ..write('statut: $statut, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $SeancesTableTable extends SeancesTable
    with TableInfo<$SeancesTableTable, SeancesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeancesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
    'nom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _motifsMeta = const VerificationMeta('motifs');
  @override
  late final GeneratedColumn<String> motifs = GeneratedColumn<String>(
    'motifs',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeSeanceMeta = const VerificationMeta(
    'typeSeance',
  );
  @override
  late final GeneratedColumn<String> typeSeance = GeneratedColumn<String>(
    'type_seance',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cibleMeta = const VerificationMeta('cible');
  @override
  late final GeneratedColumn<String> cible = GeneratedColumn<String>(
    'cible',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zoneMeta = const VerificationMeta('zone');
  @override
  late final GeneratedColumn<String> zone = GeneratedColumn<String>(
    'zone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _villeMeta = const VerificationMeta('ville');
  @override
  late final GeneratedColumn<String> ville = GeneratedColumn<String>(
    'ville',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quartierMeta = const VerificationMeta(
    'quartier',
  );
  @override
  late final GeneratedColumn<String> quartier = GeneratedColumn<String>(
    'quartier',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _objectifParticipantsMeta =
      const VerificationMeta('objectifParticipants');
  @override
  late final GeneratedColumn<int> objectifParticipants = GeneratedColumn<int>(
    'objectif_participants',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organisateurMeta = const VerificationMeta(
    'organisateur',
  );
  @override
  late final GeneratedColumn<String> organisateur = GeneratedColumn<String>(
    'organisateur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _presentateurMeta = const VerificationMeta(
    'presentateur',
  );
  @override
  late final GeneratedColumn<String> presentateur = GeneratedColumn<String>(
    'presentateur',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
  assistants = GeneratedColumn<String>(
    'assistants',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<List<String>?>($SeancesTableTable.$converterassistants);
  static const VerificationMeta _datePrevueMeta = const VerificationMeta(
    'datePrevue',
  );
  @override
  late final GeneratedColumn<DateTime> datePrevue = GeneratedColumn<DateTime>(
    'date_prevue',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heureDebutMeta = const VerificationMeta(
    'heureDebut',
  );
  @override
  late final GeneratedColumn<String> heureDebut = GeneratedColumn<String>(
    'heure_debut',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heureFinMeta = const VerificationMeta(
    'heureFin',
  );
  @override
  late final GeneratedColumn<String> heureFin = GeneratedColumn<String>(
    'heure_fin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estTermineeMeta = const VerificationMeta(
    'estTerminee',
  );
  @override
  late final GeneratedColumn<bool> estTerminee = GeneratedColumn<bool>(
    'est_terminee',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("est_terminee" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _gadgetsPrevusMeta = const VerificationMeta(
    'gadgetsPrevus',
  );
  @override
  late final GeneratedColumn<int> gadgetsPrevus = GeneratedColumn<int>(
    'gadgets_prevus',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _gadgetsDistribuesMeta = const VerificationMeta(
    'gadgetsDistribues',
  );
  @override
  late final GeneratedColumn<int> gadgetsDistribues = GeneratedColumn<int>(
    'gadgets_distribues',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalLogistiqueMeta = const VerificationMeta(
    'totalLogistique',
  );
  @override
  late final GeneratedColumn<double> totalLogistique = GeneratedColumn<double>(
    'total_logistique',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _nbParticipantsEstimeMeta =
      const VerificationMeta('nbParticipantsEstime');
  @override
  late final GeneratedColumn<int> nbParticipantsEstime = GeneratedColumn<int>(
    'nb_participants_estime',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _evaluationMeta = const VerificationMeta(
    'evaluation',
  );
  @override
  late final GeneratedColumn<bool> evaluation = GeneratedColumn<bool>(
    'evaluation',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("evaluation" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    nom,
    motifs,
    typeSeance,
    cible,
    zone,
    ville,
    quartier,
    objectifParticipants,
    organisateur,
    presentateur,
    assistants,
    datePrevue,
    heureDebut,
    heureFin,
    estTerminee,
    gadgetsPrevus,
    gadgetsDistribues,
    totalLogistique,
    nbParticipantsEstime,
    evaluation,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'seances_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SeancesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('nom')) {
      context.handle(
        _nomMeta,
        nom.isAcceptableOrUnknown(data['nom']!, _nomMeta),
      );
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('motifs')) {
      context.handle(
        _motifsMeta,
        motifs.isAcceptableOrUnknown(data['motifs']!, _motifsMeta),
      );
    }
    if (data.containsKey('type_seance')) {
      context.handle(
        _typeSeanceMeta,
        typeSeance.isAcceptableOrUnknown(data['type_seance']!, _typeSeanceMeta),
      );
    }
    if (data.containsKey('cible')) {
      context.handle(
        _cibleMeta,
        cible.isAcceptableOrUnknown(data['cible']!, _cibleMeta),
      );
    }
    if (data.containsKey('zone')) {
      context.handle(
        _zoneMeta,
        zone.isAcceptableOrUnknown(data['zone']!, _zoneMeta),
      );
    }
    if (data.containsKey('ville')) {
      context.handle(
        _villeMeta,
        ville.isAcceptableOrUnknown(data['ville']!, _villeMeta),
      );
    }
    if (data.containsKey('quartier')) {
      context.handle(
        _quartierMeta,
        quartier.isAcceptableOrUnknown(data['quartier']!, _quartierMeta),
      );
    }
    if (data.containsKey('objectif_participants')) {
      context.handle(
        _objectifParticipantsMeta,
        objectifParticipants.isAcceptableOrUnknown(
          data['objectif_participants']!,
          _objectifParticipantsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_objectifParticipantsMeta);
    }
    if (data.containsKey('organisateur')) {
      context.handle(
        _organisateurMeta,
        organisateur.isAcceptableOrUnknown(
          data['organisateur']!,
          _organisateurMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organisateurMeta);
    }
    if (data.containsKey('presentateur')) {
      context.handle(
        _presentateurMeta,
        presentateur.isAcceptableOrUnknown(
          data['presentateur']!,
          _presentateurMeta,
        ),
      );
    }
    if (data.containsKey('date_prevue')) {
      context.handle(
        _datePrevueMeta,
        datePrevue.isAcceptableOrUnknown(data['date_prevue']!, _datePrevueMeta),
      );
    } else if (isInserting) {
      context.missing(_datePrevueMeta);
    }
    if (data.containsKey('heure_debut')) {
      context.handle(
        _heureDebutMeta,
        heureDebut.isAcceptableOrUnknown(data['heure_debut']!, _heureDebutMeta),
      );
    }
    if (data.containsKey('heure_fin')) {
      context.handle(
        _heureFinMeta,
        heureFin.isAcceptableOrUnknown(data['heure_fin']!, _heureFinMeta),
      );
    }
    if (data.containsKey('est_terminee')) {
      context.handle(
        _estTermineeMeta,
        estTerminee.isAcceptableOrUnknown(
          data['est_terminee']!,
          _estTermineeMeta,
        ),
      );
    }
    if (data.containsKey('gadgets_prevus')) {
      context.handle(
        _gadgetsPrevusMeta,
        gadgetsPrevus.isAcceptableOrUnknown(
          data['gadgets_prevus']!,
          _gadgetsPrevusMeta,
        ),
      );
    }
    if (data.containsKey('gadgets_distribues')) {
      context.handle(
        _gadgetsDistribuesMeta,
        gadgetsDistribues.isAcceptableOrUnknown(
          data['gadgets_distribues']!,
          _gadgetsDistribuesMeta,
        ),
      );
    }
    if (data.containsKey('total_logistique')) {
      context.handle(
        _totalLogistiqueMeta,
        totalLogistique.isAcceptableOrUnknown(
          data['total_logistique']!,
          _totalLogistiqueMeta,
        ),
      );
    }
    if (data.containsKey('nb_participants_estime')) {
      context.handle(
        _nbParticipantsEstimeMeta,
        nbParticipantsEstime.isAcceptableOrUnknown(
          data['nb_participants_estime']!,
          _nbParticipantsEstimeMeta,
        ),
      );
    }
    if (data.containsKey('evaluation')) {
      context.handle(
        _evaluationMeta,
        evaluation.isAcceptableOrUnknown(data['evaluation']!, _evaluationMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SeancesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeancesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      nom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom'],
      )!,
      motifs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motifs'],
      ),
      typeSeance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_seance'],
      ),
      cible: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cible'],
      ),
      zone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zone'],
      ),
      ville: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ville'],
      ),
      quartier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quartier'],
      ),
      objectifParticipants: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}objectif_participants'],
      )!,
      organisateur: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organisateur'],
      )!,
      presentateur: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}presentateur'],
      ),
      assistants: $SeancesTableTable.$converterassistants.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}assistants'],
        ),
      ),
      datePrevue: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_prevue'],
      )!,
      heureDebut: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}heure_debut'],
      ),
      heureFin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}heure_fin'],
      ),
      estTerminee: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}est_terminee'],
      )!,
      gadgetsPrevus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gadgets_prevus'],
      )!,
      gadgetsDistribues: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gadgets_distribues'],
      )!,
      totalLogistique: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_logistique'],
      )!,
      nbParticipantsEstime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nb_participants_estime'],
      ),
      evaluation: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}evaluation'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $SeancesTableTable createAlias(String alias) {
    return $SeancesTableTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>?, String?> $converterassistants =
      const NullableStringListConverter();
}

class SeancesTableData extends DataClass
    implements Insertable<SeancesTableData> {
  final int id;
  final int? serverId;
  final String nom;
  final String? motifs;
  final String? typeSeance;
  final String? cible;
  final String? zone;
  final String? ville;
  final String? quartier;
  final int objectifParticipants;
  final String organisateur;
  final String? presentateur;
  final List<String>? assistants;
  final DateTime datePrevue;
  final String? heureDebut;
  final String? heureFin;
  final bool estTerminee;
  final int gadgetsPrevus;
  final int gadgetsDistribues;
  final double totalLogistique;
  final int? nbParticipantsEstime;
  final bool? evaluation;
  final bool isSynced;
  const SeancesTableData({
    required this.id,
    this.serverId,
    required this.nom,
    this.motifs,
    this.typeSeance,
    this.cible,
    this.zone,
    this.ville,
    this.quartier,
    required this.objectifParticipants,
    required this.organisateur,
    this.presentateur,
    this.assistants,
    required this.datePrevue,
    this.heureDebut,
    this.heureFin,
    required this.estTerminee,
    required this.gadgetsPrevus,
    required this.gadgetsDistribues,
    required this.totalLogistique,
    this.nbParticipantsEstime,
    this.evaluation,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['nom'] = Variable<String>(nom);
    if (!nullToAbsent || motifs != null) {
      map['motifs'] = Variable<String>(motifs);
    }
    if (!nullToAbsent || typeSeance != null) {
      map['type_seance'] = Variable<String>(typeSeance);
    }
    if (!nullToAbsent || cible != null) {
      map['cible'] = Variable<String>(cible);
    }
    if (!nullToAbsent || zone != null) {
      map['zone'] = Variable<String>(zone);
    }
    if (!nullToAbsent || ville != null) {
      map['ville'] = Variable<String>(ville);
    }
    if (!nullToAbsent || quartier != null) {
      map['quartier'] = Variable<String>(quartier);
    }
    map['objectif_participants'] = Variable<int>(objectifParticipants);
    map['organisateur'] = Variable<String>(organisateur);
    if (!nullToAbsent || presentateur != null) {
      map['presentateur'] = Variable<String>(presentateur);
    }
    if (!nullToAbsent || assistants != null) {
      map['assistants'] = Variable<String>(
        $SeancesTableTable.$converterassistants.toSql(assistants),
      );
    }
    map['date_prevue'] = Variable<DateTime>(datePrevue);
    if (!nullToAbsent || heureDebut != null) {
      map['heure_debut'] = Variable<String>(heureDebut);
    }
    if (!nullToAbsent || heureFin != null) {
      map['heure_fin'] = Variable<String>(heureFin);
    }
    map['est_terminee'] = Variable<bool>(estTerminee);
    map['gadgets_prevus'] = Variable<int>(gadgetsPrevus);
    map['gadgets_distribues'] = Variable<int>(gadgetsDistribues);
    map['total_logistique'] = Variable<double>(totalLogistique);
    if (!nullToAbsent || nbParticipantsEstime != null) {
      map['nb_participants_estime'] = Variable<int>(nbParticipantsEstime);
    }
    if (!nullToAbsent || evaluation != null) {
      map['evaluation'] = Variable<bool>(evaluation);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  SeancesTableCompanion toCompanion(bool nullToAbsent) {
    return SeancesTableCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      nom: Value(nom),
      motifs: motifs == null && nullToAbsent
          ? const Value.absent()
          : Value(motifs),
      typeSeance: typeSeance == null && nullToAbsent
          ? const Value.absent()
          : Value(typeSeance),
      cible: cible == null && nullToAbsent
          ? const Value.absent()
          : Value(cible),
      zone: zone == null && nullToAbsent ? const Value.absent() : Value(zone),
      ville: ville == null && nullToAbsent
          ? const Value.absent()
          : Value(ville),
      quartier: quartier == null && nullToAbsent
          ? const Value.absent()
          : Value(quartier),
      objectifParticipants: Value(objectifParticipants),
      organisateur: Value(organisateur),
      presentateur: presentateur == null && nullToAbsent
          ? const Value.absent()
          : Value(presentateur),
      assistants: assistants == null && nullToAbsent
          ? const Value.absent()
          : Value(assistants),
      datePrevue: Value(datePrevue),
      heureDebut: heureDebut == null && nullToAbsent
          ? const Value.absent()
          : Value(heureDebut),
      heureFin: heureFin == null && nullToAbsent
          ? const Value.absent()
          : Value(heureFin),
      estTerminee: Value(estTerminee),
      gadgetsPrevus: Value(gadgetsPrevus),
      gadgetsDistribues: Value(gadgetsDistribues),
      totalLogistique: Value(totalLogistique),
      nbParticipantsEstime: nbParticipantsEstime == null && nullToAbsent
          ? const Value.absent()
          : Value(nbParticipantsEstime),
      evaluation: evaluation == null && nullToAbsent
          ? const Value.absent()
          : Value(evaluation),
      isSynced: Value(isSynced),
    );
  }

  factory SeancesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeancesTableData(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      nom: serializer.fromJson<String>(json['nom']),
      motifs: serializer.fromJson<String?>(json['motifs']),
      typeSeance: serializer.fromJson<String?>(json['typeSeance']),
      cible: serializer.fromJson<String?>(json['cible']),
      zone: serializer.fromJson<String?>(json['zone']),
      ville: serializer.fromJson<String?>(json['ville']),
      quartier: serializer.fromJson<String?>(json['quartier']),
      objectifParticipants: serializer.fromJson<int>(
        json['objectifParticipants'],
      ),
      organisateur: serializer.fromJson<String>(json['organisateur']),
      presentateur: serializer.fromJson<String?>(json['presentateur']),
      assistants: serializer.fromJson<List<String>?>(json['assistants']),
      datePrevue: serializer.fromJson<DateTime>(json['datePrevue']),
      heureDebut: serializer.fromJson<String?>(json['heureDebut']),
      heureFin: serializer.fromJson<String?>(json['heureFin']),
      estTerminee: serializer.fromJson<bool>(json['estTerminee']),
      gadgetsPrevus: serializer.fromJson<int>(json['gadgetsPrevus']),
      gadgetsDistribues: serializer.fromJson<int>(json['gadgetsDistribues']),
      totalLogistique: serializer.fromJson<double>(json['totalLogistique']),
      nbParticipantsEstime: serializer.fromJson<int?>(
        json['nbParticipantsEstime'],
      ),
      evaluation: serializer.fromJson<bool?>(json['evaluation']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int?>(serverId),
      'nom': serializer.toJson<String>(nom),
      'motifs': serializer.toJson<String?>(motifs),
      'typeSeance': serializer.toJson<String?>(typeSeance),
      'cible': serializer.toJson<String?>(cible),
      'zone': serializer.toJson<String?>(zone),
      'ville': serializer.toJson<String?>(ville),
      'quartier': serializer.toJson<String?>(quartier),
      'objectifParticipants': serializer.toJson<int>(objectifParticipants),
      'organisateur': serializer.toJson<String>(organisateur),
      'presentateur': serializer.toJson<String?>(presentateur),
      'assistants': serializer.toJson<List<String>?>(assistants),
      'datePrevue': serializer.toJson<DateTime>(datePrevue),
      'heureDebut': serializer.toJson<String?>(heureDebut),
      'heureFin': serializer.toJson<String?>(heureFin),
      'estTerminee': serializer.toJson<bool>(estTerminee),
      'gadgetsPrevus': serializer.toJson<int>(gadgetsPrevus),
      'gadgetsDistribues': serializer.toJson<int>(gadgetsDistribues),
      'totalLogistique': serializer.toJson<double>(totalLogistique),
      'nbParticipantsEstime': serializer.toJson<int?>(nbParticipantsEstime),
      'evaluation': serializer.toJson<bool?>(evaluation),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  SeancesTableData copyWith({
    int? id,
    Value<int?> serverId = const Value.absent(),
    String? nom,
    Value<String?> motifs = const Value.absent(),
    Value<String?> typeSeance = const Value.absent(),
    Value<String?> cible = const Value.absent(),
    Value<String?> zone = const Value.absent(),
    Value<String?> ville = const Value.absent(),
    Value<String?> quartier = const Value.absent(),
    int? objectifParticipants,
    String? organisateur,
    Value<String?> presentateur = const Value.absent(),
    Value<List<String>?> assistants = const Value.absent(),
    DateTime? datePrevue,
    Value<String?> heureDebut = const Value.absent(),
    Value<String?> heureFin = const Value.absent(),
    bool? estTerminee,
    int? gadgetsPrevus,
    int? gadgetsDistribues,
    double? totalLogistique,
    Value<int?> nbParticipantsEstime = const Value.absent(),
    Value<bool?> evaluation = const Value.absent(),
    bool? isSynced,
  }) => SeancesTableData(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    nom: nom ?? this.nom,
    motifs: motifs.present ? motifs.value : this.motifs,
    typeSeance: typeSeance.present ? typeSeance.value : this.typeSeance,
    cible: cible.present ? cible.value : this.cible,
    zone: zone.present ? zone.value : this.zone,
    ville: ville.present ? ville.value : this.ville,
    quartier: quartier.present ? quartier.value : this.quartier,
    objectifParticipants: objectifParticipants ?? this.objectifParticipants,
    organisateur: organisateur ?? this.organisateur,
    presentateur: presentateur.present ? presentateur.value : this.presentateur,
    assistants: assistants.present ? assistants.value : this.assistants,
    datePrevue: datePrevue ?? this.datePrevue,
    heureDebut: heureDebut.present ? heureDebut.value : this.heureDebut,
    heureFin: heureFin.present ? heureFin.value : this.heureFin,
    estTerminee: estTerminee ?? this.estTerminee,
    gadgetsPrevus: gadgetsPrevus ?? this.gadgetsPrevus,
    gadgetsDistribues: gadgetsDistribues ?? this.gadgetsDistribues,
    totalLogistique: totalLogistique ?? this.totalLogistique,
    nbParticipantsEstime: nbParticipantsEstime.present
        ? nbParticipantsEstime.value
        : this.nbParticipantsEstime,
    evaluation: evaluation.present ? evaluation.value : this.evaluation,
    isSynced: isSynced ?? this.isSynced,
  );
  SeancesTableData copyWithCompanion(SeancesTableCompanion data) {
    return SeancesTableData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      nom: data.nom.present ? data.nom.value : this.nom,
      motifs: data.motifs.present ? data.motifs.value : this.motifs,
      typeSeance: data.typeSeance.present
          ? data.typeSeance.value
          : this.typeSeance,
      cible: data.cible.present ? data.cible.value : this.cible,
      zone: data.zone.present ? data.zone.value : this.zone,
      ville: data.ville.present ? data.ville.value : this.ville,
      quartier: data.quartier.present ? data.quartier.value : this.quartier,
      objectifParticipants: data.objectifParticipants.present
          ? data.objectifParticipants.value
          : this.objectifParticipants,
      organisateur: data.organisateur.present
          ? data.organisateur.value
          : this.organisateur,
      presentateur: data.presentateur.present
          ? data.presentateur.value
          : this.presentateur,
      assistants: data.assistants.present
          ? data.assistants.value
          : this.assistants,
      datePrevue: data.datePrevue.present
          ? data.datePrevue.value
          : this.datePrevue,
      heureDebut: data.heureDebut.present
          ? data.heureDebut.value
          : this.heureDebut,
      heureFin: data.heureFin.present ? data.heureFin.value : this.heureFin,
      estTerminee: data.estTerminee.present
          ? data.estTerminee.value
          : this.estTerminee,
      gadgetsPrevus: data.gadgetsPrevus.present
          ? data.gadgetsPrevus.value
          : this.gadgetsPrevus,
      gadgetsDistribues: data.gadgetsDistribues.present
          ? data.gadgetsDistribues.value
          : this.gadgetsDistribues,
      totalLogistique: data.totalLogistique.present
          ? data.totalLogistique.value
          : this.totalLogistique,
      nbParticipantsEstime: data.nbParticipantsEstime.present
          ? data.nbParticipantsEstime.value
          : this.nbParticipantsEstime,
      evaluation: data.evaluation.present
          ? data.evaluation.value
          : this.evaluation,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeancesTableData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('nom: $nom, ')
          ..write('motifs: $motifs, ')
          ..write('typeSeance: $typeSeance, ')
          ..write('cible: $cible, ')
          ..write('zone: $zone, ')
          ..write('ville: $ville, ')
          ..write('quartier: $quartier, ')
          ..write('objectifParticipants: $objectifParticipants, ')
          ..write('organisateur: $organisateur, ')
          ..write('presentateur: $presentateur, ')
          ..write('assistants: $assistants, ')
          ..write('datePrevue: $datePrevue, ')
          ..write('heureDebut: $heureDebut, ')
          ..write('heureFin: $heureFin, ')
          ..write('estTerminee: $estTerminee, ')
          ..write('gadgetsPrevus: $gadgetsPrevus, ')
          ..write('gadgetsDistribues: $gadgetsDistribues, ')
          ..write('totalLogistique: $totalLogistique, ')
          ..write('nbParticipantsEstime: $nbParticipantsEstime, ')
          ..write('evaluation: $evaluation, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    serverId,
    nom,
    motifs,
    typeSeance,
    cible,
    zone,
    ville,
    quartier,
    objectifParticipants,
    organisateur,
    presentateur,
    assistants,
    datePrevue,
    heureDebut,
    heureFin,
    estTerminee,
    gadgetsPrevus,
    gadgetsDistribues,
    totalLogistique,
    nbParticipantsEstime,
    evaluation,
    isSynced,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeancesTableData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.nom == this.nom &&
          other.motifs == this.motifs &&
          other.typeSeance == this.typeSeance &&
          other.cible == this.cible &&
          other.zone == this.zone &&
          other.ville == this.ville &&
          other.quartier == this.quartier &&
          other.objectifParticipants == this.objectifParticipants &&
          other.organisateur == this.organisateur &&
          other.presentateur == this.presentateur &&
          other.assistants == this.assistants &&
          other.datePrevue == this.datePrevue &&
          other.heureDebut == this.heureDebut &&
          other.heureFin == this.heureFin &&
          other.estTerminee == this.estTerminee &&
          other.gadgetsPrevus == this.gadgetsPrevus &&
          other.gadgetsDistribues == this.gadgetsDistribues &&
          other.totalLogistique == this.totalLogistique &&
          other.nbParticipantsEstime == this.nbParticipantsEstime &&
          other.evaluation == this.evaluation &&
          other.isSynced == this.isSynced);
}

class SeancesTableCompanion extends UpdateCompanion<SeancesTableData> {
  final Value<int> id;
  final Value<int?> serverId;
  final Value<String> nom;
  final Value<String?> motifs;
  final Value<String?> typeSeance;
  final Value<String?> cible;
  final Value<String?> zone;
  final Value<String?> ville;
  final Value<String?> quartier;
  final Value<int> objectifParticipants;
  final Value<String> organisateur;
  final Value<String?> presentateur;
  final Value<List<String>?> assistants;
  final Value<DateTime> datePrevue;
  final Value<String?> heureDebut;
  final Value<String?> heureFin;
  final Value<bool> estTerminee;
  final Value<int> gadgetsPrevus;
  final Value<int> gadgetsDistribues;
  final Value<double> totalLogistique;
  final Value<int?> nbParticipantsEstime;
  final Value<bool?> evaluation;
  final Value<bool> isSynced;
  const SeancesTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.nom = const Value.absent(),
    this.motifs = const Value.absent(),
    this.typeSeance = const Value.absent(),
    this.cible = const Value.absent(),
    this.zone = const Value.absent(),
    this.ville = const Value.absent(),
    this.quartier = const Value.absent(),
    this.objectifParticipants = const Value.absent(),
    this.organisateur = const Value.absent(),
    this.presentateur = const Value.absent(),
    this.assistants = const Value.absent(),
    this.datePrevue = const Value.absent(),
    this.heureDebut = const Value.absent(),
    this.heureFin = const Value.absent(),
    this.estTerminee = const Value.absent(),
    this.gadgetsPrevus = const Value.absent(),
    this.gadgetsDistribues = const Value.absent(),
    this.totalLogistique = const Value.absent(),
    this.nbParticipantsEstime = const Value.absent(),
    this.evaluation = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  SeancesTableCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required String nom,
    this.motifs = const Value.absent(),
    this.typeSeance = const Value.absent(),
    this.cible = const Value.absent(),
    this.zone = const Value.absent(),
    this.ville = const Value.absent(),
    this.quartier = const Value.absent(),
    required int objectifParticipants,
    required String organisateur,
    this.presentateur = const Value.absent(),
    this.assistants = const Value.absent(),
    required DateTime datePrevue,
    this.heureDebut = const Value.absent(),
    this.heureFin = const Value.absent(),
    this.estTerminee = const Value.absent(),
    this.gadgetsPrevus = const Value.absent(),
    this.gadgetsDistribues = const Value.absent(),
    this.totalLogistique = const Value.absent(),
    this.nbParticipantsEstime = const Value.absent(),
    this.evaluation = const Value.absent(),
    this.isSynced = const Value.absent(),
  }) : nom = Value(nom),
       objectifParticipants = Value(objectifParticipants),
       organisateur = Value(organisateur),
       datePrevue = Value(datePrevue);
  static Insertable<SeancesTableData> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<String>? nom,
    Expression<String>? motifs,
    Expression<String>? typeSeance,
    Expression<String>? cible,
    Expression<String>? zone,
    Expression<String>? ville,
    Expression<String>? quartier,
    Expression<int>? objectifParticipants,
    Expression<String>? organisateur,
    Expression<String>? presentateur,
    Expression<String>? assistants,
    Expression<DateTime>? datePrevue,
    Expression<String>? heureDebut,
    Expression<String>? heureFin,
    Expression<bool>? estTerminee,
    Expression<int>? gadgetsPrevus,
    Expression<int>? gadgetsDistribues,
    Expression<double>? totalLogistique,
    Expression<int>? nbParticipantsEstime,
    Expression<bool>? evaluation,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (nom != null) 'nom': nom,
      if (motifs != null) 'motifs': motifs,
      if (typeSeance != null) 'type_seance': typeSeance,
      if (cible != null) 'cible': cible,
      if (zone != null) 'zone': zone,
      if (ville != null) 'ville': ville,
      if (quartier != null) 'quartier': quartier,
      if (objectifParticipants != null)
        'objectif_participants': objectifParticipants,
      if (organisateur != null) 'organisateur': organisateur,
      if (presentateur != null) 'presentateur': presentateur,
      if (assistants != null) 'assistants': assistants,
      if (datePrevue != null) 'date_prevue': datePrevue,
      if (heureDebut != null) 'heure_debut': heureDebut,
      if (heureFin != null) 'heure_fin': heureFin,
      if (estTerminee != null) 'est_terminee': estTerminee,
      if (gadgetsPrevus != null) 'gadgets_prevus': gadgetsPrevus,
      if (gadgetsDistribues != null) 'gadgets_distribues': gadgetsDistribues,
      if (totalLogistique != null) 'total_logistique': totalLogistique,
      if (nbParticipantsEstime != null)
        'nb_participants_estime': nbParticipantsEstime,
      if (evaluation != null) 'evaluation': evaluation,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  SeancesTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? serverId,
    Value<String>? nom,
    Value<String?>? motifs,
    Value<String?>? typeSeance,
    Value<String?>? cible,
    Value<String?>? zone,
    Value<String?>? ville,
    Value<String?>? quartier,
    Value<int>? objectifParticipants,
    Value<String>? organisateur,
    Value<String?>? presentateur,
    Value<List<String>?>? assistants,
    Value<DateTime>? datePrevue,
    Value<String?>? heureDebut,
    Value<String?>? heureFin,
    Value<bool>? estTerminee,
    Value<int>? gadgetsPrevus,
    Value<int>? gadgetsDistribues,
    Value<double>? totalLogistique,
    Value<int?>? nbParticipantsEstime,
    Value<bool?>? evaluation,
    Value<bool>? isSynced,
  }) {
    return SeancesTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      nom: nom ?? this.nom,
      motifs: motifs ?? this.motifs,
      typeSeance: typeSeance ?? this.typeSeance,
      cible: cible ?? this.cible,
      zone: zone ?? this.zone,
      ville: ville ?? this.ville,
      quartier: quartier ?? this.quartier,
      objectifParticipants: objectifParticipants ?? this.objectifParticipants,
      organisateur: organisateur ?? this.organisateur,
      presentateur: presentateur ?? this.presentateur,
      assistants: assistants ?? this.assistants,
      datePrevue: datePrevue ?? this.datePrevue,
      heureDebut: heureDebut ?? this.heureDebut,
      heureFin: heureFin ?? this.heureFin,
      estTerminee: estTerminee ?? this.estTerminee,
      gadgetsPrevus: gadgetsPrevus ?? this.gadgetsPrevus,
      gadgetsDistribues: gadgetsDistribues ?? this.gadgetsDistribues,
      totalLogistique: totalLogistique ?? this.totalLogistique,
      nbParticipantsEstime: nbParticipantsEstime ?? this.nbParticipantsEstime,
      evaluation: evaluation ?? this.evaluation,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (motifs.present) {
      map['motifs'] = Variable<String>(motifs.value);
    }
    if (typeSeance.present) {
      map['type_seance'] = Variable<String>(typeSeance.value);
    }
    if (cible.present) {
      map['cible'] = Variable<String>(cible.value);
    }
    if (zone.present) {
      map['zone'] = Variable<String>(zone.value);
    }
    if (ville.present) {
      map['ville'] = Variable<String>(ville.value);
    }
    if (quartier.present) {
      map['quartier'] = Variable<String>(quartier.value);
    }
    if (objectifParticipants.present) {
      map['objectif_participants'] = Variable<int>(objectifParticipants.value);
    }
    if (organisateur.present) {
      map['organisateur'] = Variable<String>(organisateur.value);
    }
    if (presentateur.present) {
      map['presentateur'] = Variable<String>(presentateur.value);
    }
    if (assistants.present) {
      map['assistants'] = Variable<String>(
        $SeancesTableTable.$converterassistants.toSql(assistants.value),
      );
    }
    if (datePrevue.present) {
      map['date_prevue'] = Variable<DateTime>(datePrevue.value);
    }
    if (heureDebut.present) {
      map['heure_debut'] = Variable<String>(heureDebut.value);
    }
    if (heureFin.present) {
      map['heure_fin'] = Variable<String>(heureFin.value);
    }
    if (estTerminee.present) {
      map['est_terminee'] = Variable<bool>(estTerminee.value);
    }
    if (gadgetsPrevus.present) {
      map['gadgets_prevus'] = Variable<int>(gadgetsPrevus.value);
    }
    if (gadgetsDistribues.present) {
      map['gadgets_distribues'] = Variable<int>(gadgetsDistribues.value);
    }
    if (totalLogistique.present) {
      map['total_logistique'] = Variable<double>(totalLogistique.value);
    }
    if (nbParticipantsEstime.present) {
      map['nb_participants_estime'] = Variable<int>(nbParticipantsEstime.value);
    }
    if (evaluation.present) {
      map['evaluation'] = Variable<bool>(evaluation.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeancesTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('nom: $nom, ')
          ..write('motifs: $motifs, ')
          ..write('typeSeance: $typeSeance, ')
          ..write('cible: $cible, ')
          ..write('zone: $zone, ')
          ..write('ville: $ville, ')
          ..write('quartier: $quartier, ')
          ..write('objectifParticipants: $objectifParticipants, ')
          ..write('organisateur: $organisateur, ')
          ..write('presentateur: $presentateur, ')
          ..write('assistants: $assistants, ')
          ..write('datePrevue: $datePrevue, ')
          ..write('heureDebut: $heureDebut, ')
          ..write('heureFin: $heureFin, ')
          ..write('estTerminee: $estTerminee, ')
          ..write('gadgetsPrevus: $gadgetsPrevus, ')
          ..write('gadgetsDistribues: $gadgetsDistribues, ')
          ..write('totalLogistique: $totalLogistique, ')
          ..write('nbParticipantsEstime: $nbParticipantsEstime, ')
          ..write('evaluation: $evaluation, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $SeanceImagesTableTable extends SeanceImagesTable
    with TableInfo<$SeanceImagesTableTable, SeanceImagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeanceImagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seanceIdMeta = const VerificationMeta(
    'seanceId',
  );
  @override
  late final GeneratedColumn<int> seanceId = GeneratedColumn<int>(
    'seance_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> urls =
      GeneratedColumn<String>(
        'urls',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($SeanceImagesTableTable.$converterurls);
  static const VerificationMeta _legendeMeta = const VerificationMeta(
    'legende',
  );
  @override
  late final GeneratedColumn<String> legende = GeneratedColumn<String>(
    'legende',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    seanceId,
    urls,
    legende,
    date,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'seance_images_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SeanceImagesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('seance_id')) {
      context.handle(
        _seanceIdMeta,
        seanceId.isAcceptableOrUnknown(data['seance_id']!, _seanceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seanceIdMeta);
    }
    if (data.containsKey('legende')) {
      context.handle(
        _legendeMeta,
        legende.isAcceptableOrUnknown(data['legende']!, _legendeMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SeanceImagesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeanceImagesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      seanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seance_id'],
      )!,
      urls: $SeanceImagesTableTable.$converterurls.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}urls'],
        )!,
      ),
      legende: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}legende'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $SeanceImagesTableTable createAlias(String alias) {
    return $SeanceImagesTableTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterurls =
      const StringListConverter();
}

class SeanceImagesTableData extends DataClass
    implements Insertable<SeanceImagesTableData> {
  final int id;
  final int? serverId;
  final int seanceId;
  final List<String> urls;
  final String? legende;
  final DateTime date;
  final bool isSynced;
  const SeanceImagesTableData({
    required this.id,
    this.serverId,
    required this.seanceId,
    required this.urls,
    this.legende,
    required this.date,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['seance_id'] = Variable<int>(seanceId);
    {
      map['urls'] = Variable<String>(
        $SeanceImagesTableTable.$converterurls.toSql(urls),
      );
    }
    if (!nullToAbsent || legende != null) {
      map['legende'] = Variable<String>(legende);
    }
    map['date'] = Variable<DateTime>(date);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  SeanceImagesTableCompanion toCompanion(bool nullToAbsent) {
    return SeanceImagesTableCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      seanceId: Value(seanceId),
      urls: Value(urls),
      legende: legende == null && nullToAbsent
          ? const Value.absent()
          : Value(legende),
      date: Value(date),
      isSynced: Value(isSynced),
    );
  }

  factory SeanceImagesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeanceImagesTableData(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      seanceId: serializer.fromJson<int>(json['seanceId']),
      urls: serializer.fromJson<List<String>>(json['urls']),
      legende: serializer.fromJson<String?>(json['legende']),
      date: serializer.fromJson<DateTime>(json['date']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int?>(serverId),
      'seanceId': serializer.toJson<int>(seanceId),
      'urls': serializer.toJson<List<String>>(urls),
      'legende': serializer.toJson<String?>(legende),
      'date': serializer.toJson<DateTime>(date),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  SeanceImagesTableData copyWith({
    int? id,
    Value<int?> serverId = const Value.absent(),
    int? seanceId,
    List<String>? urls,
    Value<String?> legende = const Value.absent(),
    DateTime? date,
    bool? isSynced,
  }) => SeanceImagesTableData(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    seanceId: seanceId ?? this.seanceId,
    urls: urls ?? this.urls,
    legende: legende.present ? legende.value : this.legende,
    date: date ?? this.date,
    isSynced: isSynced ?? this.isSynced,
  );
  SeanceImagesTableData copyWithCompanion(SeanceImagesTableCompanion data) {
    return SeanceImagesTableData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      seanceId: data.seanceId.present ? data.seanceId.value : this.seanceId,
      urls: data.urls.present ? data.urls.value : this.urls,
      legende: data.legende.present ? data.legende.value : this.legende,
      date: data.date.present ? data.date.value : this.date,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeanceImagesTableData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('seanceId: $seanceId, ')
          ..write('urls: $urls, ')
          ..write('legende: $legende, ')
          ..write('date: $date, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, serverId, seanceId, urls, legende, date, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeanceImagesTableData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.seanceId == this.seanceId &&
          other.urls == this.urls &&
          other.legende == this.legende &&
          other.date == this.date &&
          other.isSynced == this.isSynced);
}

class SeanceImagesTableCompanion
    extends UpdateCompanion<SeanceImagesTableData> {
  final Value<int> id;
  final Value<int?> serverId;
  final Value<int> seanceId;
  final Value<List<String>> urls;
  final Value<String?> legende;
  final Value<DateTime> date;
  final Value<bool> isSynced;
  const SeanceImagesTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.seanceId = const Value.absent(),
    this.urls = const Value.absent(),
    this.legende = const Value.absent(),
    this.date = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  SeanceImagesTableCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required int seanceId,
    required List<String> urls,
    this.legende = const Value.absent(),
    required DateTime date,
    this.isSynced = const Value.absent(),
  }) : seanceId = Value(seanceId),
       urls = Value(urls),
       date = Value(date);
  static Insertable<SeanceImagesTableData> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<int>? seanceId,
    Expression<String>? urls,
    Expression<String>? legende,
    Expression<DateTime>? date,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (seanceId != null) 'seance_id': seanceId,
      if (urls != null) 'urls': urls,
      if (legende != null) 'legende': legende,
      if (date != null) 'date': date,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  SeanceImagesTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? serverId,
    Value<int>? seanceId,
    Value<List<String>>? urls,
    Value<String?>? legende,
    Value<DateTime>? date,
    Value<bool>? isSynced,
  }) {
    return SeanceImagesTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      seanceId: seanceId ?? this.seanceId,
      urls: urls ?? this.urls,
      legende: legende ?? this.legende,
      date: date ?? this.date,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (seanceId.present) {
      map['seance_id'] = Variable<int>(seanceId.value);
    }
    if (urls.present) {
      map['urls'] = Variable<String>(
        $SeanceImagesTableTable.$converterurls.toSql(urls.value),
      );
    }
    if (legende.present) {
      map['legende'] = Variable<String>(legende.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeanceImagesTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('seanceId: $seanceId, ')
          ..write('urls: $urls, ')
          ..write('legende: $legende, ')
          ..write('date: $date, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ParticipantsTableTable participantsTable =
      $ParticipantsTableTable(this);
  late final $SyncHistoryTableTable syncHistoryTable = $SyncHistoryTableTable(
    this,
  );
  late final $PriseContactsTableTable priseContactsTable =
      $PriseContactsTableTable(this);
  late final $RdvsTableTable rdvsTable = $RdvsTableTable(this);
  late final $SeancesTableTable seancesTable = $SeancesTableTable(this);
  late final $SeanceImagesTableTable seanceImagesTable =
      $SeanceImagesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    participantsTable,
    syncHistoryTable,
    priseContactsTable,
    rdvsTable,
    seancesTable,
    seanceImagesTable,
  ];
}

typedef $$ParticipantsTableTableCreateCompanionBuilder =
    ParticipantsTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      required int seanceId,
      required String nom,
      required String prenom,
      required String telephone,
      Value<String?> profession,
      required String statutLogement,
      Value<String?> lieu,
      required String localite,
      Value<String?> quartier,
      required List<String> besoinsExprimes,
      Value<String?> ressenti,
      required bool consentement,
      required String statut,
      required DateTime dateInscription,
      Value<bool> isSynced,
    });
typedef $$ParticipantsTableTableUpdateCompanionBuilder =
    ParticipantsTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      Value<int> seanceId,
      Value<String> nom,
      Value<String> prenom,
      Value<String> telephone,
      Value<String?> profession,
      Value<String> statutLogement,
      Value<String?> lieu,
      Value<String> localite,
      Value<String?> quartier,
      Value<List<String>> besoinsExprimes,
      Value<String?> ressenti,
      Value<bool> consentement,
      Value<String> statut,
      Value<DateTime> dateInscription,
      Value<bool> isSynced,
    });

class $$ParticipantsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ParticipantsTableTable> {
  $$ParticipantsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seanceId => $composableBuilder(
    column: $table.seanceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prenom => $composableBuilder(
    column: $table.prenom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profession => $composableBuilder(
    column: $table.profession,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statutLogement => $composableBuilder(
    column: $table.statutLogement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lieu => $composableBuilder(
    column: $table.lieu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localite => $composableBuilder(
    column: $table.localite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quartier => $composableBuilder(
    column: $table.quartier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get besoinsExprimes => $composableBuilder(
    column: $table.besoinsExprimes,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get ressenti => $composableBuilder(
    column: $table.ressenti,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get consentement => $composableBuilder(
    column: $table.consentement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statut => $composableBuilder(
    column: $table.statut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateInscription => $composableBuilder(
    column: $table.dateInscription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParticipantsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ParticipantsTableTable> {
  $$ParticipantsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seanceId => $composableBuilder(
    column: $table.seanceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prenom => $composableBuilder(
    column: $table.prenom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profession => $composableBuilder(
    column: $table.profession,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statutLogement => $composableBuilder(
    column: $table.statutLogement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lieu => $composableBuilder(
    column: $table.lieu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localite => $composableBuilder(
    column: $table.localite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quartier => $composableBuilder(
    column: $table.quartier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get besoinsExprimes => $composableBuilder(
    column: $table.besoinsExprimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ressenti => $composableBuilder(
    column: $table.ressenti,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get consentement => $composableBuilder(
    column: $table.consentement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statut => $composableBuilder(
    column: $table.statut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateInscription => $composableBuilder(
    column: $table.dateInscription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParticipantsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParticipantsTableTable> {
  $$ParticipantsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<int> get seanceId =>
      $composableBuilder(column: $table.seanceId, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get prenom =>
      $composableBuilder(column: $table.prenom, builder: (column) => column);

  GeneratedColumn<String> get telephone =>
      $composableBuilder(column: $table.telephone, builder: (column) => column);

  GeneratedColumn<String> get profession => $composableBuilder(
    column: $table.profession,
    builder: (column) => column,
  );

  GeneratedColumn<String> get statutLogement => $composableBuilder(
    column: $table.statutLogement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lieu =>
      $composableBuilder(column: $table.lieu, builder: (column) => column);

  GeneratedColumn<String> get localite =>
      $composableBuilder(column: $table.localite, builder: (column) => column);

  GeneratedColumn<String> get quartier =>
      $composableBuilder(column: $table.quartier, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get besoinsExprimes =>
      $composableBuilder(
        column: $table.besoinsExprimes,
        builder: (column) => column,
      );

  GeneratedColumn<String> get ressenti =>
      $composableBuilder(column: $table.ressenti, builder: (column) => column);

  GeneratedColumn<bool> get consentement => $composableBuilder(
    column: $table.consentement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<DateTime> get dateInscription => $composableBuilder(
    column: $table.dateInscription,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$ParticipantsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParticipantsTableTable,
          ParticipantsTableData,
          $$ParticipantsTableTableFilterComposer,
          $$ParticipantsTableTableOrderingComposer,
          $$ParticipantsTableTableAnnotationComposer,
          $$ParticipantsTableTableCreateCompanionBuilder,
          $$ParticipantsTableTableUpdateCompanionBuilder,
          (
            ParticipantsTableData,
            BaseReferences<
              _$AppDatabase,
              $ParticipantsTableTable,
              ParticipantsTableData
            >,
          ),
          ParticipantsTableData,
          PrefetchHooks Function()
        > {
  $$ParticipantsTableTableTableManager(
    _$AppDatabase db,
    $ParticipantsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParticipantsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParticipantsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParticipantsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<int> seanceId = const Value.absent(),
                Value<String> nom = const Value.absent(),
                Value<String> prenom = const Value.absent(),
                Value<String> telephone = const Value.absent(),
                Value<String?> profession = const Value.absent(),
                Value<String> statutLogement = const Value.absent(),
                Value<String?> lieu = const Value.absent(),
                Value<String> localite = const Value.absent(),
                Value<String?> quartier = const Value.absent(),
                Value<List<String>> besoinsExprimes = const Value.absent(),
                Value<String?> ressenti = const Value.absent(),
                Value<bool> consentement = const Value.absent(),
                Value<String> statut = const Value.absent(),
                Value<DateTime> dateInscription = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => ParticipantsTableCompanion(
                id: id,
                serverId: serverId,
                seanceId: seanceId,
                nom: nom,
                prenom: prenom,
                telephone: telephone,
                profession: profession,
                statutLogement: statutLogement,
                lieu: lieu,
                localite: localite,
                quartier: quartier,
                besoinsExprimes: besoinsExprimes,
                ressenti: ressenti,
                consentement: consentement,
                statut: statut,
                dateInscription: dateInscription,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required int seanceId,
                required String nom,
                required String prenom,
                required String telephone,
                Value<String?> profession = const Value.absent(),
                required String statutLogement,
                Value<String?> lieu = const Value.absent(),
                required String localite,
                Value<String?> quartier = const Value.absent(),
                required List<String> besoinsExprimes,
                Value<String?> ressenti = const Value.absent(),
                required bool consentement,
                required String statut,
                required DateTime dateInscription,
                Value<bool> isSynced = const Value.absent(),
              }) => ParticipantsTableCompanion.insert(
                id: id,
                serverId: serverId,
                seanceId: seanceId,
                nom: nom,
                prenom: prenom,
                telephone: telephone,
                profession: profession,
                statutLogement: statutLogement,
                lieu: lieu,
                localite: localite,
                quartier: quartier,
                besoinsExprimes: besoinsExprimes,
                ressenti: ressenti,
                consentement: consentement,
                statut: statut,
                dateInscription: dateInscription,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ParticipantsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParticipantsTableTable,
      ParticipantsTableData,
      $$ParticipantsTableTableFilterComposer,
      $$ParticipantsTableTableOrderingComposer,
      $$ParticipantsTableTableAnnotationComposer,
      $$ParticipantsTableTableCreateCompanionBuilder,
      $$ParticipantsTableTableUpdateCompanionBuilder,
      (
        ParticipantsTableData,
        BaseReferences<
          _$AppDatabase,
          $ParticipantsTableTable,
          ParticipantsTableData
        >,
      ),
      ParticipantsTableData,
      PrefetchHooks Function()
    >;
typedef $$SyncHistoryTableTableCreateCompanionBuilder =
    SyncHistoryTableCompanion Function({
      Value<int> id,
      required String title,
      required String time,
      required String status,
      required String type,
    });
typedef $$SyncHistoryTableTableUpdateCompanionBuilder =
    SyncHistoryTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> time,
      Value<String> status,
      Value<String> type,
    });

class $$SyncHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncHistoryTableTable> {
  $$SyncHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncHistoryTableTable> {
  $$SyncHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncHistoryTableTable> {
  $$SyncHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$SyncHistoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncHistoryTableTable,
          SyncHistoryTableData,
          $$SyncHistoryTableTableFilterComposer,
          $$SyncHistoryTableTableOrderingComposer,
          $$SyncHistoryTableTableAnnotationComposer,
          $$SyncHistoryTableTableCreateCompanionBuilder,
          $$SyncHistoryTableTableUpdateCompanionBuilder,
          (
            SyncHistoryTableData,
            BaseReferences<
              _$AppDatabase,
              $SyncHistoryTableTable,
              SyncHistoryTableData
            >,
          ),
          SyncHistoryTableData,
          PrefetchHooks Function()
        > {
  $$SyncHistoryTableTableTableManager(
    _$AppDatabase db,
    $SyncHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncHistoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncHistoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncHistoryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> time = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> type = const Value.absent(),
              }) => SyncHistoryTableCompanion(
                id: id,
                title: title,
                time: time,
                status: status,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String time,
                required String status,
                required String type,
              }) => SyncHistoryTableCompanion.insert(
                id: id,
                title: title,
                time: time,
                status: status,
                type: type,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncHistoryTableTable,
      SyncHistoryTableData,
      $$SyncHistoryTableTableFilterComposer,
      $$SyncHistoryTableTableOrderingComposer,
      $$SyncHistoryTableTableAnnotationComposer,
      $$SyncHistoryTableTableCreateCompanionBuilder,
      $$SyncHistoryTableTableUpdateCompanionBuilder,
      (
        SyncHistoryTableData,
        BaseReferences<
          _$AppDatabase,
          $SyncHistoryTableTable,
          SyncHistoryTableData
        >,
      ),
      SyncHistoryTableData,
      PrefetchHooks Function()
    >;
typedef $$PriseContactsTableTableCreateCompanionBuilder =
    PriseContactsTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      required int seanceId,
      required String nomContact,
      required String telephone,
      required DateTime date,
      required String objetMission,
      required String directionRegionale,
      Value<String?> agence,
      Value<String?> quartier,
      Value<String?> site,
      required List<String> pointsAbordes,
      Value<String?> observations,
      Value<String?> signatureBase64,
      Value<bool> isSynced,
    });
typedef $$PriseContactsTableTableUpdateCompanionBuilder =
    PriseContactsTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      Value<int> seanceId,
      Value<String> nomContact,
      Value<String> telephone,
      Value<DateTime> date,
      Value<String> objetMission,
      Value<String> directionRegionale,
      Value<String?> agence,
      Value<String?> quartier,
      Value<String?> site,
      Value<List<String>> pointsAbordes,
      Value<String?> observations,
      Value<String?> signatureBase64,
      Value<bool> isSynced,
    });

class $$PriseContactsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PriseContactsTableTable> {
  $$PriseContactsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seanceId => $composableBuilder(
    column: $table.seanceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomContact => $composableBuilder(
    column: $table.nomContact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get objetMission => $composableBuilder(
    column: $table.objetMission,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get directionRegionale => $composableBuilder(
    column: $table.directionRegionale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get agence => $composableBuilder(
    column: $table.agence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quartier => $composableBuilder(
    column: $table.quartier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get site => $composableBuilder(
    column: $table.site,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get pointsAbordes => $composableBuilder(
    column: $table.pointsAbordes,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signatureBase64 => $composableBuilder(
    column: $table.signatureBase64,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PriseContactsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PriseContactsTableTable> {
  $$PriseContactsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seanceId => $composableBuilder(
    column: $table.seanceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomContact => $composableBuilder(
    column: $table.nomContact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get objetMission => $composableBuilder(
    column: $table.objetMission,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get directionRegionale => $composableBuilder(
    column: $table.directionRegionale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get agence => $composableBuilder(
    column: $table.agence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quartier => $composableBuilder(
    column: $table.quartier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get site => $composableBuilder(
    column: $table.site,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pointsAbordes => $composableBuilder(
    column: $table.pointsAbordes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signatureBase64 => $composableBuilder(
    column: $table.signatureBase64,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PriseContactsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PriseContactsTableTable> {
  $$PriseContactsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<int> get seanceId =>
      $composableBuilder(column: $table.seanceId, builder: (column) => column);

  GeneratedColumn<String> get nomContact => $composableBuilder(
    column: $table.nomContact,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telephone =>
      $composableBuilder(column: $table.telephone, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get objetMission => $composableBuilder(
    column: $table.objetMission,
    builder: (column) => column,
  );

  GeneratedColumn<String> get directionRegionale => $composableBuilder(
    column: $table.directionRegionale,
    builder: (column) => column,
  );

  GeneratedColumn<String> get agence =>
      $composableBuilder(column: $table.agence, builder: (column) => column);

  GeneratedColumn<String> get quartier =>
      $composableBuilder(column: $table.quartier, builder: (column) => column);

  GeneratedColumn<String> get site =>
      $composableBuilder(column: $table.site, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get pointsAbordes =>
      $composableBuilder(
        column: $table.pointsAbordes,
        builder: (column) => column,
      );

  GeneratedColumn<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signatureBase64 => $composableBuilder(
    column: $table.signatureBase64,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$PriseContactsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PriseContactsTableTable,
          PriseContactsTableData,
          $$PriseContactsTableTableFilterComposer,
          $$PriseContactsTableTableOrderingComposer,
          $$PriseContactsTableTableAnnotationComposer,
          $$PriseContactsTableTableCreateCompanionBuilder,
          $$PriseContactsTableTableUpdateCompanionBuilder,
          (
            PriseContactsTableData,
            BaseReferences<
              _$AppDatabase,
              $PriseContactsTableTable,
              PriseContactsTableData
            >,
          ),
          PriseContactsTableData,
          PrefetchHooks Function()
        > {
  $$PriseContactsTableTableTableManager(
    _$AppDatabase db,
    $PriseContactsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PriseContactsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PriseContactsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PriseContactsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<int> seanceId = const Value.absent(),
                Value<String> nomContact = const Value.absent(),
                Value<String> telephone = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> objetMission = const Value.absent(),
                Value<String> directionRegionale = const Value.absent(),
                Value<String?> agence = const Value.absent(),
                Value<String?> quartier = const Value.absent(),
                Value<String?> site = const Value.absent(),
                Value<List<String>> pointsAbordes = const Value.absent(),
                Value<String?> observations = const Value.absent(),
                Value<String?> signatureBase64 = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => PriseContactsTableCompanion(
                id: id,
                serverId: serverId,
                seanceId: seanceId,
                nomContact: nomContact,
                telephone: telephone,
                date: date,
                objetMission: objetMission,
                directionRegionale: directionRegionale,
                agence: agence,
                quartier: quartier,
                site: site,
                pointsAbordes: pointsAbordes,
                observations: observations,
                signatureBase64: signatureBase64,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required int seanceId,
                required String nomContact,
                required String telephone,
                required DateTime date,
                required String objetMission,
                required String directionRegionale,
                Value<String?> agence = const Value.absent(),
                Value<String?> quartier = const Value.absent(),
                Value<String?> site = const Value.absent(),
                required List<String> pointsAbordes,
                Value<String?> observations = const Value.absent(),
                Value<String?> signatureBase64 = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => PriseContactsTableCompanion.insert(
                id: id,
                serverId: serverId,
                seanceId: seanceId,
                nomContact: nomContact,
                telephone: telephone,
                date: date,
                objetMission: objetMission,
                directionRegionale: directionRegionale,
                agence: agence,
                quartier: quartier,
                site: site,
                pointsAbordes: pointsAbordes,
                observations: observations,
                signatureBase64: signatureBase64,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PriseContactsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PriseContactsTableTable,
      PriseContactsTableData,
      $$PriseContactsTableTableFilterComposer,
      $$PriseContactsTableTableOrderingComposer,
      $$PriseContactsTableTableAnnotationComposer,
      $$PriseContactsTableTableCreateCompanionBuilder,
      $$PriseContactsTableTableUpdateCompanionBuilder,
      (
        PriseContactsTableData,
        BaseReferences<
          _$AppDatabase,
          $PriseContactsTableTable,
          PriseContactsTableData
        >,
      ),
      PriseContactsTableData,
      PrefetchHooks Function()
    >;
typedef $$RdvsTableTableCreateCompanionBuilder =
    RdvsTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      required int seanceId,
      required String titre,
      required String contact,
      required DateTime dateRdv,
      required String heure,
      required String lieu,
      required String statut,
      Value<bool> isSynced,
    });
typedef $$RdvsTableTableUpdateCompanionBuilder =
    RdvsTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      Value<int> seanceId,
      Value<String> titre,
      Value<String> contact,
      Value<DateTime> dateRdv,
      Value<String> heure,
      Value<String> lieu,
      Value<String> statut,
      Value<bool> isSynced,
    });

class $$RdvsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RdvsTableTable> {
  $$RdvsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seanceId => $composableBuilder(
    column: $table.seanceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titre => $composableBuilder(
    column: $table.titre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateRdv => $composableBuilder(
    column: $table.dateRdv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get heure => $composableBuilder(
    column: $table.heure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lieu => $composableBuilder(
    column: $table.lieu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statut => $composableBuilder(
    column: $table.statut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RdvsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RdvsTableTable> {
  $$RdvsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seanceId => $composableBuilder(
    column: $table.seanceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titre => $composableBuilder(
    column: $table.titre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateRdv => $composableBuilder(
    column: $table.dateRdv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get heure => $composableBuilder(
    column: $table.heure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lieu => $composableBuilder(
    column: $table.lieu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statut => $composableBuilder(
    column: $table.statut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RdvsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RdvsTableTable> {
  $$RdvsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<int> get seanceId =>
      $composableBuilder(column: $table.seanceId, builder: (column) => column);

  GeneratedColumn<String> get titre =>
      $composableBuilder(column: $table.titre, builder: (column) => column);

  GeneratedColumn<String> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);

  GeneratedColumn<DateTime> get dateRdv =>
      $composableBuilder(column: $table.dateRdv, builder: (column) => column);

  GeneratedColumn<String> get heure =>
      $composableBuilder(column: $table.heure, builder: (column) => column);

  GeneratedColumn<String> get lieu =>
      $composableBuilder(column: $table.lieu, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$RdvsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RdvsTableTable,
          RdvsTableData,
          $$RdvsTableTableFilterComposer,
          $$RdvsTableTableOrderingComposer,
          $$RdvsTableTableAnnotationComposer,
          $$RdvsTableTableCreateCompanionBuilder,
          $$RdvsTableTableUpdateCompanionBuilder,
          (
            RdvsTableData,
            BaseReferences<_$AppDatabase, $RdvsTableTable, RdvsTableData>,
          ),
          RdvsTableData,
          PrefetchHooks Function()
        > {
  $$RdvsTableTableTableManager(_$AppDatabase db, $RdvsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RdvsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RdvsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RdvsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<int> seanceId = const Value.absent(),
                Value<String> titre = const Value.absent(),
                Value<String> contact = const Value.absent(),
                Value<DateTime> dateRdv = const Value.absent(),
                Value<String> heure = const Value.absent(),
                Value<String> lieu = const Value.absent(),
                Value<String> statut = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => RdvsTableCompanion(
                id: id,
                serverId: serverId,
                seanceId: seanceId,
                titre: titre,
                contact: contact,
                dateRdv: dateRdv,
                heure: heure,
                lieu: lieu,
                statut: statut,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required int seanceId,
                required String titre,
                required String contact,
                required DateTime dateRdv,
                required String heure,
                required String lieu,
                required String statut,
                Value<bool> isSynced = const Value.absent(),
              }) => RdvsTableCompanion.insert(
                id: id,
                serverId: serverId,
                seanceId: seanceId,
                titre: titre,
                contact: contact,
                dateRdv: dateRdv,
                heure: heure,
                lieu: lieu,
                statut: statut,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RdvsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RdvsTableTable,
      RdvsTableData,
      $$RdvsTableTableFilterComposer,
      $$RdvsTableTableOrderingComposer,
      $$RdvsTableTableAnnotationComposer,
      $$RdvsTableTableCreateCompanionBuilder,
      $$RdvsTableTableUpdateCompanionBuilder,
      (
        RdvsTableData,
        BaseReferences<_$AppDatabase, $RdvsTableTable, RdvsTableData>,
      ),
      RdvsTableData,
      PrefetchHooks Function()
    >;
typedef $$SeancesTableTableCreateCompanionBuilder =
    SeancesTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      required String nom,
      Value<String?> motifs,
      Value<String?> typeSeance,
      Value<String?> cible,
      Value<String?> zone,
      Value<String?> ville,
      Value<String?> quartier,
      required int objectifParticipants,
      required String organisateur,
      Value<String?> presentateur,
      Value<List<String>?> assistants,
      required DateTime datePrevue,
      Value<String?> heureDebut,
      Value<String?> heureFin,
      Value<bool> estTerminee,
      Value<int> gadgetsPrevus,
      Value<int> gadgetsDistribues,
      Value<double> totalLogistique,
      Value<int?> nbParticipantsEstime,
      Value<bool?> evaluation,
      Value<bool> isSynced,
    });
typedef $$SeancesTableTableUpdateCompanionBuilder =
    SeancesTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      Value<String> nom,
      Value<String?> motifs,
      Value<String?> typeSeance,
      Value<String?> cible,
      Value<String?> zone,
      Value<String?> ville,
      Value<String?> quartier,
      Value<int> objectifParticipants,
      Value<String> organisateur,
      Value<String?> presentateur,
      Value<List<String>?> assistants,
      Value<DateTime> datePrevue,
      Value<String?> heureDebut,
      Value<String?> heureFin,
      Value<bool> estTerminee,
      Value<int> gadgetsPrevus,
      Value<int> gadgetsDistribues,
      Value<double> totalLogistique,
      Value<int?> nbParticipantsEstime,
      Value<bool?> evaluation,
      Value<bool> isSynced,
    });

class $$SeancesTableTableFilterComposer
    extends Composer<_$AppDatabase, $SeancesTableTable> {
  $$SeancesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motifs => $composableBuilder(
    column: $table.motifs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeSeance => $composableBuilder(
    column: $table.typeSeance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cible => $composableBuilder(
    column: $table.cible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ville => $composableBuilder(
    column: $table.ville,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quartier => $composableBuilder(
    column: $table.quartier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get objectifParticipants => $composableBuilder(
    column: $table.objectifParticipants,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organisateur => $composableBuilder(
    column: $table.organisateur,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get presentateur => $composableBuilder(
    column: $table.presentateur,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
  get assistants => $composableBuilder(
    column: $table.assistants,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get datePrevue => $composableBuilder(
    column: $table.datePrevue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get heureDebut => $composableBuilder(
    column: $table.heureDebut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get heureFin => $composableBuilder(
    column: $table.heureFin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get estTerminee => $composableBuilder(
    column: $table.estTerminee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gadgetsPrevus => $composableBuilder(
    column: $table.gadgetsPrevus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gadgetsDistribues => $composableBuilder(
    column: $table.gadgetsDistribues,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalLogistique => $composableBuilder(
    column: $table.totalLogistique,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nbParticipantsEstime => $composableBuilder(
    column: $table.nbParticipantsEstime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get evaluation => $composableBuilder(
    column: $table.evaluation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SeancesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SeancesTableTable> {
  $$SeancesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motifs => $composableBuilder(
    column: $table.motifs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeSeance => $composableBuilder(
    column: $table.typeSeance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cible => $composableBuilder(
    column: $table.cible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ville => $composableBuilder(
    column: $table.ville,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quartier => $composableBuilder(
    column: $table.quartier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get objectifParticipants => $composableBuilder(
    column: $table.objectifParticipants,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organisateur => $composableBuilder(
    column: $table.organisateur,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get presentateur => $composableBuilder(
    column: $table.presentateur,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assistants => $composableBuilder(
    column: $table.assistants,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get datePrevue => $composableBuilder(
    column: $table.datePrevue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get heureDebut => $composableBuilder(
    column: $table.heureDebut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get heureFin => $composableBuilder(
    column: $table.heureFin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get estTerminee => $composableBuilder(
    column: $table.estTerminee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gadgetsPrevus => $composableBuilder(
    column: $table.gadgetsPrevus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gadgetsDistribues => $composableBuilder(
    column: $table.gadgetsDistribues,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalLogistique => $composableBuilder(
    column: $table.totalLogistique,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nbParticipantsEstime => $composableBuilder(
    column: $table.nbParticipantsEstime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get evaluation => $composableBuilder(
    column: $table.evaluation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SeancesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeancesTableTable> {
  $$SeancesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get motifs =>
      $composableBuilder(column: $table.motifs, builder: (column) => column);

  GeneratedColumn<String> get typeSeance => $composableBuilder(
    column: $table.typeSeance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cible =>
      $composableBuilder(column: $table.cible, builder: (column) => column);

  GeneratedColumn<String> get zone =>
      $composableBuilder(column: $table.zone, builder: (column) => column);

  GeneratedColumn<String> get ville =>
      $composableBuilder(column: $table.ville, builder: (column) => column);

  GeneratedColumn<String> get quartier =>
      $composableBuilder(column: $table.quartier, builder: (column) => column);

  GeneratedColumn<int> get objectifParticipants => $composableBuilder(
    column: $table.objectifParticipants,
    builder: (column) => column,
  );

  GeneratedColumn<String> get organisateur => $composableBuilder(
    column: $table.organisateur,
    builder: (column) => column,
  );

  GeneratedColumn<String> get presentateur => $composableBuilder(
    column: $table.presentateur,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>?, String> get assistants =>
      $composableBuilder(
        column: $table.assistants,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get datePrevue => $composableBuilder(
    column: $table.datePrevue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get heureDebut => $composableBuilder(
    column: $table.heureDebut,
    builder: (column) => column,
  );

  GeneratedColumn<String> get heureFin =>
      $composableBuilder(column: $table.heureFin, builder: (column) => column);

  GeneratedColumn<bool> get estTerminee => $composableBuilder(
    column: $table.estTerminee,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gadgetsPrevus => $composableBuilder(
    column: $table.gadgetsPrevus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gadgetsDistribues => $composableBuilder(
    column: $table.gadgetsDistribues,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalLogistique => $composableBuilder(
    column: $table.totalLogistique,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nbParticipantsEstime => $composableBuilder(
    column: $table.nbParticipantsEstime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get evaluation => $composableBuilder(
    column: $table.evaluation,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$SeancesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SeancesTableTable,
          SeancesTableData,
          $$SeancesTableTableFilterComposer,
          $$SeancesTableTableOrderingComposer,
          $$SeancesTableTableAnnotationComposer,
          $$SeancesTableTableCreateCompanionBuilder,
          $$SeancesTableTableUpdateCompanionBuilder,
          (
            SeancesTableData,
            BaseReferences<_$AppDatabase, $SeancesTableTable, SeancesTableData>,
          ),
          SeancesTableData,
          PrefetchHooks Function()
        > {
  $$SeancesTableTableTableManager(_$AppDatabase db, $SeancesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeancesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeancesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeancesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<String> nom = const Value.absent(),
                Value<String?> motifs = const Value.absent(),
                Value<String?> typeSeance = const Value.absent(),
                Value<String?> cible = const Value.absent(),
                Value<String?> zone = const Value.absent(),
                Value<String?> ville = const Value.absent(),
                Value<String?> quartier = const Value.absent(),
                Value<int> objectifParticipants = const Value.absent(),
                Value<String> organisateur = const Value.absent(),
                Value<String?> presentateur = const Value.absent(),
                Value<List<String>?> assistants = const Value.absent(),
                Value<DateTime> datePrevue = const Value.absent(),
                Value<String?> heureDebut = const Value.absent(),
                Value<String?> heureFin = const Value.absent(),
                Value<bool> estTerminee = const Value.absent(),
                Value<int> gadgetsPrevus = const Value.absent(),
                Value<int> gadgetsDistribues = const Value.absent(),
                Value<double> totalLogistique = const Value.absent(),
                Value<int?> nbParticipantsEstime = const Value.absent(),
                Value<bool?> evaluation = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => SeancesTableCompanion(
                id: id,
                serverId: serverId,
                nom: nom,
                motifs: motifs,
                typeSeance: typeSeance,
                cible: cible,
                zone: zone,
                ville: ville,
                quartier: quartier,
                objectifParticipants: objectifParticipants,
                organisateur: organisateur,
                presentateur: presentateur,
                assistants: assistants,
                datePrevue: datePrevue,
                heureDebut: heureDebut,
                heureFin: heureFin,
                estTerminee: estTerminee,
                gadgetsPrevus: gadgetsPrevus,
                gadgetsDistribues: gadgetsDistribues,
                totalLogistique: totalLogistique,
                nbParticipantsEstime: nbParticipantsEstime,
                evaluation: evaluation,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required String nom,
                Value<String?> motifs = const Value.absent(),
                Value<String?> typeSeance = const Value.absent(),
                Value<String?> cible = const Value.absent(),
                Value<String?> zone = const Value.absent(),
                Value<String?> ville = const Value.absent(),
                Value<String?> quartier = const Value.absent(),
                required int objectifParticipants,
                required String organisateur,
                Value<String?> presentateur = const Value.absent(),
                Value<List<String>?> assistants = const Value.absent(),
                required DateTime datePrevue,
                Value<String?> heureDebut = const Value.absent(),
                Value<String?> heureFin = const Value.absent(),
                Value<bool> estTerminee = const Value.absent(),
                Value<int> gadgetsPrevus = const Value.absent(),
                Value<int> gadgetsDistribues = const Value.absent(),
                Value<double> totalLogistique = const Value.absent(),
                Value<int?> nbParticipantsEstime = const Value.absent(),
                Value<bool?> evaluation = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => SeancesTableCompanion.insert(
                id: id,
                serverId: serverId,
                nom: nom,
                motifs: motifs,
                typeSeance: typeSeance,
                cible: cible,
                zone: zone,
                ville: ville,
                quartier: quartier,
                objectifParticipants: objectifParticipants,
                organisateur: organisateur,
                presentateur: presentateur,
                assistants: assistants,
                datePrevue: datePrevue,
                heureDebut: heureDebut,
                heureFin: heureFin,
                estTerminee: estTerminee,
                gadgetsPrevus: gadgetsPrevus,
                gadgetsDistribues: gadgetsDistribues,
                totalLogistique: totalLogistique,
                nbParticipantsEstime: nbParticipantsEstime,
                evaluation: evaluation,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SeancesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SeancesTableTable,
      SeancesTableData,
      $$SeancesTableTableFilterComposer,
      $$SeancesTableTableOrderingComposer,
      $$SeancesTableTableAnnotationComposer,
      $$SeancesTableTableCreateCompanionBuilder,
      $$SeancesTableTableUpdateCompanionBuilder,
      (
        SeancesTableData,
        BaseReferences<_$AppDatabase, $SeancesTableTable, SeancesTableData>,
      ),
      SeancesTableData,
      PrefetchHooks Function()
    >;
typedef $$SeanceImagesTableTableCreateCompanionBuilder =
    SeanceImagesTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      required int seanceId,
      required List<String> urls,
      Value<String?> legende,
      required DateTime date,
      Value<bool> isSynced,
    });
typedef $$SeanceImagesTableTableUpdateCompanionBuilder =
    SeanceImagesTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      Value<int> seanceId,
      Value<List<String>> urls,
      Value<String?> legende,
      Value<DateTime> date,
      Value<bool> isSynced,
    });

class $$SeanceImagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $SeanceImagesTableTable> {
  $$SeanceImagesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seanceId => $composableBuilder(
    column: $table.seanceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get urls =>
      $composableBuilder(
        column: $table.urls,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get legende => $composableBuilder(
    column: $table.legende,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SeanceImagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SeanceImagesTableTable> {
  $$SeanceImagesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seanceId => $composableBuilder(
    column: $table.seanceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urls => $composableBuilder(
    column: $table.urls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get legende => $composableBuilder(
    column: $table.legende,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SeanceImagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeanceImagesTableTable> {
  $$SeanceImagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<int> get seanceId =>
      $composableBuilder(column: $table.seanceId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get urls =>
      $composableBuilder(column: $table.urls, builder: (column) => column);

  GeneratedColumn<String> get legende =>
      $composableBuilder(column: $table.legende, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$SeanceImagesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SeanceImagesTableTable,
          SeanceImagesTableData,
          $$SeanceImagesTableTableFilterComposer,
          $$SeanceImagesTableTableOrderingComposer,
          $$SeanceImagesTableTableAnnotationComposer,
          $$SeanceImagesTableTableCreateCompanionBuilder,
          $$SeanceImagesTableTableUpdateCompanionBuilder,
          (
            SeanceImagesTableData,
            BaseReferences<
              _$AppDatabase,
              $SeanceImagesTableTable,
              SeanceImagesTableData
            >,
          ),
          SeanceImagesTableData,
          PrefetchHooks Function()
        > {
  $$SeanceImagesTableTableTableManager(
    _$AppDatabase db,
    $SeanceImagesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeanceImagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeanceImagesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeanceImagesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<int> seanceId = const Value.absent(),
                Value<List<String>> urls = const Value.absent(),
                Value<String?> legende = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => SeanceImagesTableCompanion(
                id: id,
                serverId: serverId,
                seanceId: seanceId,
                urls: urls,
                legende: legende,
                date: date,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required int seanceId,
                required List<String> urls,
                Value<String?> legende = const Value.absent(),
                required DateTime date,
                Value<bool> isSynced = const Value.absent(),
              }) => SeanceImagesTableCompanion.insert(
                id: id,
                serverId: serverId,
                seanceId: seanceId,
                urls: urls,
                legende: legende,
                date: date,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SeanceImagesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SeanceImagesTableTable,
      SeanceImagesTableData,
      $$SeanceImagesTableTableFilterComposer,
      $$SeanceImagesTableTableOrderingComposer,
      $$SeanceImagesTableTableAnnotationComposer,
      $$SeanceImagesTableTableCreateCompanionBuilder,
      $$SeanceImagesTableTableUpdateCompanionBuilder,
      (
        SeanceImagesTableData,
        BaseReferences<
          _$AppDatabase,
          $SeanceImagesTableTable,
          SeanceImagesTableData
        >,
      ),
      SeanceImagesTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ParticipantsTableTableTableManager get participantsTable =>
      $$ParticipantsTableTableTableManager(_db, _db.participantsTable);
  $$SyncHistoryTableTableTableManager get syncHistoryTable =>
      $$SyncHistoryTableTableTableManager(_db, _db.syncHistoryTable);
  $$PriseContactsTableTableTableManager get priseContactsTable =>
      $$PriseContactsTableTableTableManager(_db, _db.priseContactsTable);
  $$RdvsTableTableTableManager get rdvsTable =>
      $$RdvsTableTableTableManager(_db, _db.rdvsTable);
  $$SeancesTableTableTableManager get seancesTable =>
      $$SeancesTableTableTableManager(_db, _db.seancesTable);
  $$SeanceImagesTableTableTableManager get seanceImagesTable =>
      $$SeanceImagesTableTableTableManager(_db, _db.seanceImagesTable);
}
