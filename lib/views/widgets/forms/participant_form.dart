import 'package:flutter/material.dart';
import '../../../models/participant_model.dart';
import 'widgets/custom_text_field.dart';

class InscriptionForm extends StatefulWidget {
  const InscriptionForm({super.key});

  @override
  State<InscriptionForm> createState() => _InscriptionFormState();
}

class _InscriptionFormState extends State<InscriptionForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _localiteController = TextEditingController();
  final _quartierController = TextEditingController();
  final _campagneController = TextEditingController();

  bool _consentementCIE = false;
  bool _showConsentError = false;

  void _submitForm() {
    setState(() => _showConsentError = !_consentementCIE);

    if (_formKey.currentState!.validate() && _consentementCIE) {
      final nouveauParticipant = ParticipantModel(
        id: 'P${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}', // ID généré
        name: '${_nomController.text} ${_prenomController.text}',
        phone: _telephoneController.text,
        location: _localiteController.text.isNotEmpty ? _localiteController.text : 'Inconnue',
        date: 'Aujourd\'hui',
        campaign: _campagneController.text.isNotEmpty ? _campagneController.text : 'Générale',
        status: 'Actif',
        statusColor: const Color(0xFFD4F1E4),
        statusTextColor: const Color(0xFF4CAF50),
      );

      Navigator.pop(context, nouveauParticipant);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text('Nouveau participant', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: CustomTextField(label: 'Nom', hint: 'Koné', controller: _nomController, isRequired: true, validator: (v) => v!.isEmpty ? 'Requis' : null)),
                  const SizedBox(width: 16),
                  Expanded(child: CustomTextField(label: 'Prénom', hint: 'Amadou', controller: _prenomController, isRequired: true, validator: (v) => v!.isEmpty ? 'Requis' : null)),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(label: 'Téléphone', hint: '+225 07 12 34 56', controller: _telephoneController, isRequired: true, keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Requis' : null),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: CustomTextField(label: 'Localité', hint: 'Abidjan', controller: _localiteController)),
                  const SizedBox(width: 16),
                  Expanded(child: CustomTextField(label: 'Quartier', hint: 'Abobo', controller: _quartierController)),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(label: 'Campagne', hint: 'Ex: Sensibilisation Abobo', controller: _campagneController),

              const SizedBox(height: 32),

              // Consentement
              Row(
                children: [
                  Checkbox(value: _consentementCIE, onChanged: (v) => setState(() { _consentementCIE = v ?? false; _showConsentError = false; }), activeColor: const Color(0xFFFF8000)),
                  const Expanded(child: Text('Le participant consent au traitement de ses données.', style: TextStyle(fontSize: 14))),
                ],
              ),
              if (_showConsentError) const Padding(padding: EdgeInsets.only(left: 48), child: Text('Requis', style: TextStyle(color: Colors.red, fontSize: 12))),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8000), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: const Text('Inscrire le participant', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}