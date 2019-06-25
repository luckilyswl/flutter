import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:app/res/theme_colors.dart';

/*
 * 客服
 **/
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _code = "";

  @override
  void initState() {
    super.initState();
    fluwx.responseFromAuth.listen((data) {
      if (data.errCode == 0) {
        setState(() {
          _code = "${data.code}";
        });
        //TODO: 发送code
      }
    });
  }

  /*
   * 微信登录
   **/
  _sendAuth() async {
    fluwx
        .sendAuth(scope: "snsapi_userinfo", state: "7shangzuo")
        .then((data) {});
  }

  /*
   * 手机号登录
   **/
  _loginWithPhone() async {
    fluwx
        .sendAuth(scope: "snsapi_userinfo", state: "7shangzuo")
        .then((data) {});
  }

  /*
   * 企业账号登录
   **/
  _loginWithAccount() async {
    fluwx
        .sendAuth(scope: "snsapi_userinfo", state: "7shangzuo")
        .then((data) {});
  }

  @override
  void dispose() {
    super.dispose();
    _code = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: Container(
            child: AppBar(
              title: Text(''),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(1.0, 0.0),
                end: Alignment(0.0, 0.0),
                colors: [
                  ThemeColors.color555C9E,
                  ThemeColors.color2E3576,
                ],
              ),
            ),
          ),
          preferredSize: Size(MediaQuery.of(context).size.width, 45),
        ),
        body: new Container(color: ThemeColors.colorF3F3F3));
  }
}
