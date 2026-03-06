import 'package:flutter/material.dart';

class ParticipantForm extends StatefulWidget {
  const ParticipantForm({super.key});

  @override
  State<ParticipantForm> createState() => _ParticipantFormState();
}

class _ParticipantFormState extends State<ParticipantForm> {
  // 1. Clé globale pour identifier et valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // 2. Contrôleurs pour récupérer les valeurs des champs texte
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _lieuController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _campagneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Contrôleurs spécifiques pour afficher la date et l'heure sélectionnées
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Libérer la mémoire quand le widget est détruit
  @override
  void dispose() {
    _titreController.dispose();
    _lieuController.dispose();
    _contactController.dispose();
    _telephoneController.dispose();
    _campagneController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  // Fonction pour afficher le calendrier
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(), // Empêche de choisir une date passée
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF97316), // Couleur orange pour le calendrier
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Formatage simple (JJ/MM/AAAA)
        _dateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  // Fonction pour afficher l'horloge
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF97316),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  // Fonction exécutée lors du clic sur "Planifier le RDV"
  void _submitForm() {
    // Valide tous les champs qui ont un 'validator'
    if (_formKey.currentState!.validate()) {
      // Récupération de toutes les données prêtes à être envoyées à une API
      final formData = {
        'titre': _titreController.text,
        'date': _selectedDate?.toIso8601String(),
        'heure': _selectedTime?.format(context),
        'lieu': _lieuController.text,
        'contact': _contactController.text,
        'telephone': _telephoneController.text,
        'campagne': _campagneController.text,
        'notes': _notesController.text,
      };

      // Affiche les données dans la console (pour tester)
      print("Données du formulaire : $formData");

      // Afficher un message de succès à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rendez-vous planifié avec succès !'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Ici, vous pourrez appeler votre fonction http.post() vers votre backend
    }
  }

  void _onBackPressed() {
    Navigator.pop(context);
    debugPrint('← Retour cliqué');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 64,
        // Correction : On retire le onTap du Padding
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 18),
              // L'action se met ici sur le bouton :
              onPressed: _onBackPressed,
            ),
          ),
        ),
        title: const Text(
          'Nouveau rendez-vous',
          style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          // 3. Ajout du widget Form
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputGroup(
                  label: 'Titre',
                  hint: 'Ex: Visite terrain',
                  isRequired: true,
                  controller: _titreController,
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer un titre' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputGroup(
                        label: 'Date',
                        hint: 'Sélectionner',
                        isRequired: true,
                        isDropdown: true,
                        controller: _dateController,
                        onTap: () => _selectDate(context),
                        validator: (value) => value!.isEmpty ? 'Requis' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputGroup(
                        label: 'Heure',
                        hint: 'Sélectionner',
                        isRequired: true,
                        isDropdown: true,
                        controller: _timeController,
                        onTap: () => _selectTime(context),
                        validator: (value) => value!.isEmpty ? 'Requis' : null,
                      ),
                    ),
                  ],
                ),
                _buildInputGroup(
                  label: 'Lieu',
                  hint: 'Ex: Bureau CIE',
                  controller: _lieuController,
                ),
                _buildInputGroup(
                  label: 'Contact',
                  hint: 'Ex: M. Kouassi',
                  isRequired: true,
                  controller: _contactController,
                  validator: (value) => value!.isEmpty ? 'Veuillez indiquer un contact' : null,
                ),
                _buildInputGroup(
                  label: 'Téléphone',
                  hint: '+225 07 12 34 56',
                  keyboardType: TextInputType.phone,
                  controller: _telephoneController,
                ),
                _buildInputGroup(
                  label: 'Campagne associée',
                  hint: 'Sensibilisation Abobo Nord',
                  controller: _campagneController,
                ),
                _buildInputGroup(
                  label: 'Notes',
                  hint: 'Notes supplémentaires...',
                  maxLines: 4,
                  controller: _notesController,
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submitForm, // Appelle la fonction de validation
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8000),
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
                const SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget réutilisable mis à jour pour supporter les contrôleurs et la validation
  Widget _buildInputGroup({
    required String label,
    required String hint,
    bool isRequired = false,
    bool isDropdown = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
    String? Function(String?)? validator,
    VoidCallback? onTap,
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
                  const TextSpan(text: ' *', style: TextStyle(color: Colors.red)), // Astérisque en rouge pour alerter
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: validator,
            maxLines: maxLines,
            keyboardType: keyboardType,
            readOnly: isDropdown,
            onTap: onTap, // Exécute l'action (comme ouvrir le calendrier)
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
              // Ajout d'une bordure rouge si le champ est invalide
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              suffixIcon: isDropdown
                  ? const Icon(Icons.keyboard_arrow_down, color: Colors.black54)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}