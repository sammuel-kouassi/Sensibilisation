import 'package:cie_services/views/widgets/contact/PriseContactView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quick_access_model.dart';
import '../models/participant_model.dart';
import '../providers/participant_provider.dart';

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
      QuickAccessModel(
        icon: Icons.person_add_outlined,
        iconColor: const Color(0xFFFF9500),
        backgroundColor: const Color(0xFFFF9500).withOpacity(0.1),
        label: 'Nouveau\nParticipant',
        onTap: () async {
          debugPrint('Accès Rapide : Nouveau Participant cliqué');

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

      QuickAccessModel(
        icon: Icons.card_giftcard_outlined,
        iconColor: Colors.blue,
        backgroundColor: Colors.blue.withOpacity(0.1),
        label: 'Gadgets',
        onTap: () {
          debugPrint('Accès Rapide : Gadgets cliqué');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GadgetsView()),
          );
        },
      ),

      QuickAccessModel(
        icon: Icons.sync_outlined,
        iconColor: const Color(0xFF21951D),
        backgroundColor: const Color(0xFF21951D).withOpacity(0.1),
        label: 'Synchronisation',
        // ✅ La variable syncCount est maintenant reconnue !
        badgeCount: syncCount,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SynchroView()),
          );
        },
      ),

      QuickAccessModel(
        icon: Icons.event_outlined,
        iconColor: const Color(0xFF21951D),
        backgroundColor: const Color(0xFF21951D).withOpacity(0.1),
        label: 'Prendre un Rendez-Vous',
        onTap: () {
          debugPrint('Accès Rapide : Rdv cliqué');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RdvView()),
          );
        },
      ),

      QuickAccessModel(
        icon: Icons.contact_phone_outlined,
        iconColor: Colors.purple,
        backgroundColor: Colors.purple.withOpacity(0.1),
        label: 'Prise de\nContact',
        onTap: () {
          debugPrint('Accès Rapide : Prise de contact cliqué');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PriseContactView()),
          );
        },
      ),
    ];
  }
}
