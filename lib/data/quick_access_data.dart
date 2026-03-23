import 'package:flutter/material.dart';
import '../models/quick_access_models.dart';
import '../views/widgets/forms/campaign_form.dart';
import '../views/widgets/forms/participant_form.dart';
import '../views/widgets/forms/prisecontact_form.dart';
import '../views/widgets/gadgets/gadgets_view.dart';
import '../views/widgets/rdv/rdv_view.dart';
import '../views/widgets/synchro/synchro_view.dart';

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
        MaterialPageRoute(builder: (context) => const CampaignForm()),
      ),
    ),
    QuickAccessModel(
      icon: Icons.people_outline,
      iconColor: const Color(0xFF4CAF50),
      backgroundColor: const Color(0xFFD4F1E4),
      label: 'Ajouter Participant',
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ParticipantForm()),
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