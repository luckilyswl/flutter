import 'package:flutter/material.dart';

const APPBAR_SCROLL_OFFSET = 100;

/*
 * 首页
 **/
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('首页'),
      ),
    );
  }
}