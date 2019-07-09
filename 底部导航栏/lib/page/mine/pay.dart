import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_wechat/page/mine/SyFlutterWechat.dart';
/*
class Pay extends StatelessWidget{
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
*/


class Pay extends StatefulWidget {
  @override
  _PayState createState() => new _PayState();
}

class _PayState extends State<Pay> {
  @override
  void initState() {
    super.initState();
    _register();
  }

  _register() async {
    bool result = await SyFlutterWechat.register('wxf9909bde17439ac2');
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('微信支付'),
          backgroundColor: Colors.deepPurple,
        ),
        body: new ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            RaisedButton(
              child: Text('支付'),
              onPressed: () async {
                String payInfo =
                    '{"appid":"wxf9909bde17439ac2","partnerid":"1518469211","prepayid":"wx120649521695951d501636f91748325073","package":"Sign=WXPay","noncestr":"1541976592","timestamp":"1541976592","sign":"E760C99A1A981B9A7D8F17B08EF60FCC"}';
                SyPayResult payResult = await SyFlutterWechat.pay(
                    SyPayInfo.fromJson(json.decode(payInfo)));
                print(payResult);
              },
            ),
          ],
        ),
      ),
    );
  }
}