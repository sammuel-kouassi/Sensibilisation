import 'package:flutter/material.dart';

class LogistiqueItem {
  String designation;
  int quantite;
  double prixUnitaire;

  LogistiqueItem({
    required this.designation,
    this.quantite = 1,
    this.prixUnitaire = 0.0,
  });

  double get total => quantite * prixUnitaire;
}

class CampaignModel {
  final String title;
  final String location;
  final String participants;

  final DateTime date;
  final TimeOfDay heureDebut;
  final TimeOfDay heureFin;

  final String supervisor;
  final String status;

  final Color statusColor;
  final Color statusTextColor;
  final double progress;

  final List<LogistiqueItem> logistique;

  CampaignModel({
    required this.title,
    required this.location,
    required this.participants,
    required this.date,
    required this.heureDebut,
    required this.heureFin,
    required this.supervisor,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
    required this.progress,
    this.logistique = const [],
  });

  double get coutTotalLogistique {
    return logistique.fold(0, (sum, item) => sum + item.total);
  }
}