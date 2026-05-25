import 'package:flutter/material.dart';
import '../../../../models/gadget_model.dart';

class GadgetCard extends StatelessWidget {
  final GadgetModel gadget;
  final VoidCallback onTap;

  const GadgetCard({super.key, required this.gadget, required this.onTap});

  static const _dark = Color(0xFF1E293B);
  static const _orange = Color(0xFFFF8000);

  String _formatMontant(double montant) {
    final parts = montant.toInt().toString().split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i != 0 && (parts.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(parts[i]);
    }
    return '${buffer.toString()} FCFA';
  }

  @override
  Widget build(BuildContext context) {
    // ── Statut couleurs ──
    final Color statusBg = gadget.isOutOfStock
        ? const Color(0xFFFFEBEE)
        : gadget.isLowStock
        ? const Color(0xFFFFF3E0)
        : const Color(0xFFE8F5E9);
    final Color statusColor = gadget.isOutOfStock
        ? const Color(0xFFC62828)
        : gadget.isLowStock
        ? const Color(0xFFE65100)
        : const Color(0xFF2E7D32);
    final String statusText = gadget.isOutOfStock
        ? 'Épuisé'
        : gadget.isLowStock
        ? 'Stock bas'
        : 'En stock';
    final IconData statusIcon = gadget.isOutOfStock
        ? Icons.remove_circle_outline_rounded
        : gadget.isLowStock
        ? Icons.warning_amber_rounded
        : Icons.check_circle_outline_rounded;

    // ── Progression ──
    final double progress = gadget.gadgetsPrevus > 0
        ? (gadget.gadgetsDistribues / gadget.gadgetsPrevus).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  // ── Ligne principale ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icône
                      Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                          color: _orange.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.card_giftcard_rounded,
                          color: _orange, size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Infos
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gadget.seanceNom,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: _dark,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined,
                                    size: 13, color: Colors.grey[400]),
                                const SizedBox(width: 3),
                                Text(
                                  gadget.zone,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Badge statut
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(statusIcon, size: 12, color: statusColor),
                            const SizedBox(width: 4),
                            Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Barre de progression ──
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Distribution',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${gadget.gadgetsDistribues} / ${gadget.gadgetsPrevus}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _dark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFF0F1F5),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            gadget.isOutOfStock
                                ? Colors.red[400]!
                                : gadget.isLowStock
                                ? Colors.orange[400]!
                                : Colors.green[500]!,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}% distribué',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[400],
                            ),
                          ),
                          Text(
                            '${gadget.restants} restant(s)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: gadget.isOutOfStock
                                  ? Colors.red[400]
                                  : gadget.isLowStock
                                  ? Colors.orange[600]
                                  : Colors.green[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Budget logistique ──
            if (gadget.totalLogistique != null &&
                gadget.totalLogistique! > 0) ...[
              Container(
                height: 1,
                color: const Color(0xFFF0F1F5),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_balance_wallet_outlined,
                            size: 14, color: Colors.grey[400]),
                        const SizedBox(width: 6),
                        Text(
                          'Budget logistique',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _formatMontant(gadget.totalLogistique!),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _dark,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ── Footer : bouton distribuer ──
            if (!gadget.isOutOfStock) ...[
              Container(
                height: 1,
                color: const Color(0xFFF0F1F5),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: _orange.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _orange.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.volunteer_activism_rounded,
                                color: _orange, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Distribuer des gadgets',
                              style: TextStyle(
                                color: _orange,
                                fontWeight: FontWeight.w700,
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
            ],
          ],
        ),
      ),
    );
  }
}