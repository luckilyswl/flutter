import 'dart:async';
import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class SendCodeButton extends StatefulWidget {
  final Function onSendEvent;
  final Function onTimeoutEvent;
  final bool isCounting;

  SendCodeButton(
      {Key key, @required this.onSendEvent, @required this.onTimeoutEvent, @required this.isCounting})
      : super(key: key);
  _SendCodeButtonState createState() => _SendCodeButtonState();
}

class _SendCodeButtonState extends State<SendCodeButton> {
  Function _onSendEvent;
  Function _onTimeoutEvent;
  int _leftSecond;
  bool _isCounting;
  Timer _countdownTimer;

  /// Default max wait second.
  static final int _totalSecnd = 60;

  @override
  void initState() {
    super.initState();
    _leftSecond = 0;    
    _onSendEvent = widget.onSendEvent;
    _onTimeoutEvent = widget.onTimeoutEvent;
    _isCounting = false;
  }

  void _initTimer() {
    if (null == _countdownTimer) {
      ///倒计时
      _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (0 >= _leftSecond) {
          _countdownTimer.cancel();
          _onTimeoutEvent();
        } else {
          var leftSecond = _leftSecond - 1;
          if (leftSecond == 0) {
            _countdownTimer.cancel();
            _onTimeoutEvent();
          } else {
            setState(() {
              _leftSecond = leftSecond;
            });
          }
        }
      });
    }
  }

  void _getPhoneCode() {
    this._onSendEvent();
  }

  @override
  void dispose() {
    debugPrint("dispose");
    if (null != _countdownTimer) {
      _countdownTimer.cancel();
      _countdownTimer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint("build");
    if (_isCounting == true) {
      if (widget.isCounting == false) {
        _isCounting = false;
        _leftSecond = 0;
        if (null != _countdownTimer) {
          _countdownTimer.cancel();
          _countdownTimer = null;
        }
      }
    } else {
      if (widget.isCounting == true) {
        _isCounting = true;
        _leftSecond = _totalSecnd;
        _initTimer();
      }
    }
    return Container(
      child: SizedBox(
        width: 90,
        height: 28,
        child: FlatButton(
          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: !_isCounting
              ? Text("获取验证码",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ThemeColors.color404040,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ))
              : Text("${_leftSecond.toString()}s重新发送",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ThemeColors.color404040,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  )),
          onPressed: () {
            if (!_isCounting) {
              _getPhoneCode();
            }
          },
          textTheme: ButtonTextTheme.normal,
          textColor: ThemeColors.color404040,
          disabledTextColor: ThemeColors.color404040,
          color: Colors.transparent,
          disabledColor: Colors.transparent,
          highlightColor: Colors.transparent,
          // 按下的背景色
          splashColor: Colors.transparent,
          // 水波纹颜色
          colorBrightness: Brightness.light,
          // 主题
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              side: BorderSide(
                  color: Color(0xFFD7B67F),
                  style: BorderStyle.solid,
                  width: 1)),
          clipBehavior: Clip.antiAlias,
          materialTapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
    );
  }
}
