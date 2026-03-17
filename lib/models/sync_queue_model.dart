import 'package:flutter/material.dart';

class SyncQueueModel {
  final int id;
  final String title;
  final String status;
  final int count;
  final IconData icon;

  SyncQueueModel({
    required this.id,
    required this.title,
    required this.status,
    required this.count,
    required this.icon,
  });
}