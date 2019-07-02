import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';

/*
 * 渐变 res
 **/
class Gradients {
  ///蓝色渐变
  static const blueLinearGradient = LinearGradient(
    begin: Alignment(1.0, 0.0),
    end: Alignment(-1, 0.0),
    colors: [
      ThemeColors.color555C9E,
      ThemeColors.color2E3576,
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
    colors: [
      ThemeColors.colorFFEFD4,
      ThemeColors.colorFFE3B1,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  ///金暗色渐变
  static const goldDarkLinearGradient = LinearGradient(
    colors: [
      ThemeColors.colorD39857,
      ThemeColors.colorE9B882,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  ///金暗色渐变
  static const blackLinearGradient = LinearGradient(
    colors: [
      ThemeColors.color333333,
      ThemeColors.color666666,
    ],
  );
}
