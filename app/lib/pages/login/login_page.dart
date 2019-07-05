import 'dart:convert';
import 'package:app/Application.dart';

import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/user_info_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/shared_preferences.dart';
import 'package:app/utils/utils_index.dart';

import 'package:app/widget/widgets_index.dart';

import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:app/res/theme_colors.dart';
import 'package:app/model/event.dart';
import 'package:app/widget/toast.dart' as T;

enum LoginType { PhoneLogin, AccountLogin }

/*
 * 登录页面
 **/
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  String _enterprise;
  String _account;
  String _accountPwd;
  String _phone;
  String _code;

  LoginType _loginType = LoginType.PhoneLogin;
  bool _buttonEnable;
  bool _isCounting;

  TextEditingController _phoneEditController;
  TextEditingController _codeEditController;
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _codeFocusNode = FocusNode();

  TextEditingController _accountEditController;
  TextEditingController _accountPwdEditController;
  TextEditingController _enterpriseEditController;
  final FocusNode _accountFocusNode = FocusNode();
  final FocusNode _accountPwdFocusNode = FocusNode();
  final FocusNode _enterpriseFocusNode = FocusNode();

  TabController _tabController;
  var _tabs = <Tab>[];

  @override
  void initState() {
    super.initState();
    _enterprise = '';
    _account = '';
    _accountPwd = '';
    _phone = '';
    _code = '';
    _buttonEnable = false;
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

    _accountEditController = TextEditingController();
    _accountPwdEditController = TextEditingController();
    _enterpriseEditController = TextEditingController();
    _accountEditController.addListener(() {
      setState(() {
        _account = _accountEditController.text;
        _buttonEnable = (_accountEditController.text.length > 0 &&
            _accountPwdEditController.text.length > 0 &&
            _enterpriseEditController.text.length > 0);
      });
    });
    _accountPwdEditController.addListener(() {
      setState(() {
        _accountPwd = _accountPwdEditController.text;
        _buttonEnable = (_accountEditController.text.length > 0 &&
            _accountPwdEditController.text.length > 0 &&
            _enterpriseEditController.text.length > 0);
      });
    });
    _enterpriseEditController.addListener(() {
      setState(() {
        _enterprise = _enterpriseEditController.text;
        _buttonEnable = (_accountEditController.text.length > 0 &&
            _accountPwdEditController.text.length > 0 &&
            _enterpriseEditController.text.length > 0);
      });
    });

    _tabs = <Tab>[
      Tab(text: '手机号登录'),
      Tab(text: '企业账号登录'),
    ];
    _tabController =
        TabController(initialIndex: 0, length: _tabs.length, vsync: this);
    fluwx.responseFromAuth.listen(
      (data) {
        if (data.errCode == 0) {
          if (this.mounted) {
            setState(() {
              _code = "${data.code}";
            });
            dio.post(Api.WECHAT_LOGIN, queryParameters: {
              "code": _code,
            }).then((data) {
                var sources = jsonDecode(data.data);
                UserInfoBean bean = UserInfoBean.fromJson(sources);
                if (bean.errorCode == Api.SUCCESS_CODE) {
                  if (bean.data.isBindPhone == "1") {
                    Future.delayed(
                      new Duration(milliseconds: 300),
                          () {
                        DataUtils.saveLoginInfo(bean);
                        Application.getEventBus().fire(EventType.loginSuccess);
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    SpUtil.putString(
                        DataUtils.SP_SESSION_ID, bean.data.sessionId);
                    Navigator.of(context).pushNamed(Page.BIND_PAGE);
                  }
                } else {
                  T.Toast.toast(context, bean.msg);
                }
              },
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    if (_phoneEditController != null) {
      _phoneEditController.dispose();
    }
    if (_codeEditController != null) {
      _codeEditController.dispose();
    }
    if (_accountEditController != null) {
      _accountEditController.dispose();
    }
    if (_accountPwdEditController != null) {
      _accountPwdEditController.dispose();
    }
    if (_enterpriseEditController != null) {
      _enterpriseEditController.dispose();
    }
    super.dispose();
  }

  _buildTabBar() {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        left: 24,
        right: 24,
      ),
      height: 46,
      decoration: ShapeDecoration(
        shape: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: _tabs,
        isScrollable: true,
        indicatorColor: Color(0xFF3F4688),
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Color(0xFF3F4688),
        labelStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelColor: Color(0xFFA6A6A6),
        unselectedLabelStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
        onTap: (int index) {
          this.setState(() {
            if (index == 0) {
              _loginType = LoginType.PhoneLogin;
              _buttonEnable = (_phoneEditController.text.length == 11 &&
                  _codeEditController.text.length == 6);
            } else {
              _loginType = LoginType.AccountLogin;
              _buttonEnable = (_accountEditController.text.length > 0 &&
                  _accountPwdEditController.text.length > 0 &&
                  _enterpriseEditController.text.length > 0);
            }
          });
        },
      ),
    );
  }

  _buildPhoneTextField() {
    return LoginTextField(
      controller: _phoneEditController,
      focusNode: _phoneFocusNode,
      obscureText: false,
      keyboardType: TextInputType.phone,
      hintText: "请输入手机号",
      imageName: "assets/images/ic_login_phone.png",
      rightWidget: Container(),
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
          if (_phone.length == 11) {
            _getPhoneCode();
          } else {
            T.Toast.toast(context, '请输入正确手机号');
          }
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

  _buildAccountTextField() {
    return LoginTextField(
      controller: _accountEditController,
      focusNode: _accountFocusNode,
      obscureText: false,
      keyboardType: TextInputType.text,
      hintText: "请输入手机号/邮箱/工号",
      imageName: "assets/images/ic_login_account.png",
      rightWidget: Container(),
    );
  }

  _buildAccountPwdTextField() {
    return LoginTextField(
      controller: _accountPwdEditController,
      focusNode: _accountPwdFocusNode,
      obscureText: true,
      keyboardType: TextInputType.text,
      hintText: "请输入密码",
      imageName: "assets/images/ic_login_pwd.png",
      rightWidget: Container(),
    );
  }

  _buildEnterpriseTextField() {
    return LoginTextField(
      controller: _enterpriseEditController,
      focusNode: _enterpriseFocusNode,
      obscureText: true,
      keyboardType: TextInputType.text,
      hintText: "请输入企业号",
      imageName: "assets/images/ic_login_pwd.png",
      rightWidget: Container(),
    );
  }

  /*
   * 微信登录
   **/
  _sendAuth() {
    fluwx
        .sendAuth(scope: "snsapi_userinfo", state: "7shangzuo")
        .then((data) {});
  }

  /*
   * 手机号登录
   **/
  _loginWithPhone() {
    dio.post(
      Api.TELPHONE_LOGIN,
      queryParameters: {
        'phone': _phone,
        'code': _code,
      },
    ).then((data) {
      var sources = jsonDecode(data.data);
      UserInfoBean bean = UserInfoBean.fromJson(sources);
      if (bean.errorCode == Api.SUCCESS_CODE) {
        Future.delayed(
          new Duration(milliseconds: 300),
          () {
            Application.getEventBus().fire(EventType.loginSuccess);
            DataUtils.saveLoginInfo(bean);
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
    if (_phone.length == 11) {
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
                    setState(() {
                      _isCounting = true;
                    });
                  },
                  phone: _phone,
                  type: SMSCodeType.SMSCodeLogin,
                  captchaBase64: captchaBase64,
                  captchaId: captchaId,
                );
              });
        } else {
          T.Toast.toast(context, sources['msg']);
        }
      });
    } else {
      T.Toast.toast(context, '请输入正确手机号');
    }
  }

  /*
   * 企业账号登录
   **/
  _loginWithAccount() {
    debugPrint('登录...');
    dio.post(
      Api.USERNAME_LOGIN,
      queryParameters: {
        'username': _account,
        'password': _accountPwd,
        'en_id': _enterprise
      },
    ).then((data) {
      var sources = jsonDecode(data.data);
      UserInfoBean bean = UserInfoBean.fromJson(sources);
      if (bean.errorCode == Api.SUCCESS_CODE) {
        Future.delayed(
          new Duration(milliseconds: 300),
          () {
            DataUtils.saveLoginInfo(bean);
            Application.getEventBus().fire(EventType.loginSuccess);
            Navigator.pop(context);
          },
        );
      } else {
        T.Toast.toast(context, bean.msg);
      }
    });
  }

  /*
   * 新企业注册
   **/
  _registerNewCompany() {
    Navigator.of(context).pushNamed(Page.REGISTER_PAGE);
  }

  _buildBottomRegisterWidget() {
    return Expanded(
      child: Container(
        child: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 120,
              child: Column(
                children: <Widget>[
                  FlatButton(
                    child: Text("新企业注册",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ThemeColors.color404040,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        )),
                    onPressed: () {
                      _registerNewCompany();
                    },
                    textTheme: ButtonTextTheme.normal,
                    textColor: ThemeColors.color404040,
                    disabledTextColor: Colors.red,
                    color: Colors.transparent,
                    disabledColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    // 按下的背景色
                    splashColor: Colors.transparent,
                    // 水波纹颜色
                    colorBrightness: Brightness.light,
                    // 主题
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        side: BorderSide(
                            color: Color(0xFFA6A6A6),
                            style: BorderStyle.solid,
                            width: 1)),
                    clipBehavior: Clip.antiAlias,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      '若贵公司已是请上座企业版客户\n可联系贵公司商务接待负责人获取登录账户',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFA6A6A6),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildLoginButtonWidget() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 24, right: 24),
      child: Column(
        children: <Widget>[
          LoginButton(
            enabled: _buttonEnable,
            onPressed: (() {
              if (_loginType == LoginType.PhoneLogin) {
                _loginWithPhone();
              } else {
                _loginWithAccount();
              }
            }),
            title: '登录',
          ),
          _loginType == LoginType.PhoneLogin
              ? Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text('未注册的手机号码验证后自动注册',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFA6A6A6),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      )),
                )
              : Container(height: 0.0, width: 0.0),
        ],
      ),
    );
  }

  _buildLoginEditWidget() {
    return _loginType == LoginType.PhoneLogin
        ? Container(
            margin: EdgeInsets.only(top: 15, left: 24, right: 24),
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildPhoneTextField(),
                _buildCodeTextField(),
              ],
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: 15, left: 24, right: 24),
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildAccountTextField(),
                _buildAccountPwdTextField(),
                _buildEnterpriseTextField(),
              ],
            ),
          );
  }

  _buildWxLoginWidget() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Container(
                height: 1,
                color: Color(0xFFDEDEDE),
              )),
              Expanded(
                child: Text(
                  '第三方账号登录',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFA6A6A6),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(child: Container(height: 1, color: Color(0xFFDEDEDE)))
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 16),
              child: GestureDetector(
                child: Image.asset("assets/images/btn_wechat_login.png",
                    width: 40, height: 40),
                onTap: () {
                  _sendAuth();
                },
              )),
          Container(
            margin: EdgeInsets.only(top: 3),
            child: Text(
              '微信登录',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ThemeColors.color404040,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 3),
            child: Text(
              '小程序用户推荐',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ThemeColors.color404040,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildLoginCartWidget() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: SizedBox(
            width: 347.0,
            child: Card(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildTabBar(),
                  _buildLoginEditWidget(),
                  _buildLoginButtonWidget(),
                  _buildWxLoginWidget(),
                ],
              ),
            )));
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
      body: new LayoutBuilder(
        builder: (BuildContext cotext, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: new ConstrainedBox(
              constraints:
                  new BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: new IntrinsicHeight(
                child: Stack(
                  // alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    LoginBackground(),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        LoginIntroduction(),
                        _buildLoginCartWidget(),
                        _buildBottomRegisterWidget(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
