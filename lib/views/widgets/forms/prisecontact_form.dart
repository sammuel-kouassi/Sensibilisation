import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/prise_contact_model.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/custom_dropdown.dart';
import 'widgets/custom_date_picker.dart';
import 'widgets/form_section.dart';

class PrisedeContactForm extends StatefulWidget {
  const PrisedeContactForm({super.key});

  @override
  State<PrisedeContactForm> createState() => _PrisedeContactFormState();
}

class _PrisedeContactFormState extends State<PrisedeContactForm> {
  final _formKey = GlobalKey<FormState>(); // Ajout pour la validation standardisée

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(); // Ajouté pour le CustomDatePicker
  final TextEditingController _objectController = TextEditingController();
  final TextEditingController _agencyController = TextEditingController();
  final TextEditingController _quarterController = TextEditingController();
  final TextEditingController _siteController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();

  DateTime? _contactDate;
  String? _selectedDirection;

  late Map<String, bool> _pointsAbordables;

  final List<String> _directions = [
    'Direction Nord',
    'Direction Sud',
    'Direction Est',
    'Direction Ouest',
    'Direction Centrale',
  ];

  @override
  void initState() {
    super.initState();
    _pointsAbordables = {
      'Sécurité électrique': false,
      'Économie d\'énergie': true,
      'Facturation et paiement': true,
      'Branchements illicites': true,
      'Droits et devoirs du client': false,
      'Numéros d\'urgence': false,
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _objectController.dispose();
    _agencyController.dispose();
    _quarterController.dispose();
    _siteController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  void _onBackPressed() {
    Navigator.pop(context);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _contactDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _contactDate) {
      setState(() {
        _contactDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _togglePoint(String point) {
    setState(() {
      _pointsAbordables[point] = !(_pointsAbordables[point] ?? false);
    });
  }

  void _onSave() {
    if (_formKey.currentState!.validate() && _selectedDirection != null) {
      // Filtrer les points cochés
      final checkedPoints = _pointsAbordables.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

      // Création du modèle
      final newContact = PriseContactModel(
        name: _nameController.text,
        phone: _phoneController.text,
        date: _dateController.text,
        object: _objectController.text,
        direction: _selectedDirection!,
        agency: _agencyController.text,
        quarter: _quarterController.text,
        site: _siteController.text,
        pointsAbordes: checkedPoints,
        observations: _observationsController.text,
      );

      // On renvoie l'objet à la page précédente
      Navigator.pop(context, newContact);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: _onBackPressed,
          child: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
        ),
        title: const Text(
          'Prise de Contact',
          style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 1. Informations générales
              FormSection(
                title: 'Informations générales',
                children: [
                  CustomTextField(
                    label: 'Nom complet',
                    hint: 'Nom et prénoms',
                    controller: _nameController,
                    isRequired: true,
                    validator: (v) => v!.isEmpty ? 'Requis' : null,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Téléphone',
                    hint: '+225 07 00 00 00',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    isRequired: true,
                    validator: (v) => v!.isEmpty ? 'Requis' : null,
                  ),
                  const SizedBox(height: 24),
                  CustomDatePicker(
                    label: 'Date',
                    hint: 'Sélectionner une date',
                    controller: _dateController,
                    onTap: _selectDate,
                    isRequired: true,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Objet de la mission',
                    hint: 'Ex: Sensibilisation sur la sécurité',
                    controller: _objectController,
                    isRequired: true,
                    validator: (v) => v!.isEmpty ? 'Requis' : null,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. Localisation
              FormSection(
                title: 'Localisation',
                icon: Icons.location_on,
                children: [
                  CustomDropdown(
                    label: 'Direction régionale',
                    hint: 'Sélectionner',
                    value: _selectedDirection,
                    items: _directions,
                    isRequired: true,
                    onChanged: (String? newValue) {
                      setState(() => _selectedDirection = newValue);
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Agence',
                    hint: 'Nom de l\'agence',
                    controller: _agencyController,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Quartier',
                          hint: 'Quartier',
                          controller: _quarterController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'Site',
                          hint: 'Site',
                          controller: _siteController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. Points abordés
              FormSection(
                title: 'Points abordés',
                children: [
                  Column(
                    children: _pointsAbordables.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () => _togglePoint(entry.key),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: entry.value ? const Color(0xFFFF9500) : Colors.grey[400]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  color: entry.value ? const Color(0xFFFF9500) : Colors.transparent,
                                ),
                                child: entry.value
                                    ? const Center(child: Icon(Icons.check, color: Colors.white, size: 18))
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 4. Signature
              FormSection(
                title: 'Signature',
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 2),
                      color: Colors.grey[50],
                    ),
                    child: Center(
                      child: Text('Zone de signature numérique', style: TextStyle(color: Colors.grey[400], fontSize: 16)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 5. Observations
              FormSection(
                title: 'Observations',
                children: [
                  CustomTextField(
                    label: '', // Pas de label au dessus
                    hint: 'Notes et observations...',
                    controller: _observationsController,
                    maxLines: 6,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 6. Bouton Enregistrer
              GestureDetector(
                onTap: _onSave,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9500),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
                      SizedBox(width: 10),
                      Text(
                        'Enregistrer le contact',
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}