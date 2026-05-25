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
    ('T1', 'Jan–Mar'),
    ('T2', 'Avr–Juin'),
    ('T3', 'Juil–Sep'),
    ('T4', 'Oct–Déc'),
  ];

  static const _orange = Color(0xFFFF8000);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: _trimestres.map((t) {
          final code = t.$1;
          final label = t.$2;
          final isSelected = selectedPeriod == code;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(
                  isSelected ? '30 derniers jours' : code),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? _orange : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? _orange
                        : const Color(0xFFEEF0F3),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: _orange.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                      : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      code,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 9,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.grey[400],
                        fontWeight: FontWeight.w500,
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