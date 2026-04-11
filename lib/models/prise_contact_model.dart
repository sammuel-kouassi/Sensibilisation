class PriseContactModel {
  final int? id;
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

  PriseContactModel({
    this.id,
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
  });
}