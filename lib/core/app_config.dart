class AppConfig {
  AppConfig._();

  static const String _host = '192.168.1.4';

  static const int _portServerpod  = 8070;
  static const int _portSpringBoot = 8081;


  /// URL du backend Serverpod (utilisé par ApiClient)
  static String get serverpodUrl => 'http://$_host:$_portServerpod';

  /// URL de base du backend Spring Boot
  static String get springBootUrl => 'http://$_host:$_portSpringBoot';

  /// URL d'upload des images
  static String get uploadUrl => '$springBootUrl/api/images/upload';

  /// URL de base pour les images servies
  static String get imagesBaseUrl => '$springBootUrl/api/images/files';
}