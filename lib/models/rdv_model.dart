class RdvModel {
  final String titre;
  final String statut;
  final String date;
  final String lieu;
  final String campagne;

  RdvModel({
    required this.titre,
    required this.statut,
    required this.date,
    required this.lieu,
    required this.campagne,
  });

  bool get isPlanifie => statut == 'Planifié';
}