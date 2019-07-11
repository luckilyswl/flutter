import 'dart:convert';

import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/book/book_pay_parameters_bean.dart';
import 'package:app/model/enum_define.dart';
import 'package:app/model/pay/pay_info_list_bean.dart';
import 'package:app/model/recharge/recharge_pay_list_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:app/widget/dialog/pay_alert_dialog.dart';
import 'package:app/widget/pay_bill/index.dart';
import 'package:app/widget/pay_bill/pay_bill_choose_header.dart';
import 'package:app/widget/pay_bill/pay_bill_third.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';
import 'package:app/widget/toast.dart' as T;
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:tobias/tobias.dart' as tobias;

/*
 * 充值支付列表页面
 **/
class RechargePayPage extends StatefulWidget {
  @override
  _RechargePayState createState() => _RechargePayState();
}

class _RechargePayState extends State<RechargePayPage>
    with SingleTickerProviderStateMixin {
  RechargePayListData payInfoData;

  int currentPayId = -1;
  String currentPayName = '';
  int orderId = 0;
  int optionId = 0;
  bool fromPay = false;

  @override
  void initState() {
    fluwx.responseFromPayment.listen((data) {
      if (data.errCode == 0) {
        Navigator.of(context).popAndPushNamed(Page.RECHARGE_PAY_RESULT_PAGE,
            arguments: {"orderId": orderId});
      } else {
        T.Toast.toast(context, '支付失败，请重新支付');
      }
    });

    payInfoData = RechargePayListData(
        order: RechargePayListOrder(orderId: orderId, orderAmount: '2000'),
        options: <PayInfoListOptions>[
          PayInfoListOptions(payId: PayType.WX_PAY, name: '微信支付'),
          PayInfoListOptions(payId: PayType.ALI_PAY, name: '支付宝')
        ]);
    if (payInfoData.options != null && payInfoData.options.length > 0) {
      currentPayId = payInfoData.options[0].payId;
      currentPayName = payInfoData.options[0].name;
    }
    super.initState();
  }

  initData() {
    dio.get(Api.RECHARGE_INFO, queryParameters: {
      "order_id": orderId.toString(),
    }).then((data) {
      var sources = jsonDecode(data.toString());
      RechargePayListBean bean = RechargePayListBean.fromJson(sources);
      RechargePayListData dataBean = bean.data;
      if (bean.errorCode == Api.SUCCESS_CODE) {
        payInfoData = dataBean;
        setState(() {});
      }
    });
  }

  _toPay() {
    Map<String, dynamic> queryParameters = {};
    queryParameters["order_id"] = orderId.toString();
    debugPrint(queryParameters.toString());
    dio
        .post(Api.RECHARGE_PAY_CONFIRM, data: queryParameters)
        .then((data) async {
      var sources = jsonDecode(data.data);
      BookPayParametersBean bean = BookPayParametersBean.fromJson(sources);
      BookPayParametersData dataBean = bean.data;
      if (bean.errorCode == Api.SUCCESS_CODE) {
        if (dataBean.payCode == '5100') {
          Navigator.of(context).popAndPushNamed(Page.RECHARGE_PAY_RESULT_PAGE,
              arguments: {"orderId": orderId});
        } else {
          if (currentPayId == PayType.ALI_PAY) {
            debugPrint(dataBean.payParam.queryString);
            Map payResult;
            try {
              payResult = await tobias.pay(dataBean.payParam.queryString);
              if (payResult["resultStatus"] == '9000') {
                Navigator.of(context).popAndPushNamed(
                    Page.RECHARGE_PAY_RESULT_PAGE,
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

  @override
  void dispose() {
    super.dispose();
  }

  _topAmountWidget() {
    return Container(
      color: Colors.white,
      height: 88,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 14, right: 14, top: 14),
            alignment: Alignment.centerLeft,
            child: Text(
              '充值金额',
              style: TextStyle(
                color: ThemeColors.color404040,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 14, right: 14),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "￥ ",
                  style: TextStyle(
                    color: ThemeColors.color404040,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                  children: [
                    TextSpan(
                      text: payInfoData.order.orderAmount,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        color: ThemeColors.color404040,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _bottomToolWidget() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        children: <Widget>[
          _payInfoWidget(),
          PayBillButton(
            title: '确认支付',
            enabled: true,
            onTap: _payButtonOnTap,
          ),
        ],
      ),
    );
  }

  _payButtonOnTap() {
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
              _mockPay();
              // _toPay();
            },
            name: currentPayName,
            amout: payInfoData.order.orderAmount,
          );
        });
  }

  _mockPay() {
    Navigator.of(context).popAndPushNamed(Page.RECHARGE_PAY_RESULT_PAGE, arguments: {'fromPay': fromPay, 'orderId': orderId});
  }

  _payInfoWidget() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 14, right: 14),
        child: Row(
          children: <Widget>[
            Text("需支付",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: ThemeColors.color404040,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: "￥",
                    style: TextStyle(
                        color: ThemeColors.colorD0021B,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                    children: [
                      TextSpan(
                        text: payInfoData.order.orderAmount,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: ThemeColors.colorD0021B,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _getListWidgets() {
    List<Widget> listWidgets = <Widget>[
      _topAmountWidget(),
      PayBillChooseHeader()
    ];

    listWidgets.addAll(_personalPayWidgetList());
    return listWidgets;
  }

  List<Widget> _personalPayWidgetList() {
    List<Widget> payWidgetList = <Widget>[];
    for (PayInfoListOptions option in payInfoData.options) {
      payWidgetList.add(PayBillThirdWidget(
          title: option.name,
          icon: option.icon,
          selected: currentPayId == option.payId,
          subTitle: option.desc != null &&
                  option.desc.text != null &&
                  option.desc.text.length > 0
              ? option.desc.text
              : '',
          lastOne: payInfoData.options.indexOf(option) ==
              payInfoData.options.length - 1,
          onTap: () {
            debugPrint('点击了第三方支付');
            setState(() {
              currentPayId = option.payId;
              currentPayName = option.name;
            });
          }));
    }
    return payWidgetList;
  }

  _getListContent() {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: _getListWidgets().length,
      itemBuilder: (BuildContext context, int index) {
        return _getListWidgets()[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /*获取传递过来的参数*/
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;
    debugPrint(arguments.toString());
    if (arguments != null) {
      debugPrint(arguments.toString());
      fromPay = arguments['fromPay'];
      optionId = arguments["optionId"];
      // initData();
    }
    

    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          child: AppBar(
            title: Text('充值支付'),
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
        child: payInfoData != null
            ? Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: _getListContent(),
                    ),
                    _bottomToolWidget(),
                    Container(
                      color: ThemeColors.colorF2F2F2,
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
              )
            : Container(),
      ),
    );
  }
}
