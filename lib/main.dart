import 'package:cie_services/views/login/login_views.dart';
import 'package:cie_services/views/widgets/bottomNavigationBarWidgets.dart';
import 'package:flutter/material.dart';
// Importe ton écran de connexion

void main() {
  runApp(const MyApp());
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
      // L'application démarre directement sur la page de connexion !
      home: const LoginView(),
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