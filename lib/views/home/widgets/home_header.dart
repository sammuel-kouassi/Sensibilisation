import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../models/kpi_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/notification_provider.dart';
import 'stat_home_card.dart';

class HomeHeader extends StatelessWidget {
  final List<KpiModel> statCardList;

  const HomeHeader({super.key, required this.statCardList});

  void _showNotificationsPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Consumer<NotificationProvider>(
              builder: (context, notifProv, _) {
                final list = notifProv.notifications;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Barre de drag
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 20),
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Notifications',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Row(
                            children: [
                              if (notifProv.unreadCount > 0) ...[
                                // Bouton "Tout marquer lu"
                                GestureDetector(
                                  onTap: () => notifProv.markAllAsRead(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF19A015).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Tout lire',
                                      style: TextStyle(
                                        color: Color(0xFF19A015),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF8000).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${notifProv.unreadCount} non lues',
                                    style: const TextStyle(
                                      color: Color(0xFFFF8000),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                              // Bouton refresh
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => notifProv.refresh(),
                                child: Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Liste dynamique
                      Expanded(
                        child: notifProv.isLoading && list.isEmpty
                            ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF8000),
                          ),
                        )
                            : list.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                          controller: scrollController,
                          itemCount: list.length,
                          itemBuilder: (context, index) =>
                              _buildNotificationItem(
                                context,
                                list[index],
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildNotificationItem(BuildContext context, AppNotification notif) {
    return GestureDetector(
      onTap: () => context.read<NotificationProvider>().markAsRead(notif.serverId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notif.isRead ? Colors.white : notif.color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: notif.isRead
                ? Colors.grey.withOpacity(0.1)
                : notif.color.withOpacity(0.2),
          ),
          boxShadow: notif.isRead
              ? []
              : [
            BoxShadow(
              color: notif.color.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: notif.color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(notif.icon, color: notif.color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          notif.titre,
                          style: TextStyle(
                            fontWeight: notif.isRead
                                ? FontWeight.w600
                                : FontWeight.w900,
                            fontSize: 15,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('HH:mm').format(notif.createdAt),
                        style: TextStyle(color: Colors.grey[500], fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (notif.corps.isNotEmpty)
                    Text(
                      notif.corps,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  const SizedBox(height: 4),
                  // Badge source (web ou mobile)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: notif.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          notif.source == 'web' ? '🌐 Web' : '📱 Mobile',
                          style: TextStyle(
                            fontSize: 10,
                            color: notif.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 60,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Aucune notification',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Les notifications du web et du mobile\ns\'afficheront ici automatiquement.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ── Plus besoin de rdvProv/syncProv ni de generateNotifications ──
    // Le NotificationProvider gère tout via polling depuis le serveur.

    return Consumer<NotificationProvider>(
      builder: (context, notifProv, _) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF8000), Color(0xFF21951D)],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bienvenue',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Text(
                        context.watch<AuthProvider>().name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  // Cloche avec badge
                  GestureDetector(
                    onTap: () => _showNotificationsPanel(context),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.notifications_active_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        if (notifProv.unreadCount > 0)
                          Positioned(
                            right: -5,
                            top: -5,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFFF8000),
                                  width: 2,
                                ),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 24,
                                minHeight: 24,
                              ),
                              child: Text(
                                '${notifProv.unreadCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              // Cartes KPI
              IntrinsicHeight(
                child: Row(
                  children: statCardList.asMap().entries.map((e) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: e.key == statCardList.length - 1 ? 0 : 16,
                        ),
                        child: StatHomeCard(kpiModel: e.value),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}