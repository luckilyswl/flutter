import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/dialog/unbind_confirm_dialog.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

/*
 * 换绑手机页面
 **/
class BindedPhonePage extends StatefulWidget {
  @override
  _BindedPhonePageState createState() => _BindedPhonePageState();
}

class _BindedPhonePageState extends State<BindedPhonePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() {}

  _close() {
    Navigator.of(context).pop();
  }

  _firstPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 14, right: 14, top: 20),
          child: Image.asset('assets/images/ic_change_phone.png',
              width: 180, height: 180),
        ),
        Container(
          margin: EdgeInsets.only(left: 14, right: 14, top: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          height: 44,
          child: Text(
            '绑定手机：+86 12345678905',
            style: TextStyle(
                color: ThemeColors.color1A1A1A,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          height: 44,
          margin: EdgeInsets.only(left: 14, right: 14),
          alignment: Alignment.center,
          child: Text('手机号已绑定，您可使用手机号登录',
              style: TextStyle(
                  color: ThemeColors.colorA6A6A6,
                  fontSize: 14,
                  fontWeight: FontWeight.normal)),
        ),
        Container(
          margin: EdgeInsets.only(left: 14, right: 14),
          child: OutlineButton(
            padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Container(
              width: ScreenUtil.getScreenW(context) - 28,
              height: 44,
              alignment: Alignment.center,
              child: Text(
                '解绑手机',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            onPressed: _toSecondPage,
            textColor: ThemeColors.color54548C,
            highlightedBorderColor: ThemeColors.color54548C,
            borderSide: new BorderSide(color: ThemeColors.color54548C),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            clipBehavior: Clip.antiAlias,
          ),
        ),
      ],
    );
  }

  _toSecondPage() {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return UnbindConfirmDialog(
            onLeftCloseEvent: () {
              Navigator.pop(context);
            },
            onRightCloseEvent: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(Page.CHANGE_PHONE_PAGE);
            },
            phone: '',
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActionBar.buildActionBar(
        context,
        AppBar(
          elevation: 0,
          title: Text('绑定手机', style: TextStyle(fontSize: 17)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            new GestureDetector(
              onTap: () {
                _close();
              },
              child: new Container(
                margin: EdgeInsets.only(right: 16),
                alignment: Alignment.centerRight,
                child: new Text(
                  '关闭',
                  style: new TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
      body: Container(
        color: ThemeColors.colorF1F1F1,
        width: ScreenUtil.getScreenW(context),
        child: _firstPage(),
      ),
    );
  }
}
