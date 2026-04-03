import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports Model & Provider
import '../../models/campaign_model.dart';
import '../../providers/campaign_provider.dart';

// Imports form
import '../widgets/animated_section.dart';
import '../widgets/forms/campaign_form.dart';

// Imports Widgets
import 'widgets/campaign_header.dart';
import 'widgets/campaign_search_bar.dart';
import 'widgets/campaign_card.dart';


class CampaignView extends StatefulWidget {
  const CampaignView({super.key});

  @override
  State<CampaignView> createState() => _CampaignViewState();
}

class _CampaignViewState extends State<CampaignView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onAddCampaignPressed(BuildContext context, CampaignProvider provider) async {
    final newCampaign = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CampaignForm()),
    );

    if (newCampaign != null && newCampaign is CampaignModel) {
      provider.addCampaign(newCampaign);

      _searchController.clear();
      provider.filterCampaigns('');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Séance ajoutée et prête pour synchronisation !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CampaignProvider(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Consumer<CampaignProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  AnimatedSection(
                    delayMs: 0,
                    child: CampaignHeader(
                      onAddPressed: () => _onAddCampaignPressed(context, provider),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          AnimatedSection(
                            delayMs: 150,
                            child: CampaignSearchBar(
                              controller: _searchController,
                              onChanged: provider.filterCampaigns,
                            ),
                          ),


                          // Gestion du chargement
                          if (provider.isLoading)
                            const Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: CircularProgressIndicator(color: Color(0xFFFF9500)),
                            )
                          else if (provider.filteredCampaigns.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: Text(
                                'Aucune séance trouvée.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          else
                            AnimatedSection(
                              delayMs: 300,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: provider.groupByLocalite.entries.map((entry) {

                                    String localite = entry.key; // Nom de la commune
                                    List<CampaignModel> seances = entry.value; // Fiches de la commune

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          child: Text(
                                            '📍 $localite',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFFFF9500)
                                            ),
                                          ),
                                        ),
                                        ...seances.map((seance) => Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: CampaignCard(campaign: seance),
                                        )).toList(),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),

                          const SizedBox(height: 45),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}