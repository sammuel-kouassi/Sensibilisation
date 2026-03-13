import 'package:flutter/material.dart';

import '../../../models/quickAccessItem_models.dart';

class QuickAccess extends StatelessWidget {
  final QuickAccessModel quickAccessModel;

  const QuickAccess({
    super.key,
    required this.quickAccessModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: quickAccessModel.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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