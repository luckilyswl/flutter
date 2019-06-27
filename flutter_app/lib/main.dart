import 'package:flutter/material.dart';
import 'package:flutter_app/navigator/tab_navigator.dart';
import 'package:flutter_app/navigator/page_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '登录',
      theme: ThemeData(
        primarySwatch: Colors.blue
    ),
      home: TabNavigator(),
      routes: Page.getRoutes(),
    );
  }
}