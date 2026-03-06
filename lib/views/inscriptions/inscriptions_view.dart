import 'package:cie_services/views/inscriptions/widgets/participant_card.dart';
import 'package:flutter/material.dart';

class InscriptionsView extends StatefulWidget {
  const InscriptionsView({super.key});

  @override
  State<InscriptionsView> createState() => _InscriptionsViewState();
}

class _InscriptionsViewState extends State<InscriptionsView> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _participants = [
    {
      'id': 'P001',
      'name': 'Ouattara Ibrahim',
      'phone': '0701234567',
      'location': 'Abobo',
      'date': '2026-02-15',
      'campaign': 'Sensibilisation Abobo',
      'status': 'Actif',
      'statusColor': const Color(0xFFD4F1E4),
      'statusTextColor': const Color(0xFF4CAF50),
    },
    {
      'id': 'P002',
      'name': 'Coulibaly Mariam',
      'phone': '0507654321',
      'location': 'Yopougon',
      'date': '2026-02-10',
      'campaign': 'Campagne Yopougon Nord',
      'status': 'Actif',
      'statusColor': const Color(0xFFD4F1E4),
      'statusTextColor': const Color(0xFF4CAF50),
    },
    {
      'id': 'P003',
      'name': 'Konan Serge',
      'phone': '0102345678',
      'location': 'Cocody',
      'date': '2026-01-20',
      'campaign': 'Sensibilisation Cocody',
      'status': 'Archivé',
      'statusColor': const Color(0xFFF0F0F0),
      'statusTextColor': const Color(0xFF999999),
    },
    {
      'id': 'P004',
      'name': 'N\'Dri Ange',
      'phone': '0756432109',
      'location': 'Plateau',
      'date': '2026-02-12',
      'campaign': 'Sensibilisation Plateau',
      'status': 'Actif',
      'statusColor': const Color(0xFFD4F1E4),
      'statusTextColor': const Color(0xFF4CAF50),
    },
    {
      'id': 'P005',
      'name': 'Bah Fatoumata',
      'phone': '0698765432',
      'location': 'Treichville',
      'date': '2026-02-08',
      'campaign': 'Sensibilisation Treichville',
      'status': 'Actif',
      'statusColor': const Color(0xFFD4F1E4),
      'statusTextColor': const Color(0xFF4CAF50),
    },
  ];

  void _onAddParticipantPressed() {
    debugPrint('✅ Bouton + Ajouter cliqué - Ajouter un participant');
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
                    'Participants',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),

                  GestureDetector(
                    onTap: _onAddParticipantPressed,
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
                            'Ajouter',
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
                  hintText: 'Rechercher (ID, nom, zone)...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
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
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_participants.length} participant(s) trouvé(s)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                children: List.generate(
                  _participants.length,
                      (index) {
                    final participant = _participants[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ParticipantCard(
                        id: participant['id'],
                        name: participant['name'],
                        phone: participant['phone'],
                        location: participant['location'],
                        date: participant['date'],
                        campaign: participant['campaign'],
                        status: participant['status'],
                        statusColor: participant['statusColor'],
                        statusTextColor: participant['statusTextColor'],
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


