import 'package:flutter/material.dart';



class MyAppBar extends StatelessWidget {
  MyAppBar({this.title});

  final Widget title;  // Widget子类中的字段往往都会定义为"final"

  @override
  Widget build(BuildContext context) {
    return new Container(
      //单位是逻辑上的像素（并非真实的像素，类似于浏览器中的像素）
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: new BoxDecoration(color: Colors.blue[500]),
      // Row 是水平方向的线性布局（linear layout）
      child: new Row(
        //列表项的类型是 <Widget>
        children: <Widget>[
          new IconButton(
              icon: new Icon(Icons.menu),
              tooltip: 'Navigation menu',
              onPressed: null    // null 会禁用 button
          ),
          new Expanded(child: title),
          new IconButton(
              icon: new Icon(Icons.search),
              tooltip: 'Search',
              onPressed: null    // null 会禁用 button
          ),
        ],
      ),
    );
  }
}

class MyScaffold extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // Material 是UI呈现的“一张纸”
    return new Material(
      // Column is 垂直方向的线性布局.
      child: new Column(
        children: <Widget>[
          new MyAppBar(
            title: new Text(
                'Example title',
                 style: Theme.of(context).primaryTextTheme.title,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(new MaterialApp(
    title: 'My App',
    home: new MyScaffold(),
  ));
}