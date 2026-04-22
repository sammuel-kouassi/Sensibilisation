import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/participant_model.dart';
import '../../../core/database/local_db.dart';

import '../../../models/seance_statut.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/custom_dropdown.dart';

class ParticipantForm extends StatefulWidget {
  final ParticipantModel? participant;
  const ParticipantForm({super.key, this.participant});

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
  final _ressentiController = TextEditingController();
  final _lieuHabitationController = TextEditingController();
  final _professionController = TextEditingController();

  String? _statutLogement;
  String? _seanceSelectionnee;

  bool _consentementCIE = false;
  bool _showConsentError = false;

  final List<String> _optionsLogement = ['Locataire', 'Propriétaire', 'Autres'];

  List<SeancesTableData> _seancesList = [];
  List<String> _seancesNoms = [];
  bool _isLoadingSeances = true;

  final List<String> _besoinsOptions = [
    'Nouveau compteur',
    'Changement compteur',
    'Branchement neuf',
    'Réclamation facture',
    'Information tarifs',
    'Signalement panne',
    'Autres',
  ];

  final List<String> _besoinsSelectionnes = [];

  @override
  void initState() {
    super.initState();

    _loadSeances();

    if (widget.participant != null) {
      final p = widget.participant!;

      _nomController.text = p.lastName;
      _prenomController.text = p.firstName;
      _telephoneController.text = p.phone;
      _professionController.text = p.profession ?? '';
      _localiteController.text = p.locality;
      _quartierController.text = p.neighborhood ?? '';
      _lieuHabitationController.text = p.residenceLocation ?? '';

      _statutLogement = p.housingStatus;
      _besoinsSelectionnes.addAll(p.needs);

      if (p.feedback != null) {
        _ressentiController.text = p.feedback!;
      }

      _consentementCIE = p.consent;
    }
  }

