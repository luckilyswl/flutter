import 'package:app/pages/login/bind_page.dart';
import 'package:app/pages/login/login_page.dart';
import 'package:app/pages/login/register_page.dart';
import 'package:app/pages/me/setting.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/pages_index.dart';

/*
 * 配置路由
 **/
class Page {
  static const String SPLASH_PAGE = '/splash';
  static const String ROOT_PAGE = '/rootPage';
  static const String LOGIN_PAGE = '/login';
  static const String BIND_PAGE = '/bind';
  static const String REGISTER_PAGE = '/register';
  static const String SETTING_PAGE = '/setting';

  static Map<String, WidgetBuilder> getRoutes() {
    var route = {
      SPLASH_PAGE: (context) => SplashPage(),
      ROOT_PAGE: (context) => TabNavigator(),
      LOGIN_PAGE: (context) => LoginPage(),
      BIND_PAGE: (context) => BindPage(),
      REGISTER_PAGE: (context) => RegisterPage(),
      SETTING_PAGE: (context) => SettingPage(),
    };

    return route;
  }
}
