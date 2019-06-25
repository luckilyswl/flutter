import 'package:flutter/material.dart';
import 'package:app/pages/home/home_page.dart';

/*
 * 配置路由
 **/
class Page {
  static const String WELCOME_PAGE = '/';
  static const String HOME_PAGE = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    var route = {
      HOME_PAGE: (context) => HomePage(),
    };

    return route;
  }
}
