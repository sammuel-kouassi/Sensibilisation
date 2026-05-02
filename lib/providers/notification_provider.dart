import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_client.dart';
import 'package:dlf_backend_client/dlf_backend_client.dart' as sp;

/// Modèle d'affichage d'une notification dans l'UI Flutter
class AppNotification {
  final int serverId;   // ID PostgreSQL de la notification
  final String titre;
  final String corps;
  final String type;    // 'rdv', 'seance', 'sync'
  final String source;  // 'web' ou 'mobile'
  final DateTime createdAt;
  bool isRead;

  AppNotification({
    required this.serverId,
    required this.titre,
    required this.corps,
    required this.type,
    required this.source,
    required this.createdAt,
    required this.isRead,
  });

  /// Construit depuis le modèle Serverpod généré
  factory AppNotification.fromServer(sp.Notification n) {
    return AppNotification(
      serverId: n.id!,
      titre: n.titre,
      corps: n.corps ?? '',
      type: n.type,
      source: n.source,
      createdAt: n.createdAt,
      isRead: n.isRead,
    );
  }

  IconData get icon {
    switch (type) {
      case 'rdv':     return Icons.calendar_today_rounded;
      case 'seance':  return Icons.event_rounded;
      case 'sync':    return Icons.cloud_done_rounded;
      default:        return Icons.notifications_rounded;
    }
  }

  Color get color {
    switch (type) {
      case 'rdv':     return const Color(0xFF3887E0);
      case 'seance':  return const Color(0xFF19A015);
      case 'sync':    return const Color(0xFFFF9500);
      default:        return Colors.grey;
    }
  }
}

class NotificationProvider extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  Timer? _pollingTimer;

  // Intervalle de polling : 30 secondes
  static const Duration _pollInterval = Duration(seconds: 30);

  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;

  int get unreadCount =>
      _notifications.where((n) => !n.isRead).length;

  List<AppNotification> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  NotificationProvider() {
    // Chargement initial immédiat
    fetchNotifications();
    // Puis toutes les 30 secondes
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_pollInterval, (_) => fetchNotifications());
  }

  /// Récupère les notifications depuis Serverpod (qui lit la BD partagée)
  Future<void> fetchNotifications() async {
    try {
      final serverNotifs =
      await apiClient.notification.getMobileNotifications();

      _notifications = serverNotifs
          .map((n) => AppNotification.fromServer(n))
          .toList();

      // Tri : non lues en premier, puis par date décroissante
      _notifications.sort((a, b) {
        if (a.isRead != b.isRead) return a.isRead ? 1 : -1;
        return b.createdAt.compareTo(a.createdAt);
      });

      notifyListeners();
    } catch (e) {
      debugPrint('⚠️ Erreur fetch notifications : $e');
    }
  }

  /// Marque une notification comme lue (en base + localement)
  Future<void> markAsRead(int serverId) async {
    try {
      await apiClient.notification.markAsRead(serverId);

      final index = _notifications.indexWhere((n) => n.serverId == serverId);
      if (index != -1) {
        _notifications[index].isRead = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('⚠️ Erreur markAsRead : $e');
    }
  }

  /// Marque toutes les notifications mobiles comme lues
  Future<void> markAllAsRead() async {
    try {
      await apiClient.notification.markAllMobileAsRead();
      for (final n in _notifications) {
        n.isRead = true;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('⚠️ Erreur markAllAsRead : $e');
    }
  }

  /// Force un refresh immédiat (ex: après pull-to-refresh)
  Future<void> refresh() => fetchNotifications();
}