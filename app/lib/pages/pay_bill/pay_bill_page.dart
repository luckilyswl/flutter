import 'dart:convert';

import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/book/book_pay_parameters_bean.dart';
import 'package:app/model/enum_define.dart';
import 'package:app/model/pay/pay_info_list_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/navigator/pop_route.dart';
import 'package:app/res/res_index.dart';
import 'package:app/widget/dialog/index.dart';
import 'package:app/widget/dialog/pay_alert_dialog.dart';
import 'package:app/widget/pay_bill/index.dart';
import 'package:app/widget/pay_bill/pay_bill_choose_header.dart';
import 'package:app/widget/pay_bill/pay_bill_detail_sheet.dart';
import 'package:app/widget/pay_bill/pay_bill_extra.dart';
import 'package:app/widget/pay_bill/pay_bill_footer.dart';
import 'package:app/widget/pay_bill/pay_bill_input.dart';
import 'package:app/widget/pay_bill/pay_bill_personal.dart';
import 'package:app/widget/pay_bill/pay_bill_third.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';
import 'package:app/widget/toast.dart' as T;
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:tobias/tobias.dart' as tobias;

/*
 * 买单页面
 **/
class PayBillPage extends StatefulWidget {
  @override
  _PayBillPageState createState() => _PayBillPageState();
}

