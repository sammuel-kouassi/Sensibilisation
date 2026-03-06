import 'package:flutter/material.dart';

class InscrtForm extends StatefulWidget {
  const InscrtForm({super.key});

  @override
  State<InscrtForm> createState() => _InscrtFormState();
}

class _InscrtFormState extends State<InscrtForm> {
  // 1. Clé pour la validation du formulaire
  final _formKey = GlobalKey<FormState>();

  // 2. Contrôleurs pour les champs texte
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _localiteController = TextEditingController();
  final TextEditingController _quartierController = TextEditingController();
  final TextEditingController _campagneController = TextEditingController();

  // 3. État pour les "Besoins exprimés" (sélection multiple)
  final List<String> _besoinsDisponibles = [
    'Nouveau compteur',
    'Changement compteur',
    'Branchement neuf',
    'Réclamation facture',
    'Information tarifs',
    'Signalement panne',
  ];
  final Set<String> _besoinsSelectionnes = {};

  // 4. État pour la case à cocher de consentement
  bool _consentementCIE = false;
  bool _showConsentError = false; // Pour afficher une erreur si non coché

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _localiteController.dispose();
    _quartierController.dispose();
    _campagneController.dispose();
    super.dispose();
  }

  // Fonction de soumission
  void _submitForm() {
    setState(() {
      _showConsentError = !_consentementCIE;
    });

    if (_formKey.currentState!.validate() && _consentementCIE) {
      // Regroupement des données du participant
      final participantData = {
        'nom': _nomController.text,
        'prenom': _prenomController.text,
        'telephone': _telephoneController.text,
        'localite': _localiteController.text,
        'quartier': _quartierController.text,
        'campagne': _campagneController.text,
        'besoins': _besoinsSelectionnes.toList(),
        'consentement': _consentementCIE,
      };

      // TODO: Envoyer 'participantData' à votre base de données WampServer

      print("Participant enregistré : $participantData");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Participant inscrit avec succès !'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Nouveau participant',
          style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom et Prénom sur la même ligne
                Row(
                  children: [
                    Expanded(
                      child: _buildInputGroup(
                        label: 'Nom',
                        hint: 'Koné',
                        isRequired: true,
                        controller: _nomController,
                        validator: (v) => v!.isEmpty ? 'Requis' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputGroup(
                        label: 'Prénom',
                        hint: 'Amadou',
                        isRequired: true,
                        controller: _prenomController,
                        validator: (v) => v!.isEmpty ? 'Requis' : null,
                      ),
                    ),
                  ],
                ),
                _buildInputGroup(
                  label: 'Téléphone',
                  hint: '+225 07 12 34 56',
                  isRequired: true,
                  keyboardType: TextInputType.phone,
                  controller: _telephoneController,
                  validator: (v) => v!.isEmpty ? 'Veuillez entrer le téléphone' : null,
                ),
                // Localité et Quartier sur la même ligne
                Row(
                  children: [
                    Expanded(
                      child: _buildInputGroup(
                        label: 'Localité',
                        hint: 'Abidjan',
                        controller: _localiteController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputGroup(
                        label: 'Quartier',
                        hint: 'Abobo',
                        controller: _quartierController,
                      ),
                    ),
                  ],
                ),
                _buildInputGroup(
                  label: 'Campagne',
                  hint: 'Sensibilisation Abobo Nord',
                  controller: _campagneController,
                ),

                const SizedBox(height: 8),
                const Text(
                  'Besoins exprimés',
                  style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),

                // Puces de sélection pour les besoins
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _besoinsDisponibles.map((besoin) {
                    final isSelected = _besoinsSelectionnes.contains(besoin);
                    return FilterChip(
                      label: Text(besoin),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _besoinsSelectionnes.add(besoin);
                          } else {
                            _besoinsSelectionnes.remove(besoin);
                          }
                        });
                      },
                      backgroundColor: const Color(0xFFF5F5F5),
                      selectedColor: const Color(0xFFFF8000),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black54,
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide.none,
                      ),
                      showCheckmark: false, // Masque la coche par défaut pour coller au design
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Encadré de consentement
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _showConsentError ? Colors.red : Colors.grey.shade300,
                      width: _showConsentError ? 1.5 : 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _consentementCIE,
                          onChanged: (value) {
                            setState(() {
                              _consentementCIE = value ?? false;
                              if (_consentementCIE) _showConsentError = false;
                            });
                          },
                          activeColor: const Color(0xFFF97316),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            text: 'Le participant consent à la collecte et au traitement de ses données personnelles conformément à la politique de confidentialité de la CIE. ',
                            style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
                            children: [
                              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_showConsentError)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 12.0),
                    child: Text(
                      'Le consentement est obligatoire',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                const SizedBox(height: 32),

                // Bouton d'inscription
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8000),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Inscrire le participant',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget utilitaire pour les champs de texte
  Widget _buildInputGroup({
    required String label,
    required String hint,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500),
              children: [
                if (isRequired)
                  const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}