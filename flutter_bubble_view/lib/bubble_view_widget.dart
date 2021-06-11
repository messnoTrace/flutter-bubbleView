part of 'bubble_view.dart';

class BubbleViewWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final double nipOffset;
  final Radius? radius;
  final double? spacing;
  final BubbleArrow nip;
  final double nipRadius;
  final double nipWidth;
  final double nipHeight;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Widget? child;

  BubbleViewWidget(
      {Key? key,
      this.width,
      this.height,
      required this.nipOffset,
      required this.nip,
      this.radius,
      this.gradient,
      this.backgroundColor,
      this.nipRadius = 4,
      this.nipWidth = 16,
      this.nipHeight = 16,
      this.spacing = 16,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.only(
        top: nip == BubbleArrow.top ? nipHeight : 0.0,
        bottom: nip == BubbleArrow.bottom ? nipHeight : 0.0,
        left: nip == BubbleArrow.left ? nipHeight : 0.0,
        right: nip == BubbleArrow.right ? nipHeight : 0.0);
    return Container(
      constraints: BoxConstraints(
          minWidth: width ?? 0.0,
          maxWidth: width ?? double.infinity,
          minHeight: height ?? 0.0),
      // width: width,
      // height: height,
      child: CustomPaint(
          painter: BubbleViewPainter(
            backgroundColor: backgroundColor,
            gradient: gradient,
            clipper: BubbleViewClipper(
                nip: nip,
                nipOffset: nipOffset,
                nipRadius: nipRadius,
                nipWidth: nipWidth,
                radius: radius,
                nipHeight: nipHeight),
          ),
          child: Padding(
            padding: padding, // nip height
            child: child,
          )),
    );
  }
}
