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
  double xPos2 = 200.0;
  double yPos2 = 200.0;
  double xPos3 = 300.0;
  double yPos3 = 300.0;
  Selected _selected = Selected.none;
  int radius = 10;
  bool _dragging = false;

  bool _insideCircle(double x, double y) {
    if (x >= xPos && x <= xPos + radius && y >= yPos && y <= yPos + radius) {
      _selected = Selected.c1;
      return true;
    }
    if (x >= xPos2 && x <= xPos2 + radius && y >= yPos2 && y <= yPos2 + radius) {
      _selected = Selected.c2;
      return true;
    }
    if (x >= xPos3 && x <= xPos3 + radius && y >= yPos3 && y <= yPos3 + radius) {
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
        print(_insideCircle(details.globalPosition.dx, details.globalPosition.dy));
        print(_selected);
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
            painter: TrianglePainter(cPos: Offset(xPos, yPos)),
            child: Container(),
          ),
          CustomPaint(
            painter: TrianglePainter(cPos: Offset(xPos2, yPos2)),
            child: Container(),
          ),
          CustomPaint(
            painter: TrianglePainter(cPos: Offset(xPos3, yPos3)),
            child: Container(),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({required Offset this.cPos});

  Offset cPos;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint circlePainter = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    canvas.drawCircle(cPos, 10, circlePainter);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TrianglePainter oldDelegate) => false;
}
