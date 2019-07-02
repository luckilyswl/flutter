import 'package:app/Application.dart';
import 'package:app/model/event.dart';
import 'package:app/utils/data_utils.dart';
import 'package:app/widget/action_bar.dart';
import 'package:flutter/material.dart';
import 'package:app/res/gradients.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ActionBar.buildActionBar(
            context,
            AppBar(
              elevation: 0,
              title: Text('设置', style: new TextStyle(fontSize: 17)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
            )),
        body: _bodyWidget());
  }

  Widget _bodyWidget() {
    return Container(
      child: new Container(
        margin: EdgeInsets.only(top: 20),
        height: 44,
        child: new FlatButton(
            onPressed: (){
              _logout();
            },
            child: new Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: Gradients.blueLinearGradient,
              ),
              child: Text('退出登录', style: new TextStyle(
                fontSize: 16,
                color: Colors.white
              ),),
            )),
      ),
    );
  }

  void _logout() {
    DataUtils.clearLoginInfo();
    Application.getEventBus().fire(EventType.logout);
    Navigator.pop(context);
  }

  @override
  bool get wantKeepAlive => true;
}
