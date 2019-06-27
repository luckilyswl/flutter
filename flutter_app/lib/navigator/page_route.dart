import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/home.dart';


class Page{

  static const String WELCOME_PAGE = '/';
  static const String HOME_PAGE = '/home';

  static Map<String ,WidgetBuilder> getRoutes(){
    var route = {
      HOME_PAGE:(context) => Home(),
    };
    return route;
  }

}
