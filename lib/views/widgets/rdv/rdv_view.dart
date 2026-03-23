import 'package:flutter/material.dart';

// Imports Model & Data
import '../../models/rdv_model.dart';
import '../../data/rdv_data.dart';

// Import Navigation (Formulaire)

// Imports Widgets
import '../widgets/forms/rendez-vous_form.dart';
import 'widgets/rdv_header.dart';
import 'widgets/rdv_card.dart';

class RdvView extends StatefulWidget {
  const RdvView({super.key});

  @override
  State<RdvView> createState() => _RdvViewState();
}

class _RdvViewState extends State<RdvView> {
  // Liste qui stockera nos rendez-vous
  List<RdvModel> _rdvs = [];

  @override
  void initState() {
    super.initState();
    // Initialisation des données depuis notre fichier data
    _rdvs = RdvData.getRdvs();
  }

  // Méthode de navigation vers le forms
  void _onPlanifierPressed() {
    debugPrint("Ouvrir le forms de planification");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ParticipantForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 1. En-tête (Titre + Boutons)
              RdvHeader(
                onPlanifierPressed: _onPlanifierPressed,
              ),

              const SizedBox(height: 24),

              // 2. Liste des Rendez-vous
              Expanded(
                child: ListView.builder(
                  itemCount: _rdvs.length,
                  itemBuilder: (context, index) {
                    final rdv = _rdvs[index];
                    return RdvCard(rdv: rdv);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}