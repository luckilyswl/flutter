import 'dart:convert';

import 'package:app/Application.dart';
import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/event.dart';
import 'package:app/model/invoice/invoice_list_bean.dart';
import 'package:app/navigator/page_route.dart';
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
class InvoiceEditPage extends StatefulWidget {
  @override
  _InvoiceEditPageState createState() => _InvoiceEditPageState();
}

class _InvoiceEditPageState extends State<InvoiceEditPage>
    with SingleTickerProviderStateMixin {
  bool _buttonEnable;
  List<Map<String, dynamic>> _titles;

  InvoiceModel invoiceModel;

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

  @override
  void initState() {
    _buttonEnable = true;

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

    super.initState();
  }

  _checkButtonState() {
    if (invoiceModel.taxNumber.length > 0) {
      setState(() {
        _buttonEnable = _nameEditController.text.length > 0 &&
            _emailEditController.text.length > 0 &&
            _taxEditController.text.length > 0;
      });
    } else {
      setState(() {
        _buttonEnable = _nameEditController.text.length > 0 &&
            _emailEditController.text.length > 0;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _saveInvoice() {
    Map<String, dynamic> queryParameters = {};
    queryParameters["invoice_id"] = invoiceModel.id.toString();
    if (invoiceModel.taxNumber.length > 0) {
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
    } else {
      queryParameters["invoice_type"] = '0';
      queryParameters["tax_title"] = _nameEditController.text;
      queryParameters["email"] = _emailEditController.text;
    }
    dio.post(Api.INVOICE_EDIT, data: queryParameters).then((data) {
      var sources = jsonDecode(data.data);
      if (sources['error_code'] == Api.SUCCESS_CODE) {
        Toast.SaveImageToast.toast(context, "编辑成功", true);
        Future.delayed(
          new Duration(milliseconds: 1000),
          () {
            Application.getEventBus().fire(EventType.changeInvoiceList);
            Navigator.of(context).popUntil(ModalRoute.withName(Page.INVOICE_LIST_PAGE));
          },
        );
      } else {
        T.Toast.toast(context, sources['msg']);
      }
    });
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

  _normalWidget(String title, String subTitle) {
    return Container(
      height: 50,
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
            Container(
              child: Text(
                subTitle,
                style: TextStyle(
                  color: ThemeColors.color404040,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getListWidgets() {
    List<Widget> listWidgets = <Widget>[];
    listWidgets.add(
        _normalWidget('抬头类型', invoiceModel.taxNumber.length > 0 ? '单位' : '个人'));
    _titles.forEach((v) {
      listWidgets.add(_editWidget(
          v["title"], v["hint"], v["controller"], v["node"], v["mutil"]));
    });
    listWidgets.add(_buttonGroupWidget());
    return listWidgets;
  }

  _getListContent() {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: getListWidgets().length,
      itemBuilder: (BuildContext context, int index) {
        return getListWidgets()[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /*获取传递过来的参数*/
    InvoiceModel invoiceInfo = ModalRoute.of(context).settings.arguments;
    if (invoiceModel == null && invoiceInfo != null) {
      invoiceModel = invoiceInfo;

      _nameEditController.text = invoiceModel.taxTitle;
      _emailEditController.text = invoiceModel.email;
      if (invoiceModel.taxNumber.length > 0) {
        _addressEditController.text = invoiceModel.companyAddress;
        _phoneEditController.text = invoiceModel.telphone;
        _bankEditController.text = invoiceModel.bankName;
        _accountEditController.text = invoiceModel.bankAccount;
        _taxEditController.text = invoiceModel.taxNumber;
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
      } else {
        _titles = <Map<String, dynamic>>[
          {
            "title": "名称",
            "hint": "姓名(必填)",
            "controller": _nameEditController,
            "node": _nameFocusNode,
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
      }
    }
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          child: AppBar(
            title: Text('编辑抬头'),
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
