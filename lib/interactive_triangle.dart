import 'package:flutter/material.dart';

class InteractiveTriangle extends StatelessWidget {
  const InteractiveTriangle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrianglePainter(),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(75, 75), 10, Paint());
    canvas.drawCircle(Offset(100, 100), 10, Paint());
    canvas.drawCircle(Offset(200, 200), 10, Paint());
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TrianglePainter oldDelegate) => false;
}
