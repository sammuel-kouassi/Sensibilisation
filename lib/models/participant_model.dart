class ParticipantModel {
  final int? id;          // id local (SQLite)
  final int sessionId;
  final String lastName;
  final String firstName;
  final String phone;
  final String? profession;
  final String housingStatus;
  final String? residenceLocation;
  final String locality;
  final String? neighborhood;
  final List<String> needs;
  final String? feedback;
  final bool consent;
  final String status;
  final DateTime registrationDate;

  ParticipantModel({
    this.id,
    required this.sessionId,
    required this.lastName,
    required this.firstName,
    required this.phone,
    this.profession,
    required this.housingStatus,
    this.residenceLocation,
    required this.locality,
    this.neighborhood,
    required this.needs,
    this.feedback,
    required this.consent,
    required this.status,
    required this.registrationDate,
  });
}
