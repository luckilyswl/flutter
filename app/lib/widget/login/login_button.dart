import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatefulWidget {
  final Function onPressed;
  final bool enabled;
  final String title;

  LoginButton(
      {Key key,
      @required this.enabled,
      @required this.title,
      @required this.onPressed})
      : super(key: key);

  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  _getLoginClickListener() {
    if (widget.enabled) {
      return widget.onPressed;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      child: FlatButton(
        padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Container(
          alignment: Alignment.center,
          child: Text(widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              )),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.0),
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                widget.enabled ? Color(0xFF555C9E) : Color(0xFFEEEEEE),
                widget.enabled ? Color(0xFF2E3576) : Color(0xFFEEEEEE)
              ],
            ),
          ),
        ),
        onPressed: (() {
          if (widget.enabled) {
            debugPrint('onPressed');
            widget.onPressed();
          }
        }),
        textTheme: ButtonTextTheme.normal,
        textColor: Colors.white,
        disabledTextColor: ThemeColors.color404040,
        // 按下的背景色
        splashColor: Colors.transparent,
        // ��波纹颜色
        colorBrightness: Brightness.dark,
        // 主题
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
    );
  }
}
