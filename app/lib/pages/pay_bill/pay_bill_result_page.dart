import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';

/*
 * 买单成功页面
 **/
class PayBillResultPage extends StatefulWidget {
  @override
  _PayBillResultPageState createState() => _PayBillResultPageState();
}

class _PayBillResultPageState extends State<PayBillResultPage>
    with SingleTickerProviderStateMixin {
  List<String> _banners;

  @override
  void initState() {
    _banners = <String>["广告位", "广告位", "广告位", "广告位"];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _seeOrder() {
    debugPrint('查看订单');
  }

  _backHome() {
    debugPrint('回到首页');
  }

  _service() {
    debugPrint('联系客服');
  }

  _normalWidget(String title) {
    return Container(
      height: 90,
      decoration: new BoxDecoration(
        color: ThemeColors.colorD8D8D8,
        borderRadius: new BorderRadius.circular((4.0)), // 圆角度
      ),
      margin: EdgeInsets.only(left: 14, right: 14, top: 14),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          color: ThemeColors.color404040,
          fontSize: 40,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _contentWidget() {
    return Container(
      height: 302,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: ThemeColors.color404040,
                  width: 24,
                  height: 24,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  alignment: Alignment.center,
                  child: Text('买单成功',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: ThemeColors.color404040,
                      )),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            alignment: Alignment.center,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "￥",
                style: TextStyle(
                    color: ThemeColors.color404040,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
                children: [
                  TextSpan(
                    text: "5178.5",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.normal,
                      color: ThemeColors.color404040,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            margin: EdgeInsets.only(left: 14, top: 20),
            color: ThemeColors.colorDEDEDE,
          ),
          Container(
            margin: EdgeInsets.only(left: 14, right: 14, top: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('支付方式',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: ThemeColors.color404040,
                    )),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "微信",
                    style: TextStyle(
                        color: ThemeColors.color404040,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: "(￥5178.5)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: ThemeColors.color404040,
                        ),
                      ),
                      TextSpan(
                        text: "+",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: ThemeColors.colorA6A6A6,
                        ),
                      ),
                      TextSpan(
                        text: "余额",
                        style: TextStyle(
                          color: ThemeColors.color404040,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: "(￥1346.5)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: ThemeColors.color404040,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 14, right: 14, top: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('退回订金',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: ThemeColors.color404040,
                    )),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "100元",
                    style: TextStyle(
                        color: ThemeColors.color404040,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: "(已原路退回)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: ThemeColors.color404040,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 14, right: 14, top: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('返回2%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: ThemeColors.color404040,
                    )),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "103.57元",
                    style: TextStyle(
                        color: ThemeColors.color404040,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: "(请联系客服领取)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: ThemeColors.color404040,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 27, right: 27),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 95,
                    height: 40,
                    child: FlatButton(
                      padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: Text("回到首页",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ThemeColors.color404040,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          )),
                      onPressed: () {
                        _backHome();
                      },
                      textTheme: ButtonTextTheme.normal,
                      textColor: ThemeColors.color404040,
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
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          side: BorderSide(
                              color: ThemeColors.color404040,
                              style: BorderStyle.solid,
                              width: 1)),
                      clipBehavior: Clip.antiAlias,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 186,
                    margin: EdgeInsets.only(left: 14),
                    decoration: new BoxDecoration(
                      color: ThemeColors.color404040,
                      borderRadius: new BorderRadius.circular((4.0)), // 圆角度
                    ),
                    child: FlatButton(
                      padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: Text("查看订单",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                      onPressed: () {
                        _seeOrder();
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
                      // 主题
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _getListContent() {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: _banners.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _contentWidget();
        } else {
          return _normalWidget(_banners[index - 1]);
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
            title: Text('花园酒店名仕阁'),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  _service();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 14),
                  alignment: Alignment.centerRight,
                  child: Text(
                    '客服',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              )
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
