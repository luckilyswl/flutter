import 'package:flutter/material.dart';

class XKTabBar extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("聊天界面"),
          backgroundColor: Colors.deepPurple,
      ),
      body: new Container(
        alignment: Alignment.bottomCenter,
        child: new TextField(

        ),
      ),
    );
  }
}