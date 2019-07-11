import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("NBA"),
        ),
        body: ListView(
          children: <Widget>[
            //获取网络图片，需要添加依赖库：http
            Image.network("http://n.sinaimg.cn/sports/2_img/upload/cf0d0fdd/107/w1024h683/20181128/pKtl-hphsupx4744393.jpg",
              height: 240,
              fit: BoxFit.cover
            ),
            //点赞或收藏
            Container(
              padding: EdgeInsets.all(32),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            "Oeschinen Lake Campground",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Text(
                          "Kandersteg, Switzerland",
                          style:  TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.red[500],
                  ),
                  Text("41"),
                ],
              ),
            ),
            //分享一栏按钮
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildButtonColumn(context, Icons.call, "电话"),
                  _buildButtonColumn(context, Icons.near_me, "导航"),
                  _buildButtonColumn(context, Icons.share, "分享"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(32),
              child: Text("帅......",softWrap: true,),
            ),
          ],
        ),
      ),
    );
  }

  Column  _buildButtonColumn(BuildContext context, IconData icon, String label) {
    Color color = Theme.of(context).primaryColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,

      //列布局
      children: <Widget>[
        Icon(
          icon,
          color: color,
        ),
        Container(
          margin: EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: color
            ),
          ),
        ),
      ],
    );
  }
}
