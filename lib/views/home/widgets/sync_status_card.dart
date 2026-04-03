import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/home_provider.dart';

class SyncStatusCard extends StatelessWidget {
  const SyncStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final isOnline = provider.isOnline;
    final pendingCount = provider.pendingSyncOperations;

    return Container(

      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: isOnline ? const Color(0xFFD4F1E4) : Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Icon(
                      isOnline ? Icons.sync_outlined : Icons.cloud_off,
                      size: 28,
                      color: isOnline ? const Color(0xFF4CAF50) : Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Synchronisation',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pendingCount > 0
                            ? '$pendingCount opération(s) en attente'
                            : 'À jour',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isOnline ? Colors.green.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3),
                  width: 1.5
              ),
              borderRadius: BorderRadius.circular(20),
              color: isOnline ? Colors.green.withValues(alpha: 0.05) : Colors.orange.withValues(alpha: 0.05),
            ),
            child: Text(
              isOnline ? 'Connecté' : 'Hors-ligne',
              style: TextStyle(
                  color: isOnline ? Colors.green[700] : Colors.orange[800],
                  fontSize: 12,
                  fontWeight: FontWeight.w600
              ),

            ),

          ),
          const SizedBox(width: 2),
        ],

      ),

    );


  }
}