
part of 'bubble_view.dart';

class BubbleViewPainter extends CustomPainter {
  final CustomClipper<Path> clipper;
  /*final gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFFDADAFB), Color(0xFFFFFFFF)],
  );*/

  final gradient;
  final backgroundColor;

  final _paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill;

  BubbleViewPainter({required this.clipper, this.backgroundColor, this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    if (gradient != null) {
      _paint.shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    } else if (backgroundColor != null) {
      _paint.color = backgroundColor;
    } else {
      _paint.color = Colors.red;
    }
    // _paint.shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(clipper.getClip(size), _paint);


    // canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
