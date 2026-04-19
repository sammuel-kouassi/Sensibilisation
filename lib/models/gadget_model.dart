import 'package:cie_services/models/seance_statut.dart';

class GadgetModel {
  final int id;
  final int? serverId;
  final String seanceNom;
  final String zone;
  final int gadgetsPrevus;
  final int gadgetsDistribues;
  final double? totalLogistique;
  final SeanceStatut statut;



  GadgetModel({
    required this.id,
    this.serverId,
    required this.seanceNom,
    required this.zone,
    required this.gadgetsPrevus,
    required this.gadgetsDistribues, this.totalLogistique, required this.statut,
  });

  int get restants => gadgetsPrevus - gadgetsDistribues;
  double get stockPercentage => gadgetsPrevus > 0 ? restants / gadgetsPrevus : 0;

  bool get isLowStock => stockPercentage <= 0.25 && gadgetsPrevus > 0;
  bool get isOutOfStock => restants <= 0;
}