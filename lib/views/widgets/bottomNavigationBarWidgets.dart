import 'package:cie_services/views/inscriptions/inscriptions_view.dart';
import 'package:cie_services/views/param/param_view.dart';
import 'package:flutter/material.dart';

import '../accueil/accueil_view.dart';
import '../campagnes/campagnes_view.dart';
import '../statistiques/statistiques_view.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    AccueilView(),
    CampagnesView(),
    InscriptionsView(),
    StatistiquesView(),
    ParamView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return false;
  }

  // ====== MÉTHODE POUR CRÉER UN BOUTON PERSONNALISÉ ======
  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    // Couleurs exactes
    final color = isSelected ? const Color(0xFFFF8000) : Colors.grey.shade600;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque, // Rend toute la zone cliquable
      child: SizedBox(
        width: 70, // Garde les icônes bien espacées
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 26,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // === LE PETIT POINT ORANGE ANIMÉ ===
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF8000) : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBody: true,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          // === LE SAFE AREA EST LA SOLUTION AU PROBLEME D'AFFICHAGE ===
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8), // Espace intérieur
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icônes modifiées pour correspondre parfaitement à l'image :
                  _buildNavItem(0, Icons.space_dashboard_outlined, 'Accueil'), // Les 4 blocs
                  _buildNavItem(1, Icons.track_changes, 'Campagnes'), // La cible / bullseye
                  _buildNavItem(2, Icons.people_outline, 'Participants'), // Les 2 personnes
                  _buildNavItem(3, Icons.insert_chart_outlined, 'Stats'), // Les barres de stats avec l'axe
                  _buildNavItem(4, Icons.settings_outlined, 'Plus'), // La roue crantée
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}