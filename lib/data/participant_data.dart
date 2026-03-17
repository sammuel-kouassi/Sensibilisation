import 'package:flutter/material.dart';
import '../models/participant_model.dart';

class ParticipantData {
  static List<ParticipantModel> getParticipants() {
    return [
      ParticipantModel(
        id: 'P001',
        name: 'Ouattara Ibrahim',
        phone: '0701234567',
        location: 'Abobo',
        date: '2026-02-15',
        campaign: 'Sensibilisation Abobo',
        status: 'Actif',
        statusColor: const Color(0xFFD4F1E4),
        statusTextColor: const Color(0xFF4CAF50),
      ),
      ParticipantModel(
        id: 'P002',
        name: 'Coulibaly Mariam',
        phone: '0507654321',
        location: 'Yopougon',
        date: '2026-02-10',
        campaign: 'Campagne Yopougon Nord',
        status: 'Actif',
        statusColor: const Color(0xFFD4F1E4),
        statusTextColor: const Color(0xFF4CAF50),
      ),
      ParticipantModel(
        id: 'P003',
        name: 'Konan Serge',
        phone: '0102345678',
        location: 'Cocody',
        date: '2026-01-20',
        campaign: 'Sensibilisation Cocody',
        status: 'Archivé',
        statusColor: const Color(0xFFF0F0F0),
        statusTextColor: const Color(0xFF999999),
      ),
      ParticipantModel(
        id: 'P004',
        name: 'N\'Dri Ange',
        phone: '0756432109',
        location: 'Plateau',
        date: '2026-02-12',
        campaign: 'Sensibilisation Plateau',
        status: 'Actif',
        statusColor: const Color(0xFFD4F1E4),
        statusTextColor: const Color(0xFF4CAF50),
      ),
      ParticipantModel(
        id: 'P005',
        name: 'Bah Fatoumata',
        phone: '0698765432',
        location: 'Treichville',
        date: '2026-02-08',
        campaign: 'Sensibilisation Treichville',
        status: 'Actif',
        statusColor: const Color(0xFFD4F1E4),
        statusTextColor: const Color(0xFF4CAF50),
      ),
    ];
  }
}