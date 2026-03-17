import 'package:flutter/material.dart';
import '../models/quickAccessItem_models.dart';

// Adapte ces imports selon l'emplacement exact de tes vues
import '../views/formulaire/campagne_form.dart';
import '../views/formulaire/inscrt_form.dart';
import '../views/formulaire/prisecontact_form.dart';
import '../views/gadgets/gadgets_view.dart';
import '../views/rdv/rdv_view.dart';
import '../views/synchro/synchro_view.dart';

List<QuickAccessModel> getQuickAccessModels(BuildContext context) {
  return [
    QuickAccessModel(
      icon: Icons.phone_outlined,
      iconColor: const Color(0xFFFF9500),
      backgroundColor: const Color(0xFFFFE4CC),
      label: 'Prise de\ncontact',
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PrisedeContactForm()),
      ),
    ),
    QuickAccessModel(
      icon: Icons.calendar_today_outlined,
      iconColor: const Color(0xFF4CAF50),
      backgroundColor: const Color(0xFFD4F1E4),
      label: 'Rendez-vous',
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RdvView()),
      ),
    ),
    QuickAccessModel(
      icon: Icons.campaign_outlined,
      iconColor: const Color(0xFFFF9500),
      backgroundColor: const Color(0xFFFFE4CC),
      label: 'Ajouter Une Campagne',
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CampagneForm()),
      ),
    ),
    QuickAccessModel(
      icon: Icons.people_outline,
      iconColor: const Color(0xFF4CAF50),
      backgroundColor: const Color(0xFFD4F1E4),
      label: 'Ajouter Participant',
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InscrtForm()),
      ),
    ),
    QuickAccessModel(
      icon: Icons.card_giftcard_outlined,
      iconColor: const Color(0xFFFFA500),
      backgroundColor: const Color(0xFFFFF3E0),
      label: 'Gadgets',
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GadgetsView()),
      ),
    ),
    QuickAccessModel(
      icon: Icons.sync_outlined,
      iconColor: const Color(0xFFFF9500),
      backgroundColor: const Color(0xFFFFE4CC),
      label: 'Synchronisation',
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SynchroView()),
      ),
    ),
  ];
}