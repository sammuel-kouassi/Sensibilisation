import 'package:flutter/material.dart';

// Imports Model & Data
import '../../models/gadget_model.dart';
import '../../data/gadget_data.dart';

// Imports Widgets
import 'widgets/gadget_sliver_app_bar.dart';
import 'widgets/gadget_search_bar.dart';
import 'widgets/gadget_card.dart';

class GadgetsView extends StatefulWidget {
  const GadgetsView({super.key});

  @override
  State<GadgetsView> createState() => _GadgetsViewState();
}

class _GadgetsViewState extends State<GadgetsView> {
  final TextEditingController _searchController = TextEditingController();

  List<GadgetModel> _allGadgets = [];
  List<GadgetModel> _filteredGadgets = [];

  @override
  void initState() {
    super.initState();
    // Chargement des données
    _allGadgets = GadgetData.getGadgets();
    _filteredGadgets = _allGadgets;

    // Écoute des changements de la barre de recherche
    _searchController.addListener(_filterGadgets);
  }

  void _filterGadgets() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredGadgets = _allGadgets;
      } else {
        _filteredGadgets = _allGadgets.where((gadget) {
          return gadget.name.toLowerCase().contains(query) ||
              gadget.category.toLowerCase().contains(query);
        }).toList();
      }
    });
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // 1. La Sliver App Bar
          GadgetSliverAppBar(onScannerPressed: _onScannerPressed),

          // 2. La barre de recherche (Adaptée en SliverToBoxAdapter)
          SliverToBoxAdapter(
            child: GadgetSearchBar(controller: _searchController),
          ),

          // 3. La liste des gadgets
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final gadget = _filteredGadgets[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GadgetCard(
                      gadget: gadget,
                      onTap: () => _onGadgetTapped(gadget),
                    ),
                  );
                },
                childCount: _filteredGadgets.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}