import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:dlf_backend_client/dlf_backend_client.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late Client client;

  //http://192.168.1.6:8070
  void init() {
    client = Client('http://10.38.97.212:8070')

      ..connectivityMonitor = FlutterConnectivityMonitor();
  }
}

final apiClient = ApiClient().client;
