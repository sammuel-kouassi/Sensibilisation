import 'package:flutter/material.dart';

class QuickAccessModel {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String label;
  final VoidCallback onTap;

  QuickAccessModel({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.label,
    required this.onTap,
  });
}