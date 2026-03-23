import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';
import 'widgets/home_header.dart';
import 'widgets/quick_access_section.dart';
import 'widgets/participants_chart_section.dart';
import 'widgets/sync_status_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(

      create: (context) => HomeProvider()..init(context),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Consumer<HomeProvider>(
          builder: (context, provider, child) {

            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF8000)),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  HomeHeader(statCardList: provider.statCards),
                  Transform.translate(
                    offset: const Offset(0, -40),
                    child: Column(
                      children: [
                        QuickAccessSection(quickAccessList: provider.quickAccess),
                        ParticipantsChartSection(barChartList: provider.barCharts),
                        const SyncStatusCard(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}