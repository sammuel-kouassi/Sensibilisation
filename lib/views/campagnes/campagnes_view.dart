import 'package:cie_services/views/campagnes/widgets/campaign_card.dart';
import 'package:flutter/material.dart';

import '../formulaire/campagne_form.dart';

class CampagnesView extends StatefulWidget {
  const CampagnesView({super.key});

  @override
  State<CampagnesView> createState() => _CampagnesViewState();
}

class _CampagnesViewState extends State<CampagnesView> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _campaigns = [
    {
      'title': 'Sensibilisation Abobo',
      'location': 'Abobo',
      'participants': '234/300 participants',
      'dates': '2026-02-01 → 2026-03-15',
      'supervisor': 'Kouamé Jean',
      'status': 'En cours',
      'statusColor': const Color(0xFFFFE4CC),
      'statusTextColor': const Color(0xFFFF9500),
      'progress': 0.78,
    },
    {
      'title': 'Campagne Yopougon Nord',
      'location': 'Yopougon',
      'participants': '180/200 participants',
      'dates': '2026-01-15 → 2026-02-28',
      'supervisor': 'Diallo Fatou',
      'status': 'Validée',
      'statusColor': const Color(0xFFD4F1E4),
      'statusTextColor': const Color(0xFF4CAF50),
      'progress': 0.90,
    },
    {
      'title': 'Sensibilisation Cocody',
      'location': 'Cocody',
      'participants': '320/300 participants',
      'dates': '2025-12-01 → 2026-01-31',
      'supervisor': 'N/A',
      'status': 'Clôturée',
      'statusColor': const Color(0xFFF0F0F0),
      'statusTextColor': const Color(0xFF999999),
      'progress': 1.0,
    },
  ];


  Future<void> _onAddCampaignPressed() async {
    final nouvelleCampagne = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CampagneForm(),
      ),
    );

    // Si on a reçu les données d'une nouvelle campagne, on met à jour la liste
    if (nouvelleCampagne != null) {
      setState(() {
        _campaigns.insert(0, nouvelleCampagne); // Ajoute en haut de la liste
      });

      // Petit message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Campagne ajoutée avec succès !'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _onSearchChanged(String value) {
    debugPrint('🔍 Recherche: $value');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Campagnes',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),

                  GestureDetector(
                    onTap: _onAddCampaignPressed, // Appelle la fonction de navigation
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 21,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9500),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 17,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Nouvelle',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
              ),
            ),

            Container(
              height: 1,
              color: Colors.grey.withOpacity(0.2),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Rechercher une campagne...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 17,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: 22,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.15),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.15),
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 14,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                children: List.generate(
                  _campaigns.length,
                      (index) {
                    final campaign = _campaigns[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CampaignCard(
                        title: campaign['title'],
                        location: campaign['location'],
                        participants: campaign['participants'],
                        dates: campaign['dates'],
                        supervisor: campaign['supervisor'],
                        status: campaign['status'],
                        statusColor: campaign['statusColor'],
                        statusTextColor: campaign['statusTextColor'],
                        progress: campaign['progress'],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 130),
          ],
        ),
      ),
    );
  }
}


