import 'dart:convert';

import 'package:app/Application.dart';
import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/event.dart';
import 'package:app/model/user_info_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/save_image_toast.dart' as Toast;
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';

import 'package:app/widget/toast.dart' as T;

/*
 * 绑定手机号页面
 **/
class BindPage extends StatefulWidget {
  @override
  _BindPageState createState() => _BindPageState();
}

class _BindPageState extends State<BindPage>
    with SingleTickerProviderStateMixin {
  String _code;
  String _phone;
  String _errorInfo;
  bool _isCounting;
  bool _buttonEnable = true;

  TextEditingController _phoneEditController;
  TextEditingController _codeEditController;
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _codeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _code = "";
    _errorInfo = "";
    _phone = "";
    _isCounting = false;

    _phoneEditController = TextEditingController();
    _codeEditController = TextEditingController();
    _phoneEditController.addListener(() {
      setState(() {
        _phone = _phoneEditController.text;
        _buttonEnable = (_phoneEditController.text.length == 11 &&
            _codeEditController.text.length == 6);
      });
    });
    _codeEditController.addListener(() {
      setState(() {
        _code = _codeEditController.text;
        _buttonEnable = (_phoneEditController.text.length == 11 &&
            _codeEditController.text.length == 6);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _code = null;
  }

  _buildTabBar() {
    return Container(
      margin: EdgeInsets.only(
        top: 15,
        left: 24,
        right: 24,
      ),
      height: 31,
      width: double.infinity,
      decoration: ShapeDecoration(
        shape: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
      ),
      child: Text(
        '绑定手机号',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF3F4688),
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _showBindSuccessWidget() {
    Toast.SaveImageToast.toast(context, '绑定成功', true);
  }

  _buildPhoneTextField() {
    return LoginTextField(
      controller: _phoneEditController,
      focusNode: _phoneFocusNode,
      obscureText: false,
      keyboardType: TextInputType.phone,
      hintText: "请输入手机号",
      imageName: "assets/images/ic_login_phone.png",
      rightWidget: _errorInfo.length > 0
          ? Container(
              width: 90,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(208, 2, 27, 0.1),
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Text(
                _errorInfo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD0021B),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          : Container(),
    );
  }

  _buildCodeTextField() {
    return LoginTextField(
      controller: _codeEditController,
      focusNode: _codeFocusNode,
      obscureText: false,
      keyboardType: TextInputType.number,
      hintText: "请输入验证码",
      imageName: "assets/images/ic_login_pwd.png",
      rightWidget: SendCodeButton(
        onSendEvent: () {
          _getPhoneCode();
        },
        onTimeoutEvent: () {
          setState(() {
            _isCounting = false;
          });
        },
        isCounting: _isCounting,
      ),
    );
  }

  /*
   * 绑定手机号
   **/
  _bindPhone() {
    _codeFocusNode.unfocus();
    dio.post(
      Api.TELPHONE_BIND,
      queryParameters: {
        'phone': _phone,
        'code': _code,
      },
    ).then((data) {
      var sources = jsonDecode(data.toString());
      UserInfoBean bean = UserInfoBean.fromJson(sources);
      if (bean.errorCode == "0") {
        _showBindSuccessWidget();
        Future.delayed(
          new Duration(milliseconds: 300),
          () {
            DataUtils.saveLoginInfo(bean);
            Application.getEventBus().fire(EventType.loginSuccess);
            Navigator.of(context).popUntil(ModalRoute.withName(Page.ROOT_PAGE));
            Navigator.pop(context);
          },
        );
      } else {
        T.Toast.toast(context, bean.msg);
      }
    });
  }

  /*
   * 获取验证码
   **/
  _getPhoneCode() {
    _phoneFocusNode.unfocus();
    dio.get(Api.IMAGE_CODE,
        queryParameters: {'width': '255', 'height': '58'}).then((data) {
      var sources = jsonDecode(data.toString());
      if (sources['error_code'] == "0") {
        var captchaBase64 = sources['data']['captcha_base64'];
        var captchaId = sources['data']['captcha_id'];
        showDialog<Null>(
            context: context, //BuildContext对象
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CaptchaDialog(
                onCloseEvent: () {
                  Navigator.pop(context);
                },
                onSuccessEvent: () {
                  Navigator.pop(context);
                  setState(() {
                    _isCounting = true;
                  });
                },
                phone: _phone,
                type: SMSCodeType.SMSCodeBind,
                captchaBase64: captchaBase64,
                captchaId: captchaId,
              );
            });
      } else {
        T.Toast.toast(context, sources['msg']);
      }
    });
    print('获取验证码');
  }

  _getBindClickListener() {
    if (_buttonEnable) {
      return () {
        _bindPhone();
      };
    } else {
      return null;
    }
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
            gradient: Gradients.loginBgLinearGradient,
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 45),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          LoginBackground(),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              LoginIntroduction(),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 347.0,
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _buildTabBar(),
                        Container(
                          margin: EdgeInsets.only(top: 15, left: 24, right: 24),
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _buildPhoneTextField(),
                              _buildCodeTextField(),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 20, left: 24, right: 24, bottom: 20),
                          child: LoginButton(
                            enabled: _buttonEnable,
                            onPressed: (() {
                              _bindPhone();
                            }),
                            title: '绑定手机号',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
