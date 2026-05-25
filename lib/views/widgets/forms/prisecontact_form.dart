import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';

import '../../../models/prise_contact_model.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/custom_dropdown.dart';
import 'widgets/custom_date_picker.dart';

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

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();
  final _objectController = TextEditingController();
  final _agencyController = TextEditingController();
  final _quarterController = TextEditingController();
  final _siteController = TextEditingController();
  final _observationsController = TextEditingController();

  DateTime? _contactDate;
  String? _selectedDirection;

  late Map<String, bool> _pointsAbordables;

  static const _orange = Color(0xFFFF8000);
  static const _vert = Color(0xFF21951D);
  static const _dark = Color(0xFF1E293B);

  final List<String> _directions = [
    'DRC', 'DRCS', 'DRBC', 'DRAS', 'DRABO', 'DRYOP',
    'DRCO', 'DRLO', 'DRAN', 'DRO', 'DRN', 'DRSO', 'DRE', 'DRSE',
  ];

  @override
  void initState() {
    super.initState();
    _pointsAbordables = {
      'Sécurité électrique': false,
      'Économie d\'énergie': false,
      'Facturation et paiement': false,
      'Branchements illicites': false,
      'Droits et devoirs du client': false,
      'Numéros d\'urgence': false,
    };

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
      if (_directions.contains(c.directionRegionale)) {
        _selectedDirection = c.directionRegionale;
      }
      for (var point in c.pointsAbordes) {
        if (_pointsAbordables.containsKey(point)) {
          _pointsAbordables[point] = true;
        }
      }
    } else {
      _contactDate = DateTime.now();
      _dateController.text = DateFormat('dd/MM/yyyy').format(_contactDate!);
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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _contactDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
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

      String? base64Signature = widget.contact?.signatureBase64;
      if (_signatureController.isNotEmpty) {
        final bytes = await _signatureController.toPngBytes();
        if (bytes != null) base64Signature = base64Encode(bytes);
      }

      final newContact = PriseContactModel(
        id: widget.contact?.id,
        seanceId: widget.contact?.seanceId ?? 1,
        nomContact: _nameController.text.trim(),
        telephone: _phoneController.text.trim(),
        date: _contactDate ?? DateTime.now(),
        objetMission: _objectController.text.trim(),
        directionRegionale: _selectedDirection!,
        agence: _agencyController.text.isNotEmpty
            ? _agencyController.text.trim() : null,
        quartier: _quarterController.text.isNotEmpty
            ? _quarterController.text.trim() : null,
        site: _siteController.text.isNotEmpty
            ? _siteController.text.trim() : null,
        pointsAbordes: checkedPoints,
        observations: _observationsController.text.isNotEmpty
            ? _observationsController.text.trim() : null,
        signatureBase64: base64Signature,
      );

      if (mounted) Navigator.pop(context, newContact);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('Veuillez remplir tous les champs obligatoires'),
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
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _orange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _orange, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _dark,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEF0F3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(
        slivers: [
          // ── AppBar gradient ──
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: _orange,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
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
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing ? 'Modifier un contact' : 'Nouveau contact',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isEditing
                                  ? 'Modifiez les informations du contact'
                                  : 'Enregistrez une nouvelle prise de contact',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
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

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── 1. Infos générales ──
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Informations générales', Icons.person_outline_rounded),
                          CustomTextField(
                            label: 'Nom complet',
                            hint: 'Nom et prénoms',
                            controller: _nameController,
                            isRequired: true,
                            validator: (v) => v!.isEmpty ? 'Requis' : null,
                          ),
                          const SizedBox(height: 14),
                          CustomTextField(
                            label: 'Téléphone',
                            hint: '+225 07 00 00 00',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            isRequired: true,
                            validator: (v) => v!.isEmpty ? 'Requis' : null,
                          ),
                          const SizedBox(height: 14),
                          CustomDatePicker(
                            label: 'Date',
                            hint: 'Sélectionner une date',
                            controller: _dateController,
                            onTap: _selectDate,
                            isRequired: true,
                          ),
                          const SizedBox(height: 14),
                          CustomTextField(
                            label: 'Objet de la mission',
                            hint: 'Ex: Sensibilisation sur la sécurité',
                            controller: _objectController,
                            isRequired: true,
                            validator: (v) => v!.isEmpty ? 'Requis' : null,
                          ),
                        ],
                      ),
                    ),

                    // ── 2. Localisation ──
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Localisation', Icons.location_on_outlined),
                          CustomDropdown(
                            label: 'Direction régionale',
                            hint: 'Sélectionner...',
                            value: _selectedDirection,
                            items: _directions,
                            isRequired: true,
                            onChanged: (v) =>
                                setState(() => _selectedDirection = v),
                          ),
                          const SizedBox(height: 14),
                          CustomTextField(
                            label: 'Agence',
                            hint: 'Nom de l\'agence',
                            controller: _agencyController,
                          ),
                          const SizedBox(height: 14),
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
                    ),

                    // ── 3. Points abordés ──
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Points abordés', Icons.checklist_rounded),
                          ..._pointsAbordables.entries.map((entry) {
                            final isChecked = entry.value;
                            return GestureDetector(
                              onTap: () => _togglePoint(entry.key),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isChecked
                                      ? _vert.withValues(alpha: 0.07)
                                      : const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isChecked
                                        ? _vert.withValues(alpha: 0.3)
                                        : const Color(0xFFE8EAF0),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: 24, height: 24,
                                      decoration: BoxDecoration(
                                        color: isChecked
                                            ? _vert : Colors.transparent,
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(
                                          color: isChecked
                                              ? _vert
                                              : const Color(0xFFCBCDD6),
                                          width: 2,
                                        ),
                                      ),
                                      child: isChecked
                                          ? const Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 15,
                                      )
                                          : null,
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        entry.key,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: isChecked
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          color: isChecked ? _vert : _dark,
                                        ),
                                      ),
                                    ),
                                    if (isChecked)
                                      Icon(
                                        Icons.check_circle_rounded,
                                        color: _vert.withValues(alpha: 0.4),
                                        size: 16,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    // ── 4. Signature ──
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Signature', Icons.draw_outlined),
                          if (isEditing && widget.contact!.signatureBase64 != null)
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.orange.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline_rounded,
                                      color: Colors.orange[700], size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Une signature existe. Ne dessinez rien pour la conserver.',
                                      style: TextStyle(
                                        color: Colors.orange[700],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _orange.withValues(alpha: 0.25),
                                width: 2,
                              ),
                              color: const Color(0xFFFAFAFA),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Signature(
                                controller: _signatureController,
                                backgroundColor: const Color(0xFFFAFAFA),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => _signatureController.clear(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.delete_outline_rounded,
                                        color: Colors.redAccent, size: 16),
                                    SizedBox(width: 6),
                                    Text(
                                      'Effacer',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── 5. Observations ──
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Observations', Icons.notes_rounded),
                          CustomTextField(
                            label: '',
                            hint: 'Notes et observations libres...',
                            controller: _observationsController,
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── Bouton submit ──
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _orange,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isEditing
                                  ? Icons.save_rounded
                                  : Icons.check_circle_outline_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              isEditing
                                  ? 'Modifier le contact'
                                  : 'Enregistrer le contact',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}