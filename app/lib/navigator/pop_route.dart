import 'package:flutter/material.dart';

/*
 * 自定义PopupWindow路由
 **/
class PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 100);
  Widget child;
  bool dimissable;

  PopRoute({@required this.child, @required this.dimissable = true});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => dimissable;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
