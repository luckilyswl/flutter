import 'dart:convert';

import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/res/theme_colors.dart';
import 'package:app/widget/widgets_index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CaptchaCard extends StatefulWidget {
  final Function onCloseEvent;
  final Function onSuccessEvent;
  final String phone;
  final SMSCodeType type;
  final String captchaId;
  final String captchaBase64;

  CaptchaCard(
      {Key key,
      @required this.onCloseEvent,
      @required this.onSuccessEvent,
      @required this.phone,
      @required this.type,
      @required this.captchaBase64,
      @required this.captchaId})
      : super(key: key);

  _CaptchaCardState createState() => _CaptchaCardState();
}

class _CaptchaCardState extends State<CaptchaCard> {
  Function _onCloseEvent;
  Function _onSuccessEvent;
  String _phone;
  SMSCodeType _type;
  String _captchaId;
  String _captchaBase64;
  String _captcha;

  final FocusNode _accountFocusNode = FocusNode();

  bool _showError = false;

  /// Default max pin length.
  static final int _pinLength = 4;

  /// Default Text style.
  static final TextStyle _textStyle = TextStyle(
    color: ThemeColors.color3F4688,
    fontSize: 28,
  );

  Color _solidColor = ThemeColors.colorA6A6A6;

  /// Control the input text field.
  PinEditingController _pinEditingController =
      PinEditingController(pinLength: _pinLength, autoDispose: false);

  /// Control whether show the obscureCode.
  bool _obscureEnable = false;

  /// Control whether textField is enable.
  bool _enable = true;

  _refreshCodeUrl() {
    debugPrint('刷新图形验证码...');
    dio.get(Api.IMAGE_CODE,
        queryParameters: {'width': '255', 'height': '58'}).then((data) {
      var sources = jsonDecode(data.toString());
      if (sources['error_code'] == Api.SUCCESS_CODE) {
        var captchaBase64 = sources['data']['captcha_base64'];
        var captchaId = sources['data']['captcha_id'];
        setState(() {
          _captchaBase64 = captchaBase64.split(',')[1];
          _captchaId = captchaId;
        });
      } else {
        Toast.toast(context, sources['msg']);
      }
    });
  }

  _checkCode() {
    debugPrint('请求发送验证码...');
    SpinKitFadingCircle(
      itemBuilder: (_, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.red : Colors.green,
          ),
        );
      },
    );
    dio.get(Api.SMS_CODE_SEND, queryParameters: {
      'phone': _phone,
      'code_type': SMSCodeType.values.indexOf(_type).toString(),
      'verify_value': _captcha,
      'captcha_id': _captchaId
    }).then((data) {
      var sources = jsonDecode(data.toString());
      if (sources['error_code'] == Api.SUCCESS_CODE) {
        this._onSuccessEvent();
      } else if (sources['error_code'] == Api.ERROR_IMAGE_CODE) {
        setState(() {
          _showError = true;
        });
        _refreshCodeUrl();
      } else {
        Toast.toast(context, sources['msg']);
        _refreshCodeUrl();
      }
    });
  }

  @override
  void initState() {
    _onCloseEvent = widget.onCloseEvent;
    _captchaBase64 = widget.captchaBase64.split(',')[1];
    _type = widget.type;
    _phone = widget.phone;
    _captchaId = widget.captchaId;
    _onSuccessEvent = widget.onSuccessEvent;
    super.initState();
  }

  @override
  void dispose() {
    _pinEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 295,
        height: 255,
        child: Card(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.only(top: 15, left: 20, bottom: 15, right: 15),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '请你输入图形验证码',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: ThemeColors.color404040,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onCloseEvent,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Icon(
                          Icons.close,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 255,
                  height: 58,
                  margin: EdgeInsets.only(top: 10),
                  color: ThemeColors.colorE3E3E3,
                  child: Image.memory(
                    Base64Decoder().convert(_captchaBase64),
                    height: 255, //设置高度
                    width: 58, //设置宽度
                    fit: BoxFit.fill, //填充
                    gaplessPlayback: true, //防止重绘
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _showError
                          ? Container(
                              width: 80,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(208, 2, 27, 0.1),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              child: Text(
                                '验证码错误',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFD0021B),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          : SizedBox(),
                      GestureDetector(
                        onTap: () {
                          _refreshCodeUrl();
                        },
                        child: Text(
                          '点击图片刷新',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: ThemeColors.color404040,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '4位数字',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: ThemeColors.colorA6A6A6,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: PinInputTextField(
                      pinLength: _pinLength,
                      focusNode: _accountFocusNode,
                      decoration: BoxLooseDecoration(
                        textStyle: _textStyle,
                        strokeColor: _showError ? Colors.red : _solidColor,
                        enteredColor: _showError ? Colors.red : _solidColor,
                        solidColor: null,
                        radius: const Radius.circular(4),
                        obscureStyle: ObscureStyle(
                          isTextObscure: _obscureEnable,
                          obscureText: '☺️',
                        ),
                      ),
                      pinEditingController: _pinEditingController,
                      autoFocus: true,
                      textInputAction: TextInputAction.go,
                      enabled: _enable,
                      onSubmit: (pin) {
                        debugPrint('submit pin:$pin');
                      },
                      onChanged: (pin) {
                        debugPrint('change pin:$pin');
                        _captcha = pin;
                        if (_captcha.length == 0) {
                          setState(() {
                            _showError = false;
                          });
                        } else if (_captcha.length == _pinLength) {
                          _accountFocusNode.unfocus();
                          _checkCode();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum SMSCodeType {
  SMSCodeNone,
  SMSCodeDefault,
  SMSCodeLogin,
  SMSCodeRegister,
  SMSCodeBind
}

class CaptchaDialog extends Dialog {
  final Function onCloseEvent;
  final Function onSuccessEvent;
  final String phone;
  final SMSCodeType type;
  final String captchaId;
  final String captchaBase64;
 
  CaptchaDialog(
      {Key key,
      @required this.onCloseEvent,
      @required this.onSuccessEvent,
      @required this.phone,
      @required this.type,
      @required this.captchaBase64,
      @required this.captchaId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Center(
        //保证控件居中效果
        child: CaptchaCard(
          onCloseEvent: onCloseEvent,
          onSuccessEvent: onSuccessEvent,
          phone: phone,
          type: type,
          captchaBase64: captchaBase64,
          captchaId: captchaId,
        ),
      ),
    );
  }
}
