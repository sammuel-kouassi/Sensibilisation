import 'package:flutter/material.dart';
import '../../../models/rdv_model.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/custom_date_picker.dart';

class RdvForm extends StatefulWidget {
  const RdvForm({super.key});

  @override
  State<RdvForm> createState() => _RdvFormState();
}

class _RdvFormState extends State<RdvForm> {
  final _formKey = GlobalKey<FormState>();

  final _titreController = TextEditingController();
  final _lieuController = TextEditingController();
  final _contactController = TextEditingController();
  final _campagneController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void dispose() {
    _titreController.dispose();
    _lieuController.dispose();
    _contactController.dispose();
    _campagneController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {

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

      if (_dateController.text.isEmpty || _timeController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner une date et une heure.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final newRdv = RdvModel(
        titre: _titreController.text,
        statut: 'Planifié',
        date: '${_dateController.text} à ${_timeController.text}',
        lieu: _lieuController.text.isNotEmpty ? _lieuController.text : 'À définir',
        campagne: _campagneController.text.isNotEmpty ? _campagneController.text : 'Aucune',
      );

      Navigator.pop(context, newRdv);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nouveau rendez-vous',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Séance associée',
                hint: 'Ex: Sensibilisation Abobo',
                controller: _campagneController,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color (0xFFFF9500),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Planifier le RDV',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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