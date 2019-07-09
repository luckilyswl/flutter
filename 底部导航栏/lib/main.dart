import 'package:flutter/material.dart';
import 'package:flutter_wechat/page/home/home.dart';
import 'package:flutter_wechat/page/mine/mine.dart';
import 'package:flutter_wechat/page/manager/manager.dart';
import 'package:flutter_wechat/page/customer_service/customer_service.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
        home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{

    MyHomePage({Key key,}) : super(key:key);

    @override
    _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  List<BottomNavigationBarItem> Navdata = [
    new BottomNavigationBarItem(icon: Icon(Icons.home),title: Text('首页')),
    new BottomNavigationBarItem(icon: Icon(Icons.build),title: Text('管理')),
    new BottomNavigationBarItem(icon: Icon(Icons.call),title: Text('客服')),
    new BottomNavigationBarItem(icon: Icon(Icons.person),title: Text('我的')),

  ];

  int _index=0;
  List<StatefulWidget> vcSet = [
    new home(),
    new manager(),
    new customer_service(),
    new mine()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: new BottomNavigationBar(

        items: Navdata,
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.deepPurple,
        onTap: (int index){
           setState(() {
             _index = index ;
           });
        },
      ),
      body: vcSet[_index],
    );
  }

}
