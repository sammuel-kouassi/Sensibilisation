import 'package:flutter/material.dart';
import '../../../models/participant_model.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/custom_dropdown.dart';

class ParticipantForm extends StatefulWidget {
  const ParticipantForm({super.key});

  @override
  State<ParticipantForm> createState() => _ParticipantFormState();
}

class _ParticipantFormState extends State<ParticipantForm> {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _localiteController = TextEditingController();
  final _quartierController = TextEditingController();

  // NOUVEAU : Contrôleur pour le champ de ressenti ("Autres")
  final _ressentiController = TextEditingController();

  final _lieuHabitationController = TextEditingController();
  final _professionController = TextEditingController();

  String? _statutLogement;

  // NOUVEAU : Variable pour stocker la séance sélectionnée
  String? _seanceSelectionnee;

  bool _consentementCIE = false;
  bool _showConsentError = false;

  final List<String> _optionsLogement = ['Locataire', 'Propriétaire', 'Autres'];

  // NOUVEAU : Liste simulée de tes séances (tu pourras la rendre dynamique plus tard)
  final List<String> _seancesDisponibles = [
    'Sensibilisation Abobo (En cours)',
    'Séance Yopougon Nord (Terminée)',
    'Campagne Cocody (Créée)',
    'Séance Treichville (En cours)',
  ];

  // NOUVEAU : J'ai ajouté 'Autres' à la fin de la liste
  final List<String> _besoinsOptions = [
    'Nouveau compteur',
    'Changement compteur',
    'Branchement neuf',
    'Réclamation facture',
    'Information tarifs',
    'Signalement panne',
    'Autres'
  ];
  final List<String> _besoinsSelectionnes = [];

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _localiteController.dispose();
    _quartierController.dispose();
    _ressentiController.dispose(); // Ne pas oublier de le libérer
    _lieuHabitationController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    setState(() => _showConsentError = !_consentementCIE);

    if (_formKey.currentState!.validate() && _consentementCIE) {

      final nouveauParticipant = ParticipantModel(
        id: 'P${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
        name: '${_nomController.text} ${_prenomController.text}',
        phone: _telephoneController.text,
        accommodation: _statutLogement ?? 'Non renseigné',
        location: _localiteController.text.isNotEmpty ? _localiteController.text : 'Inconnue',
        date: 'Aujourd\'hui',


        campaign: _seanceSelectionnee ?? 'Générale',
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
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context)
        ),
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

              CustomTextField(label: 'Profession', hint: 'Ex: Commerçant', controller: _professionController),
              const SizedBox(height: 16),
              CustomDropdown(
                label: 'Statut du logement',
                hint: 'Sélectionner...',
                value: _statutLogement,
                items: _optionsLogement,
                onChanged: (v) => setState(() => _statutLogement = v),
              ),
              const SizedBox(height: 16),

              CustomTextField(label: 'Lieu d\'habitation', hint: 'Ex: Près de la pharmacie...', controller: _lieuHabitationController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: CustomTextField(label: 'Localité', hint: 'Abidjan', controller: _localiteController)),
                  const SizedBox(width: 16),
                  Expanded(child: CustomTextField(label: 'Quartier', hint: 'Abobo', controller: _quartierController)),
                ],
              ),
              const SizedBox(height: 16),


              CustomDropdown(
                label: 'Séance',
                hint: 'Sélectionner la séance...',
                value: _seanceSelectionnee,
                items: _seancesDisponibles,
                onChanged: (v) => setState(() => _seanceSelectionnee = v),
                isRequired: true,
              ),
              const SizedBox(height: 32),

              const Text(
                'Besoins exprimés',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: _besoinsOptions.map((besoin) {
                  final isSelected = _besoinsSelectionnes.contains(besoin);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _besoinsSelectionnes.remove(besoin);

                          if (besoin == 'Autres') {
                            _ressentiController.clear();
                          }
                        } else {
                          _besoinsSelectionnes.add(besoin);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF21951D).withValues(alpha: 0.1) : const Color(0xFFF5F5F5),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF21951D) : Colors.transparent,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        besoin,
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF21951D) : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              if (_besoinsSelectionnes.contains('Autres')) ...[
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Votre ressenti / Autre besoin',
                  hint: 'Exprimez ici votre ressenti ou un autre besoin envers l\'entreprise',
                  controller: _ressentiController,
                  maxLines: 4, // Un peu plus grand pour écrire un paragraphe
                ),
              ],

              const SizedBox(height: 40),

              Row(
                children: [
                  Checkbox(
                    value: _consentementCIE,
                    onChanged: (v) => setState(() { _consentementCIE = v ?? false; _showConsentError = false; }),
                    activeColor: const Color(0xFFFF9500),
                  ),
                  const Expanded(child: Text('Le participant consent au traitement de ses données.', style: TextStyle(fontSize: 14))),
                ],
              ),
              if (_showConsentError)
                const Padding(
                  padding: EdgeInsets.only(left: 48),
                  child: Text('Requis', style: TextStyle(color: Colors.red, fontSize: 12)),
                ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9500),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Inscrire le participant', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }
}