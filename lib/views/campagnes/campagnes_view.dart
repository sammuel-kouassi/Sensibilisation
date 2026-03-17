import 'package:flutter/material.dart';

// Imports Model & Data
import '../../models/campaign_model.dart';
import '../../data/campaign_data.dart';

// Imports form
import '../formulaire/campagne_form.dart';

// Imports Widgets
import 'widgets/campaign_header.dart';
import 'widgets/campaign_search_bar.dart';
import 'widgets/campaign_card.dart';

class CampagnesView extends StatefulWidget {
  const CampagnesView({super.key});

  @override
  State<CampagnesView> createState() => _CampagnesViewState();
}

class _CampagnesViewState extends State<CampagnesView> {
  final TextEditingController _searchController = TextEditingController();

  // Listes pour gérer l'état et la recherche
  List<CampaignModel> _allCampaigns = [];
  List<CampaignModel> _filteredCampaigns = [];

  @override
  void initState() {
    super.initState();
    // Initialisation des données
    _allCampaigns = CampaignData.getCampaigns();
    _filteredCampaigns = _allCampaigns;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Logique de recherche (filtre par titre ou localisation)
  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCampaigns = _allCampaigns;
      } else {
        _filteredCampaigns = _allCampaigns.where((campaign) {
          final titleLower = campaign.title.toLowerCase();
          final locationLower = campaign.location.toLowerCase();
          final searchLower = query.toLowerCase();
          return titleLower.contains(searchLower) || locationLower.contains(searchLower);
        }).toList();
      }
    });
  }

  // Ajout d'une nouvelle campagne
  Future<void> _onAddCampaignPressed() async {
    final nouvelleCampagne = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CampagneForm()),
    );

    // Attention: Ton formulaire devra renvoyer un objet 'CampaignModel' pour que ça marche
    if (nouvelleCampagne != null && nouvelleCampagne is CampaignModel) {
      setState(() {
        _allCampaigns.insert(0, nouvelleCampagne);
        _onSearchChanged(_searchController.text); // Met à jour la liste visible
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Campagne ajoutée avec succès !'),
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
            // 1. Header
            CampaignHeader(onAddPressed: _onAddCampaignPressed),

            // 2. Barre de recherche
            CampaignSearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
            ),

            // 3. Liste des cartes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _filteredCampaigns.map((campaign) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CampaignCard(campaign: campaign),
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