import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';

/*
 * 发票详情页面
 **/
class InvoiceDetailPage extends StatefulWidget {
  @override
  _InvoiceDetailPageState createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage>
    with SingleTickerProviderStateMixin {
  bool _canEdit;
  List<Map<String, dynamic>> _titles;

  @override
  void initState() {
    _canEdit = true;
    _titles = <Map<String, dynamic>>[
      {"title": "抬头类型", "subTitle": "单位"},
      {"title": "名称", "subTitle": "深圳我不去餐饮连锁有限公司"},
      {"title": "税号", "subTitle": "56WEFXC5894W2CQ"},
      {"title": "单位地址", "subTitle": "深圳市福田区"},
      {"title": "电话号码", "subTitle": "135 6512 3546"},
      {"title": "开户银行", "subTitle": "深圳福田支行"},
      {"title": "银行账户", "subTitle": "6228 4812 6824 8914 675"},
      {"title": "邮箱", "subTitle": "wobuqu@qq.com"}
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _editInvoice() {
    Navigator.of(context).pushNamed(Page.INVOICE_EDIT_PAGE);
    debugPrint('编辑');
  }

  _deleteInvoice() {
    debugPrint('删除抬头');
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
                      child: Text('编辑',
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
                      _editInvoice();
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

  _getListContent() {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: _titles.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index ==  _titles.length) {
          return _buttonGroupWidget();
        } else {
          return _normalWidget(_titles[index]["title"],
              _titles[index]["subTitle"]);
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
            title: Text('发票详情'),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              _canEdit
                  ? GestureDetector(
                      onTap: () {
                        _deleteInvoice();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 14),
                        alignment: Alignment.centerRight,
                        child: Text(
                          '删除抬头',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
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
