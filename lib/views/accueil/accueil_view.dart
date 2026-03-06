import 'package:cie_services/views/accueil/widgets/barchart.dart';
import 'package:cie_services/views/accueil/widgets/quickAccessItem.dart';
import 'package:cie_services/views/adminis/adminis_view.dart';
import 'package:cie_services/views/rdv/rdv_view.dart';
import 'package:cie_services/views/synchro/synchro_view.dart';
import 'package:flutter/material.dart';

import '../formulaire/campagne_form.dart';
import '../formulaire/inscrt_form.dart';
import '../formulaire/prisecontact_form.dart';
import '../formulaire/rendez-vous_form.dart';
import '../gadgets/gadgets_view.dart';

class AccueilView extends StatefulWidget {
  const AccueilView({super.key});

  @override
  State<AccueilView> createState() => _AccueilViewState();
}

class _AccueilViewState extends State<AccueilView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView( // <-- Rend toute la page scrollable
        child: Column(
          children: [
            // ============ HEADER ORANGE ============
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF8000),
                    Color(0xFFFFB84D),
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bienvenue sur',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'GS2E',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    '2',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      // --- BLOC 1 : Participants ---
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '1247',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Participants',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // --- BLOC 2 : Campagnes ---
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '8',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Campagnes',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // --- BLOC 3 : Gadgets ---
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '3456',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Gadgets',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ============ CONTENU SOUS LE HEADER (Remonté de 40px) ============
            Transform.translate(
              offset: const Offset(0, -40),
              child: Column(
                children: [
                  // ============ SECTION ACCÈS RAPIDE ============
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Accès rapide',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                          children: [
                            QuickAccessItem(
                              icon: Icons.phone_outlined,
                              iconColor: const Color(0xFFFF9500),
                              backgroundColor: const Color(0xFFFFE4CC),
                              label: 'Prise de\ncontact',
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrisedeContactForm())),
                            ),
                            QuickAccessItem(
                              icon: Icons.calendar_today_outlined,
                              iconColor: const Color(0xFF4CAF50),
                              backgroundColor: const Color(0xFFD4F1E4),
                              label: 'Rendez-vous',
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RdvView())),
                            ),
                            QuickAccessItem(
                              icon: Icons.campaign_outlined,
                              iconColor: const Color(0xFFFF9500),
                              backgroundColor: const Color(0xFFFFE4CC),
                              label: 'Campagnes',
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CampagneForm())),
                            ),
                            QuickAccessItem(
                              icon: Icons.people_outline,
                              iconColor: const Color(0xFF4CAF50),
                              backgroundColor: const Color(0xFFD4F1E4),
                              label: 'Ajouter Participant',
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InscrtForm())),
                            ),
                            QuickAccessItem(
                              icon: Icons.card_giftcard_outlined,
                              iconColor: const Color(0xFFFFA500),
                              backgroundColor: const Color(0xFFFFF3E0),
                              label: 'Gadgets',
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GadgetsView())),
                            ),
                            QuickAccessItem(
                              icon: Icons.sync_outlined,
                              iconColor: const Color(0xFFFF9500),
                              backgroundColor: const Color(0xFFFFE4CC),
                              label: 'Synchronisation',
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SynchroView())),
                            ),
                            QuickAccessItem(
                              icon: Icons.security_outlined,
                              iconColor: const Color(0xFFFF9500),
                              backgroundColor: const Color(0xFFFFE4CC),
                              label: 'Administration',
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminisView())),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ============ SECTION PARTICIPANTS/MOIS ============
                  Container(
                    // J'ai mis 16 en margin "top" pour laisser un espace avec le container du dessus
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Participants / mois',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '6 derniers mois',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              BarChart(height: 60, label: 'Sept'),
                              BarChart(height: 90, label: 'Oct'),
                              BarChart(height: 105, label: 'Nov'),
                              BarChart(height: 120, label: 'Déc'),
                              BarChart(height: 100, label: 'Jan'),
                              BarChart(height: 135, label: 'Févr'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ============ SECTION SYNCHRONISATION ============
                  Container(
                    // Le margin "bottom" de 150 permet de scroller suffisamment pour laisser la place à ta barre de menu en bas
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 150),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4F1E4),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.sync_outlined,
                                    size: 28,
                                    color: Color(0xFF4CAF50),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Synchronisation',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '12 opérations en attente',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Connecté',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}