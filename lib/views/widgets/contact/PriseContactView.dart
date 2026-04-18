import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/prise_contact_model.dart';
import '../../../providers/prise_contact_provider.dart';
import '../forms/prisecontact_form.dart';
import 'contact_history_view.dart';
import 'contact_list_item.dart';

class PriseContactView extends StatefulWidget {
  const PriseContactView({super.key});

  @override
  State<PriseContactView> createState() => _PriseContactViewState();
}

class _PriseContactViewState extends State<PriseContactView> {
  final TextEditingController _searchController = TextEditingController();

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PriseContactProvider(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Consumer<PriseContactProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Prises de contact',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Color(0xFFFF9500),
                            size: 32,
                          ),
                          onPressed: () => _onAddContact(context, provider),
                        ),
                      ],
                    ),
                  ),

                  // Barre de recherche
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: provider.filterContacts,
                      decoration: InputDecoration(
                        hintText: 'Rechercher un contact...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: provider.isLoading
                          ? const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFFF9500),
                                ),
                              ),
                            )
                          : provider.filteredContacts.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text('Aucune prise de contact.'),
                              ),
                            )
                          : ContactHistoryView(
                              contacts: provider.filteredContacts,
                              onEdit: (contact) async {
                                final updated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PrisedeContactForm(contact: contact),
                                  ),
                                );
                                if (updated != null)
                                  provider.updateContact(updated);
                              },
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

  Future<bool?> _showConfirmDialog(
    BuildContext context,
    PriseContactModel contact,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ?'),
        content: Text(
          'Voulez-vous supprimer le contact de ${contact.nomContact} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ANNULER'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('SUPPRIMER', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
