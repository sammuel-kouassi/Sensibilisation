import 'package:flutter/material.dart';

class PeriodOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const PeriodOption({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  static const _orange = Color(0xFFFF8000);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? _orange.withValues(alpha: 0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? _orange.withValues(alpha: 0.12)
                    : Colors.grey.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.access_time_rounded,
                color: isSelected ? _orange : Colors.grey[400],
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? _orange : const Color(0xFF1E293B),
                  fontSize: 14,
                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 22, height: 22,
                decoration: BoxDecoration(
                  color: _orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}