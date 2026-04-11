import 'package:flutter/material.dart';
import '../../../../models/rdv_model.dart';

class RdvCard extends StatelessWidget {
  final RdvModel rdv;
  final VoidCallback? onEdit;

  const RdvCard({super.key, required this.rdv, this.onEdit});

  @override
  Widget build(BuildContext context) {
    // Couleurs dynamiques selon le statut
    final statusColor = rdv.isPlanifie ? const Color(0xFFF97316) : const Color(0xFF10B981);
    final statusBgColor = rdv.isPlanifie ? const Color(0xFFFFF7ED) : const Color(0xFFECFDF5);

    // Formatage de la date (ex: 12/04/2026)
    final dateStr = "${rdv.dateRdv.day.toString().padLeft(2, '0')}/${rdv.dateRdv.month.toString().padLeft(2, '0')}/${rdv.dateRdv.year}";

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Petit ID local pour le repère visuel
                    Text(
                      rdv.id != null ? 'RDV-${rdv.id}' : 'Non synchronisé',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rdv.titre,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // Badge de statut + Bouton Modifier
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      rdv.statut,
                      style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  // ⚠️ NOUVEAU : Le bouton "Modifier"
                  if (onEdit != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ⚠️ NOUVEAU : Ajout des labels
          _buildDetailRow(Icons.calendar_today_rounded, "Date :", dateStr),
          const SizedBox(height: 8),

          _buildDetailRow(Icons.access_time_rounded, "Heure :", rdv.heure),
          const SizedBox(height: 8),

          _buildDetailRow(Icons.location_on_outlined, "Lieu :", rdv.lieu),
          const SizedBox(height: 8),

          _buildDetailRow(Icons.person_outline, "Contact :", rdv.contact),
        ],
      ),
    );
  }

  // ⚠️ NOUVEAU : Ajout du paramètre `label`
  Widget _buildDetailRow(IconData icon, String label, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}