import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:app/widget/dialog/book_application_dialog.dart';
import 'package:app/widget/dialog/pay_alert_dialog.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';

/*
 * 预定成功页面
 **/
class BookPayPage extends StatefulWidget {
  @override
  _BookPayPageState createState() => _BookPayPageState();
}

class _BookPayPageState extends State<BookPayPage>
    with SingleTickerProviderStateMixin {
  bool _needConfirm = true;
  bool _isOpen = false;
  List<String> _payList;

  @override
  void initState() {
    _payList = <String>["个人账户", "微信支付", "支付宝"];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _payResult() {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PayAlertDialog(
            onLeftCloseEvent: () {
              Navigator.pop(context);
            },
            onRightCloseEvent: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(Page.BOOK_RESULT_PAGE);
            },
          );
        });
  }

  _normalWidget(String title) {
    return Container(
      height: 60,
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
              width: 32,
              height: 32,
              color: ThemeColors.color404040,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              width: 70,
              child: Text(
                title,
                style: TextStyle(
                  color: ThemeColors.color404040,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              child: Container(
                child: Text(
                  '余额￥116.5',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: ThemeColors.colorA6A6A6,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            )),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                color: ThemeColors.color404040,
                width: 20,
                height: 20,
                margin: EdgeInsets.only(right: 14),
              ),
            )
          ],
        ),
      ),
    );
  }

  _headerWidget() {
    return Container(
      color: Colors.white,
      height: 89,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: RichText(
              textAlign: TextAlign.center,
              text: _isOpen
                  ? TextSpan(
                      text: "￥ ",
                      style: TextStyle(
                          color: ThemeColors.colorD0021B,
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(
                          text: "0",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.normal,
                            color: ThemeColors.colorD0021B,
                          ),
                        ),
                        TextSpan(
                          text: "￥100",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: ThemeColors.colorA6A6A6,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    )
                  : TextSpan(
                      text: "￥ ",
                      style: TextStyle(
                          color: ThemeColors.colorD0021B,
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(
                          text: "100",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.normal,
                            color: ThemeColors.colorD0021B,
                          ),
                        )
                      ],
                    ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('订金将在消费/取消后原路退回',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: ThemeColors.colorA6A6A6,
                )),
          ),
        ],
      ),
    );
  }

  _getListContent() {
    if (_needConfirm) {
      if (_isOpen) {
        return ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _headerWidget();
            } else if (index == 1) {
              return Container(height: 10);
            } else if (index == 2) {
              return _enterpriseWidget();
            }
          },
        );
      } else {
        return ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: _payList.length + 4,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _headerWidget();
            } else if (index == 1) {
              return Container(height: 10);
            } else if (index == 2) {
              return _enterpriseWidget();
            } else if (index == 3) {
              return Container(
                height: 42,
                margin: EdgeInsets.only(left: 14, right: 14),
                alignment: Alignment.centerLeft,
                child: Text('选择支付方式',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: ThemeColors.color404040,
                    )),
              );
            } else {
              return _normalWidget(_payList[index - 4]);
            }
          },
        );
      }
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: _payList.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _headerWidget();
          } else if (index == 1) {
            return Container(
              height: 42,
              margin: EdgeInsets.only(left: 14, right: 14),
              alignment: Alignment.centerLeft,
              child: Text('选择支付方式',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: ThemeColors.color404040,
                  )),
            );
          } else {
            return _normalWidget(_payList[index - 2]);
          }
        },
      );
    }
  }

  _enterpriseWidget() {
    return Container(
      color: Colors.white,
      height: 44,
      padding: EdgeInsets.only(left: 14, right: 14),
      child: Row(
        children: <Widget>[
          Text('企业招待',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ThemeColors.color404040,
              )),
          Container(
            margin: EdgeInsets.only(left: 14),
            width: 42,
            height: 16,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular((2.0)), // 圆角度
              color: ThemeColors.color404040,
            ),
            child: Text(
              '免订金',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  _showApplicationDialog();
                },
                child: Container(
                  color: ThemeColors.color404040,
                  width: 51,
                  height: 28,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _showApplicationDialog() {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BookApplicationInfoDialog(
            onLeftCloseEvent: () {
              Navigator.pop(context);
            },
            onRightCloseEvent: () {
              Navigator.pop(context);
              Toast.toast(context, '敬请期待');
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          child: AppBar(
            title: Text('餐厅名称'),
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
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _getListContent(),
                ),
                Align(
                  child: Container(
                    color: ThemeColors.color404040,
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: FlatButton(
                      padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: Text("确定支付",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                      onPressed: () {
                        _payResult();
                      },
                      textTheme: ButtonTextTheme.normal,
                      textColor: Colors.white,
                      disabledTextColor: ThemeColors.color404040,
                      color: Colors.transparent,
                      disabledColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      // 按下的背景色
                      splashColor: Colors.transparent,
                      // 水波纹颜色
                      colorBrightness: Brightness.light,
                      clipBehavior: Clip.antiAlias,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                  ),
                ),
                Container(
                  color: ThemeColors.colorF2F2F2,
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          )),
    );
  }
}
