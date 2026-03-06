import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrisedeContactForm extends StatefulWidget {
  const PrisedeContactForm({super.key});

  @override
  State<PrisedeContactForm> createState() => _PrisedeContactFormState();
}

class _PrisedeContactFormState extends State<PrisedeContactForm> {
  // ============ CONTROLLERS ============
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _objectController = TextEditingController();
  final TextEditingController _agencyController = TextEditingController();
  final TextEditingController _quarterController = TextEditingController();
  final TextEditingController _siteController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();

  // ============ VARIABLES ============
  DateTime? _contactDate;
  String? _selectedDirection;

  // ✅ CORRIGÉ: Map<String, bool> au lieu de Map<String, List<String>>
  late Map<String, bool> _pointsAbordables;

  final List<String> _directions = [
    'Direction Nord',
    'Direction Sud',
    'Direction Est',
    'Direction Ouest',
    'Direction Centrale',
  ];

  @override
  void initState() {
    super.initState();
    _pointsAbordables = {
      'Sécurité électrique': false,
      'Économie d\'énergie': true,
      'Facturation et paiement': true,
      'Branchements illicites': true,
      'Droits et devoirs du client': false,
      'Numéros d\'urgence': false,
    };
  }

  // ============ MÉTHODES ============
  void _onBackPressed() {
    Navigator.pop(context);
    debugPrint('← Retour cliqué');
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _contactDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _contactDate) {
      setState(() {
        _contactDate = picked;
      });
      debugPrint('📅 Date sélectionnée: ${DateFormat('dd/MM/yyyy').format(picked)}');
    }
  }

  void _togglePoint(String point) {
    setState(() {
      _pointsAbordables[point] = !(_pointsAbordables[point] ?? false);
    });
    debugPrint('☑️ ${_pointsAbordables[point]! ? "✓" : "○"} $point');
  }

  void _onSave() {
    // ============ VALIDATION ============
    if (_nameController.text.isEmpty) {
      _showError('Veuillez entrer un nom complet');
      return;
    }
    if (_phoneController.text.isEmpty) {
      _showError('Veuillez entrer un téléphone');
      return;
    }
    if (_contactDate == null) {
      _showError('Veuillez sélectionner une date');
      return;
    }
    if (_objectController.text.isEmpty) {
      _showError('Veuillez entrer l\'objet de la mission');
      return;
    }
    if (_selectedDirection == null) {
      _showError('Veuillez sélectionner une direction régionale');
      return;
    }

    // ============ LOGS ============
    debugPrint('💾 Contact enregistré avec succès');
    debugPrint('   - Nom: ${_nameController.text}');
    debugPrint('   - Téléphone: ${_phoneController.text}');
    debugPrint('   - Date: ${DateFormat('dd/MM/yyyy').format(_contactDate!)}');
    debugPrint('   - Objet: ${_objectController.text}');
    debugPrint('   - Direction: $_selectedDirection');
    debugPrint('   - Agence: ${_agencyController.text}');
    debugPrint('   - Quartier: ${_quarterController.text}');
    debugPrint('   - Site: ${_siteController.text}');

    final checkedPoints = _pointsAbordables.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    debugPrint('   - Points abordés: $checkedPoints');
    debugPrint('   - Observations: ${_observationsController.text}');

    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _objectController.dispose();
    _agencyController.dispose();
    _quarterController.dispose();
    _siteController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: _onBackPressed,
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 28,
          ),
        ),
        title: const Text(
          'Prise de Contact',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============ SECTION INFORMATIONS GÉNÉRALES ============
              _buildSection(
                title: 'Informations générales',
                children: [
                  _buildTextField(
                    label: 'Nom complet',
                    controller: _nameController,
                    hint: 'Nom et prénoms',
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Téléphone',
                    controller: _phoneController,
                    hint: '+225 07 00 00 00',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  _buildDateField(),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Objet de la mission',
                    controller: _objectController,
                    hint: 'Ex: Sensibilisation sur la sécurité',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ============ SECTION LOCALISATION ============
              _buildSection(
                title: 'Localisation',
                icon: Icons.location_on,
                children: [
                  _buildDropdown(
                    label: 'Direction régionale',
                    hint: 'Sélectionner',
                    value: _selectedDirection,
                    items: _directions,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDirection = newValue;
                      });
                      debugPrint('📍 Direction: $newValue');
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Agence',
                    controller: _agencyController,
                    hint: 'Nom de l\'agence',
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Quartier',
                          controller: _quarterController,
                          hint: 'Quartier',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          label: 'Site',
                          controller: _siteController,
                          hint: 'Site',
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ============ SECTION POINTS ABORDÉS ============
              _buildSection(
                title: 'Points abordés',
                children: [
                  Column(
                    children: _pointsAbordables.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () => _togglePoint(entry.key),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: entry.value
                                        ? const Color(0xFFFF9500)
                                        : Colors.grey[400]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  color: entry.value
                                      ? const Color(0xFFFF9500)
                                      : Colors.transparent,
                                ),
                                child: entry.value
                                    ? const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ============ SECTION SIGNATURE ============
              _buildSection(
                title: 'Signature',
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      color: Colors.grey[50],
                    ),
                    child: Center(
                      child: Text(
                        'Zone de signature numérique',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ============ SECTION OBSERVATIONS ============
              _buildSection(
                title: 'Observations',
                children: [
                  _buildTextField(
                    label: '',
                    controller: _observationsController,
                    hint: 'Notes et observations...',
                    maxLines: 6,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ============ BOUTON ENREGISTRER ============
              GestureDetector(
                onTap: _onSave,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9500),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Enregistrer le contact',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }

  // ============ WIDGETS HELPER ============

  /// Widget pour construire une section
  Widget _buildSection({
    required String title,
    required List<Widget> children,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: const Color(0xFFFF9500),
                  size: 24,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF9500),
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  /// Widget pour construire un champ texte
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 15,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFFFF9500),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }

  /// Widget pour construire un dropdown
  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: DropdownButton<String>(
            value: value,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                hint,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 15,
                ),
              ),
            ),
            isExpanded: true,
            underline: const SizedBox(),
            icon: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[600],
                size: 24,
              ),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            dropdownColor: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Widget pour construire un date picker
  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 14,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _contactDate != null
                        ? DateFormat('dd/MM/yyyy').format(_contactDate!)
                        : 'Sélectionner...',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _contactDate != null ? Colors.black : Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}