import 'dart:convert';

import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/book/book_result_info_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';

/*
 * 预定成功页面
 **/
class BookResultPage extends StatefulWidget {
  @override
  _BookResultPageState createState() => _BookResultPageState();
}

class _BookResultPageState extends State<BookResultPage>
    with SingleTickerProviderStateMixin {
  BookResultData resultData;
  int orderId = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _seeOrder() {
    Navigator.of(context).pushNamed(Page.PAY_BILL_PAGE, arguments: {"orderId": orderId});
    debugPrint('查看订单');
  }

  _inviteFriend() {
    debugPrint('邀请好友');
  }

  _service() {
    debugPrint('联系客服');
  }

  _normalWidget(BookResultBanners banner) {
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

  _headerWidget() {
    return Container(
      height: 34,
      child: Row(
        children: <Widget>[
          Container(
            color: ThemeColors.color404040,
            width: 14,
            height: 14,
            margin: EdgeInsets.only(left: 14),
          ),
          Container(
            margin: EdgeInsets.only(left: 14),
            alignment: Alignment.centerLeft,
            child: Text(resultData.tips,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: ThemeColors.color404040,
                )),
          ),
        ],
      ),
    );
  }

  _contentWidget() {
    return Container(
      height: 258,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            color: ThemeColors.color404040,
            width: 60,
            height: 60,
            margin: EdgeInsets.only(top: 20),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            alignment: Alignment.center,
            child: Text(resultData.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: ThemeColors.color404040,
                )),
          ),
          Container(
            margin: EdgeInsets.only(top: 15, left: 27, right: 27),
            alignment: Alignment.center,
            child: Text(resultData.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: ThemeColors.colorA6A6A6,
                )),
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
                      child: Text("查看订单",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ThemeColors.color404040,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          )),
                      onPressed: () {
                        _seeOrder();
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
                      child: Text(
                          resultData.confirmStatus == 1 ? "联系客服" : "邀请好友就餐",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                      onPressed: () {
                        if (resultData.confirmStatus == 1) {
                          _service();
                        } else {
                          _inviteFriend();
                        }
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
      itemCount: resultData.banners != null ? resultData.banners.length + 2 : 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _headerWidget();
        } else if (index == 1) {
          return _contentWidget();
        } else {
          return _normalWidget(resultData.banners[index - 2]);
        }
      },
    );
  }

  initData() {
    //预定信息
    dio.get(Api.BOOK_PAY_RESULT, queryParameters: {
      "order_id": orderId.toString(),
    }).then((data) {
      var sources = jsonDecode(data.toString());
      BookResultInfoBean bean = BookResultInfoBean.fromJson(sources);
      if (bean.errorCode == Api.SUCCESS_CODE) {
        BookResultData dataBean = bean.data;
        setState(() {
          resultData = dataBean;
        });
      }
    });
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
        child: resultData != null ? _getListContent() : Container(),
      ),
    );
  }
}
