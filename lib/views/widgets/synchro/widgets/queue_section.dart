import 'package:flutter/material.dart';
import '../../../../models/sync_queue_model.dart';

class QueueSection extends StatelessWidget {
  final List<SyncQueueModel> waitingQueue;
  final int totalWaiting;
  final Function(SyncQueueModel) onItemTapped;

  const QueueSection({
    super.key,
    required this.waitingQueue,
    required this.totalWaiting,
    required this.onItemTapped,
  });

  static const _orange = Color(0xFFFF8000);
  static const _dark = Color(0xFF1E293B);

  IconData _getIcon(String type) {
    switch (type) {
      case 'contact':
        return Icons.contact_phone_outlined;
      case 'participant':
        return Icons.people_outline;
      case 'gadget':
        return Icons.card_giftcard_outlined;
      default:
        return Icons.cloud_upload_outlined;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'contact':
        return const Color(0xFF7B1FA2);
      case 'participant':
        return const Color(0xFF1565C0);
      case 'gadget':
        return const Color(0xFF21951D);
      default:
        return _orange;
    }
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
          // ── En-tête section ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: _orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.hourglass_top_rounded,
                        color: _orange, size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'File d\'attente',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: _dark,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: totalWaiting > 0
                      ? _orange.withValues(alpha: 0.1)
                      : const Color(0xFF21951D).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  totalWaiting > 0
                      ? '$totalWaiting en attente'
                      : 'À jour',
                  style: TextStyle(
                    color: totalWaiting > 0
                        ? _orange
                        : const Color(0xFF21951D),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Contenu ──
          if (waitingQueue.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline_rounded,
                      color: const Color(0xFF21951D).withValues(alpha: 0.6),
                      size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Aucun élément en attente',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: waitingQueue.asMap().entries.map((entry) {
                final item = entry.value;
                final isLast = entry.key == waitingQueue.length - 1;
                final typeColor = _getTypeColor(item.type);

                return GestureDetector(
                  onTap: () => onItemTapped(item),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFFEEF0F3), width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(_getIcon(item.type),
                              color: typeColor, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 14,
                              color: _dark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _orange.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _orange.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            item.status,
                            style: TextStyle(
                              fontSize: 11,
                              color: _orange.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}