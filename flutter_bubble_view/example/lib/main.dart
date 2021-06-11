import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bubble_view/bubble_view.dart';
import 'package:flutter_bubble_view/dialog_utils.dart';
import 'package:flutter_bubble_view/widget_utils.dart';
import 'package:flutter_bubble_view/bubbleview_container.dart';

void main() {
  runApp(ExampleApp());
}

class ExampleApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExampleState();
  }
}

class ExampleState extends State {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey _topKey = GlobalKey();
  final GlobalKey _bottomKey = GlobalKey();
  final GlobalKey _leftKey = GlobalKey();
  final GlobalKey _rightKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('BubbleView app'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: size.width / 2 - 50,
            top: size.height / 2,
            child: Container(
              color: Colors.grey,
              width: 100,
              height: 50,
              child: Center(
                child: Text(
                  "example",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              top: size.height / 2 + 70,
              child: BubbleViewContainer(
                width: 150,
                height: 50,
                child: Center(child: Text("ArrowTop")),
              )),
          Positioned(
              left: 0,
              right: 0,
              top: size.height / 2 - 70,
              child: BubbleViewContainer(
                width: 150,
                height: 50,
                arrow: BubbleArrow.bottom,
                child: Center(
                    child: Text(
                  "ArrowBottom",
                  style: TextStyle(color: Colors.white),
                )),
              )),
          Positioned(
              left: 0,
              top: size.height / 2,
              child: BubbleViewContainer(
                width: 100,
                height: 50,
                arrow: BubbleArrow.right,
                child: Center(child: Text("ArrowRight")),
              )),
          Positioned(
              right: 0,
              top: size.height / 2,
              child: BubbleViewContainer(
                width: 100,
                height: 50,
                arrow: BubbleArrow.left,
                child: Center(child: Text("ArrowLeft")),
              )),
          Positioned(
              left: 0,
              top: size.height / 2 - 75,
              child: BubbleViewContainer(
                width: 100,
                height: 50,
                arrow: BubbleArrow.none,
                child: Center(child: Text("ArrowNone")),
              )),
          Positioned(
              top: size.height / 4,
              left: size.width / 2 - 50,
              child: GestureDetector(
                key: _topKey,
                onTap: () {
                  showBubbleView(_topKey, BubbleArrow.top, "top");
                },
                child: Container(
                  color: Colors.grey,
                  width: 100,
                  height: 50,
                  child: Center(
                    child: Text(
                      "showTop",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )),
          Positioned(
              top: size.height / 4 - 60,
              left: size.width / 2 - 50,
              child: GestureDetector(
                key: _bottomKey,
                onTap: () {
                  showBubbleView(_bottomKey, BubbleArrow.bottom, "bottom");
                },
                child: Container(
                  color: Colors.grey,
                  width: 100,
                  height: 50,
                  child: Center(
                    child: Text(
                      "showBottom",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )),
          Positioned(
              top: size.height / 4 - 120,
              left: size.width / 2 - 50,
              child: GestureDetector(
                key: _leftKey,
                onTap: () {
                  showBubbleView(_leftKey, BubbleArrow.left, "left");
                },
                child: Container(
                  color: Colors.grey,
                  width: 100,
                  height: 50,
                  child: Center(
                    child: Text(
                      "showLeft",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )),
          Positioned(
              top: size.height / 4 - 180,
              left: size.width / 2 - 50,
              child: InkWell(
                key: _rightKey,
                onTap: () {

                  showBubbleView(_rightKey, BubbleArrow.right, "right");
                },
                child: Container(
                  color: Colors.grey,
                  width: 100,
                  height: 50,
                  child: Center(
                    child: Text(
                      "showRight",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void showBubbleView(GlobalKey key,BubbleArrow arrow,String text){
    final size=MediaQuery.of(context);
    final anchor = WidgetUtils.getWidgetBoundary(key,
        offset: Offset(0, -size.padding.top));
    final tipsWidth = 200.0;
    final textStyle = TextStyle(
        color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500);
    final strutStyle = StrutStyle(forceStrutHeight: true, height: 1.5);
    final tipsHeight = 50.0;
    DialogUtils.showPopupTips(context, anchor,
        width: tipsWidth,
        height: tipsHeight,
        backgroundColor: Colors.black87,
        radius: Radius.circular(12),
        arrow: arrow,
        child: Padding(
          padding: EdgeInsets.only(
            left: tipsWidth * 0.07,
            right: tipsWidth * 0.07,
            top: 11,
            bottom: 13,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            strutStyle: strutStyle,
            style: textStyle,
          ),
        ));
  }
}
