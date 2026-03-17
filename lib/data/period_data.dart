import '../models/period_models.dart';


class PeriodData {
  static const String defaultPeriod = 'Ce mois';

  static List<PeriodOptionModels> getPeriods() {
    return [
      PeriodOptionModels(title: 'Ce mois'),
      PeriodOptionModels(title: '3 derniers mois'),
      PeriodOptionModels(title: '6 derniers mois'),
      PeriodOptionModels(title: 'Cette année'),
    ];
  }
}