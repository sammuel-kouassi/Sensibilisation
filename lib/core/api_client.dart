// lib/core/api_client.dart
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:dlf_backend_client/dlf_backend_client.dart';
import 'app_config.dart'; // ← toutes les URLs viennent d'ici

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late Client client;

  void init() {
    client = Client(AppConfig.serverpodUrl)
      ..connectivityMonitor = FlutterConnectivityMonitor();
  }
}

final apiClient = ApiClient().client;