import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';

/*
 * 发票编辑页面
 **/
class InvoiceEditPage extends StatefulWidget {
  @override
  _InvoiceEditPageState createState() => _InvoiceEditPageState();
}

class _InvoiceEditPageState extends State<InvoiceEditPage>
    with SingleTickerProviderStateMixin {
  bool _canEdit;
  List<Map<String, dynamic>> _titles;

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
    _canEdit = true;

    _nameEditController = TextEditingController();
    _nameEditController.text = "深圳我不去餐饮连锁有限公司";
    _nameEditController.addListener(() {
      
    });

    _addressEditController = TextEditingController();
    _addressEditController.text = "广州市海珠区广州大道南1601号洋湾岛B区三楼317至319";
    _addressEditController.addListener(() {
      
    });

    _phoneEditController = TextEditingController();
    _phoneEditController.text = "135 6512 3546";
    _phoneEditController.addListener(() {
      
    });

    _bankEditController = TextEditingController();
    _bankEditController.text = "广州海珠支行";
    _bankEditController.addListener(() {
      
    });

    _accountEditController = TextEditingController();
    _accountEditController.text = "6228 4812 6824 8914 675";
    
    _accountEditController.addListener(() {
      
    });

    _taxEditController = TextEditingController();
    _taxEditController.text = "9144010MA5AKYNN11";
    _taxEditController.addListener(() {
      
    });

    _emailEditController = TextEditingController();
    _emailEditController.text = "ryan@7shangzuo.com";
    _emailEditController.addListener(() {
      
    });

    _titles = <Map<String, dynamic>>[
      {"title": "抬头类型", "subTitle": "单位"},
      {"title": "名称", "subTitle": "深圳我不去餐饮连锁有限公司", "hint": "单位名称(必填)", "controller": _nameEditController, "node": _nameFocusNode},
      {"title": "税号", "subTitle": "56WEFXC5894W2CQ", "hint": "纳税人识别号", "controller": _taxEditController, "node": _taxFocusNode},
      {"title": "单位地址", "subTitle": "深圳市福田区", "hint": "单位地址信息", "controller": _addressEditController, "node": _addressFocusNode},
      {"title": "电话号码", "subTitle": "135 6512 3546", "hint": "电话号码", "controller": _phoneEditController, "node": _phoneFocusNode},
      {"title": "开户银行", "subTitle": "深圳福田支行", "hint": "开户银行名称", "controller": _bankEditController, "node": _bankFocusNode},
      {"title": "银行账户", "subTitle": "6228 4812 6824 8914 675", "hint": "银行账户号码", "controller": _accountEditController, "node": _accountFocusNode},
      {"title": "邮箱", "subTitle": "wobuqu@qq.com", "hint": "邮箱", "controller": _emailEditController, "node": _emailFocusNode}
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

  _editWidget(String title, String hint, TextEditingController controller, FocusNode node) {
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
    return _canEdit
        ? Container(
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
          )
        : Container();
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

  _getListContent() {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: _titles.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _normalWidget(_titles[index]["title"], _titles[index]["subTitle"]);
        } else if (index == _titles.length) {
          return _buttonGroupWidget();
        } else {
          return _editWidget(
              _titles[index]["title"], _titles[index]["hint"],_titles[index]["controller"],_titles[index]["node"]);
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
            title: Text('编辑发票抬头'),
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
