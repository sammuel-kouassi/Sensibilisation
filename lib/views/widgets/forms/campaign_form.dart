import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/campaign_model.dart'; // Import du modèle !
import 'widgets/custom_text_field.dart';
import 'widgets/custom_dropdown.dart';
import 'widgets/form_section.dart';

class CampaignForm extends StatefulWidget {
  const CampaignForm({super.key});

  @override
  State<CampaignForm> createState() => _CampaignFormState();
}

class _CampaignFormState extends State<CampaignForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _objectifsController = TextEditingController();
  final _participantsController = TextEditingController();
  final _supervisorController = TextEditingController();

  String? _selectedZone;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _zones = ['Abobo', 'Yopougon', 'Cocody', 'Plateau', 'Treichville', 'Adjamé', 'Attécoubé'];

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  void _onSave() {
    if (_formKey.currentState!.validate() && _startDate != null && _endDate != null) {

      final newCampaign = CampaignModel(
        title: _nameController.text,
        location: _selectedZone!,
        participants: '0/${_participantsController.text} participants',
        dates: '${DateFormat('yyyy-MM-dd').format(_startDate!)} → ${DateFormat('yyyy-MM-dd').format(_endDate!)}',
        supervisor: _supervisorController.text.isNotEmpty ? _supervisorController.text : 'N/A',
        status: 'En cours',
        statusColor: const Color(0xFFFFE4CC),
        statusTextColor: const Color(0xFFFF9500),
        progress: 0.0,
      );

      // On renvoie l'objet à la page précédente
      Navigator.pop(context, newCampaign);
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
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text('Nouvelle Campagne', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              FormSection(
                title: 'Informations',
                children: [
                  CustomTextField(label: 'Nom', hint: 'Ex: Sensibilisation Abobo', controller: _nameController, isRequired: true, validator: (v) => v!.isEmpty ? 'Requis' : null),
                  const SizedBox(height: 16),
                  CustomTextField(label: 'Objectifs', hint: 'Décrivez...', controller: _objectifsController, maxLines: 4),
                  const SizedBox(height: 16),
                  CustomDropdown(label: 'Zone', hint: 'Sélectionner', value: _selectedZone, items: _zones, isRequired: true, onChanged: (v) => setState(() => _selectedZone = v)),
                ],
              ),
              const SizedBox(height: 24),
              FormSection(
                title: 'Planification',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: _selectStartDate,
                          child: CustomTextField(label: 'Début', hint: _startDate != null ? DateFormat('dd/MM/yyyy').format(_startDate!) : 'Sélectionner', isRequired: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: _selectEndDate,
                          child: CustomTextField(label: 'Fin', hint: _endDate != null ? DateFormat('dd/MM/yyyy').format(_endDate!) : 'Sélectionner', isRequired: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(label: 'Objectif participants', hint: 'Ex: 200', controller: _participantsController, keyboardType: TextInputType.number, isRequired: true, validator: (v) => v!.isEmpty ? 'Requis' : null),
                  const SizedBox(height: 16),
                  CustomTextField(label: 'Superviseur', hint: 'Nom du superviseur', controller: _supervisorController),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF9500), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text('Créer la campagne', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}