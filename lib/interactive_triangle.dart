import 'package:flutter/material.dart';

class MovablePoint extends StatefulWidget {
  const MovablePoint({Key? key}) : super(key: key);

  @override
  State<MovablePoint> createState() => _MovablePointState();
}

enum Selected { none, c1, c2, c3 }

class Circle {
  double x;
  double y;
  double radius;
  Circle({required this.x, required this.y, this.radius = 10});
}

class _MovablePointState extends State<MovablePoint> {
  Circle c1 = Circle(x: 100.0, y: 100.0);
  Circle c2 = Circle(x: 150.0, y: 200.0);
  Circle c3 = Circle(x: 200.0, y: 100.0);

  Selected _selected = Selected.none;
  double radius = 10;
  bool _dragging = false;

  bool _insideCircle(double x, double y) {
    if (x >= c1.x - c1.radius && x <= c1.x + c1.radius && y >= c1.y - c1.radius && c1.y <= c1.y + c1.radius) {
      _selected = Selected.c1;
      return true;
    }
    if (x >= c2.x - c2.radius && x <= c2.x + c2.radius && y >= c2.y - c2.radius && c2.y <= c2.y + c1.radius) {
      _selected = Selected.c2;
      return true;
    }
    if (x >= c3.x - c3.radius && x <= c3.x + c3.radius && y >= c3.y - c3.radius && c3.y <= c3.y + c1.radius) {
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
            painter: LinePainter(startPos: Offset(c1.x, c1.y), endPos: Offset(c2.x, c2.y)),
            child: Container(),
          ),
          CustomPaint(
            painter: LinePainter(startPos: Offset(c3.x, c3.y), endPos: Offset(c1.x, c1.y)),
            child: Container(),
          ),
          CustomPaint(
            painter: LinePainter(startPos: Offset(c2.x, c2.y), endPos: Offset(c3.x, c3.y)),
            child: Container(),
          ),
          CustomPaint(
            painter: PointPainter(cPos: Offset(c1.x, c1.y), radius: radius),
            child: Container(),
          ),
          CustomPaint(
            painter: PointPainter(cPos: Offset(c2.x, c2.y), radius: radius),
            child: Container(),
          ),
          CustomPaint(
            painter: PointPainter(cPos: Offset(c3.x, c3.y), radius: radius),
            child: Container(),
          ),
        ],
      ),
    );
  }
}

class PointPainter extends CustomPainter {
  PointPainter({required this.cPos, required this.radius});

  Offset cPos;
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

    canvas.drawCircle(cPos, radius, circlePainter);
    canvas.drawCircle(cPos, radius, strokePainter);
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