  Future<void> _loadSeances() async {
    try {
      final seances = await localDb.getAllSeances();

      // ✅ Uniquement les séances EN COURS (le jour J)
      final seancesEnCours = seances.where((s) {
        final statut = calculerStatut(
          datePrevue: s.datePrevue,
          estTerminee: s.estTerminee,
        );
        return statut == SeanceStatut.enCours;
      }).toList();

      if (mounted) {
        setState(() {
          _seancesList = seancesEnCours;
          _seancesNoms = seancesEnCours.map((s) => s.nom).toList(); // ← plus besoin du label statut
          _isLoadingSeances = false;

          if (widget.participant != null) {
            final matchIndex = _seancesList.indexWhere(
                  (s) => s.id == widget.participant!.sessionId,
            );
            if (matchIndex != -1) {
              _seanceSelectionnee = _seancesNoms[matchIndex];
            }
          }
        });
      }
    } catch (e) {
      debugPrint('❌ Erreur chargement des séances: $e');
      if (mounted) setState(() => _isLoadingSeances = false);
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _localiteController.dispose();
    _quartierController.dispose();
    _ressentiController.dispose();
    _lieuHabitationController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    setState(() => _showConsentError = !_consentementCIE);

    if (_formKey.currentState!.validate() && _consentementCIE) {
      int finalSessionId = 1;
      if (_seanceSelectionnee != null) {
        final index = _seancesNoms.indexOf(_seanceSelectionnee!);
        if (index != -1) {
          finalSessionId = _seancesList[index].id;
        }
      }

      final participantSauvegarde = ParticipantModel(
        id: widget.participant?.id,
        sessionId: finalSessionId,
        lastName: _nomController.text.trim(),
        firstName: _prenomController.text.trim(),
        phone: _telephoneController.text.trim(),
        profession: _professionController.text.isNotEmpty
            ? _professionController.text.trim()
            : null,
        housingStatus: _statutLogement ?? 'Autres',
        residenceLocation: _lieuHabitationController.text.isNotEmpty
            ? _lieuHabitationController.text.trim()
            : null,
        locality: _localiteController.text.isNotEmpty
            ? _localiteController.text.trim()
            : 'Inconnue',
        neighborhood: _quartierController.text.isNotEmpty
            ? _quartierController.text.trim()
            : null,
        needs: List.from(_besoinsSelectionnes),
        feedback:
            _besoinsSelectionnes.contains('Autres') &&
                _ressentiController.text.isNotEmpty
            ? _ressentiController.text.trim()
            : null,
        consent: _consentementCIE,
        status: widget.participant?.status ?? 'Actif',
        registrationDate:
            widget.participant?.registrationDate ?? DateTime.now(),
      );

      Navigator.pop(context, participantSauvegarde);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.participant != null;
    final String pageTitle = isEditing
        ? 'Éditer le participant'
        : 'Nouveau participant';
    final String buttonText = isEditing
        ? 'Éditer le participant'
        : 'Inscrire le participant';

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
          pageTitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                  Expanded(
                    child: CustomTextField(
                      label: 'Nom',
                      hint: 'Koné',
                      controller: _nomController,
                      isRequired: true,
                      validator: (v) => v!.isEmpty ? 'Requis' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'Prénom',
                      hint: 'Amadou',
                      controller: _prenomController,
                      isRequired: true,
                      validator: (v) => v!.isEmpty ? 'Requis' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Téléphone',
                hint: '+225 07 12 34 56',
                controller: _telephoneController,
                isRequired: true,
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Profession',
                hint: 'Ex: Commerçant',
                controller: _professionController,
              ),
              const SizedBox(height: 16),
              CustomDropdown(
                label: 'Statut du logement',
                hint: 'Sélectionner...',
                value: _statutLogement,
                items: _optionsLogement,
                onChanged: (v) => setState(() => _statutLogement = v),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Lieu d\'habitation',
                hint: 'Ex: Près de la pharmacie...',
                controller: _lieuHabitationController,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Localité',
                      hint: 'Abidjan',
                      controller: _localiteController,
                      isRequired: true,
                      validator: (v) => v!.isEmpty ? 'Requis' : null,
                      inputFormatters: [CapitalizeFirstLetterFormatter()],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'Quartier',
                      hint: 'Abobo',
                      controller: _quartierController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CustomDropdown(
                label: 'Séance',
                hint: _isLoadingSeances
                    ? 'Chargement...'
                    : _seancesList.isEmpty
                    ? 'Aucune séance en cours aujourd\'hui'
                    : 'Sélectionner la séance...',
                value: _seanceSelectionnee,
                items: _isLoadingSeances ? [] : _seancesNoms,
                onChanged: (v) {
                  if (_seancesList.isEmpty) return;
                  setState(() => _seanceSelectionnee = v);
                },
                isRequired: true,
              ),
              const SizedBox(height: 32),

              const Text(
                'Besoins exprimés',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
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
                          if (besoin == 'Autres') _ressentiController.clear();
                        } else {
                          _besoinsSelectionnes.add(besoin);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF21951D).withAlpha(26)
                            : const Color(0xFFF5F5F5),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF21951D)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        besoin,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF21951D)
                              : Colors.grey[700],
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
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
                  hint: 'Exprimez ici votre ressenti...',
                  controller: _ressentiController,
                  maxLines: 4,
                ),
              ],

              const SizedBox(height: 40),

              Row(
                children: [
                  Checkbox(
                    value: _consentementCIE,
                    onChanged: (v) => setState(() {
                      _consentementCIE = v ?? false;
                      _showConsentError = false;
                    }),
                    activeColor: const Color(0xFFFF9500),
                  ),
                  const Expanded(
                    child: Text(
                      'Le participant consent au traitement de ses données.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              if (_showConsentError)
                const Padding(
                  padding: EdgeInsets.only(left: 48),
                  child: Text(
                    'Requis',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9500),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
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

class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final formatted = text[0].toUpperCase() + text.substring(1).toLowerCase();

    return newValue.copyWith(text: formatted, selection: newValue.selection);
  }
}
