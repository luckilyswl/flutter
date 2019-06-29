import 'dart:convert';

import 'package:flutter/material.dart';

void main() => runApp(    //入口代码。没有这句，代码无法运行
    new MaterialApp(
        home: new MyApp()
    )
);

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  List data;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("读取json数据"),
        ),
        body: new Container(   //容器
          child: new Center(
            // Use future builder and DefaultAssetBundle to load the local JSON file
            child: new FutureBuilder(
                future: DefaultAssetBundle
                    .of(context)
                    .loadString('data_repo/starwars_data.json'),
                builder: (context, snapshot) {
                  // Decode the JSON : 解码json
                  var new_data = json.decode(snapshot.data.toString());

                  return new ListView.builder(
                    // Build the ListView
                    itemBuilder: (BuildContext context, int index) {
                      return new Card(   //卡片
                        child: new Column(   //布局
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Text("Name : " + new_data[index]['name']),
                            new Text("Height : " + new_data[index]['height'],style: TextStyle(color: Colors.teal),),
                            new Text("Mass : " + new_data[index]['mass']),
                            new Text("Hair Color : " + new_data[index]['hair_color'],style: TextStyle(color: Colors.amber)),
                            new Text("Skin Color : " + new_data[index]['skin_color']),
                            new Text("Eye Color : " + new_data[index]['eye_color'],style: TextStyle(color: Colors.blue)),
                            new Text("Birth Year : " + new_data[index]['birth_year']),
                            new Text("Gender : " + new_data[index]['gender'],style: TextStyle(color: Colors.red))
                          ],
                        ),
                      );
                    },
                    //注释这行，会出现错误，但也不影响运行：RangeError (index): Invalid value: Not in range 0..10, inclusive: 11
                    itemCount: new_data == null ? 0 : new_data.length,
                  );
                }),
          ),
        ));
  }
}