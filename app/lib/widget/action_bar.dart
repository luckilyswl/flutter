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
          image: DecorationImage(
            image: AssetImage('assets/images/ic_action_bar_status_bg.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
      preferredSize: Size(MediaQuery.of(context).size.width, 44),
    );
  }
}
