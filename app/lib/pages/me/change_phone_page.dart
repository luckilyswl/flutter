import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

/*
 * 换绑手机页面
 **/
class ChangePhonePage extends StatefulWidget {
  @override
  _ChangePhonePageState createState() => _ChangePhonePageState();
}

class _ChangePhonePageState extends State<ChangePhonePage>
    with SingleTickerProviderStateMixin {
  int step = 1;
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

  _currentPage() {
    if (step == 1) {
      return _firstPage();
    } else if (step == 2) {
      return _secondPage();
    } else {
      return _thirdPage();
    }
  }

  _firstPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 14, right: 14, top: 35),
          alignment: Alignment.center,
          child: Text('验证手机号',
              style: TextStyle(
                  color: ThemeColors.color1A1A1A,
                  fontSize: 23,
                  fontWeight: FontWeight.w500)),
        ),
        Container(
          margin: EdgeInsets.only(left: 14, right: 14, top: 10),
          alignment: Alignment.center,
          child: Text(
            '请输入 123****8905 收到的短信验证码',
            style: TextStyle(
                color: ThemeColors.color404040,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          width: ScreenUtil.getScreenW(context) - 28,
          constraints: BoxConstraints(minHeight: 44, maxHeight: 44),
          margin: const EdgeInsets.only(left: 14, right: 14, top: 6),
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: TextField(
            controller: null,
            focusNode: null,
            keyboardType: TextInputType.number,
            style: FontStyles.style141A1A1A,
            textAlign: TextAlign.center,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: '请输入6位验证码',
              border: InputBorder.none,
              counterText: '',
              hintStyle: FontStyles.style14A6A6A6,
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            height: 44,
            margin: EdgeInsets.only(left: 14, right: 14, bottom: 30),
            alignment: Alignment.center,
            child: Text(
              '获取验证码',
              style: TextStyle(
                  color: ThemeColors.color54548C,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 14, right: 14),
          child: FlatButton(
            padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Container(
              width: ScreenUtil.getScreenW(context) - 28,
              height: 44,
              alignment: Alignment.center,
              child: Text(
                '下一步',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                step = 2;
              });
            },
            textTheme: ButtonTextTheme.normal,
            textColor: Colors.white,
            color: ThemeColors.color54548C,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            colorBrightness: Brightness.light,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                side: BorderSide(
                    color: ThemeColors.color54548C,
                    style: BorderStyle.solid,
                    width: 1)),
            clipBehavior: Clip.antiAlias,
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
        ),
      ],
    );
  }

  _secondPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 14, right: 14, top: 35),
          alignment: Alignment.center,
          child: Text('验证手机号',
              style: TextStyle(
                  color: ThemeColors.color1A1A1A,
                  fontSize: 23,
                  fontWeight: FontWeight.w500)),
        ),
        Container(
          margin: EdgeInsets.only(left: 14, right: 14, top: 10),
          alignment: Alignment.center,
          child: Text(
            '我们将发送验证码到你手机上',
            style: TextStyle(
                color: ThemeColors.color404040,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          width: ScreenUtil.getScreenW(context) - 28,
          constraints: BoxConstraints(minHeight: 44, maxHeight: 44),
          margin: const EdgeInsets.only(left: 14, right: 14, top: 30),
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: TextField(
            controller: null,
            focusNode: null,
            keyboardType: TextInputType.number,
            style: FontStyles.style141A1A1A,
            textAlign: TextAlign.center,
            maxLength: 11,
            decoration: InputDecoration(
              hintText: '请填写手机号',
              border: InputBorder.none,
              counterText: '',
              hintStyle: FontStyles.style14A6A6A6,
            ),
            onChanged: (String text) {
              if (text.length == 11) {}
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 14, right: 14, top: 30),
          child: FlatButton(
            padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Container(
              width: ScreenUtil.getScreenW(context) - 28,
              height: 44,
              alignment: Alignment.center,
              child: Text(
                '下一步',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                step = 3;
              });
            },
            textTheme: ButtonTextTheme.normal,
            textColor: Colors.white,
            color: ThemeColors.color54548C,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            colorBrightness: Brightness.light,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                side: BorderSide(
                    color: ThemeColors.color54548C,
                    style: BorderStyle.solid,
                    width: 1)),
            clipBehavior: Clip.antiAlias,
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
        ),
      ],
    );
  }

  _thirdPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 14, right: 14, top: 35),
          alignment: Alignment.center,
          child: Text('验证手机号',
              style: TextStyle(
                  color: ThemeColors.color1A1A1A,
                  fontSize: 23,
                  fontWeight: FontWeight.w500)),
        ),
        Container(
          margin: EdgeInsets.only(left: 14, right: 14, top: 10),
          alignment: Alignment.center,
          child: Text(
            '请输入 123****8905 收到的短信验证码',
            style: TextStyle(
                color: ThemeColors.color404040,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          width: ScreenUtil.getScreenW(context) - 28,
          constraints: BoxConstraints(minHeight: 44, maxHeight: 44),
          margin: const EdgeInsets.only(left: 14, right: 14, top: 6),
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: TextField(
            controller: null,
            focusNode: null,
            keyboardType: TextInputType.number,
            style: FontStyles.style141A1A1A,
            textAlign: TextAlign.center,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: '请输入6位验证码',
              border: InputBorder.none,
              counterText: '',
              hintStyle: FontStyles.style14A6A6A6,
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            height: 44,
            margin: EdgeInsets.only(left: 14, right: 14, bottom: 30),
            alignment: Alignment.center,
            child: Text(
              '获取验证码',
              style: TextStyle(
                  color: ThemeColors.color54548C,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 14, right: 14),
          child: FlatButton(
            padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Container(
              width: ScreenUtil.getScreenW(context) - 28,
              height: 44,
              alignment: Alignment.center,
              child: Text(
                '绑定手机',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            onPressed: () {},
            textTheme: ButtonTextTheme.normal,
            textColor: Colors.white,
            color: ThemeColors.color54548C,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            colorBrightness: Brightness.light,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                side: BorderSide(
                    color: ThemeColors.color54548C,
                    style: BorderStyle.solid,
                    width: 1)),
            clipBehavior: Clip.antiAlias,
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: ActionBar.buildActionBar(
            context,
            AppBar(
              elevation: 0,
              title: Text('解绑手机', style: TextStyle(fontSize: 17)),
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
            child: _currentPage(),
          ),
        ),
        onWillPop: () {
          if (step == 3) {
            setState(() {
              step = 2;
            });
            return Future.value(false);
          } else if (step == 2) {
            setState(() {
              step = 1;
            });
            return Future.value(false);
          }
          return Future.value(true);
        });
  }
}
