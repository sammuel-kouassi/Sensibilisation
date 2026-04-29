import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/gadget_provider.dart';
import '../../../models/gadget_model.dart';

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

  void _onGadgetTapped(
      BuildContext context,
      GadgetModel gadget,
      GadgetProvider provider,
      ) {
    if (gadget.isOutOfStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le stock pour cette séance est épuisé.')),
      );
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ANNULER'),
          ),
          ElevatedButton(
            onPressed: () {
              final quantity = int.tryParse(quantityController.text) ?? 0;
              if (quantity > 0 && quantity <= gadget.restants) {
                provider.distributeGadget(gadget, quantity);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Stock mis à jour !'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Quantité invalide.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9500),
            ),
            child: const Text('VALIDER', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

                        // --- États ---
                        if (provider.isLoading)
                          const Padding(
                            padding: EdgeInsets.only(top: 50.0),
                            child: CircularProgressIndicator(
                              color: Color(0xFFFF9500),
                            ),
                          )

                        // Premier lancement hors-ligne
                        else if (provider.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 60,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.wifi_off_rounded,
                                  size: 64,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  provider.errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      provider.loadGadgets(forceSync: true),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Réessayer'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF9500),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )

                        else if (provider.filteredGadgets.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: Text(
                                'Aucune séance trouvée.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )

                          // Liste des gadgets
                          else
                            AnimatedSection(
                              delayMs: 300,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Column(
                                  children: provider.filteredGadgets.map((
                                      gadget,
                                      ) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: GadgetCard(
                                        gadget: gadget,
                                        onTap: () => _onGadgetTapped(
                                          context,
                                          gadget,
                                          provider,
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
    );
  }
}