import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CampagneForm extends StatefulWidget {
  const CampagneForm({super.key});

  @override
  State<CampagneForm> createState() => _CampagneFormState();
}

class _CampagneFormState extends State<CampagneForm> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _objectifsController = TextEditingController();
  final TextEditingController _participantsController = TextEditingController();
  final TextEditingController _supervisorController = TextEditingController();
  final TextEditingController _logisticsController = TextEditingController();


  String? _selectedZone;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _zones = [
    'Abobo',
    'Yopougon',
    'Cocody',
    'Plateau',
    'Treichville',
    'Adjamé',
    'Attécoubé',
  ];


  void _onBackPressed() {
    Navigator.pop(context);
    debugPrint('← Retour cliqué');
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
      debugPrint('📅 Date début: ${DateFormat('dd/MM/yyyy').format(picked)}');
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
      debugPrint('📅 Date fin: ${DateFormat('dd/MM/yyyy').format(picked)}');
    }
  }

  void _onSave() {

    if (_nameController.text.isEmpty) {
      _showError('Veuillez entrer le nom de la campagne');
      return;
    }
    if (_selectedZone == null) {
      _showError('Veuillez sélectionner une zone');
      return;
    }
    if (_startDate == null) {
      _showError('Veuillez sélectionner une date de début');
      return;
    }
    if (_endDate == null) {
      _showError('Veuillez sélectionner une date de fin');
      return;
    }
    if (_participantsController.text.isEmpty) {
      _showError('Veuillez entrer l\'objectif de participants');
      return;
    }

    void _onSave() {

      if (_nameController.text.isEmpty) {
        _showError('Veuillez entrer le nom de la campagne');
        return;
      }
      if (_selectedZone == null) {
        _showError('Veuillez sélectionner une zone');
        return;
      }
      if (_startDate == null) {
        _showError('Veuillez sélectionner une date de début');
        return;
      }
      if (_endDate == null) {
        _showError('Veuillez sélectionner une date de fin');
        return;
      }
      if (_participantsController.text.isEmpty) {
        _showError('Veuillez entrer l\'objectif de participants');
        return;
      }


      final newCampaignData = {
        'title': _nameController.text,
        'location': _selectedZone,
        'participants': '0/${_participantsController.text} participants',
        'dates': '${DateFormat('yyyy-MM-dd').format(_startDate!)} → ${DateFormat('yyyy-MM-dd').format(_endDate!)}',
        'supervisor': _supervisorController.text.isNotEmpty ? _supervisorController.text : 'N/A',
        'status': 'En cours',
        'statusColor': const Color(0xFFFFE4CC),
        'statusTextColor': const Color(0xFFFF9500),
        'progress': 0.0, // Progression à zéro
      };


      Navigator.pop(context, newCampaignData);
    }


    debugPrint('💾 Campagne créée avec succès');
    debugPrint('   - Nom: ${_nameController.text}');
    debugPrint('   - Zone: $_selectedZone');
    debugPrint('   - Date début: ${DateFormat('dd/MM/yyyy').format(_startDate!)}');
    debugPrint('   - Date fin: ${DateFormat('dd/MM/yyyy').format(_endDate!)}');
    debugPrint('   - Objectifs: ${_objectifsController.text}');
    debugPrint('   - Participants: ${_participantsController.text}');
    debugPrint('   - Superviseur: ${_supervisorController.text}');
    debugPrint('   - Logistique: ${_logisticsController.text}');

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
    _objectifsController.dispose();
    _participantsController.dispose();
    _supervisorController.dispose();
    _logisticsController.dispose();
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
          'Nouvelle Campagne',
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

              _buildSection(
                title: 'Informations',
                children: [
                  _buildTextField(
                    label: 'Nom de la campagne',
                    controller: _nameController,
                    hint: 'Ex: Sensibilisation Abobo',
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Objectifs',
                    controller: _objectifsController,
                    hint: 'Décrivez les objectifs...',
                    maxLines: 6,
                  ),
                  const SizedBox(height: 24),
                  _buildDropdown(
                    label: 'Zone géographique',
                    hint: 'Sélectionner une zone',
                    value: _selectedZone,
                    items: _zones,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedZone = newValue;
                      });
                      debugPrint('📍 Zone sélectionnée: $newValue');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),


              _buildSection(
                title: 'Planification',
                children: [

                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        children: [
                          SizedBox(
                            width: (constraints.maxWidth - 12) / 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date début',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _buildDatePicker(
                                  onTap: _selectStartDate,
                                  date: _startDate,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: (constraints.maxWidth - 12) / 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date fin',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _buildDatePicker(
                                  onTap: _selectEndDate,
                                  date: _endDate,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Objectif participants',
                    controller: _participantsController,
                    hint: 'Ex: 200',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Superviseur',
                    controller: _supervisorController,
                    hint: 'Nom du superviseur',
                  ),
                ],
              ),

              const SizedBox(height: 24),


              _buildSection(
                title: 'Besoins logistiques',
                children: [
                  _buildTextField(
                    label: '',
                    controller: _logisticsController,
                    hint: 'Salles, bâches, chaises, matériel...',
                    maxLines: 6,
                  ),
                ],
              ),

              const SizedBox(height: 32),


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
                        'Créer la campagne',
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

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }




  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF9500),
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

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
                color: Colors.grey.withOpacity(0.15),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.15),
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
              color: Colors.grey.withOpacity(0.15),
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


  Widget _buildDatePicker({
    required VoidCallback onTap,
    required DateTime? date,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.grey.withOpacity(0.15),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                date != null
                    ? DateFormat('dd/MM/yyyy').format(date)
                    : 'Sélectionner...',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: date != null ? Colors.black : Colors.grey[400],
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
    );
  }
}