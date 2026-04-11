import 'package:flutter/material.dart';
import '../../../../models/gadget_model.dart';

class GadgetCard extends StatelessWidget {
  final GadgetModel gadget;
  final VoidCallback onTap;

  const GadgetCard({super.key, required this.gadget, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color statusBgColor = gadget.isOutOfStock ? const Color(0xFFFFEBEE) :
    gadget.isLowStock ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9);
    Color statusTextColor = gadget.isOutOfStock ? const Color(0xFFC62828) :
    gadget.isLowStock ? const Color(0xFFE65100) : const Color(0xFF2E7D32);
    String statusText = gadget.isOutOfStock ? 'Épuisé' :
    gadget.isLowStock ? 'Stock bas' : 'En stock';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.event_seat, color: Colors.orange),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gadget.seanceNom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(gadget.zone, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    children: [
                      Text('Prévus: ${gadget.gadgetsPrevus}', style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text('Distribués: ${gadget.gadgetsDistribues}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(12)),
              child: Text(statusText, style: TextStyle(color: statusTextColor, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}