import 'package:flutter/material.dart';
import '../formulaire/rendez-vous_form.dart';


class RdvView extends StatefulWidget {
  const RdvView({super.key});

  @override
  State<RdvView> createState() => _RdvViewState();
}

class _RdvViewState extends State<RdvView> {
  // Liste de données fictives basée sur votre maquette
  // Vous pourrez plus tard remplacer ceci par les données venant de votre base WampServer
  final List<Map<String, dynamic>> _rdvs = [
    {
      'titre': 'Séance Abobo Centre',
      'statut': 'Planifié',
      'date': '2026-03-05 à 09:00',
      'lieu': 'Mairie Abobo',
      'campagne': 'Sensibilisation Abobo',
    },
    {
      'titre': 'Réunion équipe Yopougon',
      'statut': 'Planifié',
      'date': '2026-03-06 à 14:00',
      'lieu': 'Agence CIE Yopougon',
      'campagne': 'Campagne Yopougon Nord',
    },
    {
      'titre': 'Visite terrain Marcory',
      'statut': 'Terminé',
      'date': '2026-03-04 à 10:30',
      'lieu': 'Place Marcory',
      'campagne': 'Campagne Marcory',
    },
    {
      'titre': 'Formation agents Plateau',
      'statut': 'Planifié',
      'date': '2026-03-07 à 08:00',
      'lieu': 'Direction Régionale',
      'campagne': 'Mission Plateau',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Fond très légèrement gris pour faire ressortir les cartes blanches
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // --- En-tête : Titre + Bouton Planifier ---
              // --- En-tête : Bouton Retour + Titre + Bouton Planifier ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 18),
                          onPressed: () {
                            Navigator.pop(context); // Action de retour
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Rendez-vous',
                        style: TextStyle(
                          fontSize: 22, // Légèrement réduit pour faire de la place
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  // Bloc de droite : Bouton Planifier
                  ElevatedButton(
                    onPressed: () {
                      print("Ouvrir le formulaire de planification");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ParticipantForm(), // Assure-toi que l'import est correct
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF97316),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 18, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Planifier',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      const SizedBox(height: 24),// ... le contenu du bouton (Icône + Texte)

              // --- Liste des Rendez-vous ---
              Expanded(
                child: ListView.builder(
                  itemCount: _rdvs.length,
                  itemBuilder: (context, index) {
                    final rdv = _rdvs[index];
                    return _buildRdvCard(rdv);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget personnalisé pour dessiner chaque carte de rendez-vous
  Widget _buildRdvCard(Map<String, dynamic> rdv) {
    final isPlanifie = rdv['statut'] == 'Planifié';
    // Couleurs dynamiques selon le statut (Orange ou Vert)
    final statusColor = isPlanifie ? const Color(0xFFF97316) : const Color(0xFF10B981);
    final statusBgColor = isPlanifie ? const Color(0xFFFFF7ED) : const Color(0xFFECFDF5);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200), // Bordure subtile
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
                  rdv['titre'],
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
                  borderRadius: BorderRadius.circular(20), // Badge arrondi
                ),
                child: Text(
                  rdv['statut'],
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
          _buildDetailRow(Icons.access_time_rounded, rdv['date']),
          const SizedBox(height: 8),

          // Ligne 3 : Lieu
          _buildDetailRow(Icons.location_on_outlined, rdv['lieu']),
          const SizedBox(height: 8),

          // Ligne 4 : Campagne
          _buildDetailRow(Icons.adjust, rdv['campagne']),
        ],
      ),
    );
  }

  // Widget utilitaire pour les lignes de détails (Icône + Texte)
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
            overflow: TextOverflow.ellipsis, // Coupe le texte s'il est trop long
          ),
        ),
      ],
    );
  }
}