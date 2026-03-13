import 'package:flutter/material.dart';
import '../models/startcard_home_models.dart';

List<StartCardHomeModels> getStartcardModels(BuildContext context) {
  return [
    StartCardHomeModels(
      icon: Icons.people_alt_outlined,
      iconColor: Colors.blue,
      number: '1247',
      label: 'Participants',
    ),
    StartCardHomeModels(
      icon: Icons.campaign_outlined,
      iconColor: Colors.orange,
      number: '8',
      label: 'Campagnes',
    ),
    StartCardHomeModels(
      icon: Icons.card_giftcard_outlined,
      iconColor: Colors.green,
      number: '3456',
      label: 'Gadgets',
    ),
  ];
}