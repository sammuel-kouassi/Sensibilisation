import 'package:flutter/material.dart';
import '../models/carte_models.dart';

List<CarteModels> getCarteModels(BuildContext context) {
  return [
    CarteModels(
      icon: Icons.flash_on,
      iconColor: const Color(0xFFFF8000),
      number: '1,245',
      label: 'Consommations',
    ),
    CarteModels(
      icon: Icons.warning_amber_rounded,
      iconColor: const Color(0xFFE74C3C),
      number: '34',
      label: 'Incidents',
    ),
    CarteModels(
      icon: Icons.check_circle_outline,
      iconColor: const Color(0xFF4CAF50),
      number: '98%',
      label: 'Taux de résolution',
    ),
    CarteModels(
      icon: Icons.people_outline,
      iconColor: const Color(0xFF3498DB),
      number: '+12%',
      label: 'Nouveaux abonnés',
    ),
  ];
}