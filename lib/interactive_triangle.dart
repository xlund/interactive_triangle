import 'package:flutter/material.dart';

class InteractiveTriangle extends StatefulWidget {
  const InteractiveTriangle({Key? key}) : super(key: key);

  @override
  State<InteractiveTriangle> createState() => _InteractiveTriangleState();
}

enum Selected { none, c1, c2, c3 }

class Circle {
  double x;
  double y;
  double radius;
  Circle({required this.x, required this.y, this.radius = 10});

  Offset get offset => Offset(x, y);
  double get minX => x - radius;
  double get minY => y - radius;
  double get maxX => x + radius;
  double get maxY => y + radius;
}

class _InteractiveTriangleState extends State<InteractiveTriangle> {
  Circle c1 = Circle(x: 100.0, y: 100.0);
  Circle c2 = Circle(x: 150.0, y: 200.0);
  Circle c3 = Circle(x: 200.0, y: 100.0);
  Selected _selected = Selected.none;
  bool _dragging = false;

  bool _insideCircle(double x, double y) {
    if (x >= c1.minX && x <= c1.maxX && y >= c1.minY && c1.y <= c1.maxY) {
      _selected = Selected.c1;
      return true;
    }
    if (x >= c2.minX && x <= c2.maxX && y >= c2.minY && c2.y <= c2.maxY) {
      _selected = Selected.c2;
      return true;
    }
    if (x >= c3.minX && x <= c3.maxX && y >= c3.minY && c3.y <= c3.maxY) {
      _selected = Selected.c3;
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        _dragging = _insideCircle(details.globalPosition.dx, details.globalPosition.dy);
      },
      onPanEnd: (details) {
        _dragging = false;
        _selected = Selected.none;
      },
      onPanUpdate: (details) {
        if (_dragging) {
          setState(() {
            switch (_selected) {
              case Selected.c1:
                c1.x += details.delta.dx;
                c1.y += details.delta.dy;
                break;
              case Selected.c2:
                c2.x += details.delta.dx;
                c2.y += details.delta.dy;
                break;
              case Selected.c3:
                c3.x += details.delta.dx;
                c3.y += details.delta.dy;
                break;
              default:
                break;
            }
          });
        }
      },
      child: Stack(
        children: [
          CustomPaint(
            painter: FillPainter(c1: c1, c2: c2, c3: c3),
            child: Container(),
          ),
          CustomPaint(
            painter: LinePainter(startPos: c1.offset, endPos: c2.offset),
            child: Container(),
          ),
          CustomPaint(
            painter: LinePainter(startPos: c3.offset, endPos: c1.offset),
            child: Container(),
          ),
          CustomPaint(
            painter: LinePainter(startPos: c2.offset, endPos: c3.offset),
            child: Container(),
          ),
          CustomPaint(
            painter: PointPainter(offset: c1.offset, radius: c1.radius),
            child: Container(),
          ),
          CustomPaint(
            painter: PointPainter(offset: c2.offset, radius: c2.radius),
            child: Container(),
          ),
          CustomPaint(
            painter: PointPainter(offset: c3.offset, radius: c3.radius),
            child: Container(),
          ),
        ],
      ),
    );
  }
}

class FillPainter extends CustomPainter {
  FillPainter({required this.c1, required this.c2, required this.c3});
  Circle c1;
  Circle c2;
  Circle c3;
  Paint painter = Paint()
    ..color = Color(0xFFDEDEDE)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(c1.x, c1.y);
    path.lineTo(c2.x, c2.y);
    path.lineTo(c3.x, c3.y);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(FillPainter oldDelegate) => true;
}

class PointPainter extends CustomPainter {
  PointPainter({required this.offset, required this.radius});

  Offset offset;
  double radius;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint circlePainter = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final Paint strokePainter = Paint()
      ..color = Color(0xFFFF00CD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(offset, radius, circlePainter);
    canvas.drawCircle(offset, radius, strokePainter);
  }

  @override
  bool shouldRepaint(PointPainter oldDelegate) => true;
}

class LinePainter extends CustomPainter {
  LinePainter({required Offset this.startPos, required Offset this.endPos});

  Offset startPos;
  Offset endPos;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePainter = Paint()
      ..color = Color(0xFFFF00CD)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    canvas.drawLine(startPos, endPos, linePainter);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => true;
}
