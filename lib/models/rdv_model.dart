class RdvModel {
  final int? id;          // L'ID local SQLite (null lors de la création)
  final int seanceId;     // ID de la séance rattachée
  final String titre;
  final String contact;   // Le nom de la personne à rencontrer
  final DateTime dateRdv; // Le vrai format Date
  final String heure;     // Ex: "14:30"
  final String lieu;
  final String statut;

  RdvModel({
    this.id,
    required this.seanceId,
    required this.titre,
    required this.contact,
    required this.dateRdv,
    required this.heure,
    required this.lieu,
    required this.statut,
  });

  // Getter pratique pour vérifier le statut
  bool get isPlanifie => statut == 'Planifié';
}