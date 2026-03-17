import 'package:flutter/material.dart';

class ParticipantModel {
  final String id;
  final String name;
  final String phone;
  final String location;
  final String date;
  final String campaign;
  final String status;
  final Color statusColor;
  final Color statusTextColor;

  ParticipantModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.date,
    required this.campaign,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
  });
}