import 'package:flutter/material.dart';
import '../models/barchart_models.dart';

List<BarchartModels> getBarchartModels(BuildContext context) {
  return [
    BarchartModels(height: 50, label: 'Oct'),
    BarchartModels(height: 80, label: 'Nov'),
    BarchartModels(height: 120, label: 'Déc'),
    BarchartModels(height: 90, label: 'Jan'),
    BarchartModels(height: 140, label: 'Fév'),
    BarchartModels(height: 160, label: 'Mar'),
  ];
}