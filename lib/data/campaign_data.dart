import 'package:flutter/material.dart';
import '../models/campaign_model.dart';

class CampaignData {
  static List<CampaignModel> getCampaigns() {
    return [
      CampaignModel(
        title: 'Sensibilisation Abobo',
        location: 'Abobo',
        participants: '234/300 participants',
        dates: '2026-02-01 → 2026-03-15',
        supervisor: 'Kouamé Jean',
        status: 'En cours',
        statusColor: const Color(0xFFFFE4CC),
        statusTextColor: const Color(0xFFFF9500),
        progress: 0.78,
      ),
      CampaignModel(
        title: 'Campagne Yopougon Nord',
        location: 'Yopougon',
        participants: '180/200 participants',
        dates: '2026-01-15 → 2026-02-28',
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
        dates: '2025-12-01 → 2026-01-31',
        supervisor: 'N/A',
        status: 'Clôturée',
        statusColor: const Color(0xFFF0F0F0),
        statusTextColor: const Color(0xFF999999),
        progress: 1.0,
      ),
    ];
  }
}