import 'dart:math';

import 'package:flutter/material.dart';

class Circle extends StatefulWidget {
  final double value;
  final double maxValue;
  final List<Color> gradient;
  final List<double> stops;
  final List<String> information;
  final TextStyle textStyle;
  final TextStyle subTextStyle;
  final List<double> informationStop;
  Circle({
    @required this.informationStop,
    @required this.value,
    @required this.maxValue,
    @required this.gradient,
    @required this.stops,
    @required this.information,
    @required this.textStyle,
    @required this.subTextStyle,
  });
  @override
  State<StatefulWidget> createState() => CircleState();
}

class CircleState extends State<Circle> with SingleTickerProviderStateMixin {
  PieChart painter;
  Animation<double> animation;
  AnimationController controller;
  double fraction = 0.0;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    painter = PieChart(
        information: widget.information,
        informationStop: widget.informationStop,
        gradient: widget.gradient,
        stops: widget.stops,
        value: widget.value,
        maxValue: widget.maxValue,
        textStyle: widget.textStyle,
        subTextStyle: widget.subTextStyle,
        fraction: fraction);
    return CustomPaint(painter: painter);
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }
}

// FOR PAINTING POLYGONS
class CirclePainter extends CustomPainter {
  Paint _paint;
  double _fraction;

  CirclePainter(this._fraction) {
    _paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    print('paint $_fraction');

    var rect = Offset(0.0, 0.0) & size;

    canvas.drawArc(rect, -pi / 2, pi * 2 * _fraction, false, _paint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}

class PieChart extends CustomPainter {
  final double value;
  final double maxValue;
  final List<Color> gradient;
  final List<double> stops;
  final List<String> information;
  final double fraction;
  final TextStyle textStyle;
  final TextStyle subTextStyle;
  final List<double> informationStop;
  PieChart({
    @required this.fraction,
    @required this.informationStop,
    @required this.value,
    @required this.maxValue,
    @required this.gradient,
    @required this.stops,
    @required this.information,
    @required this.textStyle,
    @required this.subTextStyle,
  });
  double rad(double angle) => pi / 180 * angle;
  @override
  void paint(Canvas canvas, Size size) {
    Gradient grad = LinearGradient(colors: gradient, stops: stops);
    Paint paint = Paint()
      ..color = Color(0xFFF0F0F0)
      ..strokeWidth = 25.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    double radius = min(size.width / 2 - paint.strokeWidth / 2,
        size.height / 2 - paint.strokeWidth / 2);
    Offset center = Offset(size.width / 2, size.height / 2);
    Rect rect = Rect.fromCircle(center: center, radius: radius);
    Path ps = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius + 4),
        rad(-220),
        rad(260),
      );
    //canvas.drawPath(ps, paint);
    canvas.drawShadow(ps, Colors.grey.withOpacity(0.3), 7, true);
    canvas.drawArc(rect, rad(-220), rad(260), false, paint);

    double arcAngle = 2 * pi * (value / maxValue) * 260 / 360;
    paint..shader = grad.createShader(rect);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), rad(-220),
        arcAngle * fraction, false, paint);

    Path p = Path()
      ..addOval(
        Rect.fromCircle(
            center: center, radius: radius - paint.strokeWidth / 2 + 2),
      );
    canvas.drawShadow(p, Colors.grey.withOpacity(0.3), 3, true);
    paint..shader = null;
    paint..color = Colors.white;
    paint..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - paint.strokeWidth / 2, paint);
    drawText(canvas, size, "${value.toInt()}");
  }

  void drawText(Canvas canvas, Size size, String text) {
    double index_pv = ((this.value / maxValue));
    print(index_pv);
    int index = 0;
    for (int i = 0; i < informationStop.length; i++) {
      if (index_pv < informationStop[index = i]) {
        print("Compare match  ${informationStop[index]}");
        break;
      }
      index = 0;
    }
    TextSpan sp = TextSpan(
      style: textStyle,
      text: text,
      children: [
        TextSpan(
          style: subTextStyle,
          text: information[index],
        ),
      ],
    );
    TextPainter tp = TextPainter(
      text: sp,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    tp.layout();

    double dx = size.width / 2 - tp.width / 2;
    double dy = size.height / 2 - tp.height / 2;

    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
