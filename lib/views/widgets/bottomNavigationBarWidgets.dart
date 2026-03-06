import 'package:cie_services/views/formulaire/prisecontact_form.dart';
import 'package:cie_services/views/inscriptions/inscriptions_view.dart';
import 'package:cie_services/views/param/param_view.dart';
import 'package:cie_services/views/rdv/rdv_view.dart';
import 'package:flutter/material.dart';

import '../accueil/accueil_view.dart';
import '../campagnes/campagnes_view.dart';
import '../formulaire/campagne_form.dart';
import '../formulaire/inscrt_form.dart';
import '../formulaire/rendez-vous_form.dart';
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
     //RdvView(),
     //InscrtForm(),
    //ParticipantForm(),
    //PrisedeContactForm(),
    // CampagneForm(),
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
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: NavigationBar(
            height: 70,
            elevation: 0,
            backgroundColor: Colors.transparent,
            indicatorColor: const Color(0xFFFF9500).withOpacity(0.15),
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.dashboard_outlined,
                  color: _selectedIndex == 0 ? const Color(0xFFFF9500) : Colors.grey,
                  size: 26
                ),
                selectedIcon: Icon(
                  Icons.dashboard,
                  color: const Color(0xFFFF9500),
                  size: 26,
                ),
                label: 'Accueil',
              ),
              NavigationDestination(
                icon: Icon(Icons.campaign_outlined,
                color: _selectedIndex == 1 ? const Color(0xFFFF9500) : Colors.grey,
                size: 26,
                ),
                label: 'Campagnes',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.people_outline,
                  color: _selectedIndex == 2 ? const Color(0xFFFF9500) : Colors.grey,
                  size: 26,
                ),
                selectedIcon: Icon(
                  Icons.people,
                  color: const Color(0xFFFF9500),
                  size: 26,
                ),
                label: 'Participants',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.bar_chart_outlined,
                  color: _selectedIndex == 3 ? const Color(0xFFFF9500) : Colors.grey,
                  size: 26,
                ),
                selectedIcon: Icon(
                  Icons.bar_chart,
                  color: const Color(0xFFFF9500),
                  size: 26,
                ),
                label: 'Stats',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.settings_outlined,
                  color: _selectedIndex == 4 ? const Color(0xFFFF9500) : Colors.grey,
                  size: 26,
                ),
                selectedIcon: Icon(
                  Icons.settings,
                  color: const Color(0xFFFF9500),
                  size: 26,
                ),
                label: 'Plus',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
