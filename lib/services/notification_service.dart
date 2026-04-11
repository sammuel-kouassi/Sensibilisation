import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/rdv_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _notifications.initialize(
      InitializationSettings(android: android, iOS: ios),
    );
  }

  // PROGRAMMATION MULTIPLE ---
  Future<void> scheduleAllRdvNotifications(int rdvId, RdvModel rdv) async {
    try {
      final parts = rdv.heure.split(':');
      final rdvDate = DateTime(
        rdv.dateRdv.year,
        rdv.dateRdv.month,
        rdv.dateRdv.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      // 1. Instantané (Confirmation)
      await _show(
        rdvId * 10,
        'RDV Confirmé',
        'Votre rendez-vous "${rdv.titre}" est enregistré.',
      );

      // 2. J-3
      final j3 = rdvDate.subtract(const Duration(days: 3));
      if (j3.isAfter(DateTime.now())) {
        await _schedule(
          rdvId * 10 + 3,
          'Rappel J-3',
          'RDV "${rdv.titre}" dans 3 jours.',
          j3,
        );
      }

      // 3. Jour J (08:00)
      final jourJ = DateTime(rdvDate.year, rdvDate.month, rdvDate.day, 8, 0);
      if (jourJ.isAfter(DateTime.now())) {
        await _schedule(
          rdvId * 10 + 4,
          'C\'est aujourd\'hui !',
          'RDV "${rdv.titre}" à ${rdv.heure}.',
          jourJ,
        );
      }

      // 4. 1h avant
      final h1 = rdvDate.subtract(const Duration(hours: 1));
      if (h1.isAfter(DateTime.now())) {
        await _schedule(
          rdvId * 10 + 1,
          'RDV dans 1h',
          'Prévu à ${rdv.heure} à ${rdv.lieu}.',
          h1,
        );
      }
    } catch (e) {
      debugPrint('Erreur Notif : $e');
    }
  }

  // ANNULATION COMPLÈTE ---
  Future<void> cancelAllRdvNotifications(int rdvId) async {
    await _notifications.cancel(rdvId * 10);
    await _notifications.cancel(rdvId * 10 + 1);
    await _notifications.cancel(rdvId * 10 + 3);
    await _notifications.cancel(rdvId * 10 + 4);
  }

  Future<void> _show(int id, String t, String b) async {
    await _notifications.show(
      id,
      t,
      b,
      const NotificationDetails(
        android: AndroidNotificationDetails('rdv', 'RDV'),
      ),
    );
  }

  Future<void> _schedule(int id, String t, String b, DateTime d) async {
    await _notifications.zonedSchedule(
      id,
      t,
      b,
      tz.TZDateTime.from(d, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails('rdv', 'RDV'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
