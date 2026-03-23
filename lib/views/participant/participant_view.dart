import 'package:flutter/material.dart';

// Imports Model & Data
import '../../models/participant_model.dart';
import '../../data/participant_data.dart';


import '../widgets/forms/inscription_form.dart';
import 'widgets/inscriptions_header.dart';
import 'widgets/inscriptions_search_bar.dart';
import 'widgets/participant_card.dart';

class InscriptionsView extends StatefulWidget {
  const InscriptionsView({super.key});

  @override
  State<InscriptionsView> createState() => _InscriptionsViewState();
}

class _InscriptionsViewState extends State<InscriptionsView> {
  final TextEditingController _searchController = TextEditingController();

  List<ParticipantModel> _allParticipants = [];
  List<ParticipantModel> _filteredParticipants = [];

  @override
  void initState() {
    super.initState();
    _allParticipants = ParticipantData.getParticipants();
    _filteredParticipants = _allParticipants;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Logique de recherche : Filtre par ID, Nom ou Zone (location)
  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredParticipants = _allParticipants;
      } else {
        final searchLower = query.toLowerCase();
        _filteredParticipants = _allParticipants.where((participant) {
          return participant.id.toLowerCase().contains(searchLower) ||
              participant.name.toLowerCase().contains(searchLower) ||
              participant.location.toLowerCase().contains(searchLower);
        }).toList();
      }
    });
  }

  Future<void> _onAddParticipantPressed() async {
    final nouveauParticipant = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InscriptionForm()),
    );

    if (nouveauParticipant != null && nouveauParticipant is ParticipantModel) {
      setState(() {
        _allParticipants.insert(0, nouveauParticipant);
        _onSearchChanged(_searchController.text); // Rafraîchir la liste filtrée
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Participant ajouté avec succès !'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. En-tête avec bouton Ajouter
            InscriptionsHeader(onAddPressed: _onAddParticipantPressed),

            // 2. Barre de recherche
            InscriptionsSearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
            ),

            // 3. Compteur de résultats (Dynamique !)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_filteredParticipants.length} participant(s) trouvé(s)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            // 4. Liste des cartes participants
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _filteredParticipants.map((participant) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ParticipantCard(participant: participant),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 130),
          ],
        ),
      ),
    );
  }
}
