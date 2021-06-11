import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bubble_view/bubble_view.dart';
import 'package:flutter_bubble_view/bubbleview_pop_container.dart';
import 'package:flutter_bubble_view/flexible_container.dart';

typedef ConstraintsWidgetBuilder = Widget Function(
    BuildContext context, BoxConstraints? constraints);
enum DialogAnimation { material, scale }

typedef DialogTransitions = Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child);

Widget _buildScaleTransitions(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return Transform.scale(
      scale: animation.value,
      child: Opacity(opacity: animation.value, child: child));
}

DialogTransitions _buildTransitions(DialogAnimation animation) {
  if (animation == DialogAnimation.scale) {
    return _buildScaleTransitions;
  }
  return _buildMaterialDialogTransitions;
}

Widget _buildMaterialDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

class _DialogRouteEx<T> extends PopupRoute<T> {
  _DialogRouteEx({
    required RoutePageBuilder pageBuilder,
    bool barrierDismissible = true,
    String barrierLabel = "",
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 200),
    required RouteTransitionsBuilder transitionBuilder,
    RouteSettings? settings,
  })  : assert(barrierDismissible != null),
        _pageBuilder = pageBuilder,
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _barrierColor = barrierColor,
        _transitionDuration = transitionDuration,
        _transitionBuilder = transitionBuilder,
        super(settings: settings);

  final RoutePageBuilder _pageBuilder;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  String get barrierLabel => _barrierLabel;
  final String _barrierLabel;

  @override
  Color get barrierColor => _barrierColor;
  final Color _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

  final RouteTransitionsBuilder _transitionBuilder;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Semantics(
      child: _pageBuilder(context, animation, secondaryAnimation),
      scopesRoute: true,
      explicitChildNodes: true,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (_transitionBuilder == null) {
      return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.linear,
          ),
          child: child);
    } // Some default transition
    return _transitionBuilder(context, animation, secondaryAnimation, child);
  }
}

class DialogUtils {
  static Widget _defaultTransitionsBuilder1(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SlideTransition(
      position: AlwaysStoppedAnimation(Offset(0, -animation.value)),
      child: child,
    );
  }

  static Future showSimpleDialog(
      {required BuildContext context,
      bool barrierDismissible = true,
      ConstraintsWidgetBuilder? builder,
      Color backgroundColor = Colors.white,
      Color? barrierColor,
      EdgeInsets padding = EdgeInsets.zero,
      bool replace = false,
      BoxConstraints? constraint,
      DialogAnimation animation = DialogAnimation.material,
      double? minHeight,
      RouteSettings? routeSettings,
      double? elevation,
      BorderRadius? radius,
      EdgeInsets? insetPadding}) {
    if (constraint == null) {
      final mediaQuery = MediaQuery.of(context);
      final size = mediaQuery.size;
      constraint = BoxConstraints.tightForFinite(
          width: size.width, height: max(size.height / 3, minHeight ?? 250));
    }
    return showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        routeSettings: routeSettings,
        animation: animation,
        replace: replace,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Colors.transparent,
            elevation: elevation ?? 0,
            insetPadding: insetPadding ?? EdgeInsets.zero,
            contentPadding: padding,
            children: <Widget>[
              FlexibleContainer(
                color: backgroundColor,
                constraints: constraint,
                padding: padding,
                child: builder?.call(context, constraint),
                needClip: true,
                radius: radius ?? BorderRadius.circular(12),
              )
            ],
          );
        });
  }

  static Future showDialog(
      {required BuildContext context,
      bool barrierDismissible = true,
      required WidgetBuilder builder,
      Color? barrierColor = Colors.black54,
      bool useRootNavigator = true,
      bool replace = false,
      DialogAnimation animation = DialogAnimation.material,
      Duration transitionDuration = const Duration(milliseconds: 150),
      RouteSettings? routeSettings}) {
    if (barrierColor!.value == 0) {
      barrierColor = Color(0x01000000);
    }
    return showGeneralExDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = Builder(builder: builder);
        final ThemeData theme = Theme.of(context);
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return theme != null
                ? Theme(data: theme, child: pageChild)
                : pageChild;
          }),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor,
      replace: replace,
      transitionDuration: transitionDuration,
      transitionBuilder: _buildTransitions(animation),
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }

  static Future<T?> showGeneralExDialog<T>({
    required BuildContext context,
    required RoutePageBuilder pageBuilder,
    bool barrierDismissible = true,
    String barrierLabel = "",
    required Color barrierColor,
    required Duration transitionDuration,
    required RouteTransitionsBuilder transitionBuilder,
    bool useRootNavigator = true,
    bool replace = false,
    RouteSettings? routeSettings,
  }) {
    assert(pageBuilder != null);
    assert(useRootNavigator != null);
    assert(!barrierDismissible || barrierLabel != null);
    final route = _DialogRouteEx<T>(
      pageBuilder: pageBuilder,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
      settings: routeSettings,
    );

    return replace == true
        ? Navigator.of(context, rootNavigator: useRootNavigator)
            .pushReplacement(route)
        : Navigator.of(context, rootNavigator: useRootNavigator).push<T>(route);
  }
  static Future showPopupTips(BuildContext context, Rect anchorBoundary,
      {double? width,
        double? height,
        double spacing = 4,
        Color? backgroundColor,
        Gradient? gradient,
        Radius? radius,
        double offsetScale = 0.5,
        BubbleArrow? arrow,
        Widget? child}) {
    return showDialog(
        context: context,
        transitionDuration: Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        builder: (context) {
          return Dialog(
              insetPadding: EdgeInsets.all(0),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: BubbleViewPopContainer(
                anchorBoundary: anchorBoundary,
                verticalOffset: spacing,
                width: width ?? double.infinity,
                height: height ?? double.infinity,
                gradient: gradient,
                backgroundColor: backgroundColor,
                radius: radius == null ? Radius.circular(20) : radius,
                offsetScale: offsetScale,
                arrow: arrow??BubbleArrow.top,
                child: child,
              ));
        });
  }
}
