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

  static const _orange = Color(0xFFFF8000);
  static const _dark = Color(0xFF1E293B);

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
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.inventory_2_outlined, color: Colors.white),
              SizedBox(width: 10),
              Text('Le stock pour cette séance est épuisé.'),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── En-tête dialog ──
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.card_giftcard_rounded,
                        color: _orange, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Distribuer des gadgets',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: _dark,
                          ),
                        ),
                        Text(
                          gadget.seanceNom,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Stock restant ──
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stock restant',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${gadget.restants} gadgets',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: _dark,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Champ quantité ──
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  labelText: 'Quantité à distribuer',
                  labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                  prefixIcon: const Icon(Icons.remove_red_eye_outlined,
                      color: _orange, size: 20),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: Color(0xFFEEF0F3), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _orange, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),

              const SizedBox(height: 20),

              // ── Boutons ──
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: const Color(0xFFEEF0F3), width: 1),
                        ),
                        child: const Center(
                          child: Text(
                            'Annuler',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _dark,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final quantity =
                            int.tryParse(quantityController.text) ?? 0;
                        if (quantity > 0 && quantity <= gadget.restants) {
                          provider.distributeGadget(gadget, quantity);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(Icons.check_circle_rounded,
                                      color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Stock mis à jour !'),
                                ],
                              ),
                              backgroundColor: Colors.green[700],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(Icons.error_outline_rounded,
                                      color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Quantité invalide.'),
                                ],
                              ),
                              backgroundColor: Colors.red[600],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: _orange,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text(
                            'Valider',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Consumer<GadgetProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              // ── AppBar gradient ──
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                backgroundColor: _orange,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  // Badge total gadgets
                  if (!provider.isLoading &&
                      provider.filteredGadgets.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        '${provider.filteredGadgets.length} séance(s)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_orange, Color(0xFFe06b00)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20, top: -20,
                          child: Container(
                            width: 140, height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.07),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -30, bottom: -10,
                          child: Container(
                            width: 100, height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gadgets',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Gestion et distribution par séance',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Barre de recherche ──
              SliverToBoxAdapter(
                child: AnimatedSection(
                  delayMs: 100,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: GadgetSearchBar(
                      controller: _searchController,
                      onChanged: provider.filterGadgets,
                    ),
                  ),
                ),
              ),

              // ── États ──
              if (provider.isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: _orange),
                  ),
                )

              else if (provider.errorMessage != null)
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.wifi_off_rounded,
                                size: 40, color: Colors.grey[300]),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            provider.errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: () =>
                                provider.loadGadgets(forceSync: true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                              decoration: BoxDecoration(
                                color: _orange,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.refresh_rounded,
                                      color: Colors.white, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'Réessayer',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )

              else if (provider.filteredGadgets.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.search_off_rounded,
                                size: 40, color: Colors.grey[300]),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucune séance trouvée',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Essayez un autre terme de recherche',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                // ── Liste des gadgets ──
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final gadget = provider.filteredGadgets[index];
                          return AnimatedSection(
                            delayMs: 200 + (index * 60),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GadgetCard(
                                gadget: gadget,
                                onTap: () => _onGadgetTapped(
                                    context, gadget, provider),
                              ),
                            ),
                          );
                        },
                        childCount: provider.filteredGadgets.length,
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}