import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports Provider
import '../../../providers/gadget_provider.dart';
import '../../../models/gadget_model.dart';

// Imports Widgets
import '../animated_section.dart';
import 'widgets/gadget_search_bar.dart';
import 'widgets/gadget_card.dart';

class GadgetsView extends StatefulWidget {
  const GadgetsView({super.key});

  @override
  State<GadgetsView> createState() => _GadgetsViewState();
}

class _GadgetsViewState extends State<GadgetsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onGadgetTapped(BuildContext context, GadgetModel gadget, GadgetProvider provider) {
    if (gadget.isOutOfStock) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Le stock pour cette séance est épuisé.')));
      return;
    }

    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Distribuer - ${gadget.seanceNom}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Stock restant : ${gadget.restants} gadgets.'),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantité à distribuer',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ANNULER')),
          ElevatedButton(
            onPressed: () {
              final quantity = int.tryParse(quantityController.text) ?? 0;
              if (quantity > 0 && quantity <= gadget.restants) {
                provider.distributeGadget(gadget, quantity);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock mis à jour !'), backgroundColor: Colors.green));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quantité invalide.'), backgroundColor: Colors.red));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF9500)),
            child: const Text('VALIDER', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ⚠️ On retourne directement Scaffold (n'oublie pas d'ajouter GadgetProvider dans main.dart !)
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Consumer<GadgetProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AnimatedSection(
                          delayMs: 150,
                          child: GadgetSearchBar(
                            controller: _searchController,
                            onChanged: provider.filterGadgets,
                          ),
                        ),
                        const SizedBox(height: 16),

                        if (provider.isLoading)
                          const Padding(
                            padding: EdgeInsets.only(top: 50.0),
                            child: CircularProgressIndicator(color: Color(0xFFFF9500)),
                          )
                        else if (provider.filteredGadgets.isEmpty)
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
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: provider.filteredGadgets.map((gadget) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: GadgetCard(
                                      gadget: gadget,
                                      // ⚠️ CORRECTION ICI : On passe bien les 3 arguments !
                                      onTap: () => _onGadgetTapped(context, gadget, provider),
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
    );
  }
}