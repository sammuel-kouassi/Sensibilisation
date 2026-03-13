import 'package:flutter/material.dart';

import '../models/barchart_models.dart';

List<BarchartModels> getBarchartModels(BuildContext context) {
  return [
    BarchartModels(height: 60, label: 'Sept'),
    BarchartModels(height: 90, label: 'Oct'),
    BarchartModels(height: 105, label: 'Nov'),
    BarchartModels(height: 120, label: 'Déc'),
    BarchartModels(height: 100, label: 'Jan'),
    BarchartModels(height: 135, label: 'Févr'),
  ];
}
