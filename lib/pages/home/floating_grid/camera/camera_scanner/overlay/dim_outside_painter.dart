import 'package:flutter/material.dart';

class DimOutsidePainter extends CustomPainter {
  final Rect hole;
  final double radius;

  DimOutsidePainter(this.hole, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(RRect.fromRectAndRadius(hole, Radius.circular(radius)));

    canvas.drawPath(path, Paint()..color = Colors.black54);
  }

  @override
  bool shouldRepaint(covariant DimOutsidePainter old) =>
      old.hole != hole || old.radius != radius;
}
