import 'package:flutter/material.dart';
import '../models/carte_models.dart';

List<CarteModels> getCarteModels(BuildContext context) {
  return [
    CarteModels(
      icon: Icons.groups_rounded,
      iconColor: const Color(0xFFFF8000),
      number: '124',
      label: 'Participants',
    ),
    CarteModels(
      icon: Icons.forum_rounded,
      iconColor: const Color(0xFF3498DB),
      number: '89',
      label: 'Prises de contact',
    ),
    CarteModels(
      icon: Icons.card_giftcard_rounded,
      iconColor: const Color(0xFF4CAF50),
      number: '250',
      label: 'Gadgets distribués',
    ),
    CarteModels(
      icon: Icons.calendar_month_rounded,
      iconColor: const Color(0xFFE74C3C),
      number: '12',
      label: 'Rendez-vous',
    ),
  ];
}