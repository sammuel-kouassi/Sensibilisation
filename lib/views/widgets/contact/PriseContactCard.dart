import 'package:flutter/material.dart';
import '../../../models/prise_contact_model.dart';

class PriseContactCard extends StatelessWidget {
  final PriseContactModel contact;
  final VoidCallback? onEdit;

  const PriseContactCard({super.key, required this.contact, this.onEdit});

  @override
  Widget build(BuildContext context) {
    // Formatage simple de la date
    final dateStr =
        "${contact.date.day.toString().padLeft(2, '0')}/${contact.date.month.toString().padLeft(2, '0')}/${contact.date.year}";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.id != null ? 'CONTACT-${contact.id}' : 'Non synchronisé',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contact.nomContact,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Bouton Édition
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // --- INFORMATIONS ---
          _buildInfoRow(Icons.assignment_outlined, "Objet :", contact.objetMission),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.phone_outlined, "Tél :", contact.telephone),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.business_outlined, "DR :", contact.directionRegionale),
          if (contact.agence != null && contact.agence!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildInfoRow(Icons.storefront_outlined, "Agence :", contact.agence!),
          ],
          const SizedBox(height: 10),
          _buildInfoRow(Icons.calendar_today_outlined, "Date :", dateStr),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Séance ID : ${contact.seanceId}',
                style: TextStyle(color: Colors.grey[500], fontSize: 12, fontStyle: FontStyle.italic),
              ),
              // Petit indicateur de signature
              if (contact.signatureBase64 != null && contact.signatureBase64!.isNotEmpty)
                const Row(
                  children: [
                    Icon(Icons.draw, size: 14, color: Color(0xFF4CAF50)),
                    SizedBox(width: 4),
                    Text('Signé', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget utilitaire pour les lignes d'info
  Widget _buildInfoRow(IconData icon, String label, String value) {
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
            value,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}