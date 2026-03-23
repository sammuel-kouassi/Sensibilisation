import 'package:flutter/material.dart';
import '../../../models/rdv_model.dart';

class RdvCard extends StatelessWidget {
  final RdvModel rdv;

  const RdvCard({super.key, required this.rdv});

  @override
  Widget build(BuildContext context) {
    // Utilisation de la propriété de notre modèle pour déterminer les couleurs
    final statusColor = rdv.isPlanifie ? const Color(0xFFF97316) : const Color(0xFF10B981);
    final statusBgColor = rdv.isPlanifie ? const Color(0xFFFFF7ED) : const Color(0xFFECFDF5);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne 1 : Titre et Badge de statut
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  rdv.titre,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  rdv.statut,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Ligne 2 : Date et Heure
          _buildDetailRow(Icons.access_time_rounded, rdv.date),
          const SizedBox(height: 8),

          // Ligne 3 : Lieu
          _buildDetailRow(Icons.location_on_outlined, rdv.lieu),
          const SizedBox(height: 8),

          // Ligne 4 : Campagne
          _buildDetailRow(Icons.adjust, rdv.campagne),
        ],
      ),
    );
  }

  // Sous-widget interne pour garder le code de la carte propre
  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}