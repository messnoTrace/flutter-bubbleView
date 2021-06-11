part of 'bubble_view.dart';

enum BubbleArrow { none, left, right, top, bottom }

class BubbleViewClipper extends CustomClipper<Path> {
  final BubbleArrow nip;
  Radius? radius;
  final double nipRadius;
  final double nipWidth;
  final double nipHeight;
  final double nipOffset;
  late double _nipPX;
  late double _nipPY;

  BubbleViewClipper(
      {this.nip = BubbleArrow.top,
      this.nipOffset = 0,
      this.radius,
      this.nipRadius = 4,
      this.nipHeight = 8,
      this.nipWidth = 16}) {
    var k = nipHeight / (nipWidth * 0.5);
    _nipPX = nipRadius / sqrt(1 + k * k);
    _nipPY = _nipPX * k;
    print(
        "_nipPX:$_nipPX _nipPy:$_nipPY nipHeight:$nipHeight $nipWidth nipOffset=$nipOffset");
  }

  @override
  Path getClip(Size size) {
    final path = Path();
    switch (nip) {
      case BubbleArrow.top:
        path.addRRect(RRect.fromLTRBR(0, nipHeight, size.width, size.height,
            radius ?? Radius.circular(12)));

        path.moveTo(nipOffset - (nipWidth / 2), nipHeight);
        path.lineTo(nipOffset - _nipPX, _nipPY);
        path.arcToPoint(Offset(nipOffset + _nipPX, _nipPY),
            radius: Radius.circular(nipRadius), clockwise: true);
        path.lineTo(nipOffset + (nipWidth / 2), nipHeight);

        path.close();
        break;
      case BubbleArrow.bottom:
        final rect = RRect.fromLTRBR(0, 0, size.width, size.height - nipHeight,
            radius ?? Radius.circular(12));
        path.addRRect(rect);
        path.moveTo(nipOffset - (nipWidth / 2), rect.bottom);
        path.lineTo(nipOffset - _nipPX, rect.bottom + nipHeight - _nipPY);
        path.arcToPoint(
            Offset(nipOffset + _nipPX, rect.bottom + nipHeight - _nipPY),
            radius: Radius.circular(nipRadius),
            clockwise: false);
        path.lineTo(nipOffset + (nipWidth / 2), rect.bottom);
        path.close();
        break;
      case BubbleArrow.left:
        final rect = RRect.fromLTRBR(
            0, 0, size.width, size.height, radius ?? Radius.circular(12));
        path.addRRect(rect);
        path.moveTo(0, nipOffset - (nipWidth / 2));
        path.lineTo(-nipHeight / 2 - _nipPX, nipOffset - _nipPY);
        path.arcToPoint(Offset(-nipHeight / 2 - _nipPX, nipOffset + _nipPY),
            radius: Radius.circular(nipRadius), clockwise: false);
        path.lineTo(0, nipOffset + (nipWidth / 2));
        path.close();
        break;
      case BubbleArrow.right:
        final rect = RRect.fromLTRBR(
            0, 0, size.width, size.height, radius ?? Radius.circular(12));
        path.addRRect(rect);
        path.moveTo(rect.right, nipOffset - (nipWidth / 2));
        path.lineTo(rect.right + nipOffset / 2 - _nipPX*2, nipOffset - _nipPY);
        path.arcToPoint(
            Offset(rect.right + nipOffset / 2 - _nipPX*2, nipOffset + _nipPY),
            radius: Radius.circular(nipRadius),
            clockwise: true);
        path.lineTo(rect.right, nipOffset + (nipWidth / 2));
        path.close();
        break;
      case BubbleArrow.none:
        final rect = RRect.fromLTRBR(
            0, 0, size.width, size.height, radius ?? Radius.circular(12));
        path.addRRect(rect);
        path.close();
        break;
      default:
        break;
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
