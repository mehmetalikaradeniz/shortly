import 'package:flutter/material.dart';

/// [height] have to be [width] * 0.45
class QuadraticShape extends StatelessWidget {
  final double width;
  const QuadraticShape({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: QuadraticPainter(),
      size: Size(width, width * 0.45),
    );
  }
}


class QuadraticPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xff4B3F6B);
    final curvePath = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(size.width / 35, size.height, size.width * 62 / 100, size.height * 97 / 100)
      ..quadraticBezierTo(size.width * 95 / 100, size.height * 94 / 100, size.width, size.height)
      ..lineTo(size.width, 0);

      /*..moveTo(0, 0)
      ..cubicTo(140, 176, 180, 150, size.width, size.height)
      ..lineTo(size.width, 0); */
      //..close(); //9

    //10
    canvas.drawPath(curvePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}
