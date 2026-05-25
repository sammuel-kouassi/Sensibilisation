import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/prise_contact_model.dart';
import '../../../providers/prise_contact_provider.dart';
import '../forms/prisecontact_form.dart';
import 'contact_history_view.dart';

class PriseContactView extends StatefulWidget {
  const PriseContactView({super.key});

  @override
  State<PriseContactView> createState() => _PriseContactViewState();
}

class _PriseContactViewState extends State<PriseContactView> {
  final TextEditingController _searchController = TextEditingController();

  static const _orange = Color(0xFFFF8000);
  static const _dark = Color(0xFF1E293B);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onAddContact(
      BuildContext context,
      PriseContactProvider provider,
      ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrisedeContactForm()),
    );
    if (result != null && result is PriseContactModel) {
      provider.addContact(result);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 10),
                Text('Contact ajouté avec succès !'),
              ],
            ),
            backgroundColor: Colors.green[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PriseContactProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: Consumer<PriseContactProvider>(
          builder: (context, provider, child) {
            return CustomScrollView(
              slivers: [
                // ── AppBar gradient orange ──
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
                    GestureDetector(
                      onTap: () => _onAddContact(context, provider),
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add_rounded,
                                color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Nouveau',
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
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding:
                              const EdgeInsets.fromLTRB(20, 0, 20, 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Prises de contact',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    provider.filteredContacts.isEmpty
                                        ? 'Aucun contact enregistré'
                                        : '${provider.filteredContacts.length} contact(s)',
                                    style: const TextStyle(
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFEEF0F3), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: provider.filterContacts,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Rechercher un contact...',
                          hintStyle: TextStyle(
                              color: Colors.grey[400], fontSize: 14),
                          prefixIcon: Icon(Icons.search_rounded,
                              color: Colors.grey[400], size: 20),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              provider.filterContacts('');
                              setState(() {});
                            },
                            child: Icon(Icons.close_rounded,
                                color: Colors.grey[400], size: 18),
                          )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Contenu ──
                if (provider.isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: _orange),
                    ),
                  )
                else if (provider.filteredContacts.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              color: _orange.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.contact_phone_outlined,
                              size: 40,
                              color: _orange.withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Aucune prise de contact',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _dark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Appuyez sur "Nouveau" pour enregistrer\nvotre premier contact',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 28),
                          GestureDetector(
                            onTap: () => _onAddContact(context, provider),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                              decoration: BoxDecoration(
                                color: _orange,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: _orange.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add_rounded,
                                      color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Nouveau contact',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 4, bottom: 40),
                    sliver: SliverToBoxAdapter(
                      child: ContactHistoryView(
                        contacts: provider.filteredContacts,
                        onEdit: (contact) async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PrisedeContactForm(contact: contact),
                            ),
                          );
                          if (updated != null) {
                            provider.updateContact(updated);
                          }
                        },
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