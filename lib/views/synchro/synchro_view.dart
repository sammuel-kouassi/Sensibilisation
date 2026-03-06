import 'package:flutter/material.dart';

class SynchroView extends StatefulWidget {
  const SynchroView({super.key});

  @override
  State<SynchroView> createState() => _SynchroViewState();
}

class _SynchroViewState extends State<SynchroView> {
  // ============ VARIABLES ============
  bool _isConnected = true;
  bool _isSyncing = false;

  final List<Map<String, dynamic>> _waitingQueue = [
    {
      'id': 1,
      'title': '3 contacts à synchroniser',
      'status': 'En attente',
      'count': 3,
      'icon': Icons.cloud_upload_outlined,
    },
    {
      'id': 2,
      'title': '5 participants à envoyer',
      'status': 'En attente',
      'count': 5,
      'icon': Icons.cloud_upload_outlined,
    },
    {
      'id': 3,
      'title': '4 distributions de gadgets',
      'status': 'En attente',
      'count': 4,
      'icon': Icons.cloud_upload_outlined,
    },
  ];

  final List<Map<String, dynamic>> _lastSync = [
    {
      'title': 'Contacts',
      'time': 'il y a 30 min',
      'icon': Icons.check_circle,
      'iconColor': const Color(0xFF4CAF50),
    },
    {
      'title': 'Participants',
      'time': 'il y a 1h',
      'icon': Icons.check_circle,
      'iconColor': const Color(0xFF4CAF50),
    },
    {
      'title': 'Campagnes',
      'time': 'il y a 2h',
      'icon': Icons.check_circle,
      'iconColor': const Color(0xFF4CAF50),
    },
    {
      'title': 'Gadgets',
      'time': 'il y a 45 min',
      'icon': Icons.check_circle,
      'iconColor': const Color(0xFF4CAF50),
    },
  ];

  // ============ MÉTHODES ============
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
          _waitingQueue.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Synchronisation réussie!'),
            duration: Duration(seconds: 2),
          ),
        );
        debugPrint('✅ Synchronisation terminée avec succès');
      }
    });
  }

  void _onQueueItemTapped(Map<String, dynamic> item) {
    debugPrint('📤 Item sélectionné: ${item['title']}');
  }

  @override
  Widget build(BuildContext context) {
    final totalWaiting = _waitingQueue.fold<int>(
      0,
          (sum, item) => sum + (item['count'] as int),
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: _onBackPressed,
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 28,
          ),
        ),
        title: const Text(
          'Synchronisation',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============ SECTION CONNEXION ============
              _buildConnectionCard(),

              const SizedBox(height: 24),

              // ============ SECTION FILE D'ATTENTE ============
              _buildQueueSection(totalWaiting),

              const SizedBox(height: 24),

              // ============ SECTION DERNIÈRE SYNCHRONISATION ============
              _buildLastSyncSection(),

              const SizedBox(height: 32),

              // ============ BOUTON SYNCHRONISER ============
              _buildSyncButton(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ============ WIDGETS HELPER ============

  /// Widget Carte Connexion
  Widget _buildConnectionCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.wifi,
              color: Color(0xFF4CAF50),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connecté',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Réseau disponible',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9500),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'En ligne',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget Section File d'Attente
  Widget _buildQueueSection(int totalWaiting) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'File d\'attente',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$totalWaiting en attente',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: _waitingQueue.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _onQueueItemTapped(item),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Icon(
                          item['icon'],
                          color: const Color(0xFFFF9500),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item['status'],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Widget Section Dernière Synchronisation
  Widget _buildLastSyncSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dernière synchronisation',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: _lastSync.map((sync) {
              final isLast = sync == _lastSync.last;
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                child: Row(
                  children: [
                    Icon(
                      sync['icon'],
                      color: sync['iconColor'],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sync['title'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            sync['time'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Widget Bouton Synchroniser
  Widget _buildSyncButton() {
    return GestureDetector(
      onTap: _isSyncing ? null : _onSynchronizeNow,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _isSyncing ? Colors.grey[400] : const Color(0xFFFF9500),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isSyncing)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              const Icon(
                Icons.sync,
                color: Colors.white,
                size: 22,
              ),
            const SizedBox(width: 10),
            Text(
              _isSyncing ? 'Synchronisation...' : 'Synchroniser maintenant',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}