import 'package:flutter/material.dart';

class PeriodOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const PeriodOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: PeriodModels.onTap,
      child: Container(
        color: PeriodModels.isSelected ? const Color(0xFFFFE4CC) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              PeriodModels.title,
              style: TextStyle(
                color: PeriodModels.isSelected ? const Color(0xFFFF9500) : Colors.black,
                fontSize: 14,
                fontWeight: PeriodModels.isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (PeriodModels.isSelected)
              const Icon(
                Icons.check,
                color: Color(0xFFFF9500),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}