import 'package:flutter/material.dart';


class customer_service extends StatefulWidget{
  @override
  _Customer_serviceState createState() => new _Customer_serviceState();
}
class _Customer_serviceState extends State{

  static const String _title = '客服';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: _title,
      home: new Scaffold(
        appBar: new AppBar(
          title:Text(_title),
          backgroundColor: Colors.deepPurple,
        ),
        body: MyStatelessWidget(),
      ),
    );
  }
}

class MyStatelessWidget  extends StatelessWidget{

  MyStatelessWidget({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    return Center(
      child:Card(
        /* child: InkWell(
           splashColor: Colors.deepPurple.withAlpha(30),
           onTap: (){
             print('Card tapped.');
           },
           child: Container(
             width:300,
             height: 100,
             child: Text('A card that can be tapped'),
           ),
         ),*/
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('BUY TICKETS'),
                    onPressed: (){
                      /*...*/
                    },
                  ),
                  FlatButton(
                    child: const Text('LISTEN'),
                    onPressed: (){
                      /*...*/
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
