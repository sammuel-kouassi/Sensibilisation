import 'package:flutter/material.dart';
import '../models/startcard_home_models.dart';

List<StartCardHomeModels> getStartcardModels(BuildContext context) {
  return [
    StartCardHomeModels(
      iconColor: Colors.blue,
      number: '1247',
      label: 'Participants',
    ),
    StartCardHomeModels(
      iconColor: Colors.orange,
      number: '8',
      label: 'Campagnes',
    ),
    StartCardHomeModels(
      iconColor: Colors.green,
      number: '3456',
      label: 'Gadgets',
    ),
  ];
}