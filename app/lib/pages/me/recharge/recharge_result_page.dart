import 'dart:convert';

import 'package:app/Application.dart';
import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/event.dart';
import 'package:app/model/pay/pay_complete_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

/*
 * 充值成功页面
 **/
class RechargePayResultPage extends StatefulWidget {
  @override
  _RechargePayResultPageState createState() => _RechargePayResultPageState();
}

class _RechargePayResultPageState extends State<RechargePayResultPage>
    with SingleTickerProviderStateMixin {
  PayCompleteData payResultData;
  int orderId = 0;
  bool fromPayPage = false;

  @override
  void initState() {
    payResultData = PayCompleteData(
        title: '充值成功',
        payAmount: '2000',
        payInfo: <PayCompletePayInfo>[
          PayCompletePayInfo(
            title: '支付方式',
            text: '微信支付',
          ),
          PayCompletePayInfo(
            title: '获得余额',
            text: '2500元',
          )
        ]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() {
    dio.get(Api.RECHARGE_PAY_RESULT, queryParameters: {
      "order_id": orderId.toString(),
    }).then((data) {
      var sources = jsonDecode(data.toString());
      PayCompleteBean bean = PayCompleteBean.fromJson(sources);
      if (bean.errorCode == Api.SUCCESS_CODE) {
        PayCompleteData dataBean = bean.data;
        setState(() {
          payResultData = dataBean;
        });
      }
    });
  }

  _continuteRecharge() {
    Navigator.of(context).pop();
  }

  _backHome() {
    Application.getEventBus().fire(EventType.goHome);
    Navigator.of(context).popUntil(ModalRoute.withName(Page.ROOT_PAGE));
  }

  _seeDetail() {
    Navigator.of(context).pushNamed(Page.BALANCE_DETAIL_PAGE);
  }

  _backPayPage() {
    Navigator.of(context).popUntil(ModalRoute.withName(Page.PAY_BILL_PAGE));
  }

  _service() {
    Navigator.of(context).pushNamed(Page.CUSTOMER_SERVICE_PAGE);
  }

  _titleWidget() {
    return Container(
      height: 110,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
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
                  child: Text(payResultData.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: ThemeColors.color404040,
                      )),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "￥ ",
                  style: TextStyle(
                      color: ThemeColors.color404040,
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                  children: [
                    TextSpan(
                      text: payResultData.payAmount,
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
          ],
        ),
      ),
    );
  }

  _bottomButtonWidgets() {
    return fromPayPage
        ? Container(
            margin: EdgeInsets.only(top: 20, left: 14, right: 14, bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 168,
                  height: 40,
                  child: FlatButton(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Text("继续充值",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ThemeColors.color3F4688,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        )),
                    onPressed: () {
                      _continuteRecharge();
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
                            color: ThemeColors.color3F4688,
                            style: BorderStyle.solid,
                            width: 1)),
                    clipBehavior: Clip.antiAlias,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                  ),
                ),
                Container(
                  height: 40,
                  width: 168,
                  decoration: new BoxDecoration(
                    color: ThemeColors.color404040,
                    borderRadius: new BorderRadius.circular((5.0)), // 圆角度
                  ),
                  child: FlatButton(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text("返回买单",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          )),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Color(0xFF555C9E),
                            Color(0xFF2E3576),
                          ],
                        ),
                      ),
                    ),
                    onPressed: () {
                      _backPayPage();
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
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                  ),
                ),
              ],
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            height: 40,
            width: 186,
            decoration: new BoxDecoration(
              color: ThemeColors.color404040,
              borderRadius: new BorderRadius.circular((4.0)), // 圆角度
            ),
            child: FlatButton(
              padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Container(
                alignment: Alignment.center,
                child: Text("去首页",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    )),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Color(0xFF555C9E),
                      Color(0xFF2E3576),
                    ],
                  ),
                ),
              ),
              onPressed: () {
                _backHome();
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
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              clipBehavior: Clip.antiAlias,
              materialTapTargetSize: MaterialTapTargetSize.padded,
            ),
          );
  }

  _payInfoItemWidgets(PayCompletePayInfo payInfo) {
    return Container(
      margin: EdgeInsets.only(left: 14, right: 14, top: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(payInfo.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: ThemeColors.color404040,
              )),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: payInfo.text,
              style: TextStyle(
                  color: ThemeColors.color404040,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: payInfo.desc != null && payInfo.desc.length > 0
                      ? "(${payInfo.desc})"
                      : '',
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
    );
  }

  _balanceItemWidgets(PayCompletePayInfo payInfo) {
    return Container(
      margin: EdgeInsets.only(left: 14, right: 14, top: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(payInfo.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: ThemeColors.color404040,
              )),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(left: 14, right: 14),
              child: Text(
                payInfo.text,
                style: TextStyle(
                    color: ThemeColors.color404040,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                _seeDetail();
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '去看看',
                      style: TextStyle(
                        color: ThemeColors.color3F4688,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Container(
                      color: ThemeColors.color3F4688,
                      width: 14,
                      height: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _contentItemWidgets() {
    List<Widget> itemWidgets = <Widget>[];
    itemWidgets.add(_titleWidget());
    itemWidgets.add(
      Container(
        height: 1,
        margin: EdgeInsets.only(left: 14, top: 20),
        color: ThemeColors.colorDEDEDE,
      ),
    );
    itemWidgets.add(_payInfoItemWidgets(payResultData.payInfo[0]));
    itemWidgets.add(_balanceItemWidgets(payResultData.payInfo[1]));
    itemWidgets.add(_bottomButtonWidgets());
    return itemWidgets;
  }

  _contentWidget() {
    return Container(
        constraints: BoxConstraints(minHeight: 310),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _contentItemWidgets(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    /*获取传递过来的参数*/
    Map<String, dynamic> orderInfo = ModalRoute.of(context).settings.arguments;
    if (orderId == 0 && orderInfo != null) {
      debugPrint(orderInfo.toString());
      orderId = orderInfo["orderId"];
      fromPayPage = orderInfo["fromPay"];
      // initData();
    }

    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          child: AppBar(
            title: Text('充值支付'),
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
      body: payResultData != null
          ? Container(
              color: ThemeColors.colorF2F2F2,
              child: _contentWidget(),
            )
          : Container(),
    );
  }
}
