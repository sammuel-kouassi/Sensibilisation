import 'package:flutter/material.dart';

class GadgetSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const GadgetSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEF0F3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: 'Rechercher une séance...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded,
              color: Colors.grey[400], size: 20),
          suffixIcon: controller.text.isNotEmpty
              ? GestureDetector(
            onTap: () {
              controller.clear();
              onChanged?.call('');
            },
            child: Icon(Icons.close_rounded,
                color: Colors.grey[400], size: 18),
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 14, horizontal: 16),
        ),
      ),
    );
  }
}