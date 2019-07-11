import 'package:app/model/pay/pay_info_list_bean.dart';
import 'package:app/res/res_index.dart';
import 'package:app/widget/pay_bill/pay_bill_footer.dart';
import 'package:flutter/material.dart';

class PayBillDetailSheet extends StatelessWidget {
  final String payButtonTitle;
  final String payButtoSubTitle;
  final bool payButtonEnabled;
  final Function payButtonOnTapEvent;
  final Function detailOnTapEvent;
  final Function onCloseTapEvent;

  final PayInfoListOrder order;
  final PayInfoListOptions options;
  final PayInfoListAccountOption accountOption;

  const PayBillDetailSheet(
      {Key key,
      @required this.payButtonTitle,
      @required this.payButtoSubTitle,
      @required this.payButtonEnabled,
      @required this.payButtonOnTapEvent,
      @required this.detailOnTapEvent,
      @required this.onCloseTapEvent,
      @required this.order,
      @required this.options,
      @required this.accountOption})
      : super(key: key);

  _itemWidget(String title, String subTitle) {
    return Container(
      decoration: ShapeDecoration(
        shape: UnderlineInputBorder(
            borderSide: BorderSide(
                color: ThemeColors.colorDEDEDE, style: BorderStyle.solid)),
      ),
      height: 50,
      margin: EdgeInsets.only(
        left: 14,
      ),
      padding: EdgeInsets.only(
        right: 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title,
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: ThemeColors.color404040,
              )),
          Text(subTitle,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  color: ThemeColors.color404040,
                  fontSize: 14,
                  fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  _tipsItemWidget(String tips) {
    return Container(
      height: 18,
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('$tips',
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: ThemeColors.colorA6A6A6,
              )),
        ],
      ),
    );
  }

  _contentWidgetList() {
    List<Widget> contentWidgetList = <Widget>[];
    contentWidgetList.add(
      Container(
        alignment: Alignment.center,
        height: 50,
        decoration: ShapeDecoration(
          shape: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: ThemeColors.colorDEDEDE, style: BorderStyle.solid)),
        ),
        child: Text(
          '结算明细',
          textAlign: TextAlign.center,
          style: TextStyle(
              decoration: TextDecoration.none,
              color: ThemeColors.color404040,
              fontSize: 16,
              fontWeight: FontWeight.normal),
        ),
      ),
    );

    contentWidgetList.add(_itemWidget('消费总金额', '￥${order.endMoney}'));
    if (accountOption != null &&
        accountOption.name != null &&
        accountOption.name.length > 0 &&
        accountOption.amount != '0' &&
        accountOption.amount.length > 0) {
      contentWidgetList.add(
          _itemWidget('${accountOption.name}', '-￥${accountOption.amount}'));
    }
    for (PayInfoListPayInfo payInfo in options.payInfo) {
      contentWidgetList
          .add(_itemWidget('${payInfo.title}', '+￥${payInfo.value}'));
    }
    contentWidgetList.add(
      Divider(
        height: 6,
        color: Colors.transparent,
      ),
    );
    for (PayInfoListTips item in options.tips) {
      contentWidgetList.add(_tipsItemWidget(item.text));
    }
    return contentWidgetList;
  }

  double _widgetHeight() {
    double baseHeight = 150;
    if (accountOption != null &&
        accountOption.name != null &&
        accountOption.name.length > 0 &&
        accountOption.amount != '0' &&
        accountOption.amount.length > 0) {
      baseHeight += 50;
    }
    baseHeight += 50 * options.payInfo.length;
    baseHeight += 6;
    baseHeight += 18 * options.tips.length;
    baseHeight += 36;
    return baseHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(153),
      child: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(onTap: onCloseTapEvent, child: Container(
              color: Colors.transparent,
            )),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                debugPrint('onTap');
              },
              child: SafeArea(
                top: false,
                child: Container(
                  height: _widgetHeight(),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0),
                    ),
                  ),
                  child: Column(children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: ThemeColors.colorDEDEDE,
                                  style: BorderStyle.solid)),
                        ),
                        child: Column(
                          children: _contentWidgetList(),
                        ),
                      ),
                    ),
                    PayBillFooter(
                        payAmount: options.payAmount,
                        returnAmount: options.rebateMoney,
                        payButtonTitle: payButtonTitle,
                        payButtoSubTitle: payButtoSubTitle,
                        payButtonEnabled: payButtonEnabled,
                        detailOnTapEvent: detailOnTapEvent,
                        payButtonOnTapEvent: payButtonOnTapEvent)
                  ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
