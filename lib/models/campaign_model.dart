import 'package:flutter/material.dart';

class CampaignModel {
  final String title;
  final String location;
  final String participants;
  final String dates;
  final String supervisor;
  final String status;
  final Color statusColor;
  final Color statusTextColor;
  final double progress;

  CampaignModel({
    required this.title,
    required this.location,
    required this.participants,
    required this.dates,
    required this.supervisor,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
    required this.progress,
  });
}