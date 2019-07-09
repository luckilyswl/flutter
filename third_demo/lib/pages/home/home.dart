import 'package:flutter/material.dart';
import 'package:third_demo/message.dart';


class MyHomePage extends StatefulWidget{
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var textEditingController = TextEditingController();
  var messageList = List<Message>();
  
 /* @override
  void initState() {
    super.initState();
    for(var i = 0;i < 10; i++){
      messageList.add(Message("你好啊$i"));
    }
  }*/
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('小QQ聊天机器人'),
        ),
      body: Column(
        children: <Widget>[
          Flexible(
              child: ListView.builder(
                itemBuilder: (context,index) {
                  if(messageList[index].username == '我'){
                    return buildRightItem(messageList[index].content);
                  }else{
                    return buildLeftItem(messageList[index].content);
                  }
                },
                itemCount: messageList.length,
          )),
          TextField(
            controller: textEditingController, 
            decoration: new InputDecoration.collapsed(
                hintStyle: TextStyle(color: Colors.deepOrange),
                hintText: '请输入消息'),
            onSubmitted: sendMessage,
          ),
        ],
      ),
    );
  }

//发送消息
  void sendMessage(String text) {
    if (text.isEmpty) return;
    print(text);
    setState(() {
      messageList.add(Message("我","我："+text));
      messageList.add(Message("小Q", "小Q：" + text));
    });
    textEditingController.clear();
  }
 //发送消息布局
   buildRightItem(content) {
     return new Container(
       margin: const EdgeInsets.only(left: 10,right: 5),
       padding: const EdgeInsets.symmetric(vertical: 10),
       child: new Row(
         crossAxisAlignment: CrossAxisAlignment.end,  //对齐方式，左上对齐
         mainAxisAlignment: MainAxisAlignment.end,
         children: <Widget>[
           new Flexible(
             child: new Container(
               margin: const EdgeInsets.only(left: 10,right: 10,top: 10),
               padding: const EdgeInsets.all(8),
               child: new Text(
                 content,
                 style: new TextStyle(fontSize: 14,color: Colors.blue),
               ),
               decoration: new BoxDecoration(
                 color: Colors.white,
                 borderRadius: new BorderRadius.only(
                   bottomLeft: new Radius.circular(10)
                 )
               ),
             ),
           ),
           new Container(
             height: 40,
             width: 40,
             child: new Image.network(
                 'https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=2182894899,3428535748&fm=58&bpow=445&bpoh=605',
                 width: 40,
                 height: 40,
                 fit: BoxFit.cover,
              ),
           )
         ]
       ),
     );
   }

  //回复消息布局
  buildLeftItem(content) {
    return Container(
      margin: const EdgeInsets.only(left: 5,right: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,  //对齐方式，左上对齐
        children: <Widget>[
          new Image.network('https://pp.myapp.com/ma_icon/0/icon_42284557_1517984341/96',
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          ),
          new Flexible(
            child: new Container(
              margin: const EdgeInsets.only(left: 10,right: 10,top: 10),
              padding: const EdgeInsets.all(8),
              child: new Text(
                content,
                style: new TextStyle(fontSize: 14,color: Colors.white),
              ),
              decoration: new BoxDecoration(
                color: Colors.blue,
                borderRadius: new BorderRadius.only(bottomRight: new Radius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}