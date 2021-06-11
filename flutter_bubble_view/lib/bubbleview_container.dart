import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bubble_view/bubble_view.dart';

class BubbleViewContainer extends StatefulWidget {
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

  BubbleViewContainer(
      {Key? key,
      this.width = 0.0,
      this.height = 0.0,
      this.anchorBoundary,
      this.verticalOffset = 10.0,
      this.backgroundColor = Colors.black38,
      this.gradient,
      this.radius,
      this.child,
      this.offsetScale = 0.5,
      this.horizontalMargin = 16.0,
      this.arrow = BubbleArrow.top})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BubbleViewContainerState();
  }
}

class BubbleViewContainerState extends State<BubbleViewContainer> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final boundaryLeft = widget.horizontalMargin!;
    final boundaryRight = screenSize.width - widget.horizontalMargin!;
    final bubbleWidth = min((boundaryRight - boundaryLeft), widget.width);
    final bubbleRight = min(
        widget.anchorBoundary?.center.dx ??
            0 + (bubbleWidth * (1 - widget.offsetScale)),
        boundaryRight);
    final bubbleLeft = max(
        widget.anchorBoundary?.center.dx ??
            0 - (bubbleWidth * widget.offsetScale),
        boundaryLeft);
    final tipsOffset =
        (widget.arrow == BubbleArrow.top || widget.arrow == BubbleArrow.bottom)
            ? bubbleWidth * widget.offsetScale
            : widget.height * widget.offsetScale;
    print(
        "build bubbleWidth:$bubbleWidth tipsLeft:$bubbleLeft tipsRight:$bubbleRight");
    return Center(
      child: Container(
        width: bubbleWidth,
        height: widget.height,
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
    );
  }
}
