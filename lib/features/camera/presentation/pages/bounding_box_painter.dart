import 'package:flutter/material.dart';
import 'package:pothole_mobile_app/features/camera/domain/bounding_box.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<BoundingBox> boxes;

  BoundingBoxPainter(this.boxes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    for (var box in boxes) {
      final rect = Rect.fromLTWH(
        box.x * size.width,
        box.y * size.height,
        box.w * size.width,
        box.h * size.height,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
