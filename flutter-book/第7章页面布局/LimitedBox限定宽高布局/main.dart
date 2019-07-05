import 'package:flutter/material.dart';
class LayoutDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('LimitedBox限定宽高布局示例'),
        ),
        body: Row(
          children: <Widget>[
            Container(
              color: Colors.grey,
              width: 100.0,
            ),
            LimitedBox(
              maxWidth: 150.0,//设置最大宽度 限定child在此范围内
              child: Container(
                color: Colors.lightGreen,
                width: 250.0,
              ),
            ),
          ],

        )
    );
  }
}
void main() {
  runApp(
    new MaterialApp(
      title: 'LimitedBox限定宽高布局示例',
      home: new LayoutDemo(),
    ),
  );
}
