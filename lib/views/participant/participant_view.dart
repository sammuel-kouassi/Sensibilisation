import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Future<void> _onAddParticipantPressed(
    BuildContext context,
    ParticipantProvider provider,
  ) async {
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

  Future<void> _onEditParticipant(
    BuildContext context,
    ParticipantProvider provider,
    ParticipantModel participant,
  ) async {
    final updatedParticipant = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParticipantForm(participant: participant),
      ),
    );

    if (updatedParticipant != null && updatedParticipant is ParticipantModel) {
      provider.updateParticipant(updatedParticipant);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Participant modifié avec succès !'),
            backgroundColor: Colors.blue,
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
                      onAddPressed: () =>
                          _onAddParticipantPressed(context, provider),
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
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                10,
                                24,
                                10,
                              ),
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
                              child: CircularProgressIndicator(
                                color: Color(0xFFFF9500),
                              ),
                            )
                          else if (provider.filteredParticipants.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: Text(
                                'Aucun participant trouvé.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          else
                            AnimatedSection(
                              delayMs: 450,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  children: provider.filteredParticipants.map((
                                    participant,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: Dismissible(
                                        key: Key(participant.id.toString()),
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.only(
                                            right: 24,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade400,
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        ),

                                        confirmDismiss: (direction) async {
                                          return await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              title: const Row(
                                                children: [
                                                  Icon(
                                                    Icons.warning_amber_rounded,
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text('Confirmation'),
                                                ],
                                              ),
                                              content: Text(
                                                'Voulez-vous vraiment supprimer ${participant.firstName} ${participant.lastName} ?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(false),
                                                  child: Text(
                                                    'ANNULER',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(true),
                                                  child: const Text(
                                                    'SUPPRIMER',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },

                                        onDismissed: (direction) {
                                          provider.deleteParticipant(
                                            participant.id!,
                                            participant.id,
                                          );
                                        },

                                        child: ParticipantCard(
                                          participant: participant,
                                          onEdit: () => _onEditParticipant(
                                            context,
                                            provider,
                                            participant,
                                          ),
                                        ),
                                      ),
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
