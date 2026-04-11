import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';

import '../../../models/prise_contact_model.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/custom_dropdown.dart';
import 'widgets/custom_date_picker.dart';
import 'widgets/form_section.dart';

class PrisedeContactForm extends StatefulWidget {
  final PriseContactModel? contact;
  const PrisedeContactForm({super.key, this.contact});

  @override
  State<PrisedeContactForm> createState() => _PrisedeContactFormState();
}

class _PrisedeContactFormState extends State<PrisedeContactForm> {
  final _formKey = GlobalKey<FormState>();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _objectController = TextEditingController();
  final TextEditingController _agencyController = TextEditingController();
  final TextEditingController _quarterController = TextEditingController();
  final TextEditingController _siteController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();

  DateTime? _contactDate;
  String? _selectedDirection;

  late Map<String, bool> _pointsAbordables;

  final List<String> _directions = [
    'DRC', 'DRCS', 'DRBC', 'DRAS', 'DRABO', 'DRYOP', 'DRCO',
    'DRLO', 'DRAN', 'DRO', 'DRN', 'DRSO', 'DRE', 'DRSE',
  ];

  @override
  void initState() {
    super.initState();

    // Initialisation par défaut de tous les points à false
    _pointsAbordables = {
      'Sécurité électrique': false,
      'Économie d\'énergie': false,
      'Facturation et paiement': false,
      'Branchements illicites': false,
      'Droits et devoirs du client': false,
      'Numéros d\'urgence': false,
    };

    // --- MAGIE DE L'ÉDITION : PRÉ-REMPLISSAGE ---
    if (widget.contact != null) {
      final c = widget.contact!;
      _nameController.text = c.nomContact;
      _phoneController.text = c.telephone;
      _objectController.text = c.objetMission;
      _agencyController.text = c.agence ?? '';
      _quarterController.text = c.quartier ?? '';
      _siteController.text = c.site ?? '';
      _observationsController.text = c.observations ?? '';

      _contactDate = c.date;
      _dateController.text = DateFormat('dd/MM/yyyy').format(_contactDate!);

      // On s'assure que la DR existe dans la liste
      if (_directions.contains(c.directionRegionale)) {
        _selectedDirection = c.directionRegionale;
      }

      // On coche les points qui avaient été sélectionnés
      for (var point in c.pointsAbordes) {
        if (_pointsAbordables.containsKey(point)) {
          _pointsAbordables[point] = true;
        } else {
          _pointsAbordables[point] = true; // Si c'est un point custom
        }
      }
    } else {
      // --- MODE NOUVEAU CONTACT ---
      _contactDate = DateTime.now();
      _dateController.text = DateFormat('dd/MM/yyyy').format(_contactDate!);

      // Points par défaut pour un nouveau contact
      _pointsAbordables['Économie d\'énergie'] = true;
      _pointsAbordables['Facturation et paiement'] = true;
      _pointsAbordables['Branchements illicites'] = true;
    }
  }

  @override
  void dispose() {
    _signatureController.dispose();
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

  Future<void> _onSave() async {
    if (_formKey.currentState!.validate() && _selectedDirection != null) {
      final checkedPoints = _pointsAbordables.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

      // --- GESTION DE LA SIGNATURE ---
      // On garde l'ancienne signature par défaut
      String? base64Signature = widget.contact?.signatureBase64;

      // Si l'utilisateur a dessiné quelque chose de nouveau, on l'écrase
      if (_signatureController.isNotEmpty) {
        final bytes = await _signatureController.toPngBytes();
        if (bytes != null) {
          base64Signature = base64Encode(bytes);
        }
      }

      final newContact = PriseContactModel(
        id: widget.contact?.id, // CRUCIAL : On conserve l'ancien ID
        seanceId: widget.contact?.seanceId ?? 1,
        nomContact: _nameController.text.trim(),
        telephone: _phoneController.text.trim(),
        date: _contactDate ?? DateTime.now(),
        objetMission: _objectController.text.trim(),
        directionRegionale: _selectedDirection!,
        agence: _agencyController.text.isNotEmpty ? _agencyController.text.trim() : null,
        quartier: _quarterController.text.isNotEmpty ? _quarterController.text.trim() : null,
        site: _siteController.text.isNotEmpty ? _siteController.text.trim() : null,
        pointsAbordes: checkedPoints,
        observations: _observationsController.text.isNotEmpty ? _observationsController.text.trim() : null,
        signatureBase64: base64Signature, // Injecté ici (nouveau ou ancien conservé)
      );

      if (mounted) {
        Navigator.pop(context, newContact);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- NOUVEAU : VARIABLES DYNAMIQUES SELON LE MODE ---
    final isEditing = widget.contact != null;
    final appBarTitle = isEditing ? 'Modifier un contact' : 'Nouveau contact';
    final buttonText = isEditing ? 'Modifier le contact' : 'Enregistrer le contact';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: _onBackPressed,
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 28,
          ),
        ),
        title: Text(
          appBarTitle, // Texte dynamique
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
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
                                    color: entry.value
                                        ? const Color(0xFFFF9500)
                                        : Colors.grey[400]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  color: entry.value
                                      ? const Color(0xFFFF9500)
                                      : Colors.transparent,
                                ),
                                child: entry.value
                                    ? const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
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

              FormSection(
                title: 'Signature',
                children: [
                  if (isEditing && widget.contact!.signatureBase64 != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Une signature existe déjà. Ne dessinez rien ici si vous souhaitez la conserver.",
                        style: TextStyle(color: Colors.orange[800], fontSize: 13, fontStyle: FontStyle.italic),
                      ),
                    ),
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFFF8000).withOpacity(0.3),
                        width: 2,
                      ),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Signature(
                        controller: _signatureController,
                        backgroundColor: Colors.grey[50]!,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _signatureController.clear(),
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Colors.redAccent,
                      ),
                      label: const Text(
                        'Effacer la signature',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              FormSection(
                title: 'Observations',
                children: [
                  CustomTextField(
                    label: '',
                    hint: 'Notes et observations...',
                    controller: _observationsController,
                    maxLines: 6,
                  ),
                ],
              ),
              const SizedBox(height: 32),

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
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        buttonText, // Texte dynamique
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16,
                        ),
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