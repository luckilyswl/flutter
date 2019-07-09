import 'package:flutter/material.dart';
import 'package:flutter_wechat/page/mine/pay.dart';

class mine extends StatefulWidget{

  @override
  _mineState createState() => new _mineState();
}

class  _mineState extends State{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text('我的信息'),
            backgroundColor: Colors.deepPurple,
        ),
        body: new ListView(
          children: <Widget>[
            new Container(
              padding:const EdgeInsets.only(top: 20.0),
              color: Colors.grey[200],
              child: new Container(
                color: Colors.white,
                height: 100.0,
                child: new ListTile(
                  title: new Text("头像"),
                  trailing: new Image.asset("images/xk.jpg",width: 60.0,height: 60.0,),
                ),
              ),
            ),
            new Container(
              padding:const EdgeInsets.only(top: 20.0),
              color: Colors.grey[200],
              child: new Container(
                color: Colors.white,
                height: 45.0,
                child: new ListTile(
                  title: new Text("名字"),
                  trailing: new Text("Tony"),
                ),
              ),
            ),
            new Container(
              color: Colors.white,
              height: 45.0,
              child: new ListTile(
                title: new Text("微信号"),
                trailing: new Text("tony001"),
              ),
            ),
             new ListTile(
               onTap: (){
                  Navigator.of(context).push(
                     new MaterialPageRoute(
                        builder: (context){
                          return new Pay();
                        }
                     )
                  );
               },
               title: new Text("支付"),
             ),
            new Container(
              color: Colors.white,
              height: 45.0,
              child: new ListTile(
                title: new Text("更多"),
                trailing: new Icon(Icons.arrow_forward_ios,size: 17.0,),
              ),
            ),
            new Container(
              color: Colors.white,
              height: 45.0,
              child: new ListTile(
                title: new Text("我的地址"),
                trailing: new Icon(Icons.arrow_forward_ios,size: 17.0),
              ),
            ),
          ],
        ),
    );
  }
}