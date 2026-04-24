import 'package:cie_services/providers/auth_provider.dart';
import 'package:cie_services/providers/gadget_provider.dart';
import 'package:cie_services/providers/notification_provider.dart';
import 'package:cie_services/services/notification_service.dart';
import 'package:cie_services/views/widgets/bottomNavigationBarWidgets.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'core/api_client.dart';

import 'providers/participant_provider.dart';
import 'providers/sync_provider.dart';
import 'providers/prise_contact_provider.dart';
import 'providers/rdv_provider.dart';
import 'views/login/login_views.dart';
import 'views/splash/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiClient().init();
  await NotificationService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParticipantProvider()),
        ChangeNotifierProvider(create: (_) => SyncProvider()),
        ChangeNotifierProvider(create: (_) => PriseContactProvider()),
        ChangeNotifierProvider(create: (_) => RdvProvider()),
        ChangeNotifierProvider(create: (_) => GadgetProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CIE Sensibilisation',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9500)),
      ),
      home: const SplashView(),
      routes: {LoginView.routeName: (context) => const LoginView()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const BottomNavigationBarWidget();
  }
}
