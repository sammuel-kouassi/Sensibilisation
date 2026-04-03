import 'package:flutter/material.dart';
import '../models/campaign_model.dart';

class CampaignData {
  static List<CampaignModel> getCampaigns() {
    return [
      CampaignModel(
        title: 'Sensibilisation Abobo',
        location: 'Abobo',
        participants: '234/300 participants',
        date: DateTime(2026, 2, 1),
        heureDebut: const TimeOfDay(hour: 9, minute: 0),
        heureFin: const TimeOfDay(hour: 12, minute: 0),
        supervisor: 'Kouamé Jean',
        status: 'En cours',
        statusColor: const Color(0xFFFFE4CC),
        statusTextColor: const Color(0xFFFF8000),
        progress: 0.78,
      ),
      CampaignModel(
        title: 'Séance Yopougon Nord',
        location: 'Yopougon',
        participants: '180/200 participants',
        date: DateTime(2026, 1, 15),
        heureDebut: const TimeOfDay(hour: 14, minute: 30),
        heureFin: const TimeOfDay(hour: 17, minute: 0),
        supervisor: 'Diallo Fatou',
        status: 'Validée',
        statusColor: const Color(0xFFD4F1E4),
        statusTextColor: const Color(0xFF4CAF50),
        progress: 0.90,
      ),
      CampaignModel(
        title: 'Sensibilisation Cocody',
        location: 'Cocody',
        participants: '320/300 participants',
        date: DateTime(2025, 12, 1),
        heureDebut: const TimeOfDay(hour: 8, minute: 0),
        heureFin: const TimeOfDay(hour: 10, minute: 0),
        supervisor: 'N/A',
        status: 'Clôturée',
        statusColor: const Color(0xFFF0F0F0),
        statusTextColor: const Color(0xFF999999),
        progress: 1.0,
      ),
    ];
  }
}