import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';
import 'rdv_provider.dart';
import 'sync_provider.dart';

class NotificationProvider extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  Set<String> _readIds = {};

  static const String _prefKey = 'read_notification_ids';

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationProvider() {
    _loadReadIds();
  }

  /// Charge les IDs lus depuis le stockage local au démarrage
  Future<void> _loadReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_prefKey) ?? [];
    _readIds = stored.toSet();
    notifyListeners();
  }

  /// Persiste les IDs lus dans le stockage local
  Future<void> _saveReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefKey, _readIds.toList());
  }

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

    // 2. Traitement Synchro — utilise sync.time réel pour un tri correct
    for (var sync in syncProv.lastSync) {
      final id = "sync_${sync.time}_${sync.title}";

      // Résolution du DateTime réel de la synchro
      DateTime syncTime;
      if (sync.time is DateTime) {
        syncTime = sync.time as DateTime;
      } else {
        syncTime = DateTime.tryParse(sync.time.toString()) ?? DateTime.now();
      }

      newList.add(
        AppNotification(
          id: id,
          title: sync.title,
          body: sync.status == 'success'
              ? 'Données sécurisées sur le serveur.'
              : 'Échec de l\'envoi.',
          time: syncTime,
          isRead: _readIds.contains(id),
          icon: sync.status == 'success'
              ? Icons.cloud_done_rounded
              : Icons.cloud_off_rounded,
          color: sync.status == 'success' ? Colors.green : Colors.red,
        ),
      );
    }

    // Tri du plus récent au plus ancien
    newList.sort((a, b) => b.time.compareTo(a.time));

    _notifications = newList;
    notifyListeners();
  }

  /// Marque une notification comme lue et persiste l'état
  Future<void> markAsRead(String id) async {
    _readIds.add(id);
    await _saveReadIds();

    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  /// Marque toutes les notifications comme lues
  Future<void> markAllAsRead() async {
    for (final n in _notifications) {
      _readIds.add(n.id);
      n.isRead = true;
    }
    await _saveReadIds();
    notifyListeners();
  }

  /// Réinitialise toutes les notifications (utile pour les tests)
  Future<void> clearReadIds() async {
    _readIds.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
    notifyListeners();
  }
}