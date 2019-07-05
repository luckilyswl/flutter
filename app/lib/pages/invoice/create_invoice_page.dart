import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';

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
    _nameEditController.addListener(() {});

    _addressEditController = TextEditingController();
    _addressEditController.addListener(() {});

    _phoneEditController = TextEditingController();
    _phoneEditController.addListener(() {});

    _bankEditController = TextEditingController();
    _bankEditController.addListener(() {});

    _accountEditController = TextEditingController();

    _accountEditController.addListener(() {});

    _taxEditController = TextEditingController();
    _taxEditController.addListener(() {});

    _emailEditController = TextEditingController();
    _emailEditController.addListener(() {});

    _emailEditController = TextEditingController();
    _emailEditController.addListener(() {});

    _personNameEditController = TextEditingController();
    _personNameEditController.addListener(() {});

    _personEmailEditController = TextEditingController();
    _personEmailEditController.addListener(() {});

    _personTitles = <Map<String, dynamic>>[
      {
        "title": "名称",
        "subTitle": "深圳我不去餐饮连锁有限公司",
        "hint": "姓名(必填)",
        "controller": _personNameEditController,
        "node": _nameFocusNode
      },
      {
        "title": "邮箱",
        "subTitle": "wobuqu@qq.com",
        "hint": "邮箱",
        "controller": _personEmailEditController,
        "node": _personEmailFocusNode
      }
    ];

    _titles = <Map<String, dynamic>>[
      {
        "title": "名称",
        "subTitle": "深圳我不去餐饮连锁有限公司",
        "hint": "单位名称(必填)",
        "controller": _nameEditController,
        "node": _personNameFocusNode
      },
      {
        "title": "税号",
        "subTitle": "56WEFXC5894W2CQ",
        "hint": "纳税人识别号",
        "controller": _taxEditController,
        "node": _taxFocusNode
      },
      {
        "title": "单位地址",
        "subTitle": "深圳市福田区",
        "hint": "单位地址信息",
        "controller": _addressEditController,
        "node": _addressFocusNode
      },
      {
        "title": "电话号码",
        "subTitle": "135 6512 3546",
        "hint": "电话号码",
        "controller": _phoneEditController,
        "node": _phoneFocusNode
      },
      {
        "title": "开户银行",
        "subTitle": "深圳福田支行",
        "hint": "开户银行名称",
        "controller": _bankEditController,
        "node": _bankFocusNode
      },
      {
        "title": "银行账户",
        "subTitle": "6228 4812 6824 8914 675",
        "hint": "银行账户号码",
        "controller": _accountEditController,
        "node": _accountFocusNode
      },
      {
        "title": "邮箱",
        "subTitle": "wobuqu@qq.com",
        "hint": "邮箱",
        "controller": _emailEditController,
        "node": _emailFocusNode
      }
    ];

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _saveInvoice() {
    debugPrint('保存抬头');
  }

  _editWidget(String title, String hint, TextEditingController controller,
      FocusNode node) {
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
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 14),
                child: TextField(
                  controller: controller,
                  focusNode: node,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: hint,
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
              onPressed: (() {
                _saveInvoice();
              }),
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
                                color: _isPerson ? ThemeColors.color404040 : ThemeColors.colorA6A6A6,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              )),
                          onPressed: () {
                            _toPerson();
                          },
                          textTheme: ButtonTextTheme.normal,
                          textColor: _isPerson ? ThemeColors.color404040 : ThemeColors.colorA6A6A6,
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
                                  color: _isPerson ? ThemeColors.color404040 : ThemeColors.colorA6A6A6,
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
                                color: _isPerson ? ThemeColors.colorA6A6A6 : ThemeColors.color404040,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              )),
                          onPressed: () {
                            _toEnterprise();
                          },
                          textTheme: ButtonTextTheme.normal,
                          textColor: _isPerson ? ThemeColors.colorA6A6A6 : ThemeColors.color404040,
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
                                  color: _isPerson ? ThemeColors.colorA6A6A6 : ThemeColors.color404040,
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
  }

  _toEnterprise() {
    setState(() {
      _isPerson = false;
    });
  }

  _getListContent() {
    return _isPerson ? ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: _personTitles.length + 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _normalWidget('抬头类型');
        } else if (index == _personTitles.length+1) {
          return _buttonGroupWidget();
        } else {
          return _editWidget(_personTitles[index-1]["title"], _personTitles[index-1]["hint"],
              _personTitles[index-1]["controller"], _personTitles[index-1]["node"]);
        }
      },
    ) : ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: _titles.length + 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _normalWidget('抬头类型');
        } else if (index == _titles.length+1) {
          return _buttonGroupWidget();
        } else {
          return _editWidget(_titles[index-1]["title"], _titles[index-1]["hint"],
              _titles[index-1]["controller"], _titles[index-1]["node"]);
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
