import 'package:flutter/material.dart';
import '../models/sync_queue_model.dart';
import '../models/sync_history_model.dart';

class SyncData {
  static List<SyncQueueModel> getWaitingQueue() {
    return [
      SyncQueueModel(
        id: 1,
        title: '3 contacts à synchroniser',
        status: 'En attente',
        count: 3,
        icon: Icons.cloud_upload_outlined,
      ),
      SyncQueueModel(
        id: 2,
        title: '5 participants à envoyer',
        status: 'En attente',
        count: 5,
        icon: Icons.cloud_upload_outlined,
      ),
      SyncQueueModel(
        id: 3,
        title: '4 distributions de gadgets',
        status: 'En attente',
        count: 4,
        icon: Icons.cloud_upload_outlined,
      ),
    ];
  }

  static List<SyncHistoryModel> getLastSync() {
    return [
      SyncHistoryModel(
        title: 'Contacts',
        time: 'il y a 30 min',
        icon: Icons.check_circle,
        iconColor: const Color(0xFF4CAF50),
      ),
      SyncHistoryModel(
        title: 'Participants',
        time: 'il y a 1h',
        icon: Icons.check_circle,
        iconColor: const Color(0xFF4CAF50),
      ),
      SyncHistoryModel(
        title: 'Campagnes',
        time: 'il y a 2h',
        icon: Icons.check_circle,
        iconColor: const Color(0xFF4CAF50),
      ),
      SyncHistoryModel(
        title: 'Gadgets',
        time: 'il y a 45 min',
        icon: Icons.check_circle,
        iconColor: const Color(0xFF4CAF50),
      ),
    ];
  }
}