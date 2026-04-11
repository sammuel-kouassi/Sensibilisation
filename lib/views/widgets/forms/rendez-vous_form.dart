import 'package:flutter/material.dart';
import '../../../models/rdv_model.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/custom_date_picker.dart';

class RdvForm extends StatefulWidget {
  final RdvModel? rdv; // Permet de passer un RDV existant pour la modification

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

  @override
  void initState() {
    super.initState();
    // --- MAGIE DE L'ÉDITION : PRÉ-REMPLISSAGE ---
    if (widget.rdv != null) {
      final r = widget.rdv!;
      _titreController.text = r.titre;
      _lieuController.text = r.lieu;
      _contactController.text = r.contact;
      _timeController.text = r.heure;

      _selectedDate = r.dateRdv;
      _dateController.text = "${r.dateRdv.day.toString().padLeft(2, '0')}/${r.dateRdv.month.toString().padLeft(2, '0')}/${r.dateRdv.year}";
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
    if (picked != null) {
      if (context.mounted) {
        setState(() => _timeController.text = picked.format(context));
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {

      if (_selectedDate == null || _timeController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner une date et une heure.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // --- CRÉATION DU NOUVEAU MODÈLE ---
      final newRdv = RdvModel(
        id: widget.rdv?.id, // On conserve l'ID si c'est une modification
        seanceId: widget.rdv?.seanceId ?? 1, // On associe à la séance 1 par défaut
        titre: _titreController.text.trim(),
        contact: _contactController.text.trim(),
        dateRdv: _selectedDate!, // On envoie le vrai objet DateTime
        heure: _timeController.text.trim(),
        lieu: _lieuController.text.isNotEmpty ? _lieuController.text.trim() : 'À définir',
        statut: widget.rdv?.statut ?? 'Planifié', // Garde l'ancien statut ou met "Planifié"
      );

      Navigator.pop(context, newRdv);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.rdv != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? 'Modifier le rendez-vous' : 'Nouveau rendez-vous',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'Titre',
                hint: 'Ex: Visite terrain',
                controller: _titreController,
                isRequired: true,
                validator: (v) => v == null || v.isEmpty ? 'Ce champ est requis' : null,
              ),
              const SizedBox(height: 16),
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
                  const SizedBox(width: 16),
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
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Lieu',
                hint: 'Ex: Bureau CIE',
                controller: _lieuController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Contact',
                hint: 'Ex: M. Kouassi',
                controller: _contactController,
                isRequired: true,
                validator: (v) => v == null || v.isEmpty ? 'Ce champ est requis' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9500),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Mettre à jour le RDV' : 'Planifier le RDV',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}