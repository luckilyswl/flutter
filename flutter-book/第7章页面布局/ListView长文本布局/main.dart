import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    title: '滚动布局示例',
    home: new MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {




    return new Scaffold(
      appBar: new AppBar(
        title: new Text('滚动布局示例'),
      ),
      body:new ListView(
        children: <Widget>[
          new Center(
            child: new Text(
              '\n广州天河区公园',
              style: new TextStyle(
                fontSize:30.0,
              ),
            ),
          ),
          new Center(
            child: new Text(
              '天河公园',
              style: new TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          new Center(
            child: new Text(
              '''天河公园，是区属综合性公园，位于广州天河区员村，西靠天府路，南连黄埔大道，北接中山大道，来往交通十分便利。公园总面积为70.7公顷，水体面积占10公顷。天河公园以自然生态景观为主要特色，公园规划为五个功能区：百花园景区、文体娱乐区、老人活动区、森林休憩区、后勤管理区。
              ''',
              style: new TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
