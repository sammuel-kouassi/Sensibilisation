
import 'package:flutter/material.dart';

class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final data = [
      {'percentage': 25, 'color': const Color(0xFFFF9500)}, // Abobo
      {'percentage': 5, 'color': Colors.grey},              // Plateau
      {'percentage': 20, 'color': const Color(0xFFE74C3C)}, // Marcory
      {'percentage': 28, 'color': const Color(0xFFFFC107)}, // Cocody
      {'percentage': 25, 'color': const Color(0xFF4CAF50)}, // Yopougon
    ];

    var currentAngle = -90.0;

    for (var item in data) {
      final sweepAngle = (item['percentage'] as int) * 3.6;
      final paint = Paint()
        ..color = item['color'] as Color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle * 3.14159 / 180,
        sweepAngle * 3.14159 / 180,
        true,
        paint,
      );

      currentAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
