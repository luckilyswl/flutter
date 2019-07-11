import 'dart:convert';

import 'package:app/Application.dart';
import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/event.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';

import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';


/*
 * 新企业注册页面
 **/
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  int _registerStepIndex;
  bool _buttonEnable;

  String _companyName;
  String _manager;
  String _phone;
  String _code;
  String _tips;

  //填写信息
  TextEditingController _enterpriseNameEditController;
  TextEditingController _ownerEditController;
  TextEditingController _phoneEditController;
  final FocusNode _enterpriseNameFocusNode = FocusNode();
  final FocusNode _ownerFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  //验证手机号
  TextEditingController _codeEditController;
  final FocusNode _codeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _companyName = "";
    _manager = "";
    _code = "";
    _phone = "";
    _registerStepIndex = 0;
    _buttonEnable = false;
    _tips = "";

    _enterpriseNameEditController = TextEditingController();
    _ownerEditController = TextEditingController();
    _phoneEditController = TextEditingController();
    _codeEditController = TextEditingController();

    _enterpriseNameEditController.addListener(() {
      setState(() {
        _companyName = _enterpriseNameEditController.text;
        _buttonEnable = (_enterpriseNameEditController.text.length > 0 &&
            _ownerEditController.text.length > 0 &&
            _phoneEditController.text.length == 11);
      });
    });
    _ownerEditController.addListener(() {
      setState(() {
        _manager = _ownerEditController.text;
        _buttonEnable = (_enterpriseNameEditController.text.length > 0 &&
            _ownerEditController.text.length > 0 &&
            _phoneEditController.text.length == 11);
      });
    });
    _phoneEditController.addListener(() {
      setState(() {
        _phone = _phoneEditController.text;
        _buttonEnable = (_enterpriseNameEditController.text.length > 0 &&
            _ownerEditController.text.length > 0 &&
            _phoneEditController.text.length == 11);
      });
    });
    _codeEditController.addListener(() {
      setState(() {
        _code = _codeEditController.text;
        _buttonEnable = (_enterpriseNameEditController.text.length > 0 &&
            _ownerEditController.text.length > 0 &&
            _phoneEditController.text.length == 11 &&
            _codeEditController.text.length == 6);
      });
    });
  }

  @override
  void dispose() {
    _enterpriseNameEditController.dispose();
    _ownerEditController.dispose();
    _phoneEditController.dispose();
    _codeEditController.dispose();
    super.dispose();
  }

  _getImageCode() {
    debugPrint('获取图形验证码...');
    dio.get(Api.IMAGE_CODE,
        queryParameters: {'width': '255', 'height': '58'}).then((data) {
      var sources = jsonDecode(data.toString());
      if (sources['error_code'] == Api.SUCCESS_CODE) {
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
                  this.setState(() {
                    _registerStepIndex = _registerStepIndex + 1;
                  });
                },
                phone: _phone,
                type: SMSCodeType.SMSCodeRegister,
                captchaBase64: captchaBase64,
                captchaId: captchaId,
              );
            });
      } else {
        Toast.toast(context, sources['msg']);
      }
    });
  }

  _registerEnterprise() {
    debugPrint('企业注册...');
    dio.post(
      Api.ENTERPRISE_REGISTER,
      data: {
        'company_name': _companyName,
        'manager': _manager,
        'phone': _phone,
        'code': _code,
      },
    ).then((data) {
      var sources = jsonDecode(data.toString());
      if (sources['error_code'] == Api.SUCCESS_CODE) {
        var tips = sources['data']['tips'];
        this.setState(() {
          _tips = tips;
          _registerStepIndex = _registerStepIndex + 1;
          _buttonEnable = (_companyName.length > 0 &&
              _manager.length > 0 &&
              _phone.length == 11 &&
              _code.length == 6);
        });
      } else {
        Toast.toast(context, sources['msg']);
      }
    });
  }

  /*
   * 下一步
   **/
  _nextStep() {
    if (_registerStepIndex == 0) {
      debugPrint('获取图形验证码...');
      dio.get(Api.IMAGE_CODE,
          queryParameters: {'width': '255', 'height': '58'}).then((data) {
        var sources = jsonDecode(data.toString());
        if (sources['error_code'] == Api.SUCCESS_CODE) {
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
                    this.setState(() {
                      _registerStepIndex = _registerStepIndex + 1;
                    });
                  },
                  phone: _phone,
                  type: SMSCodeType.SMSCodeRegister,
                  captchaBase64: captchaBase64,
                  captchaId: captchaId,
                );
              });
        } else {
          Toast.toast(context, sources['msg']);
        }
      });
    } else if (_registerStepIndex == 1) {
      debugPrint('企业注册...');
      dio.post(
        Api.ENTERPRISE_REGISTER,
        data: {
          'company_name': _companyName,
          'manager': _manager,
          'phone': _phone,
          'code': _code,
        },
      ).then((data) {
        var sources = jsonDecode(data.toString());
        if (sources['error_code'] == Api.SUCCESS_CODE) {
          var tips = sources['data']['tips'];
          this.setState(() {
            _tips = tips;
            _registerStepIndex = _registerStepIndex + 1;
            _buttonEnable = (_companyName.length > 0 &&
                _manager.length > 0 &&
                _phone.length == 11 &&
                _code.length == 6);
          });
        } else {
          Toast.toast(context, sources['msg']);
        }
      });
    }
  }

  /*
   * 联系客服
   **/
  _contactCustomerService() {
    Application.getEventBus().fire(EventType.goServer);
    Navigator.of(context).popUntil(ModalRoute.withName(Page.ROOT_PAGE));
  }

  /*
   * 返回首页
   **/
  _backHome() {
    Application.getEventBus().fire(EventType.goHome);
    Navigator.of(context).popUntil(ModalRoute.withName(Page.ROOT_PAGE));
  }

  List<Widget> _cardContent() {
    if (_registerStepIndex == 0) {
      return <Widget>[
        Container(
          margin: EdgeInsets.only(top: 15, left: 24, right: 24),
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RegisterTextField(
                controller: _enterpriseNameEditController,
                focusNode: _enterpriseNameFocusNode,
                obscureText: false,
                keyboardType: TextInputType.text,
                hintText: "请输入企业名称",
                title: "企业名称",
              ),
              RegisterTextField(
                controller: _ownerEditController,
                focusNode: _ownerFocusNode,
                obscureText: false,
                keyboardType: TextInputType.phone,
                hintText: "请输入真实姓名",
                title: "负责人",
              ),
              RegisterTextField(
                controller: _phoneEditController,
                focusNode: _phoneFocusNode,
                obscureText: false,
                keyboardType: TextInputType.phone,
                hintText: "请输入手机号",
                title: "手机号",
              ),
            ],
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 30),
            child: LoginButton(
              enabled: _buttonEnable,
              onPressed: (() {
                _getImageCode();
              }),
              title: "下一步，验证手机号",
            )),
      ];
    } else if (_registerStepIndex == 1) {
      return <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: 24,
            right: 24,
          ),
          padding: EdgeInsets.only(bottom: 20),
          width: double.infinity,
          decoration: ShapeDecoration(
            shape: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  '验证手机号',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF3F4688),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: RichText(
                  text: TextSpan(
                    text: '短信验证码已发送至 ',
                    style: TextStyle(
                        color: ThemeColors.colorA6A6A6, fontSize: 14.0),
                    children: <TextSpan>[
                      TextSpan(
                        text: _phone,
                        style: TextStyle(
                          color: ThemeColors.color404040,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RegisterTextField(
                controller: _codeEditController,
                focusNode: _codeFocusNode,
                obscureText: false,
                keyboardType: TextInputType.number,
                hintText: "请输入验证码",
                title: "验证码",
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 30),
          child: LoginButton(
            enabled: _buttonEnable,
            onPressed: (() {
              _registerEnterprise();
            }),
            title: "下一步，提交注册信息",
          ),
        ),
      ];
    } else {
      return <Widget>[
        Container(
          margin: EdgeInsets.only(
            top: 40,
            left: 23,
            bottom: 40,
            right: 23,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '已成功提交信息',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF3F4688),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 5, bottom: 20, left: 52, right: 52),
                child: Text(
                  _tips,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 16.0 / 14,
                    color: Color(0xFFA6A6A6),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 140,
                    height: 44,
                    child: FlatButton(
                      padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: Text("联系客服",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFA27D26),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                      onPressed: () {
                        _contactCustomerService();
                      },
                      textTheme: ButtonTextTheme.normal,
                      textColor: Color(0xFFA27D26),
                      disabledTextColor: Color(0xFFA27D26),
                      color: Colors.transparent,
                      disabledColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      // 按下的背景色
                      splashColor: Colors.transparent,
                      // 水波纹颜色
                      colorBrightness: Brightness.light,
                      // 主题
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                          side: BorderSide(
                              color: Color(0xFFD7B67F),
                              style: BorderStyle.solid,
                              width: 1)),
                      clipBehavior: Clip.antiAlias,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 44,
                    child: FlatButton(
                      padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: Container(
                          alignment: Alignment.center,
                          child: Text("进入请上座",
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
                              colors: [Color(0xFF555C9E), Color(0xFF2E3576)],
                            ),
                          )),
                      onPressed: () {
                        _backHome();
                      },
                      textTheme: ButtonTextTheme.normal,
                      textColor: Colors.white,
                      disabledTextColor: ThemeColors.color404040,
                      // 按下的背景色
                      splashColor: Colors.transparent,
                      // ��波纹颜色
                      colorBrightness: Brightness.dark,
                      // 主题
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ];
    }
  }

  _buildBindCartWidget() {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: SizedBox(
        width: 347.0,
        child: Card(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _cardContent(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          child: AppBar(
            title: Text('新企业注册'),
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
        alignment: Alignment.topCenter,
        children: <Widget>[
          LoginBackground(),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // _buildStepWidget(),
              RegisterStepper(
                registerStepIndex: _registerStepIndex,
              ),
              _buildBindCartWidget(),
            ],
          )
        ],
      ),
    );
  }
}
