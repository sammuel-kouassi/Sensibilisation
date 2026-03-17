import 'package:flutter/material.dart';

class SyncHistoryModel {
  final String title;
  final String time;
  final IconData icon;
  final Color iconColor;

  SyncHistoryModel({
    required this.title,
    required this.time,
    required this.icon,
    required this.iconColor,
  });
}