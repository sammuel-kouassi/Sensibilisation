import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/sync_queue_model.dart';
import '../../../providers/sync_provider.dart';

import 'widgets/connection_card.dart';
import 'widgets/queue_section.dart';
import 'widgets/last_sync_section.dart';
import 'widgets/sync_button.dart';

class SynchroView extends StatelessWidget {
  const SynchroView({super.key});

  static const _orange = Color(0xFFFF8000);
  static const _vert = Color(0xFF21951D);

  void _onBackPressed(BuildContext context) => Navigator.pop(context);

  Future<void> _onSynchronizeNow(
      BuildContext context,
      SyncProvider provider,
      ) async {
    if (!provider.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.wifi_off_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('Mode hors-ligne actif. Impossible de synchroniser.'),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final success = await provider.synchronizeNow();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                success
                    ? Icons.check_circle_rounded
                    : Icons.error_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                success
                    ? 'Synchronisation réussie !'
                    : 'Échec de la synchronisation.',
              ),
            ],
          ),
          backgroundColor: success ? Colors.green[700] : Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: Duration(seconds: success ? 3 : 4),
        ),
      );
    }
  }

  void _onQueueItemTapped(SyncQueueModel item) {
    debugPrint('📤 Item sélectionné: ${item.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Consumer<SyncProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _orange),
            );
          }

          return CustomScrollView(
            slivers: [
              // ── AppBar gradient ──
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                backgroundColor: _orange,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white),
                  onPressed: () => _onBackPressed(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: provider.isOnline
                            ? [_vert, const Color(0xFF167013)]
                            : [Colors.grey[700]!, Colors.grey[900]!],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20, top: -20,
                          child: Container(
                            width: 140, height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.07),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -30, bottom: -10,
                          child: Container(
                            width: 100, height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Synchronisation',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  provider.isOnline
                                      ? 'Connexion active — prêt à synchroniser'
                                      : 'Hors ligne — en attente de réseau',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Contenu ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConnectionCard(isOnline: provider.isOnline),
                      const SizedBox(height: 16),
                      QueueSection(
                        waitingQueue: provider.waitingQueue,
                        totalWaiting: provider.totalWaiting,
                        onItemTapped: _onQueueItemTapped,
                      ),
                      const SizedBox(height: 16),
                      LastSyncSection(lastSync: provider.lastSync),
                      const SizedBox(height: 24),
                      SyncButton(
                        isSyncing: provider.isSyncing,
                        onSync: () => _onSynchronizeNow(context, provider),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}