import 'package:flutter/material.dart';
import '../../../models/rdv_model.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/custom_date_picker.dart';

class RdvForm extends StatefulWidget {
  final RdvModel? rdv;
  const RdvForm({super.key, this.rdv});

  @override
  State<RdvForm> createState() => _RdvFormState();
}

class _RdvFormState extends State<RdvForm> {
  final _formKey = GlobalKey<FormState>();

  final _titreController = TextEditingController();
  final _lieuController = TextEditingController();
  final _contactController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  DateTime? _selectedDate;

  static const _orange = Color(0xFFFF8000);
  static const _dark = Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    if (widget.rdv != null) {
      final r = widget.rdv!;
      _titreController.text = r.titre;
      _lieuController.text = r.lieu;
      _contactController.text = r.contact;
      _timeController.text = r.heure;
      _selectedDate = r.dateRdv;
      _dateController.text =
      "${r.dateRdv.day.toString().padLeft(2, '0')}/${r.dateRdv.month.toString().padLeft(2, '0')}/${r.dateRdv.year}";
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _lieuController.dispose();
    _contactController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      _selectedDate = picked;
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      setState(() => _dateController.text = "$day/$month/${picked.year}");
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && context.mounted) {
      setState(() => _timeController.text = picked.format(context));
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _timeController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.white),
                SizedBox(width: 10),
                Text('Veuillez sélectionner une date et une heure.'),
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

      final newRdv = RdvModel(
        id: widget.rdv?.id,
        seanceId: widget.rdv?.seanceId ?? 1,
        titre: _titreController.text.trim(),
        contact: _contactController.text.trim(),
        dateRdv: _selectedDate!,
        heure: _timeController.text.trim(),
        lieu: _lieuController.text.isNotEmpty
            ? _lieuController.text.trim()
            : 'À définir',
        statut: widget.rdv?.statut ?? 'Planifié',
      );

      Navigator.pop(context, newRdv);
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
    final isEditing = widget.rdv != null;

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
                    colors: [Color(0xFF21951D), Color(0xFF167013)],
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
                              isEditing
                                  ? 'Modifier le rendez-vous'
                                  : 'Nouveau rendez-vous',
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
                                  ? 'Modifiez les détails du rendez-vous'
                                  : 'Planifiez un nouveau rendez-vous',
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
                  children: [

                    // ── 1. Détails du RDV ──
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Détails du rendez-vous', Icons.event_outlined),
                          CustomTextField(
                            label: 'Titre',
                            hint: 'Ex: Visite terrain',
                            controller: _titreController,
                            isRequired: true,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Ce champ est requis'
                                : null,
                          ),
                          const SizedBox(height: 14),
                          CustomTextField(
                            label: 'Contact',
                            hint: 'Ex: M. Kouassi',
                            controller: _contactController,
                            isRequired: true,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Ce champ est requis'
                                : null,
                          ),
                        ],
                      ),
                    ),

                    // ── 2. Date & Heure ──
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Date & Heure', Icons.schedule_outlined),
                          Row(
                            children: [
                              Expanded(
                                child: CustomDatePicker(
                                  label: 'Date',
                                  hint: 'JJ/MM/AAAA',
                                  controller: _dateController,
                                  onTap: _selectDate,
                                  isRequired: true,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomDatePicker(
                                  label: 'Heure',
                                  hint: 'HH:MM',
                                  controller: _timeController,
                                  onTap: _selectTime,
                                  isRequired: true,
                                ),
                              ),
                            ],
                          ),
                          // Indicateur visuel si date sélectionnée
                          if (_selectedDate != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF21951D)
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFF21951D)
                                      .withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: Color(0xFF21951D),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'RDV prévu le ${_dateController.text}'
                                        '${_timeController.text.isNotEmpty ? ' à ${_timeController.text}' : ''}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF21951D),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // ── 3. Lieu ──
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Lieu', Icons.location_on_outlined),
                          CustomTextField(
                            label: 'Lieu du rendez-vous',
                            hint: 'Ex: Bureau CIE, Plateau',
                            controller: _lieuController,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Laissez vide pour définir ultérieurement',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                              fontStyle: FontStyle.italic,
                            ),
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
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF21951D),
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
                                  : Icons.calendar_month_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              isEditing
                                  ? 'Mettre à jour le RDV'
                                  : 'Planifier le RDV',
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