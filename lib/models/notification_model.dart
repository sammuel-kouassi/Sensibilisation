import 'package:flutter/material.dart';

class AppNotification {
  final String id; // ID unique
  final String title;
  final String body;
  final DateTime time;
  final IconData icon;
  final Color color;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.icon = Icons.notifications_active_outlined,
    this.color = const Color(0xFFFF8000),
    this.isRead = false,
  });
}