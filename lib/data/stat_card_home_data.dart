import 'package:flutter/material.dart';
import '../models/stat_card_home_models.dart';

List<StatCardHomeModels> getStatCardModels(BuildContext context) {
  return [
    StatCardHomeModels(number: '1247', label: 'Participants'),
    StatCardHomeModels(number: '8', label: 'Campagnes'),
    StatCardHomeModels(number: '3456', label: 'Gadgets'),
  ];
}
