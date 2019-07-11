import 'dart:convert';

import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/pay/pay_complete_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

/*
 * 买单成功页面
 **/
class PayBillResultPage extends StatefulWidget {
  @override
  _PayBillResultPageState createState() => _PayBillResultPageState();
}

class _PayBillResultPageState extends State<PayBillResultPage>
    with SingleTickerProviderStateMixin {
  PayCompleteData payResultData;
  int orderId = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() {
    dio.get(Api.PAY_RESULT, queryParameters: {
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

  _seeOrder() {
    debugPrint('查看订单');
  }

  _backHome() {
    Navigator.of(context).popUntil(ModalRoute.withName(Page.ROOT_PAGE));
  }

  _service() {
    Navigator.of(context).pushNamed(Page.CUSTOMER_SERVICE_PAGE);
  }

  _normalWidget(PayCompleteBanners banner) {
    return Container(
      height: 90,
      decoration: new BoxDecoration(
        color: ThemeColors.colorD8D8D8,
        borderRadius: new BorderRadius.circular((4.0)), // 圆角度
      ),
      margin: EdgeInsets.only(left: 14, right: 14, top: 14),
      alignment: Alignment.center,
      child: Image.network(banner.imgUrl, fit: BoxFit.fill),
    );
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
            Container(
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
    return Container(
      margin: EdgeInsets.only(top:20, left: 27, right: 27, bottom: 20),
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
                  text: payInfo.desc != null && payInfo.desc.length > 0 ? "(${payInfo.desc})" : '',
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
    for (PayCompletePayInfo payInfo in payResultData.payInfo) {
      itemWidgets.add(_payInfoItemWidgets(payInfo));
    }
    itemWidgets.add(_bottomButtonWidgets());
    return itemWidgets;
  }

  _contentWidget() {
    return Container(
        constraints: BoxConstraints(minHeight: 245),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _contentItemWidgets(),
        ));
  }

  _getListContent() {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: payResultData.banners != null ? payResultData.banners.length + 1 : 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _contentWidget();
        } else {
          return _normalWidget(payResultData.banners[index - 1]);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /*获取传递过来的参数*/
    Map<String, dynamic> orderInfo = ModalRoute.of(context).settings.arguments;
    if (orderId == 0 && orderInfo != null) {
      orderId = orderInfo["orderId"];
      initData();
    }

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
      body: payResultData != null
          ? Container(
              color: ThemeColors.colorF2F2F2,
              child: _getListContent(),
            )
          : Container(),
    );
  }
}
