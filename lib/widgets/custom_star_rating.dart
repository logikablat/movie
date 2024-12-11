import 'package:flutter/material.dart';

class CustomStarRating extends StatelessWidget {
  final double rating;

  const CustomStarRating({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return SizedBox(
          width: 24,
          height: 24,
          child: CustomPaint(
            painter: StarPainter(
              filled: index < rating.floor(),
              partial: index >= rating.floor() && index < rating,
            ),
          ),
        );
      }),
    );
  }
}

class StarPainter extends CustomPainter {
  final bool filled;
  final bool partial;

  StarPainter({required this.filled, required this.partial});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.amber
      ..style = filled || partial ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Path path = Path();
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    // Звездные вершины (5-конечная звезда)
    for (int i = 0; i < 5; i++) {
      final double angle = (i * 144) * 3.14159265359 / 180;
      final double x = centerX + radius * Math.cos(angle);
      final double y = centerY - radius * Math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    if (partial) {
      // Создание полузаполненной звезды
      final clipPath = Path()
        ..addRect(Rect.fromLTWH(0, 0, size.width / 2, size.height));
      canvas.clipPath(clipPath);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
