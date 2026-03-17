import '../models/user_profile_model.dart';
import '../models/app_info_model.dart';

class ParamData {

  static UserProfileModel getCurrentUser() {
    return UserProfileModel(
      name: 'Admin Principal',
      email: 'admin@cie.ci',
      role: 'Administrateur',
    );
  }

  static AppInfoModel getAppInfo() {
    return AppInfoModel(
      version: '1.0.0',
      copyrightYear: '2026',
    );
  }
}