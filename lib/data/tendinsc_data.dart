import '../models/tendinsc_models.dart';

class TendinscData {

  static List<TendinscModels> getTrendStats() {
    return [
      TendinscModels(monthIndex: 0, monthName: 'Oct', participants: 60),
      TendinscModels(monthIndex: 1, monthName: 'Nov', participants: 120),
      TendinscModels(monthIndex: 2, monthName: 'Déc', participants: 90),
      TendinscModels(monthIndex: 3, monthName: 'Jan', participants: 110),
      TendinscModels(monthIndex: 4, monthName: 'Fév', participants: 130),
    ];
  }
}