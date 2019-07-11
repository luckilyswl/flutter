import 'package:app/model/invoice/invoice_list_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';

/*
 * 开具发票页面
 **/
class IssueInvoicePage extends StatefulWidget {
  @override
  _IssueInvoicePageState createState() => _IssueInvoicePageState();
}

class _IssueInvoicePageState extends State<IssueInvoicePage>
    with SingleTickerProviderStateMixin {
  bool _buttonEnable;

  InvoiceModel invoiceModel;
  String email;

  //填写信息
  TextEditingController _emailEditController;
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void initState() {
    _buttonEnable = false;
    _emailEditController = TextEditingController();
    _emailEditController.addListener(() {
      setState(() {
        email = _emailEditController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailEditController.dispose();
    super.dispose();
  }

  _checkButtonState() {
    setState(() {
      _buttonEnable = (invoiceModel != null && email != null && email.length > 0);
    });
  }

  _noNeed() {
    Navigator.of(context).pop({"need": false});
  }

  _confirm() {
    Navigator.of(context).pop({"invoiceModel": invoiceModel, "email": email, "need": true});
  }

  _toSelectInvoice() async {
    if (invoiceModel != null) {
      final result = await Navigator.of(context).pushNamed(
          Page.INVOICE_LIST_PAGE,
          arguments: {"id": invoiceModel.id});
      if (result != null) {
        InvoiceModel backInvoiceModel = result;
        setState(() {
          invoiceModel = backInvoiceModel;
          if (email == null) {
            email = invoiceModel.email;
            _emailEditController.text = email;
          }
        });
        _checkButtonState();
      }
    } else {
      final result = await Navigator.of(context).pushNamed(
          Page.INVOICE_LIST_PAGE);
      if (result != null) {
        InvoiceModel backInvoiceModel = result;
        setState(() {
          invoiceModel = backInvoiceModel;
          if (email == null) {
            email = invoiceModel.email;
            _emailEditController.text = email;
          }
        });
        _checkButtonState();
      }
    }
  }

  _normalWidget(String title, String subTitle) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 14),
        padding: EdgeInsets.only(top: 13),
        decoration: ShapeDecoration(
          shape: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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

  _chooseWidget() {
    return GestureDetector(
      onTap: () {
        _toSelectInvoice();
      },
      child: Container(
        height: invoiceModel != null ? 60 : 50,
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 14),
          decoration: ShapeDecoration(
            shape: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 70,
                padding: EdgeInsets.only(top: 13),
                child: Text(
                  '发票抬头',
                  style: TextStyle(
                    color: ThemeColors.color404040,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                  child: invoiceModel != null
                      ? Container(
                          padding: EdgeInsets.only(top: 13),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  invoiceModel.taxTitle,
                                  style: TextStyle(
                                    color: ThemeColors.color404040,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  invoiceModel.invoiceType == 0
                                      ? '个人'
                                      : '税号 ${invoiceModel.taxNumber}',
                                  style: TextStyle(
                                    color: ThemeColors.colorA6A6A6,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.only(top: 13),
                          child: Text(
                            '请选择',
                            style: TextStyle(
                              color: ThemeColors.colorA6A6A6,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 20,
                  height: 20,
                  color: ThemeColors.color404040,
                  margin: EdgeInsets.only(right: 14),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _inputWidget() {
    return Container(
      height: 50,
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 70,
              child: Text(
                '邮箱地址',
                style: TextStyle(
                  color: ThemeColors.color404040,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 14),
                child: TextField(
                  controller: _emailEditController,
                  focusNode: _emailFocusNode,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: '请输入',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA6A6A6),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                child: Text('确定',
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
                    colors: [
                      _buttonEnable ? Color(0xFF404040) : Color(0xFFA6A6A6),
                      _buttonEnable ? Color(0xFF404040) : Color(0xFFA6A6A6)
                    ],
                  ),
                ),
              ),
              onPressed: () {
                if (_buttonEnable) {
                  _confirm();
                }
              },
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
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 50,
            child: FlatButton(
              padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Text(
                "不需要",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                _noNeed();
              },
              textTheme: ButtonTextTheme.normal,
              textColor: ThemeColors.color404040,
              color: Colors.transparent,
              highlightColor: Colors.transparent,
              // 按下的背景色
              splashColor: Colors.transparent,
              // 水波纹颜色
              colorBrightness: Brightness.light,
              materialTapTargetSize: MaterialTapTargetSize.padded,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*获取传递过来的参数*/
    Map<String, dynamic> invoiceInfo =
        ModalRoute.of(context).settings.arguments;
    if (invoiceModel == null && invoiceInfo != null) {
      email = invoiceInfo["email"];
      _emailEditController.text = email;
      invoiceModel = invoiceInfo["invoiceModel"];
      _checkButtonState();
    }
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          child: AppBar(
            title: Text('开具发票'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _normalWidget('开票方', '发票由餐厅提供'),
            _normalWidget('发票明细', '餐饮服务费'),
            _chooseWidget(),
            _inputWidget(),
            Container(
                margin: EdgeInsets.only(top: 10, left: 14, right: 14),
                child: Row(children: <Widget>[
                  Container(
                    child: Text(
                      '* 部分餐厅仅提供纸质发票，用餐结束后到',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: ThemeColors.colorA6A6A6,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ])),
            _buttonGroupWidget(),
          ],
        ),
      ),
    );
  }
}
