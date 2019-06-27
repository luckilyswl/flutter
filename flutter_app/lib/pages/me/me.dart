import 'package:flutter/material.dart';

const APPBAR_SCROLL_OFFSET = 100;

/*
 * 首页
 **/
class Me extends StatefulWidget {
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('我的'),
      ),
    );
  }
}
