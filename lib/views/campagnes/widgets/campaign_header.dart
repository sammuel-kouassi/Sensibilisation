import 'package:flutter/material.dart';

class CampaignHeader extends StatelessWidget {
  final VoidCallback onAddPressed;

  const CampaignHeader({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Campagnes',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
              GestureDetector(
                onTap: onAddPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 11),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9500),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.add, color: Colors.white, size: 17),
                      SizedBox(width: 5),
                      Text(
                        'Nouvelle',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey.withOpacity(0.2),
        ),
      ],
    );
  }
}