import 'package:flutter/material.dart';
import '../../../models/stat_card_home_models.dart';
import 'stat_home_card.dart';

class HomeHeader extends StatelessWidget {

  final List<StatCardHomeModels> statCardList;

  const HomeHeader({
    super.key,
    required this.statCardList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [Color(0xFFFF8000), Color(0xFF21951D)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bienvenue chez',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'CIE-SODECI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),


              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                      onPressed: () {
                      },
                    ),
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFF8000), width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 35),

          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: statCardList.asMap().entries.map((entry) {
                final index = entry.key;
                final statModel = entry.value;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == statCardList.length - 1 ? 0 : 16.0,
                    ),
                    child: StatHomeCard(statCardHomeModels: statModel),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}