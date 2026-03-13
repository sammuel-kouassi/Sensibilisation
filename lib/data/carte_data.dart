import 'package:flutter/material.dart';

import '../models/carte_models.dart';

List<CarteModels> getCarteModels(BuildContext context) {
  return [
    CarteModels(
      icon: Icons.people_outline,
      iconColor: Color(0xFF21951D),
      number: '1247',
      label: 'Total participants',
    ),

    CarteModels(
      icon: Icons.radio_button_unchecked,
      iconColor: Color(0xFF21951D),
      number: '78%',
      label: 'Taux réalisation',
    ),

    CarteModels(
      icon: Icons.bookmark_outline,
      iconColor: Color(0xFF21951D),
      number: '24',
      label: 'Agents actifs',
    ),

    CarteModels(
      icon: Icons.trending_up,
      iconColor: Color(0xFF21951D),
      number: '3456',
      label: 'Gadgets distribués',
    ),
  ];
}
