import 'package:flutter/material.dart';

// Imports Model & Data
import '../../models/sync_queue_model.dart';
import '../../models/sync_history_model.dart';
import '../../data/sync_data.dart';

// Imports Widgets
import 'widgets/connection_card.dart';
import 'widgets/queue_section.dart';
import 'widgets/last_sync_section.dart';
import 'widgets/sync_button.dart';

class SynchroView extends StatefulWidget {
  const SynchroView({super.key});

  @override
  State<SynchroView> createState() => _SynchroViewState();
}

class _SynchroViewState extends State<SynchroView> {
  // Variables d'état
  bool _isSyncing = false;

  // Listes de données
  List<SyncQueueModel> _waitingQueue = [];
  List<SyncHistoryModel> _lastSync = [];

  @override
  void initState() {
    super.initState();
    // Initialisation depuis notre fichier Data
    _waitingQueue = SyncData.getWaitingQueue();
    _lastSync = SyncData.getLastSync();
  }

  void _onBackPressed() {
    Navigator.pop(context);
    debugPrint('← Retour cliqué');
  }

  void _onSynchronizeNow() {
    debugPrint('🔄 Synchronisation démarrée...');
    setState(() {
      _isSyncing = true;
    });

    // Simulation de synchronisation (3 secondes)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isSyncing = false;
          _waitingQueue.clear(); // On vide la file d'attente après succès
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Synchronisation réussie!'),
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        debugPrint('✅ Synchronisation terminée avec succès');
      }
    });
  }

  void _onQueueItemTapped(SyncQueueModel item) {
    debugPrint('📤 Item sélectionné: ${item.title}');
  }

  @override
  Widget build(BuildContext context) {
    // Calcul du total en attente
    final totalWaiting = _waitingQueue.fold<int>(
      0,
          (sum, item) => sum + item.count,
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: _onBackPressed,
          child: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
        ),
        title: const Text(
          'Synchronisation',
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ConnectionCard(),

              const SizedBox(height: 24),

              QueueSection(
                waitingQueue: _waitingQueue,
                totalWaiting: totalWaiting,
                onItemTapped: _onQueueItemTapped,
              ),

              const SizedBox(height: 24),

              LastSyncSection(lastSync: _lastSync),

              const SizedBox(height: 32),

              SyncButton(
                isSyncing: _isSyncing,
                onSync: _onSynchronizeNow,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}