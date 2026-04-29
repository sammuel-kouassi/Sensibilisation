import 'package:flutter/material.dart';

class TrimestreSelector extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onSelected;

  const TrimestreSelector({
    super.key,
    required this.selectedPeriod,
    required this.onSelected,
  });

  static const _trimestres = [
    ('T1', 'Jan – Mar'),
    ('T2', 'Avr – Juin'),
    ('T3', 'Juil – Sep'),
    ('T4', 'Oct – Déc'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: _trimestres.map((t) {
          final code = t.$1;
          final label = t.$2;
          final isSelected = selectedPeriod == code;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(isSelected ? '30 derniers jours' : code),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFF9500)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFF9500)
                        : Colors.grey.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [BoxShadow(
                    color: const Color(0xFFFF9500).withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )]
                      : [],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      code,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 9,
                        color: isSelected
                            ? Colors.white.withOpacity(0.85)
                            : Colors.grey[500],
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}