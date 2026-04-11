import 'package:flutter/material.dart';
import 'period_option.dart';

class PeriodSelector extends StatefulWidget {
  final String selectedPeriod;
  final List<String> availablePeriods;
  final ValueChanged<String> onPeriodChanged;

  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.availablePeriods,
    required this.onPeriodChanged,
  });

  @override
  State<PeriodSelector> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<PeriodSelector> {
  bool _isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: GestureDetector(
            onTap: () => setState(() => _isDropdownOpen = !_isDropdownOpen),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFF8000), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05), // Modifié ici
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.selectedPeriod,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    _isDropdownOpen ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isDropdownOpen)
          Container(
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.withOpacity(0.15), width: 1.5), // Modifié ici
            ),
            child: Column(
              // On boucle directement sur les chaînes de caractères (String)
              children: widget.availablePeriods.map((period) {
                return Column(
                  children: [
                    PeriodOption(
                      title: period,
                      isSelected: widget.selectedPeriod == period,
                      onTap: () {
                        widget.onPeriodChanged(period);
                        setState(() => _isDropdownOpen = false);
                      },
                    ),
                    if (period != widget.availablePeriods.last)
                      Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.1), // Modifié ici
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}