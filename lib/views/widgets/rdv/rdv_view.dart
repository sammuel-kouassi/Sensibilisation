import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports Model & Provider
import '../../../models/rdv_model.dart';
import '../../../providers/rdv_provider.dart';

// Imports Form & Widgets
import '../forms/participant_form.dart'; // À remplacer par RdvForm si tu en crées un plus tard
import 'widgets/rdv_header.dart';
import 'widgets/rdv_card.dart';

class RdvView extends StatelessWidget {
  const RdvView({super.key});

  // Méthode de navigation vers le formulaire
  Future<void> _onPlanifierPressed(BuildContext context, RdvProvider provider) async {
    debugPrint("Ouvrir le formulaire de planification");

    final nouveauRdv = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ParticipantForm(), // ou RdvForm()
      ),
    );

    // Si le formulaire renvoie un objet RdvModel, on l'ajoute via le provider
    if (nouveauRdv != null && nouveauRdv is RdvModel) {
      provider.addRdv(nouveauRdv);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rendez-vous planifié avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RdvProvider(),
      child: Scaffold(
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

                    // 1. En-tête (Titre + Boutons)
                    // On passe la fonction en lui donnant le context et le provider
                    RdvHeader(
                      onPlanifierPressed: () => _onPlanifierPressed(context, provider),
                    ),

                    const SizedBox(height: 24),

                    // 2. Gestion du chargement et de la liste
                    if (provider.isLoading)
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(color: Color(0xFFF97316)),
                        ),
                      )
                    else if (provider.rdvs.isEmpty)
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Aucun rendez-vous prévu.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                    // 3. Liste des Rendez-vous
                      Expanded(
                        child: ListView.builder(
                          itemCount: provider.rdvs.length,
                          itemBuilder: (context, index) {
                            final rdv = provider.rdvs[index];
                            return RdvCard(rdv: rdv);
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}