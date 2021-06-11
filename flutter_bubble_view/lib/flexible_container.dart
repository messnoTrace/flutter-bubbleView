

import 'package:flutter/material.dart';

class FlexibleContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius radius;
  final Color? color;
  final DecorationImage? image;
  final List<BoxShadow>? shadows;
  final Alignment? alignment;
  final bool needClip;
  final BoxShape shape;
  final Gradient? gradient;
  final BoxConstraints? constraints;

  final Widget? child;

  FlexibleContainer(
      {Key? key,
      this.width,
      this.height,
      this.constraints,
      this.margin,
      this.padding,
      this.borderColor,
      this.borderWidth = 1.0,
      this.shape = BoxShape.rectangle,
      this.color,
      this.radius = BorderRadius.zero,
      this.gradient,
      this.shadows,
      this.alignment,
      this.needClip = false,
      this.image,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _borderColor = borderColor;
    final _borderWidth = borderWidth ?? 1.0;
    return Container(
        height: height,
        width: width,
        margin: margin,
        padding: padding,
        constraints: constraints,
        alignment: alignment ?? Alignment.center,
        decoration: BoxDecoration(
            gradient: gradient,
            border: _borderColor == null
                ? null
                : Border.all(
                    color: _borderColor,
                    width: _borderWidth,
                    style: BorderStyle.solid,
                  ),
            shape: shape,
            borderRadius: (shape == BoxShape.rectangle) ? radius : null,
            boxShadow: shadows,
            image: image,
            color: color),
        child: needClip
            ? (shape == BoxShape.circle
                ? ClipOval(
                    child: child,
                  )
                : ClipRRect(
                    borderRadius: radius,
                    child: child,
                  ))
            : child);
  }
}
