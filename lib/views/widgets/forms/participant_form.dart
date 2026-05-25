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

  // ── Couleurs du thème ──
  static const _orange = Color(0xFFFF8000);
  static const _vert = Color(0xFF21951D);
  static const _dark = Color(0xFF1E293B);
  static const _grey = Color(0xFFF8F9FA);

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
      if (p.feedback != null) _ressentiController.text = p.feedback!;
      _consentementCIE = p.consent;
    }
  }

  Future<void> _loadSeances() async {
    try {
      final seances = await localDb.getAllSeances();
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
          _seancesNoms = seancesEnCours.map((s) => s.nom).toList();
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
          final seance = _seancesList[index];
          finalSessionId = seance.serverId ?? seance.id;
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
        feedback: _besoinsSelectionnes.contains('Autres') &&
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

  // ── Section title widget ──
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

  // ── Section card wrapper ──
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
    final isEditing = widget.participant != null;
    final String pageTitle =
    isEditing ? 'Éditer le participant' : 'Nouveau participant';
    final String buttonText =
    isEditing ? 'Enregistrer les modifications' : 'Inscrire le participant';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(
        slivers: [
          // ── AppBar avec gradient ──
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
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.07),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -10,
                      child: Container(
                        width: 100,
                        height: 100,
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
                              pageTitle,
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
                                  ? 'Modifiez les informations du participant'
                                  : 'Remplissez les informations du participant',
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

          // ── Contenu du formulaire ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── 1. Infos personnelles ──
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Informations personnelles', Icons.person_outline_rounded),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'Nom',
                                  hint: 'Koné',
                                  controller: _nomController,
                                  isRequired: true,
                                  validator: (v) =>
                                  v!.isEmpty ? 'Requis' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Prénom',
                                  hint: 'Amadou',
                                  controller: _prenomController,
                                  isRequired: true,
                                  validator: (v) =>
                                  v!.isEmpty ? 'Requis' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          CustomTextField(
                            label: 'Téléphone',
                            hint: '07 12 34 56 78',
                            controller: _telephoneController,
                            isRequired: true,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Requis';
                              if (v.length != 10)
                                return '10 chiffres requis';
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          CustomTextField(
                            label: 'Profession',
                            hint: 'Ex: Commerçant',
                            controller: _professionController,
                          ),
                        ],
                      ),
                    ),

                    // ── 2. Logement ──
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Logement & Localisation', Icons.home_outlined),
                          CustomDropdown(
                            label: 'Statut du logement',
                            hint: 'Sélectionner...',
                            value: _statutLogement,
                            items: _optionsLogement,
                            onChanged: (v) =>
                                setState(() => _statutLogement = v),
                          ),
                          const SizedBox(height: 14),
                          CustomTextField(
                            label: 'Lieu d\'habitation',
                            hint: 'Ex: Près de la pharmacie...',
                            controller: _lieuHabitationController,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'Localité',
                                  hint: 'Abidjan',
                                  controller: _localiteController,
                                  isRequired: true,
                                  validator: (v) =>
                                  v!.isEmpty ? 'Requis' : null,
                                  inputFormatters: [
                                    CapitalizeFirstLetterFormatter(),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Quartier',
                                  hint: 'Abobo',
                                  controller: _quartierController,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── 3. Séance ──
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Séance', Icons.event_outlined),
                          CustomDropdown(
                            label: 'Séance en cours',
                            hint: _isLoadingSeances
                                ? 'Chargement...'
                                : _seancesList.isEmpty
                                ? 'Aucune séance aujourd\'hui'
                                : 'Sélectionner la séance...',
                            value: _seanceSelectionnee,
                            items: _isLoadingSeances ? [] : _seancesNoms,
                            onChanged: (v) {
                              if (_seancesList.isEmpty) return;
                              setState(() => _seanceSelectionnee = v);
                            },
                            isRequired: true,
                          ),
                          if (_isLoadingSeances) ...[
                            const SizedBox(height: 12),
                            const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: _orange,
                                ),
                              ),
                            ),
                          ],
                          if (!_isLoadingSeances && _seancesList.isEmpty) ...[
                            const SizedBox(height: 12),
                            Container(
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
                                  Icon(
                                    Icons.info_outline_rounded,
                                    color: Colors.orange[700],
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Aucune séance n\'est en cours aujourd\'hui.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.orange[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // ── 4. Besoins exprimés ──
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Besoins exprimés', Icons.checklist_rounded),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _besoinsOptions.map((besoin) {
                              final isSelected =
                              _besoinsSelectionnes.contains(besoin);
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
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? _vert.withValues(alpha: 0.1)
                                        : const Color(0xFFF5F6FA),
                                    border: Border.all(
                                      color: isSelected
                                          ? _vert
                                          : const Color(0xFFE8EAF0),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isSelected) ...[
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: _vert,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 6),
                                      ],
                                      Text(
                                        besoin,
                                        style: TextStyle(
                                          color: isSelected
                                              ? _vert
                                              : Colors.grey[600],
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          if (_besoinsSelectionnes.contains('Autres')) ...[
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Précisez votre besoin',
                              hint: 'Exprimez ici votre ressenti...',
                              controller: _ressentiController,
                              maxLines: 3,
                            ),
                          ],
                        ],
                      ),
                    ),

                    // ── 5. Consentement ──
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Consentement', Icons.verified_user_outlined),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _consentementCIE = !_consentementCIE;
                                _showConsentError = false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _consentementCIE
                                    ? _vert.withValues(alpha: 0.06)
                                    : const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _showConsentError
                                      ? Colors.red.withValues(alpha: 0.5)
                                      : _consentementCIE
                                      ? _vert.withValues(alpha: 0.3)
                                      : const Color(0xFFE8EAF0),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: _consentementCIE
                                          ? _vert
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                        color: _consentementCIE
                                            ? _vert
                                            : const Color(0xFFCBCDD6),
                                        width: 2,
                                      ),
                                    ),
                                    child: _consentementCIE
                                        ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                        : null,
                                  ),
                                  const SizedBox(width: 14),
                                  const Expanded(
                                    child: Text(
                                      'Le participant consent au traitement de ses données personnelles.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: _dark,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_showConsentError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 4),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    color: Colors.red,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Le consentement est requis',
                                    style: TextStyle(
                                      color: Colors.red[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
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
                          backgroundColor: _orange,
                          elevation: 0,
                          shadowColor: Colors.transparent,
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
                                  : Icons.person_add_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              buttonText,
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

class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    final formatted =
        text[0].toUpperCase() + text.substring(1).toLowerCase();
    return newValue.copyWith(text: formatted, selection: newValue.selection);
  }
}