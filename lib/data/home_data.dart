import 'package:cie_services/views/widgets/contact/PriseContactView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quick_access_model.dart';
import '../models/participant_model.dart';
import '../providers/participant_provider.dart';

import '../views/widgets/extras/extras_view.dart';
import '../views/widgets/forms/participant_form.dart';
import '../views/widgets/gadgets/gadgets_view.dart';
import '../views/widgets/rdv/rdv_view.dart';
import '../views/widgets/synchro/synchro_view.dart';

class HomeData {
  static List<QuickAccessModel> getQuickAccess(
      BuildContext context,
      int syncCount,
      ) {
    return [
      // 🟠 Nouveau Participant
      QuickAccessModel(
        icon: Icons.person_add_outlined,
        iconColor: const Color(0xFFFF8000),
        backgroundColor: const Color(0xFFFF8000).withValues(alpha: 0.12),
        label: 'Nouveau\nParticipant',
        onTap: () async {
          final nouveauParticipant = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ParticipantForm()),
          );
          if (nouveauParticipant != null &&
              nouveauParticipant is ParticipantModel) {
            if (context.mounted) {
              Provider.of<ParticipantProvider>(
                context,
                listen: false,
              ).addParticipant(nouveauParticipant);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Participant ajouté avec succès !'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
      ),

      // 🟢 Gadgets
      QuickAccessModel(
        icon: Icons.card_giftcard_outlined,
        iconColor: const Color(0xFF21951D),
        backgroundColor: const Color(0xFF21951D).withValues(alpha: 0.10),
        label: 'Gadgets',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GadgetsView()),
          );
        },
      ),

      // 🔵 Synchronisation
      QuickAccessModel(
        icon: Icons.sync_outlined,
        iconColor: const Color(0xFF1565C0),
        backgroundColor: const Color(0xFF1565C0).withValues(alpha: 0.10),
        label: 'Synchronisation',
        badgeCount: syncCount,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SynchroView()),
          );
        },
      ),

      // 🟣 Prendre un RDV
      QuickAccessModel(
        icon: Icons.calendar_today_outlined,
        iconColor: const Color(0xFF7B1FA2),
        backgroundColor: const Color(0xFF7B1FA2).withValues(alpha: 0.10),
        label: 'Prendre un\nRDV',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RdvView()),
          );
        },
      ),

      // 🔴 Prise de Contact
      QuickAccessModel(
        icon: Icons.contact_page_outlined,
        iconColor: const Color(0xFFE91E63),
        backgroundColor: const Color(0xFFE91E63).withValues(alpha: 0.10),
        label: 'Prise de\nContact',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PriseContactView()),
          );
        },
      ),

      // 🟡 Séances
      QuickAccessModel(
        icon: Icons.tv_outlined,
        iconColor: const Color(0xFFFF8000),
        backgroundColor: const Color(0xFFFF8000).withValues(alpha: 0.10),
        label: 'Séances',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExtrasView()),
          );
        },
      ),
    ];
  }
}