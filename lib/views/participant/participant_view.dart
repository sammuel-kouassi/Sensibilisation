import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports Model & Provider
import '../../models/participant_model.dart';
import '../../providers/participant_provider.dart';

import '../widgets/animated_section.dart';
import '../widgets/forms/participant_form.dart';
import 'widgets/participant_header.dart';
import 'widgets/participant_search_bar.dart';
import 'widgets/participant_card.dart';


class ParticipantView extends StatefulWidget {
  const ParticipantView({super.key});

  @override
  State<ParticipantView> createState() => _ParticipantViewState();
}

class _ParticipantViewState extends State<ParticipantView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onAddParticipantPressed(BuildContext context, ParticipantProvider provider) async {
    final nouveauParticipant = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ParticipantForm()),
    );

    if (nouveauParticipant != null && nouveauParticipant is ParticipantModel) {
      provider.addParticipant(nouveauParticipant);

      _searchController.clear();
      provider.filterParticipants('');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Participant ajouté avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParticipantProvider(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Consumer<ParticipantProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [

                  AnimatedSection(
                    delayMs: 0,
                    child: ParticipantHeader(
                      onAddPressed: () => _onAddParticipantPressed(context, provider),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          AnimatedSection(
                            delayMs: 150,
                            child: ParticipantSearchBar(
                              controller: _searchController,
                              onChanged: provider.filterParticipants,
                            ),
                          ),

                          AnimatedSection(
                            delayMs: 300,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${provider.filteredParticipants.length} participant(s) trouvé(s)',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          if (provider.isLoading)
                            const Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: CircularProgressIndicator(color: Color(0xFFFF9500)),
                            )
                          else if (provider.filteredParticipants.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: Text('Aucun participant trouvé.', style: TextStyle(color: Colors.grey)),
                            )
                          else

                            AnimatedSection(
                              delayMs: 450,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: provider.filteredParticipants.map((participant) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: ParticipantCard(participant: participant),
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