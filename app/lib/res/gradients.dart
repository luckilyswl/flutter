import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';

/*
 * 渐变 res
 **/
class Gradients {
  ///蓝色渐变
  static const blueLinearGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      ThemeColors.color363659,
      ThemeColors.color54548C,
    ],
  );

  static const loginBgLinearGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      ThemeColors.color555C9E,
      ThemeColors.color2E3576,
    ],
  );

  ///金亮色渐变
  static const goldLightLinearGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      ThemeColors.colorFFEFD4,
      ThemeColors.colorFFE3B1,
    ],
  );

  ///金暗色渐变
  static const goldDarkLinearGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      ThemeColors.colorF9D598,
      ThemeColors.colorD59D56,
    ],
  );

  ///金暗色渐变
  static const blackLinearGradient = LinearGradient(
    colors: [
      ThemeColors.color333333,
      ThemeColors.color666666,
    ],
  );

  /// 返回买单渐变
  static const returnBuyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xffE8B177),
      Color(0xffD08F49),
    ],
  );
}
