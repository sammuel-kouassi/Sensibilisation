import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/prise_contact_model.dart';
import '../../../providers/prise_contact_provider.dart';
import '../forms/prisecontact_form.dart';
import 'PriseContactCard.dart';

class PriseContactView extends StatefulWidget {
  const PriseContactView({super.key});

  @override
  State<PriseContactView> createState() => _PriseContactViewState();
}

class _PriseContactViewState extends State<PriseContactView> {
  final TextEditingController _searchController = TextEditingController();

  Future<void> _onAddContact(BuildContext context, PriseContactProvider provider) async {
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Prises de contact',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
          actions: [
            Consumer<PriseContactProvider>(
              builder: (context, provider, _) => IconButton(
                icon: const Icon(Icons.add_circle, color: Color(0xFFFF9500), size: 30),
                onPressed: () => _onAddContact(context, provider),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Consumer<PriseContactProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: provider.filterContacts,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un contact...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF9500)))
                      : provider.filteredContacts.isEmpty
                      ? const Center(child: Text('Aucune prise de contact.'))
                      : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = provider.filteredContacts[index];
                      return Dismissible(
                        key: Key('contact_${contact.id}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async => await _showConfirmDialog(context, contact),
                        onDismissed: (_) => provider.deleteContact(contact.id!, null),
                        child: PriseContactCard(
                          contact: contact,
                          onEdit: () async {
                            final updated = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => PrisedeContactForm(contact: contact))
                            );
                            if(updated != null) provider.updateContact(updated);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context, PriseContactModel contact) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ?'),
        content: Text('Voulez-vous supprimer le contact de ${contact.nomContact} ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ANNULER')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('SUPPRIMER', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}