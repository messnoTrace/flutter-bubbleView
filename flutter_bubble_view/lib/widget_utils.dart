import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



class TextMetrics {
  final double width;
  final double height;
  final int? maxLines;
  final bool didExceedMaxLines;
  final double preferredLineHeight;

  TextMetrics(
      {required this.width,
      required this.height,
      required this.maxLines,
      required this.didExceedMaxLines,
      required this.preferredLineHeight});

  @override
  String toString() {
    return 'TextMetrics{width: $width, height: $height, maxLines: $maxLines, didExceedMaxLines: $didExceedMaxLines, preferredLineHeight: $preferredLineHeight}';
  }
}

class WidgetUtils {

  static Size calculateTextSize(String text, TextStyle style,
      {double? maxWidth, StrutStyle? strutStyle, int maxLine = 1}) {
    final constraints = BoxConstraints(
      maxWidth: maxWidth ?? double.infinity,
      minHeight: 0.0,
      minWidth: maxWidth ?? 0.0,
    );

    final renderParagraph = RenderParagraph(
        TextSpan(
          text: text,
          style: style,
        ),
        maxLines: maxLine,
        strutStyle: strutStyle ?? StrutStyle.fromTextStyle(style),
        textDirection: TextDirection.ltr)
      ..layout(constraints);
    return Size(renderParagraph.getMinIntrinsicWidth(style.fontSize ?? 14.0).ceilToDouble(),
        renderParagraph.getMinIntrinsicHeight(style.fontSize ?? 14.0).ceilToDouble());
  }

  static TextMetrics measureText(String text, TextStyle style,
      {double? maxWidth, StrutStyle? strutStyle, int maxLines = 1}) {
    TextPainter painter = TextPainter(
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        strutStyle: strutStyle ?? StrutStyle.fromTextStyle(style),
        text: TextSpan(text: text, style: style));
    painter.layout(maxWidth: maxWidth ?? double.infinity);
    return TextMetrics(
        width: painter.width,
        height: painter.height,
        maxLines: maxLines,
        didExceedMaxLines: painter.didExceedMaxLines,
        preferredLineHeight: painter.preferredLineHeight);
  }

  static String breakWord(String word) {
    if (word == null || word.isEmpty) {
      return word;
    }
    String breakWord = ' ';
    word.runes.forEach((element) {
      breakWord += String.fromCharCode(element);
      breakWord += '\u200B';
    });
    return breakWord;
  }

  static Rect getWidgetBoundary(GlobalKey key, {Offset offset = Offset.zero}) {
    RenderObject? widgetRenderBox = key.currentContext?.findRenderObject();
    if (widgetRenderBox != null) {
      Offset widgetOffset = (widgetRenderBox as RenderBox).localToGlobal(Offset.zero);
      Size size = widgetRenderBox.size;
      final widgetCenter =
          Rect.fromLTWH(widgetOffset.dx, widgetOffset.dy, size.width, size.height).center;
      return Rect.fromCenter(
          center: Offset(widgetCenter.dx + offset.dx, widgetCenter.dy + offset.dy),
          width: size.width,
          height: size.height);
    }
    return Rect.zero;
  }
}
