import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/rdv_model.dart';
import '../../../providers/rdv_provider.dart';

import '../forms/rendez-vous_form.dart';
import 'widgets/rdv_header.dart';
import 'widgets/rdv_card.dart';

class RdvView extends StatelessWidget {
  const RdvView({super.key});

  Future<void> _onPlanifierPressed(
    BuildContext context,
    RdvProvider provider,
  ) async {
    final nouveauRdv = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RdvForm()),
    );

    if (nouveauRdv != null && nouveauRdv is RdvModel) {
      provider.addRdv(nouveauRdv);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rendez-vous planifié avec succès !'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ⚠️ CORRECTION : Plus de ChangeNotifierProvider ici !
    // On retourne directement le Scaffold.
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Consumer<RdvProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  RdvHeader(
                    onPlanifierPressed: () =>
                        _onPlanifierPressed(context, provider),
                  ),

                  const SizedBox(height: 24),

                  if (provider.isLoading)
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFF97316),
                        ),
                      ),
                    )
                  else if (provider.rdvs.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Aucun rendez-vous prévu.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: provider.rdvs.length,
                        itemBuilder: (context, index) {
                          final rdv = provider.rdvs[index];

                          // ⚠️ NOUVEAU : On englobe la RdvCard dans un Dismissible
                          return Dismissible(
                            key: Key('rdv_${rdv.id}'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            confirmDismiss: (_) async {
                              // Boîte de dialogue de confirmation
                              return await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Supprimer ?'),
                                  content: Text(
                                    'Voulez-vous supprimer le RDV "${rdv.titre}" ?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('ANNULER'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text(
                                        'SUPPRIMER',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (_) {
                              // On demande au provider de supprimer l'élément
                              provider.deleteRdv(rdv.id!, null);
                            },
                            child: RdvCard(
                              rdv: rdv,
                              onEdit: () async {
                                // On ouvre le formulaire en lui passant le rdv actuel
                                final updatedRdv = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RdvForm(rdv: rdv),
                                  ),
                                );

                                // Si l'utilisateur valide les modifications
                                if (updatedRdv != null &&
                                    updatedRdv is RdvModel) {
                                  provider.updateRdv(updatedRdv);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
