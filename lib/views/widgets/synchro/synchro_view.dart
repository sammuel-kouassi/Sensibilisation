import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports Model & Provider
import '../../../models/sync_queue_model.dart';
import '../../../providers/sync_provider.dart';

// Imports Widgets
import 'widgets/connection_card.dart';
import 'widgets/queue_section.dart';
import 'widgets/last_sync_section.dart';
import 'widgets/sync_button.dart';

class SynchroView extends StatelessWidget {
  const SynchroView({super.key});

  void _onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> _onSynchronizeNow(BuildContext context, SyncProvider provider) async {
    if (!provider.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Impossible de synchroniser en mode hors-ligne.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await provider.synchronizeNow();

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Synchronisation réussie!'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    }
  }

  void _onQueueItemTapped(SyncQueueModel item) {
    debugPrint('📤 Item sélectionné: ${item.title}');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SyncProvider(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => _onBackPressed(context),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 22),
          ),
          title: const Text(
            'Synchronisation',
            style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body: Consumer<SyncProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFFFF9500)));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConnectionCard(isOnline: provider.isOnline),

                    const SizedBox(height: 24),

                    QueueSection(
                      waitingQueue: provider.waitingQueue,
                      totalWaiting: provider.totalWaiting,
                      onItemTapped: _onQueueItemTapped,
                    ),

                    const SizedBox(height: 24),

                    LastSyncSection(lastSync: provider.lastSync),

                    const SizedBox(height: 32),

                    SyncButton(
                      isSyncing: provider.isSyncing,
                      onSync: () => _onSynchronizeNow(context, provider),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}