import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';

/*
 * 红点 Widget
 **/
class RedPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: ThemeColors.colorE44239,
      ),
    );
  }
}
