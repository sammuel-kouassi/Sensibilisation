import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/campaign_model.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/custom_dropdown.dart';
import 'widgets/form_section.dart';

class CampaignForm extends StatefulWidget {
  const CampaignForm({super.key});

  @override
  State<CampaignForm> createState() => _SeanceFormState();
}

class _SeanceFormState extends State<CampaignForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _participantsController = TextEditingController();
  final _supervisorController = TextEditingController();

  final _objectifsController = TextEditingController();

  String? _selectedZone;
  DateTime? _date;
  TimeOfDay? _heureDebut;
  TimeOfDay? _heureFin;

  List<LogistiqueItem> _logistiques = [];

  final List<String> _zones = ['Abidjan', 'Intérieur'];

  @override
  void dispose() {
    _nameController.dispose();
    _participantsController.dispose();
    _supervisorController.dispose();
    _objectifsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _selectTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _heureDebut = picked;
        else _heureFin = picked;
      });
    }
  }

  void _ajouterLogistique() {
    setState(() {
      _logistiques.add(LogistiqueItem(designation: 'Nouveau matériel'));
    });
  }

  void _onSave() {
    if (_formKey.currentState!.validate() && _date != null && _heureDebut != null && _heureFin != null) {
      final newSeance = CampaignModel(
        title: _nameController.text,
        location: _selectedZone ?? 'À définir',
        participants: '0/${_participantsController.text}',
        date: _date!,
        heureDebut: _heureDebut!,
        heureFin: _heureFin!,
        supervisor: _supervisorController.text.isNotEmpty ? _supervisorController.text : 'N/A',
        status: 'En cours',
        statusColor: const Color(0xFFFFE4CC),
        statusTextColor: const Color(0xFFFF9500),
        progress: 0.0,
        logistique: _logistiques,
      );
      Navigator.pop(context, newSeance);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir la date et les heures.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalBudget = _logistiques.fold(0, (sum, item) => sum + item.total);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text('Nouvelle Séance', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              FormSection(
                title: 'Informations de la Séance',
                children: [
                  CustomTextField(label: 'Nom de la séance', hint: 'Ex: Sensibilisation Abobo', controller: _nameController, isRequired: true, validator: (v) => v == null || v.isEmpty ? 'Requis' : null),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Objectifs',
                    hint: 'Décrivez les objectifs...',
                    controller: _objectifsController,
                    isRequired: true,
                    maxLines: 4,
                    validator: (v) => v == null || v.isEmpty ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomDropdown(label: 'Zone', hint: 'Sélectionner', value: _selectedZone, items: _zones, isRequired: true, onChanged: (v) => setState(() => _selectedZone = v)),
                ],
              ),
              const SizedBox(height: 24),

              FormSection(
                title: 'Planification',
                children: [
                  CustomTextField(
                    label: 'Objectif participants',
                    hint: 'Ex: 200',
                    controller: _participantsController,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Organisateur',
                    hint: 'Nom de l''organisateur',
                    controller: _supervisorController,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              FormSection(
                title: 'Date et Heures',
                children: [
                  InkWell(
                    onTap: _selectDate,
                    child: CustomTextField(label: 'Date prévue', hint: _date != null ? DateFormat('dd/MM/yyyy').format(_date!) : 'JJ/MM/AAAA', isRequired: true, controller: TextEditingController(), enabled: false),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectTime(isStart: true),
                          child: CustomTextField(label: 'Heure de début', hint: _heureDebut != null ? _heureDebut!.format(context) : '--:--', isRequired: true, controller: TextEditingController(), enabled: false),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectTime(isStart: false),
                          child: CustomTextField(label: 'Heure de fin', hint: _heureFin != null ? _heureFin!.format(context) : '--:--', isRequired: true, controller: TextEditingController(), enabled: false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              FormSection(
                title: 'Besoins logistiques',
                children: [
                  ...List.generate(_logistiques.length, (index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              initialValue: _logistiques[index].designation,
                              decoration: const InputDecoration(labelText: 'Élément (ex: Bâche)', border: InputBorder.none),
                              onChanged: (v) => _logistiques[index].designation = v,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              initialValue: _logistiques[index].quantite.toString(),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Qté', border: InputBorder.none),
                              onChanged: (v) => setState(() => _logistiques[index].quantite = int.tryParse(v) ?? 1),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              initialValue: _logistiques[index].prixUnitaire.toString(),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Prix U.', border: InputBorder.none),
                              onChanged: (v) => setState(() => _logistiques[index].prixUnitaire = double.tryParse(v) ?? 0.0),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                            onPressed: () => setState(() => _logistiques.removeAt(index)),
                          )
                        ],
                      ),
                    );
                  }),
                  TextButton.icon(
                    onPressed: _ajouterLogistique,
                    icon: const Icon(Icons.add_circle_outline, color: Color(
                        0xFF21951D)),
                    label: const Text('Ajouter un élément (Bâches, Chaises...)', style: TextStyle(color: Color(
                        0xFF21951D))),
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total Logistique : ${totalBudget.toStringAsFixed(0)} FCFA',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF9500), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text('Enregistrer la séance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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