class _PayBillPageState extends State<PayBillPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _payEditController;
  final FocusNode _payFocusNode = FocusNode();

  bool _isOpen = false; //是否展开支付各种支付方式
  bool _isEnterpriseUser = false; //是否显示企业支付
  //支付信息
  int _payButtonType = PayTargetType.TARGET_NONE; //支付按钮是否可点击
  String _payButtonTitle = ''; //支付按钮是否可点击
  String _payButtoSubTitle = ''; //支付按钮是否可点击
  bool _payButtonEnabled = true; //支付按钮是否可点击
  bool useBalance = false;
  List<PayInfoListOptions> _payList;

  PayInfoListData payInfoData;

  // List<PayInfoListOptions> _payList = [];
  PayInfoListOptions enterpriseOptions; //企业付款
  PayInfoListOptions personalOptions; //个人付款

  PayInfoListOptions currentOptions; //当前付款方式

  String currentPayName = '';
  int orderId = 0;
  String _inputAmount = '';
  bool _inputEnabled;

  @override
  void initState() {
    fluwx.responseFromPayment.listen((data) {
      if (data.errCode == 0) {
        Navigator.of(context).popAndPushNamed(Page.PAY_BILL_RESULT_PAGE,
            arguments: {"orderId": orderId});
      } else {
        T.Toast.toast(context, '支付失败，请重新支付');
      }
    });

    _payEditController = TextEditingController();
    _payEditController.addListener(() {
      setState(() {
        _inputAmount = _payEditController.text;
      });
      initData();
    });
    super.initState();
  }

  initData() {
    dio.get(Api.PAY_LIST, queryParameters: {
      "order_id": orderId.toString(),
      "amount": _inputAmount,
      "use_balance": useBalance ? '1' : '0',
    }).then((data) {
      var sources = jsonDecode(data.toString());
      PayInfoListBean bean = PayInfoListBean.fromJson(sources);
      PayInfoListData dataBean = bean.data;
      if (bean.errorCode == Api.SUCCESS_CODE) {
        payInfoData = dataBean;
        if (payInfoData.businessSetAmount != '0') {
          _inputAmount = payInfoData.businessSetAmount;
          _payEditController.text = _inputAmount;
        }
        _isEnterpriseUser = payInfoData.enterprisePay == 1; //是否显示企业账号
        List<PayInfoListOptions> payList = [];
        for (PayInfoListOptions options in dataBean.options) {
          if (options.payId == PayType.ENTERPRISE_PAY) {
            enterpriseOptions = options;
          } else if (options.payId == PayType.PERSONAL_PAY) {
            personalOptions = options;
          } else {
            payList.add(options);
          }
          if (currentOptions != null && currentOptions.payId == options.payId) {
            currentOptions = options;
          }
        }

        if (!_isEnterpriseUser) {
          //如果显示企业账号，企业账号为空
          enterpriseOptions = null;
        }

        if (_isEnterpriseUser && currentOptions == null) {
          //如果可以使用企业账号且当前方式为空，选择企业账号
          currentOptions = enterpriseOptions;
          currentPayName = '企业账户';
        }

        if (currentOptions == null) {
          //如果当前方式为空，选择个人账号
          currentOptions = personalOptions;
          currentPayName = '个人账户';
        }

        _changePayMethod();
        _payList = payList;

        setState(() {});
      }
    });
  }

  _changePayMethod() {
    if (currentOptions.payId == PayType.PERSONAL_PAY) {
      _isOpen = true;
      useBalance = false;
      if (_inputAmount.length == 0) {
        //未输入状态
        _payButtonEnabled = false;
        _payButtonTitle = '确认支付';
        _payButtoSubTitle = '';
        _payButtonType = PayTargetType.TARGET_PAY;
      } else {
        if (personalOptions.available == 1) {
          //可以支付
          _payButtonEnabled = true;
          _payButtonTitle = '确认支付';
          _payButtoSubTitle = '';
          _payButtonType = PayTargetType.TARGET_PAY;
        } else {
          //余额不足
          _payButtonEnabled = true;
          _payButtonTitle = '去充值';
          _payButtoSubTitle = '( ${payInfoData.rechargeRecommend.title[1]} )';
          _payButtonType = PayTargetType.TARGET_RECHARGE;
        }
      }
    } else if (currentOptions.payId == PayType.ALI_PAY ||
        currentOptions.payId == PayType.WX_PAY) {
      _isOpen = true;
      _payButtonEnabled = true;
      _payButtonTitle = '确认支付';
      _payButtoSubTitle = '';
      _payButtonType = PayTargetType.TARGET_PAY;
    } else {
      useBalance = false;
      if (enterpriseOptions.available == 1) {
        _payButtonEnabled = true;
        _payButtonTitle = '确认支付';
        _payButtoSubTitle = '';
        _payButtonType = PayTargetType.TARGET_PAY;
      } else if (enterpriseOptions.available == 3) {
        _payButtonEnabled = true;
        _payButtonTitle = '马上申请';
        _payButtoSubTitle = '';
        _payButtonType = PayTargetType.TARGET_APPLICATION;
      } else {
        _payButtonEnabled = false;
        _payButtonTitle = enterpriseOptions.subBtn.name;
        _payButtoSubTitle = '';
        _payButtonType = PayTargetType.TARGET_NONE;
      }
    }
    setState(() {});
  }

  _toPay() {
    Map<String, dynamic> queryParameters = {};
    queryParameters["order_id"] = orderId.toString();
    queryParameters["pay_id"] = currentOptions.payId.toString();
    queryParameters["ver"] = '2.0';
    queryParameters["use_balance"] = useBalance ? '1' : '0';
    debugPrint(queryParameters.toString());
    dio.post(Api.PAY_CONFIRM, data: queryParameters).then((data) async {
      var sources = jsonDecode(data.data);
      BookPayParametersBean bean = BookPayParametersBean.fromJson(sources);
      BookPayParametersData dataBean = bean.data;
      if (bean.errorCode == Api.SUCCESS_CODE) {
        if (dataBean.payCode == '5100') {
          Navigator.of(context).popAndPushNamed(Page.PAY_BILL_RESULT_PAGE,
              arguments: {"orderId": orderId});
        } else {
          if (currentOptions.payId == PayType.ALI_PAY) {
            debugPrint(dataBean.payParam.queryString);
            Map payResult;
            try {
              payResult = await tobias.pay(dataBean.payParam.queryString);
              if (payResult["resultStatus"] == '9000') {
                Navigator.of(context).popAndPushNamed(Page.PAY_BILL_RESULT_PAGE,
                    arguments: {"orderId": orderId});
              } else {
                T.Toast.toast(context, '支付失败，请重��支付');
              }
            } on Exception catch (e) {
              payResult = {};
              T.Toast.toast(context, '支付失败，请重新支付');
            }
            if (!mounted) {
              return;
            }
            debugPrint(payResult.toString());
          } else if (currentOptions.payId == PayType.WX_PAY) {
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
    _payEditController.dispose();
    super.dispose();
  }

  _bottomToolWidget() {
    return PayBillFooter(
      payAmount: currentOptions.payAmount,
      returnAmount: currentOptions.rebateMoney,
      payButtonTitle: _payButtonTitle,
      payButtoSubTitle: _payButtoSubTitle,
      payButtonEnabled: _payButtonEnabled,
      detailOnTapEvent: () {
        _showDetailSheet();
      },
      payButtonOnTapEvent: _payButtonOnTap,
    );
  }

  _showDetailSheet() {
    Navigator.of(context).push(
      PopRoute(
        child: PayBillDetailSheet(
          options: currentOptions,
          order: payInfoData.order,
          accountOption: useBalance ? payInfoData.accountOption : null,
          payButtonTitle: _payButtonTitle,
          payButtoSubTitle: _payButtoSubTitle,
          payButtonEnabled: _payButtonEnabled,
          detailOnTapEvent: () {
            Navigator.of(context).pop();
          },
          payButtonOnTapEvent: () {
            Navigator.of(context).pop();
            _payButtonOnTap();
          },
          onCloseTapEvent: () {
            Navigator.of(context).pop();
          },
        ),
        dimissable: true,
      ),
    );
  }

  _payButtonOnTap() {
    _payFocusNode.unfocus();
    if (_payButtonType == PayTargetType.TARGET_PAY) {
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
              name: currentPayName,
              amout: payInfoData.order.endMoney,
            );
          });
    } else if (_payButtonType == PayTargetType.TARGET_APPLICATION) {
      T.Toast.toast(context, '敬请期待企业功能');
    } else if (_payButtonType == PayTargetType.TARGET_RECHARGE) {
      Navigator.of(context)
          .pushNamed(Page.RECHARGE_PAGE, arguments: {'orderId': orderId});
    }
  }

  _dividerWidget() {
    return Container(
      height: 10,
    );
  }

  List<Widget> _getListWidgets() {
    List<Widget> listWidgets = <Widget>[
      PayBillInputWidget(
          controller: _payEditController,
          node: _payFocusNode,
          enabled: _inputEnabled),
      PayBillChooseHeader()
    ];

    if (_isEnterpriseUser) {
      if (enterpriseOptions.available != 3) {
        //通过申请，置顶企业支付，默认选中
        listWidgets.add(PayBillEnterpriseWidget(
          title: enterpriseOptions.name,
          icon: enterpriseOptions.icon,
          subTitle: enterpriseOptions.subBtn.name,
          enableSelected: true,
          selected: currentOptions.payId == PayType.ENTERPRISE_PAY,
          onTap: () {
            debugPrint('点击了企业账户');
            setState(() {
              currentOptions = enterpriseOptions;
              currentPayName = '企业账户';
            });
            _payFocusNode.unfocus();
            _changePayMethod();
          },
        ));
        if (_isOpen) {
          listWidgets.add(_dividerWidget());
          listWidgets.addAll(_personalPayWidgetList());
        } else {
          listWidgets.add(_enterpriseOpenWidget());
        }
      } else {
        listWidgets.addAll(_personalPayWidgetList());
        listWidgets.add(_dividerWidget());
        //未通过申请
        listWidgets.add(PayBillEnterpriseWidget(
          title: enterpriseOptions.name,
          icon: enterpriseOptions.icon,
          subTitle: enterpriseOptions.subBtn.name,
          enableSelected: true,
          selected: currentOptions.payId == PayType.ENTERPRISE_PAY,
          onTap: () {
            debugPrint('点击了企业账户');
            setState(() {
              currentOptions = enterpriseOptions;
              currentPayName = '企业账户';
            });
            _payFocusNode.unfocus();
            _changePayMethod();
          },
        ));
      }
    } else {
      listWidgets.addAll(_personalPayWidgetList());
    }
    if ((currentOptions.payId == PayType.WX_PAY ||
            currentOptions.payId == PayType.ALI_PAY) &&
        payInfoData.accountOption != null &&
        payInfoData.accountOption.name != null) {
      listWidgets.addAll(<Widget>[
        _dividerWidget(),
        PayBillExtraWidget(
          subTitle: '-￥${payInfoData.accountOption.amount}',
          isOpen: useBalance,
          onChanged: (bool value) {
            setState(() {
              useBalance = value;
            });
            initData();
          },
        )
      ]);
    }
    return listWidgets;
  }

  List<Widget> _personalPayWidgetList() {
    List<Widget> payWidgetList = <Widget>[];
    payWidgetList.add(PayBillPersonalWidget(
      options: personalOptions,
      rechargeRecommend: payInfoData.rechargeRecommend,
      selected: currentOptions.payId == personalOptions.payId,
      onTap: () {
        setState(() {
          currentOptions = personalOptions;
          currentPayName = '个人账户';
        });
        _payFocusNode.unfocus();
        _changePayMethod();
      },
      onRechargeEvent: () {
        Navigator.of(context)
            .pushNamed(Page.RECHARGE_PAGE, arguments: {'orderId': orderId});
      },
      onListEvent: () {
        showDialog<Null>(
            context: context, //BuildContext对象
            barrierDismissible: false,
            builder: (BuildContext context) {
              return PayBillListDialog(
                onCloseEvent: () {
                  Navigator.pop(context);
                },
                imgUrl: payInfoData.rechargeRecommend.imgUrl,
              );
            });
      },
    ));

    for (PayInfoListOptions option in _payList) {
      payWidgetList.add(PayBillThirdWidget(
          title: option.name,
          icon: option.icon,
          selected: currentOptions.payId == option.payId,
          subTitle: option.desc != null &&
                  option.desc.text != null &&
                  option.desc.text.length > 0
              ? option.desc.text
              : '',
          onTap: () {
            debugPrint('点击了第三方支付');
            setState(() {
              currentOptions = option;
              currentPayName = option.name;
            });
            _payFocusNode.unfocus();
            _changePayMethod();
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

  _enterpriseOpenWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isOpen = true;
        });
      },
      child: Container(
        height: 34,
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('更多支付方式'),
            Container(
              width: 14,
              height: 14,
              color: ThemeColors.color404040,
              margin: EdgeInsets.only(left: 2),
            )
          ],
        ),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: Border(
            top: BorderSide(color: Color(0xFFDEDEDE), style: BorderStyle.solid),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*获取传递过来的参数*/
    Map<String, dynamic> orderInfo = ModalRoute.of(context).settings.arguments;
    if (payInfoData == null && orderInfo != null) {
      orderId = orderInfo["orderId"];
      initData();
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        child: Container(
          child: AppBar(
            title:
                Text(payInfoData != null ? payInfoData.order.shopName : '买单'),
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
                    Container(
                      color: Colors.white,
                      child: SafeArea(
                        top: false,
                        child: _bottomToolWidget(),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }
}
