import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports Provider
import '../../../providers/gadget_provider.dart';
import '../../../models/gadget_model.dart';

// Imports Widgets
import '../../home/home_view.dart';
import '../animated_section.dart';
import 'widgets/gadget_header.dart';
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
  }

  void _onGadgetTapped(GadgetModel gadget) {
    debugPrint('📦 Gadget sélectionné: ${gadget.name}');
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

                  AnimatedSection(
                    delayMs: 0,
                    child: GadgetHeader(onScannerPressed: _onScannerPressed),
                  ),

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
                                'Aucun gadget trouvé.',
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
                                        onTap: () => _onGadgetTapped(gadget),
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