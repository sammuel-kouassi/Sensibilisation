class RdvModel {
  final int? id;
  final int seanceId;
  final String titre;
  final String contact;
  final DateTime dateRdv;
  final String heure;
  final String lieu;
  final String statut;
  final DateTime dateInscription; // ✅ Nouveau champ

  RdvModel({
    this.id,
    required this.seanceId,
    required this.titre,
    required this.contact,
    required this.dateRdv,
    required this.heure,
    required this.lieu,
    required this.statut,
    DateTime? dateInscription, // ✅ Optionnel à la création
  }) : dateInscription = dateInscription ?? DateTime.now(); // ✅ Défaut = maintenant

  bool get isPlanifie => statut == 'Planifié';
}