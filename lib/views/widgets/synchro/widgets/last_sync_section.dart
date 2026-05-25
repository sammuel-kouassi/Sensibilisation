import 'package:flutter/material.dart';
import '../../../../models/sync_history_model.dart';

class LastSyncSection extends StatelessWidget {
  final List<SyncHistoryModel> lastSync;

  const LastSyncSection({super.key, required this.lastSync});

  static const _dark = Color(0xFF1E293B);
  static const _orange = Color(0xFFFF8000);

  IconData _getIcon(String status) {
    return status == 'success'
        ? Icons.check_circle_rounded
        : Icons.error_rounded;
  }

  Color _getColor(String status) {
    return status == 'success'
        ? const Color(0xFF21951D)
        : Colors.red[600]!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEF0F3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── En-tête ──
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: _orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.history_rounded,
                    color: _orange, size: 18),
              ),
              const SizedBox(width: 12),
              const Text(
                'Dernière synchronisation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _dark,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (lastSync.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: Colors.grey[300], size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Aucune synchronisation récente',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: lastSync.asMap().entries.map((entry) {
                final sync = entry.value;
                final isLast = entry.key == lastSync.length - 1;
                final color = _getColor(sync.status);
                final isSuccess = sync.status == 'success';

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: color.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(_getIcon(sync.status),
                                color: color, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sync.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: _dark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  sync.time,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isSuccess ? 'Réussi' : 'Échoué',
                              style: TextStyle(
                                fontSize: 11,
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast) const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}