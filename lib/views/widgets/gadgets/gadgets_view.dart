import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports Provider
import '../../../providers/gadget_provider.dart';
import '../../../models/gadget_model.dart';

// Imports Widgets
import '../../home/home_view.dart';
import '../animated_section.dart';
import 'widgets/gadget_header.dart'; // <-- Nouveau Header fixe
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

  void _onScannerPressed() {
    debugPrint('📱 Scanner QR - Lancer scan');
    // Logique de navigation vers la vue du scanner
  }

  void _onGadgetTapped(GadgetModel gadget) {
    debugPrint('📦 Gadget sélectionné: ${gadget.name}');
    // Logique pour voir les détails d'un gadget
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GadgetProvider(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Consumer<GadgetProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  // 1. HEADER FIXE (Apparaît immédiatement)
                  AnimatedSection(
                    delayMs: 0,
                    child: GadgetHeader(onScannerPressed: _onScannerPressed),
                  ),

                  // 2. ZONE DE DÉFILEMENT
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // La barre de recherche (Cascade à 150ms)
                          AnimatedSection(
                            delayMs: 150,
                            child: GadgetSearchBar(
                              controller: _searchController,
                              onChanged: provider.filterGadgets,
                            ),
                          ),

                          // Espacement pour aérer
                          const SizedBox(height: 16),

                          // 3. Gestion de l'état de chargement et liste
                          if (provider.isLoading)
                            const Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: CircularProgressIndicator(color: Color(0xFFFF9500)),
                            )
                          else if (provider.filteredGadgets.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: Text(
                                'Aucun gadget trouvé.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          else
                          // La liste des gadgets filtrée (Cascade à 300ms)
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
                                        onTap: () => _onGadgetTapped(gadget),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),

                          // Espace vide en bas pour le scroll
                          const SizedBox(height: 130),
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