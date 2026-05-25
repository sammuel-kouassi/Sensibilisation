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

  static const _orange = Color(0xFFFF8000);
  static const _dark = Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        children: [
          // ── Bouton principal ──
          GestureDetector(
            onTap: () =>
                setState(() => _isDropdownOpen = !_isDropdownOpen),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isDropdownOpen
                      ? _orange
                      : const Color(0xFFEEF0F3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isDropdownOpen
                        ? _orange.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: _orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.calendar_today_outlined,
                        color: _orange, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Période sélectionnée',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.selectedPeriod,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isDropdownOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey[400],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Dropdown ──
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCubic,
            child: _isDropdownOpen
                ? Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFFEEF0F3), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: widget.availablePeriods.map((period) {
                  final isLast =
                      period == widget.availablePeriods.last;
                  return Column(
                    children: [
                      PeriodOption(
                        title: period,
                        isSelected:
                        widget.selectedPeriod == period,
                        onTap: () {
                          widget.onPeriodChanged(period);
                          setState(
                                  () => _isDropdownOpen = false);
                        },
                      ),
                      if (!isLast)
                        Divider(
                          height: 1,
                          color: Colors.grey[100],
                          indent: 16,
                          endIndent: 16,
                        ),
                    ],
                  );
                }).toList(),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}