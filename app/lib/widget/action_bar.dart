import 'package:app/res/gradients.dart';
import 'package:flutter/material.dart';

/*
 * 渐变ActionBar(包含状态栏) Widget
 **/
class ActionBar {
  static Widget buildActionBar(BuildContext context, AppBar appBar) {
    return PreferredSize(
      child: Container(
        child: appBar,
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          gradient: Gradients.blueLinearGradient,
        ),
      ),
      preferredSize: Size(MediaQuery.of(context).size.width, 45.4),
    );
  }
}
