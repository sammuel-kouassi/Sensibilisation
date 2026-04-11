import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import 'rdv_provider.dart';
import 'sync_provider.dart';

class NotificationProvider extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  final Set<String> _readIds = {};

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void generateNotifications(RdvProvider rdvProv, SyncProvider syncProv) {
    List<AppNotification> newList = [];

    // 1. Traitement des RDV
    for (var rdv in rdvProv.rdvs) {
      final timeParts = rdv.heure.split(':');
      final fullDateTime = DateTime(
        rdv.dateRdv.year,
        rdv.dateRdv.month,
        rdv.dateRdv.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      final id = "rdv_${rdv.id}";
      newList.add(
        AppNotification(
          id: id,
          title: 'RDV : ${rdv.titre}',
          body:
              'Prévu le ${fullDateTime.day.toString().padLeft(2, '0')}/${fullDateTime.month.toString().padLeft(2, '0')}/${fullDateTime.year} à ${rdv.heure}',
          time: fullDateTime,
          isRead: _readIds.contains(id),
          icon: Icons.calendar_today_rounded,
        ),
      );
    }

    // 2. Traitement Synchro
    for (var sync in syncProv.lastSync) {
      final id = "sync_${sync.time}_${sync.title}";
      newList.add(
        AppNotification(
          id: id,
          title: sync.title,
          body: sync.status == 'success'
              ? 'Données sécurisées sur le serveur.'
              : 'Échec de l\'envoi.',
          time: DateTime.now(),
          isRead: _readIds.contains(id),
          icon: sync.status == 'success'
              ? Icons.cloud_done_rounded
              : Icons.cloud_off_rounded,
          color: sync.status == 'success' ? Colors.green : Colors.red,
        ),
      );
    }

    newList.sort((a, b) => b.time.compareTo(a.time));
    _notifications = newList;
    notifyListeners();
  }

  void markAsRead(String id) {
    _readIds.add(id);
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }
}
