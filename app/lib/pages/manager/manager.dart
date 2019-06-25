import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';

/*
 * 管理
 **/
class ManagerPage extends StatefulWidget {
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('企业管理', style: new TextStyle(fontSize: 17)),
        centerTitle: true,
        backgroundColor: ThemeColors.color555C9E,
      ),
      body: _bodyWidget(),
    );
  }
  Widget _bodyWidget() {
    return new SingleChildScrollView(
      child: new Container(
        alignment: Alignment.center,
        child: new Column(
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 40),
              child:new Text('该页面仅为企业用户提供服务', style: new TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: ThemeColors.color404040
              ),)
            ),

            new Padding(padding: EdgeInsets.only(top: 40),
              child: new CircleAvatar(
                backgroundColor: ThemeColors.colorEEEEEE,
                radius: 75.0,
              ),
            ),

            new Padding(padding: EdgeInsets.only(top: 40, left: 68, right: 68),
              child: new Text(
                '请用已绑定企业的账号进行登录，若您的企业需要开通服务，请前往企业注册页面提交信息',
                style: new TextStyle(
                  fontSize: 14,
                  height: 1.2,
                  color: ThemeColors.colorA6A6A6,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            new Container(
              margin: new EdgeInsets.only(top: 40),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  // 企业注册
                  new Container(
                    width: 140.0,
                    height: 40.0,
                    child: new Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          side: new BorderSide(
                              width: 1,
                              color: ThemeColors.color3F4688
                          ),
                          borderRadius: BorderRadius.circular(22)
                      ),
                      color: Colors.white,
                      child: new FlatButton(
                          onPressed: () {
                            _register();
                          },
                          child: new Text('企业注册', style: new TextStyle(
                              fontSize: 16,
                              color: ThemeColors.color3F4688
                          ),)
                      )
                    ),
                  ),

                  // 前往登录
                  new Container(
                    width: 140,
                    height: 40,
                    child: new Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)
                      ),
                      color: ThemeColors.color555C9E,
                      child: new FlatButton(
                        onPressed: () {
                          _goLogin();
                        },
                        child: new Text('前往登录', style: new TextStyle(
                            fontSize: 16,
                            color: Colors.white
                        ),),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /*
   * 企业注册
   **/
  _register() {
  }

  /*
   * 前往登录
   **/
  _goLogin() {
  }
}

