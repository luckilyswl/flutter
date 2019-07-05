import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final title = "网格列表示例";

    return new MaterialApp(
      title: title,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(title),
        ),
        //使用GridView.count构建网格
        body: new GridView.count(
          primary: false,
          //四周增加一定的空隙
          padding: const EdgeInsets.all(20.0),
          crossAxisSpacing: 30.0,
          //一行上放三列数据
          crossAxisCount: 3,
          //数据项 五行三列
          children: <Widget>[
            const Text('第一行第一列'),
            const Text('第一行第二列'),
            const Text('第一行第三列'),
            const Text('第二行第一列'),
            const Text('第二行第二列'),
            const Text('第二行第三列'),
            const Text('第三行第一列'),
            const Text('第三行第二列'),
            const Text('第三行第三列'),
            const Text('第二行第三列'),
            const Text('第三行第一列'),
            const Text('第三行第二列'),
            const Text('第三行第三列'),
            const Text('第三行第三列'),
            const Text('第三行第三列'),
          ],
        ),
      ),
    );
  }
}
