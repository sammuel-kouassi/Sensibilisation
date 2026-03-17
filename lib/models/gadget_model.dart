import 'package:flutter/material.dart';

class GadgetModel {
  final int id;
  final String name;
  final String category;
  final int enStock;
  final int distribues;
  final int total;
  final String? statusBadge;
  final Color? statusColor;
  final Color? statusTextColor;
  final IconData icon;

  GadgetModel({
    required this.id,
    required this.name,
    required this.category,
    required this.enStock,
    required this.distribues,
    required this.total,
    this.statusBadge,
    this.statusColor,
    this.statusTextColor,
    required this.icon,
  });

  // Petite fonction utilitaire directement dans le modèle !
  double get stockPercentage => total > 0 ? enStock / total : 0;
}