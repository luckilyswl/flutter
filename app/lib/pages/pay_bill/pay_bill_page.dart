import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:app/widget/dialog/index.dart';
import 'package:app/widget/dialog/pay_alert_dialog.dart';
import 'package:app/widget/pay_bill/index.dart';
import 'package:app/widget/pay_bill/pay_bill_choose_header.dart';
import 'package:app/widget/pay_bill/pay_bill_extra.dart';
import 'package:app/widget/pay_bill/pay_bill_input.dart';
import 'package:app/widget/pay_bill/pay_bill_personal.dart';
import 'package:app/widget/pay_bill/pay_bill_third.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';

/*
 * 买单页面
 **/
class PayBillPage extends StatefulWidget {
  @override
  _PayBillPageState createState() => _PayBillPageState();
}

class _PayBillPageState extends State<PayBillPage>
    with SingleTickerProviderStateMixin {
  bool _isOpen = true;
  bool _isEnterpriseUser = true;
  bool _extra = true;
  //支付信息
  bool _showReturn = false; //显示返现
  bool _payButtonEnabled = true; //支付按钮是否可点击
  bool _showPayInfoTitle = false; //显示支付小标题

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
    Navigator.of(context).pushNamed(Page.PAY_BILL_RESULT_PAGE);
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
            enabled: _payButtonEnabled,
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
              _payResult();
            },
          );
        });
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
            RichText(
              text: TextSpan(
                text: "￥",
                style: TextStyle(
                    color: ThemeColors.colorD0021B,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
                children: [
                  TextSpan(
                    text: "6525",
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
        ),
      ),
    );
  }

  _dividerWidget() {
    return Container(
      height: 10,
    );
  }

  List<Widget> _getListWidgets() {
    List<Widget> listWidgets = <Widget>[
      PayBillInputWidget(),
      PayBillChooseHeader()
    ];
    if (_isEnterpriseUser) {
      listWidgets.add(PayBillEnterpriseWidget(
        subTitle: '-￥6525',
        selected: false,
        onTap: () {
          debugPrint('点击了企业账户');
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
    }
    if (_extra) {
      listWidgets.addAll(<Widget>[
        _dividerWidget(),
        PayBillExtraWidget(
          subTitle: '-￥1346.5',
        )
      ]);
    }
    return listWidgets;
  }

  List<Widget> _personalPayWidgetList() {
    return <Widget>[
      PayBillPersonalWidget(
        subTitle: '余额￥7346.5',
        recommendList: <String>['每充200送20，多充多送'],
        tipsList: <String>['充值金额随时可退；', '余额全平台1000+餐厅通用'],
        selected: false,
        onTap: () {
          debugPrint('点击了个人账户');
        },
        onRechargeEvent: () {
          debugPrint('去充值');
        },
        onListEvent: () {
          debugPrint('查看使用餐厅');
          showDialog<Null>(
              context: context, //BuildContext对象
              barrierDismissible: false,
              builder: (BuildContext context) {
                return PayBillListDialog(
                  onCloseEvent: () {
                    Navigator.pop(context);
                  },
                );
              });
        },
      ),
      PayBillThirdWidget(
        title: '微信支付',
        selected: false,
        onTap: () {
          debugPrint('点击了微信支付');
        },
      ),
      PayBillThirdWidget(
        title: '支付宝',
        selected: false,
        onTap: () {
          debugPrint('点击了支付宝');
        },
      ),
    ];
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
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          child: AppBar(
            title: Text('花园酒店名仕阁'),
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
                _bottomToolWidget(),
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
