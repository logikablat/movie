import 'package:flutter/material.dart';
import 'dart:math';

class StarRating extends StatelessWidget {
  final double rating;

  const StarRating({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return CustomPaint(
          size: const Size(20, 20),
          painter: StarPainter(
            filledPercentage: (index < rating.floor())
                ? 1.0
                : (index < rating ? rating - index : 0.0),
          ),
        );
      }),
    );
  }
}

class StarPainter extends CustomPainter {
  final double filledPercentage;

  StarPainter({required this.filledPercentage});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outlinePaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final Paint fillPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    final Path starPath = _createStarPath(size.width, size.height);

    // Отрисовка контура звезды
    canvas.drawPath(starPath, outlinePaint);

    // Заполнение звезды
    if (filledPercentage > 0) {
      final Rect bounds = starPath.getBounds();
      canvas.clipRect(Rect.fromLTRB(0, 0, bounds.width * filledPercentage, bounds.height));
      canvas.drawPath(starPath, fillPaint);
    }
  }

  Path _createStarPath(double width, double height) {
    final Path path = Path();
    final double cx = width / 2;
    final double cy = height / 2;
    final double radius = width / 2;
    final double innerRadius = radius / 2.5;
    const int numPoints = 5;

    for (int i = 0; i < numPoints; i++) {
      double angle = (i * 2 * pi / numPoints) - pi / 2;
      double x = cx + radius * cos(angle);
      double y = cy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      angle += pi / numPoints;
      x = cx + innerRadius * cos(angle);
      y = cy + innerRadius * sin(angle);
      path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

