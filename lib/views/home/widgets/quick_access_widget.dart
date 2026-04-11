import 'package:flutter/material.dart';
import '../../../models/quick_access_model.dart';

class QuickAccessWidget extends StatelessWidget {
  final QuickAccessModel quickAccessModel;

  const QuickAccessWidget({super.key, required this.quickAccessModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: quickAccessModel.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ⚠️ NOUVEAU : Un Stack pour superposer la bulle rouge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: quickAccessModel.backgroundColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Icon(
                    quickAccessModel.icon,
                    size: 28,
                    color: quickAccessModel.iconColor,
                  ),
                ),
              ),

              // 🔴 LA BULLE DE NOTIFICATION (S'affiche uniquement si > 0)
              if (quickAccessModel.badgeCount > 0)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      quickAccessModel.badgeCount > 9
                          ? '9+'
                          : quickAccessModel.badgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            quickAccessModel.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
