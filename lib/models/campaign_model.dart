class SeanceModel {
  final int id;
  final String nom;
  final String statut;
  final String zone;
  final String dateDebut;
  final String? organisateur;

  SeanceModel({
    required this.id,
    required this.nom,
    required this.statut,
    required this.zone,
    required this.dateDebut,
    this.organisateur,
  });

  factory SeanceModel.fromJson(Map<String, dynamic> json) => SeanceModel(
    id: json["id"],
    nom: json["nom"],
    statut: json["statut"],
    zone: json["zone"],
    dateDebut: json["dateDebut"],
    organisateur: json["organisateur"],
  );
}
