import 'package:flutter/material.dart';
import 'package:flutter_wechat/page/home/XKTabBar.dart';

class home extends StatefulWidget{
  @override
  _HomeState createState() => new _HomeState();
}
class _HomeState extends State{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('首页'),
        backgroundColor: Colors.deepPurple,
      ),
      //聊天界面的设置
       // body: _buildListView(),
    );
  }

 /* ListView _buildListView(){
    return new ListView(
      children: <Widget>[
        new ListTile(
          onTap: (){
            Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (context){
                      return new XKTabBar();
                    }
                )
            );
          },
          leading: new Image.asset("images/img.jpg",width: 40.0,height: 40.0,fit: BoxFit.cover,),
          title: new Text("班主任"),
          subtitle: new Text("你高考考了满分你知道吗？"),
          trailing: new Text("9:00"),
        ),
        new ListTile(
          onTap: (){
            //指定页面路由的跳转
            Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (context){
                      return new XKTabBar();
                    }
                )
            );
          },
          leading: new Image.asset("images/lebron.jpg",width: 40.0,height: 40.0,fit: BoxFit.cover,),
          title: new Text("LebronJames"),
          subtitle: new Text("We will take over this game"),
          trailing: new Text("8:15"),
        ),
        new ListTile(
          onTap: (){
            Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (context){
                      return new XKTabBar();
                    }
                )
            );
          },
          leading: new Image.asset("images/xk.jpg",width: 40.0,height: 40.0,fit: BoxFit.cover,),
          title: new Text("石甲州"),
          subtitle: new Text("帮我带饭啊，钱放你桌子上了"),
          trailing: new Text("6:00"),
        ),
        new ListTile(
          onTap: (){
            Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (context){
                      return new XKTabBar();
                    }
                )
            );
          },
          leading: new Image.asset("images/a001.jpg",width: 40.0,height: 40.0,fit: BoxFit.cover,),
          title: new Text("李思思"),
          subtitle: new Text("你好，你的代码崩了"),
          trailing: new Text("昨天"),
        ),
        new ListTile(
          onTap: (){
            Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (context){
                      return new XKTabBar();
                    }
                )
            );
          },
          leading: new Image.asset("images/a002.jpg",width: 40.0,height: 40.0,fit: BoxFit.cover,),
          title: new Text("迪丽热巴"),
          subtitle: new Text("打野，上没闪快来"),
          trailing: new Text("昨天"),
        ),
        new ListTile(
          onTap: (){
            Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (context){
                      return new XKTabBar();
                    }
                )
            );
          },
          leading: new Image.asset("images/a003.jpg",width: 40.0,height: 40.0,fit: BoxFit.cover,),
          title: new Text("Faker"),
          subtitle: new Text("李哥你好，你会玩劫吗？"),
          trailing: new Text("上个月"),
        ),
        new ListTile(
          onTap: (){
            Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (context){
                      return new XKTabBar();
                    }
                )
            );
          },
          leading: new Image.asset("images/a004.jpg",width: 40.0,height: 40.0,fit: BoxFit.cover,),
          title: new Text("鳄鱼"),
          subtitle: new Text("上路你很吊啊"),
          trailing: new Text("那年今日"),
        ),
      ],
    );
  }*/
}
