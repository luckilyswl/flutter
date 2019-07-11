import 'dart:convert';

import 'package:app/Application.dart';
import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/event.dart';
import 'package:app/res/res_index.dart';
import 'package:app/widget/invoice/invoice_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';
import 'package:app/widget/save_image_toast.dart' as Toast;
import 'package:app/widget/toast.dart' as T;

/*
 * 发票编辑页面
 **/
class InvoiceCreatePage extends StatefulWidget {
  @override
  _InvoiceCreatePageState createState() => _InvoiceCreatePageState();
}

class _InvoiceCreatePageState extends State<InvoiceCreatePage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _titles;

  List<Map<String, dynamic>> _personTitles;

  bool _isPerson = true;
  bool _buttonEnable = false;

  //填写信息
  TextEditingController _nameEditController;
  final FocusNode _nameFocusNode = FocusNode();
  TextEditingController _emailEditController;
  final FocusNode _emailFocusNode = FocusNode();
  TextEditingController _addressEditController;
  final FocusNode _addressFocusNode = FocusNode();
  TextEditingController _phoneEditController;
  final FocusNode _phoneFocusNode = FocusNode();
  TextEditingController _bankEditController;
  final FocusNode _bankFocusNode = FocusNode();
  TextEditingController _accountEditController;
  final FocusNode _accountFocusNode = FocusNode();
  TextEditingController _taxEditController;
  final FocusNode _taxFocusNode = FocusNode();

  //填写个人信息
  TextEditingController _personNameEditController;
  final FocusNode _personNameFocusNode = FocusNode();
  TextEditingController _personEmailEditController;
  final FocusNode _personEmailFocusNode = FocusNode();

  @override
  void initState() {
    _nameEditController = TextEditingController();
    _nameEditController.addListener(() {
      _checkButtonState();
    });

    _addressEditController = TextEditingController();
    _addressEditController.addListener(() {
      _checkButtonState();
    });

    _phoneEditController = TextEditingController();
    _phoneEditController.addListener(() {
      _checkButtonState();
    });

    _bankEditController = TextEditingController();
    _bankEditController.addListener(() {
      _checkButtonState();
    });

    _accountEditController = TextEditingController();
    _accountEditController.addListener(() {
      _checkButtonState();
    });

    _taxEditController = TextEditingController();
    _taxEditController.addListener(() {
      _checkButtonState();
    });

    _emailEditController = TextEditingController();
    _emailEditController.addListener(() {
      _checkButtonState();
    });

    _personNameEditController = TextEditingController();
    _personNameEditController.addListener(() {
      _checkButtonState();
    });

    _personEmailEditController = TextEditingController();
    _personEmailEditController.addListener(() {
      _checkButtonState();
    });

    _personTitles = <Map<String, dynamic>>[
      {
        "title": "名称",
        "hint": "姓名(必填)",
        "controller": _personNameEditController,
        "node": _personNameFocusNode,
        "mutil": false,
      },
      {
        "title": "邮箱",
        "hint": "邮箱",
        "controller": _personEmailEditController,
        "node": _personEmailFocusNode,
        "mutil": false,
      }
    ];

    _titles = <Map<String, dynamic>>[
      {
        "title": "名称",
        "hint": "单位名称(必填)",
        "controller": _nameEditController,
        "node": _nameFocusNode,
        "mutil": false,
      },
      {
        "title": "税号",
        "hint": "纳税人识别号",
        "controller": _taxEditController,
        "node": _taxFocusNode,
        "mutil": false,
      },
      {
        "title": "单位地址",
        "hint": "单位地址信息",
        "controller": _addressEditController,
        "node": _addressFocusNode,
        "mutil": true,
      },
      {
        "title": "电话号码",
        "hint": "电话号码",
        "controller": _phoneEditController,
        "node": _phoneFocusNode,
        "mutil": false,
      },
      {
        "title": "开户银行",
        "hint": "开户银行名称",
        "controller": _bankEditController,
        "node": _bankFocusNode,
        "mutil": false,
      },
      {
        "title": "银行账户",
        "hint": "银行账户号码",
        "controller": _accountEditController,
        "node": _accountFocusNode,
        "mutil": false,
      },
      {
        "title": "邮箱",
        "hint": "邮箱",
        "controller": _emailEditController,
        "node": _emailFocusNode,
        "mutil": false,
      }
    ];

    super.initState();
  }

  _checkButtonState() {
    if (_isPerson) {
      setState(() {
        _buttonEnable = _personNameEditController.text.length > 0 &&
            _personEmailEditController.text.length > 0;
      });
    } else {
      setState(() {
        _buttonEnable = _nameEditController.text.length > 0 &&
            _emailEditController.text.length > 0 &&
            _taxEditController.text.length > 0;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _saveInvoice() {
    if (_buttonEnable) {
      Map<String, dynamic> queryParameters = {};
      if (_isPerson) {
        queryParameters["invoice_type"] = '0';
        queryParameters["tax_title"] = _personNameEditController.text;
        queryParameters["email"] = _personEmailEditController.text;
      } else {
        queryParameters["invoice_type"] = '1';
        queryParameters["tax_title"] = _nameEditController.text;
        queryParameters["email"] = _emailEditController.text;
        queryParameters["tax_number"] = _taxEditController.text;
        if (_addressEditController.text.length > 0) {
          queryParameters["company_address"] = _addressEditController.text;
        }
        if (_phoneEditController.text.length > 0) {
          queryParameters["telphone"] = _phoneEditController.text;
        }
        if (_bankEditController.text.length > 0) {
          queryParameters["bank_name"] = _bankEditController.text;
        }
        if (_accountEditController.text.length > 0) {
          queryParameters["bank_account"] = _accountEditController.text;
        }
      }
      dio
          .post(Api.INVOICE_CREATE, queryParameters: queryParameters)
          .then((data) {
        var sources = jsonDecode(data.data);
        if (sources['error_code'] == Api.SUCCESS_CODE) {
          Toast.SaveImageToast.toast(context, "添加成功", true);
          Future.delayed(
            new Duration(milliseconds: 1000),
            () {
              Application.getEventBus().fire(EventType.changeInvoiceList);
              Navigator.of(context).pop();
            },
          );
        } else {
          T.Toast.toast(context, sources['msg']);
        }
      });
    }
  }

  _editWidget(String title, String hint, TextEditingController controller,
      FocusNode node, bool isMutil) {
    return InvoiceInputWidget(
        title: title,
        hint: hint,
        controller: controller,
        node: node,
        isMutil: isMutil);
  }

  _buttonGroupWidget() {
    return Container(
      margin: EdgeInsets.only(top: 35, left: 14, right: 14),
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            child: FlatButton(
              padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Container(
                alignment: Alignment.center,
                child: Text('保存',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    )),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [Color(0xFF404040), Color(0xFF404040)],
                  ),
                ),
              ),
              onPressed: _saveInvoice,
              textTheme: ButtonTextTheme.normal,
              disabledTextColor: ThemeColors.color404040,
              textColor: Colors.white,
              // 按下的背景��
              splashColor: Colors.transparent,
              // ��波纹颜色
              colorBrightness: Brightness.dark,
              // 主题
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ],
      ),
    );
  }

  _normalWidget(String title) {
    return Container(
      height: 68,
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 14),
        decoration: ShapeDecoration(
          shape: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 70,
              child: Text(
                title,
                style: TextStyle(
                  color: ThemeColors.color404040,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 132,
                        height: 40,
                        child: FlatButton(
                          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Text("个人",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _isPerson
                                    ? ThemeColors.color404040
                                    : ThemeColors.colorA6A6A6,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              )),
                          onPressed: () {
                            _toPerson();
                          },
                          textTheme: ButtonTextTheme.normal,
                          textColor: _isPerson
                              ? ThemeColors.color404040
                              : ThemeColors.colorA6A6A6,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              side: BorderSide(
                                  color: _isPerson
                                      ? ThemeColors.color404040
                                      : ThemeColors.colorA6A6A6,
                                  style: BorderStyle.solid,
                                  width: 1)),
                          clipBehavior: Clip.antiAlias,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                        ),
                      ),
                      Container(
                        width: 132,
                        height: 40,
                        child: FlatButton(
                          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Text("单位",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _isPerson
                                    ? ThemeColors.colorA6A6A6
                                    : ThemeColors.color404040,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              )),
                          onPressed: () {
                            _toEnterprise();
                          },
                          textTheme: ButtonTextTheme.normal,
                          textColor: _isPerson
                              ? ThemeColors.colorA6A6A6
                              : ThemeColors.color404040,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              side: BorderSide(
                                  color: _isPerson
                                      ? ThemeColors.colorA6A6A6
                                      : ThemeColors.color404040,
                                  style: BorderStyle.solid,
                                  width: 1)),
                          clipBehavior: Clip.antiAlias,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _toPerson() {
    setState(() {
      _isPerson = true;
    });
    _checkButtonState();
  }

  _toEnterprise() {
    setState(() {
      _isPerson = false;
    });
    _checkButtonState();
  }

  _getListContent() {
    return _isPerson
        ? ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: _personTitles.length + 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _normalWidget('抬头类型');
              } else if (index == _personTitles.length + 1) {
                return _buttonGroupWidget();
              } else {
                return _editWidget(
                    _personTitles[index - 1]["title"],
                    _personTitles[index - 1]["hint"],
                    _personTitles[index - 1]["controller"],
                    _personTitles[index - 1]["node"],
                    _personTitles[index - 1]["mutil"]);
              }
            },
          )
        : ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: _titles.length + 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _normalWidget('抬头类型');
              } else if (index == _titles.length + 1) {
                return _buttonGroupWidget();
              } else {
                return _editWidget(
                    _titles[index - 1]["title"],
                    _titles[index - 1]["hint"],
                    _titles[index - 1]["controller"],
                    _titles[index - 1]["node"],
                    _titles[index - 1]["mutil"]);
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          child: AppBar(
            title: Text('添加发票抬头'),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          decoration: BoxDecoration(
            gradient: Gradients.loginBgLinearGradient,
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 45),
      ),
      body: Container(
        color: ThemeColors.colorF2F2F2,
        child: _getListContent(),
      ),
    );
  }
}
