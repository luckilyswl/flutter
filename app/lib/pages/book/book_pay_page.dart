import 'dart:convert';

import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/book/book_pay_info_bean.dart';
import 'package:app/model/book/book_pay_parameters_bean.dart';
import 'package:app/model/enum_define.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:app/widget/dialog/book_application_dialog.dart';
import 'package:app/widget/dialog/pay_alert_dialog.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';
import 'package:app/widget/toast.dart' as T;
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:tobias/tobias.dart' as tobias;

/*
 * 预定成功页面
 **/
class BookPayPage extends StatefulWidget {
  @override
  _BookPayPageState createState() => _BookPayPageState();
}

class _BookPayPageState extends State<BookPayPage>
    with SingleTickerProviderStateMixin {
  bool _useEnterprise = false;
  List<BookPayInfoOptions> _payList = [];
  BookPayInfoOptions enterpriseOptions;
  BookPayInfoData payData;
  int currentPayId = -1;
  String currentPayName = '';
  int orderId = 0;

  @override
  void initState() {
    fluwx.responseFromPayment.listen((data) {
      if (data.errCode == 0) {
        Navigator.of(context).popAndPushNamed(Page.BOOK_RESULT_PAGE,
            arguments: {"orderId": orderId});
      } else {
        T.Toast.toast(context, '支付失败，请重新支付');
      }
    });
    super.initState();
  }

  initData() {
    dio.get(Api.BOOK_PAY_LIST, queryParameters: {
      "order_id": orderId.toString(),
    }).then((data) {
      var sources = jsonDecode(data.toString());
      BookPayInfoBean bean = BookPayInfoBean.fromJson(sources);
      BookPayInfoData dataBean = bean.data;
      if (bean.errorCode == Api.SUCCESS_CODE) {
        setState(() {
          payData = dataBean;
          List<BookPayInfoOptions> payList = [];
          for (BookPayInfoOptions options in dataBean.options) {
            if (options.payId == PayType.ENTERPRISE_PAY) {
              enterpriseOptions = options;
            } else {
              payList.add(options);
            }
          }
          _payList = payList;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _showPayAlertDialog() {
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
              _toPay();
            },
            amout: payData.orderAmout.toString(),
            name: currentPayName,
          );
        });
  }

  _toPay() {
    Map<String, dynamic> queryParameters = {};
    queryParameters["order_id"] = payData.orderId.toString();
    queryParameters["pay_id"] = currentPayId.toString();
    if (currentPayId == PayType.PERSONAL_PAY) {
      queryParameters["use_balance"] = '1';
    }
    dio.post(Api.BOOK_PAY, data: queryParameters).then((data) async {
      var sources = jsonDecode(data.data);
      BookPayParametersBean bean = BookPayParametersBean.fromJson(sources);
      BookPayParametersData dataBean = bean.data;
      if (bean.errorCode == Api.SUCCESS_CODE) {
        if (dataBean.payCode == '5100') {
          Navigator.of(context).popAndPushNamed(Page.BOOK_RESULT_PAGE,
              arguments: {"orderId": orderId});
        } else {
          if (currentPayId == PayType.ALI_PAY) {
            debugPrint(dataBean.payParam.queryString);
            Map payResult;
            try {
              payResult = await tobias.pay(dataBean.payParam.queryString);
              if (payResult["resultStatus"] == '9000') {
                Navigator.of(context).popAndPushNamed(Page.BOOK_RESULT_PAGE,
                    arguments: {"orderId": orderId});
              } else {
                T.Toast.toast(context, '支付失败，请重新支付');
              }
            } on Exception catch (e) {
              payResult = {};
              T.Toast.toast(context, '支付失败，请重新支付');
            }
            if (!mounted) {
              return;
            }
            debugPrint(payResult.toString());
          } else if (currentPayId == PayType.WX_PAY) {
            fluwx.pay(
              appId: 'wxa9fef87b18258e5e',
              partnerId: dataBean.payParam.partnerId,
              prepayId: dataBean.payParam.prepayId,
              packageValue: dataBean.payParam.package,
              nonceStr: dataBean.payParam.nonceStr,
              timeStamp: int.parse(dataBean.payParam.timeStamp),
              sign: dataBean.payParam.paySign,
            );
          }
        }
      } else {
        T.Toast.toast(context, sources['msg']);
      }
    });
  }

  _normalWidget(BookPayInfoOptions payInfoOptions) {
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
            Image.network(payInfoOptions.icon,
                width: 32, height: 32, fit: BoxFit.fill),
            Container(
              margin: EdgeInsets.only(left: 20),
              width: 70,
              child: Text(
                payInfoOptions.name,
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
                  payInfoOptions.payId == PayType.PERSONAL_PAY
                      ? '余额￥${payData.userAccount.availableBalance.toString()}'
                      : '',
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
              child: GestureDetector(
                onTap: () {
                  if (payInfoOptions.available == 1) {
                    setState(() {
                      currentPayId = payInfoOptions.payId;
                      currentPayName = payInfoOptions.name;
                    });
                  }
                },
                child: payInfoOptions.payId == currentPayId
                    ? Container(
                        color: Colors.green,
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.only(right: 14),
                      )
                    : Container(
                        color: ThemeColors.colorA6A6A6,
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.only(right: 14),
                      ),
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
              text: _useEnterprise
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
                          text: "￥${payData.orderAmout.toString()}",
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
                          text: "${payData.orderAmout.toString()}",
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
    if (payData.enterprisePay == 1 || payData.enterprisePay == 3) {
      if (_useEnterprise) {
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
              child: Container(
                width: 51,
                height: 28,
                child: CupertinoSwitch(
                  activeColor: ThemeColors.colorF2C785,
                  value: _useEnterprise,
                  onChanged: (bool value) {
                    setState(() {
                      if (payData.enterprisePay == 3) {
                        _showApplicationDialog();
                      } else if (payData.enterprisePay == 1) {
                        setState(() {
                          _useEnterprise = !_useEnterprise;
                          if (_useEnterprise) {
                            currentPayId = enterpriseOptions.payId;
                            currentPayName = enterpriseOptions.name;
                          }
                        });
                      }
                    });
                  },
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
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: payData != null ? _getListContent() : Container(),
                ),
                Align(
                  child: Container(
                    color: ThemeColors.color404040,
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: FlatButton(
                      padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: Text("确认支付",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                      onPressed: () {
                        _showPayAlertDialog();
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
