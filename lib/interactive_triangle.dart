import 'package:flutter/material.dart';

class MovablePoint extends StatefulWidget {
  const MovablePoint({Key? key}) : super(key: key);

  @override
  State<MovablePoint> createState() => _MovablePointState();
}

enum Selected { none, c1, c2, c3 }

class _MovablePointState extends State<MovablePoint> {
  double xPos = 100.0;
  double yPos = 100.0;
  double xPos2 = 150.0;
  double yPos2 = 200.0;
  double xPos3 = 200.0;
  double yPos3 = 100.0;
  Selected _selected = Selected.none;
  double radius = 10;
  bool _dragging = false;

  bool _insideCircle(double x, double y) {
    if (x >= xPos - radius && x <= xPos + radius && y >= yPos - radius && y <= yPos + radius) {
      _selected = Selected.c1;
      return true;
    }
    if (x >= xPos2 - radius && x <= xPos2 + radius && y >= yPos2 - radius && y <= yPos2 + radius) {
      _selected = Selected.c2;
      return true;
    }
    if (x >= xPos3 - radius && x <= xPos3 + radius && y >= yPos3 - radius && y <= yPos3 + radius) {
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
                xPos += details.delta.dx;
                yPos += details.delta.dy;
                break;
              case Selected.c2:
                xPos2 += details.delta.dx;
                yPos2 += details.delta.dy;
                break;
              case Selected.c3:
                xPos3 += details.delta.dx;
                yPos3 += details.delta.dy;
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
            painter: LinePainter(startPos: Offset(xPos, yPos), endPos: Offset(xPos2, yPos2)),
            child: Container(),
          ),
          CustomPaint(
            painter: LinePainter(startPos: Offset(xPos3, yPos3), endPos: Offset(xPos, yPos)),
            child: Container(),
          ),
          CustomPaint(
            painter: LinePainter(startPos: Offset(xPos2, yPos2), endPos: Offset(xPos3, yPos3)),
            child: Container(),
          ),
          CustomPaint(
            painter: PointPainter(cPos: Offset(xPos, yPos), radius: radius),
            child: Container(),
          ),
          CustomPaint(
            painter: PointPainter(cPos: Offset(xPos2, yPos2), radius: radius),
            child: Container(),
          ),
          CustomPaint(
            painter: PointPainter(cPos: Offset(xPos3, yPos3), radius: radius),
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
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    final Paint strokePainter = Paint()
      ..color = Color(0xFFFF00CD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(cPos, radius, circlePainter);
    canvas.drawCircle(cPos, radius, strokePainter);
  }

  @override
  bool shouldRepaint(PointPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(PointPainter oldDelegate) => false;
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
