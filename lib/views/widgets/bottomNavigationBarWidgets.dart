import 'package:flutter/material.dart';

import '../home/home_view.dart';
import '../participant/participant_view.dart';
import '../settings/param_view.dart';
import '../statistics/statistics_view.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeView(),
    ParticipantView(),
    StatisticsView(),
    ParamView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Remplacement de WillPopScope (obsolète) par la nouvelle logique PopScope
  void _onPopInvoked(bool didPop, dynamic result) {
    if (didPop) return;
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
    }
  }

  Widget _buildNavItem(
    int index,
    IconData unselectedIcon,
    IconData selectedIcon,
    String label,
  ) {
    final isSelected = _selectedIndex == index;

    final activeColor = const Color(0xFFFF8000);
    final inactiveIconColor = Colors.grey.shade400;
    final inactiveTextColor = Colors.grey.shade500;
    final pillColor = activeColor.withValues(alpha: 0.15);

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation de la bulle de fond
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 20 : 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isSelected ? pillColor : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  isSelected ? selectedIcon : unselectedIcon,
                  key: ValueKey<bool>(isSelected),
                  color: isSelected ? activeColor : inactiveIconColor,
                  size: isSelected ? 28 : 24,
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Animation du texte
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected ? Colors.black87 : inactiveTextColor,
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: _onPopInvoked,
      child: Scaffold(
        extendBody: false,
        backgroundColor: Colors.grey[50],

        body: IndexedStack(index: _selectedIndex, children: _pages),

        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(bottom: 8, top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  0,
                  Icons.space_dashboard_outlined,
                  Icons.space_dashboard_rounded,
                  'Accueil',
                ),
                _buildNavItem(
                  1,
                  Icons.people_outline_rounded,
                  Icons.people_rounded,
                  'Participants',
                ),
                _buildNavItem(
                  2,
                  Icons.insert_chart_outlined,
                  Icons.insert_chart_rounded,
                  'Stats',
                ),
                _buildNavItem(
                  3,
                  Icons.settings_outlined,
                  Icons.settings_rounded,
                  'Paramètres',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
