import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bubble_view/bubble_view.dart';

class BubbleViewPopContainer extends StatefulWidget {
  final Rect? anchorBoundary;
  final double verticalOffset;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Widget? child;
  final Radius? radius;
  final double offsetScale;
  final double? horizontalMargin;
  final BubbleArrow? arrow;

  BubbleViewPopContainer(
      {Key? key,
      this.width = 0.0,
      this.height = 0.0,
      this.anchorBoundary,
      this.verticalOffset = 10.0,
      this.backgroundColor,
      this.gradient,
      this.radius,
      this.child,
      this.offsetScale = 0.5,
      this.horizontalMargin = 16.0,
      this.arrow = BubbleArrow.top})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BubbleViewPopContainerState();
  }
}

class BubbleViewPopContainerState extends State<BubbleViewPopContainer> {
  @override
  Widget build(BuildContext context) {
    print(
        "----BubbleArrow=${widget.arrow}  center=${widget.anchorBoundary!.center} anch=${widget.anchorBoundary}");
    final screenSize = MediaQuery.of(context).size;
    final boundaryLeft = widget.horizontalMargin!;
    final boundaryRight = screenSize.width - widget.horizontalMargin!;
    final boundaryTop = widget.verticalOffset;
    final boundaryBottom = screenSize.height - widget.verticalOffset;
    print(
        "----boundaryLeft=$boundaryLeft  boundaryRight=$boundaryRight  screenSize.with=${screenSize.width} height=${screenSize.height}");

    final bubbleWidth = min((boundaryRight - boundaryLeft), widget.width);
    final bubbleRight = min(
        widget.anchorBoundary!.center.dx +
            (bubbleWidth * (1 - widget.offsetScale)),
        boundaryRight);

    final bubbleLeft = max(
        widget.anchorBoundary!.center.dx - (bubbleWidth * widget.offsetScale),
        boundaryLeft);

    final bubbleTop = max(
        widget.anchorBoundary!.center.dy - (widget.height * widget.offsetScale),
        boundaryTop);
    final bubbleBottom = min(
        widget.anchorBoundary!.center.dy +
            (widget.height * (1 - widget.offsetScale)),
        boundaryBottom);
    final tipsOffset =
        (widget.arrow == BubbleArrow.top || widget.arrow == BubbleArrow.bottom)
            ? bubbleWidth * widget.offsetScale
            : widget.height * widget.offsetScale;
    print(
        "build tipsWidth:$bubbleWidth tipsLeft:$bubbleLeft tipsRight:$bubbleRight");
    double? top = widget.anchorBoundary!.bottom + widget.verticalOffset;
    double? left = bubbleLeft;
    switch (widget.arrow) {
      case BubbleArrow.left:
        left = widget.anchorBoundary!.right + widget.verticalOffset;
        top = widget.anchorBoundary!.center.dy -
            widget.height * widget.offsetScale;
        break;
      case BubbleArrow.bottom:
        top = widget.anchorBoundary!.top -
            widget.verticalOffset -
            widget.anchorBoundary!.height;
        break;
      case BubbleArrow.right:
        left =
            widget.anchorBoundary!.left - widget.verticalOffset - bubbleWidth;
        top = widget.anchorBoundary!.center.dy -
            (widget.height * widget.offsetScale);
        break;
      case BubbleArrow.none:
        break;
      default:
        break;
    }
    print(
        "------top=$top left=$left height=${widget.height}");
    return Stack(
      children: [
        Positioned(
          top: top,
          left: left,
          child: BubbleViewWidget(
              width: bubbleWidth,
              height: widget.height,
              nipOffset: tipsOffset,
              nip: widget.arrow!,
              nipHeight: 6,
              nipRadius: 4,
              radius: widget.radius,
              gradient: widget.gradient,
              backgroundColor: widget.backgroundColor,
              child: widget.child),
        ),
        GestureDetector(
          onScaleStart: (_) {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
