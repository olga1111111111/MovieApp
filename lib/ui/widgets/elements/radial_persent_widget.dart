import 'package:flutter/material.dart';
import 'dart:math';

class RadialWidget extends StatefulWidget {
  const RadialWidget({Key? key}) : super(key: key);

  @override
  _RadialWidgetState createState() => _RadialWidgetState();
}

class _RadialWidgetState extends State<RadialWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 100,
          width: 100,
          // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          child: const RadialPersentWidget(
            lineWidth: 5,
            lineColor: Colors.red,
            fillColor: Colors.blue,
            freeColor: Colors.amber,
            percent: 0.72,
            child: Text(
              '72%',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class RadialPersentWidget extends StatelessWidget {
  final Widget child;

  final Color fillColor;
  final Color freeColor;
  final Color lineColor;
  final double percent;
  final double lineWidth;

  const RadialPersentWidget({
    Key? key,
    required this.child,
    required this.fillColor,
    required this.freeColor,
    required this.lineColor,
    required this.percent,
    required this.lineWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: MyPainter(
            percent: percent,
            fillColor: fillColor,
            freeColor: freeColor,
            lineColor: lineColor,
            lineWidth: lineWidth,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(11.0),
          child: Center(child: child),
        )
      ],
    );
  }
}

class MyPainter extends CustomPainter {
  final Color fillColor;
  final Color freeColor;
  final Color lineColor;
  final double percent;
  final double lineWidth;

  MyPainter({
    required this.fillColor,
    required this.freeColor,
    required this.lineColor,
    required this.percent,
    required this.lineWidth,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final arcRect = calculateArcRect(size);

    drawBackground(canvas, size);
    // canvas.drawCircle(
    //     Offset(size.width / 2, size.height / 2), size.width / 2, paint);
    // canvas.drawRect(Offset.zero & Size(30, 40), paint);
    // canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);

    drawFreeArc(canvas, arcRect);

    drawFilledArc(canvas, arcRect);
  }

  void drawFilledArc(Canvas canvas, Rect arcRect) {
    final filledPaint = Paint();
    filledPaint.color = lineColor;
    filledPaint.style = PaintingStyle.stroke;
    filledPaint.strokeCap = StrokeCap.round;
    filledPaint.strokeWidth = lineWidth;

    canvas.drawArc(
      arcRect,
      -pi / 2,
      pi * 2 * percent,
      false,
      filledPaint,
    );
  }

  void drawFreeArc(Canvas canvas, Rect arcRect) {
    final freePaint = Paint();
    freePaint.color = freeColor;
    freePaint.style = PaintingStyle.stroke;
    freePaint.strokeWidth = lineWidth;

    canvas.drawArc(
      arcRect,
      pi * 2 * percent - (pi / 2),
      pi * 2 * (1.0 - percent),
      false,
      freePaint,
    );
  }

  void drawBackground(Canvas canvas, Size size) {
    final backgroundPaint = Paint();
    backgroundPaint.color = fillColor;
    backgroundPaint.style = PaintingStyle.fill;
    canvas.drawOval(Offset.zero & size, backgroundPaint);
  }

  Rect calculateArcRect(Size size) {
    const lineMargin = 3;
    final offset = lineWidth / 2 + lineMargin;
    final arcRect = Offset(offset, offset) &
        Size(size.width - offset * 2, size.height - offset * 2);
    return arcRect;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
