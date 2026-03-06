
import 'package:flutter/material.dart';

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final pointPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    final textPaint = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final points = [
      Offset(30, 150),   // Oct
      Offset(90, 110),   // Nov
      Offset(150, 80),   // Déc
      Offset(210, 100),  // Jan
      Offset(270, 40),   // Févr
    ];

    // Dessiner la ligne
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Dessiner les points
    for (var point in points) {
      canvas.drawCircle(point, 7, pointPaint);
    }

    // Labels
    final labels = ['Oct', 'Nov', 'Déc', 'Jan', 'Févr'];
    for (int i = 0; i < labels.length; i++) {
      textPaint.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      );
      textPaint.layout();
      textPaint.paint(
        canvas,
        Offset(points[i].dx - textPaint.width / 2, points[i].dy + 20),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}