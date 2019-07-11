import 'package:app/res/theme_colors.dart';
import 'package:app/widget/pay_bill/pay_bill_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class PayBillFooter extends StatelessWidget {
  final String payAmount;
  final String returnAmount;
  final String payButtonTitle;
  final String payButtoSubTitle;
  final bool payButtonEnabled;
  final Function payButtonOnTapEvent;
  final Function detailOnTapEvent;

  const PayBillFooter(
      {Key key,
      @required this.payAmount,
      @required this.returnAmount,
      @required this.payButtonTitle,
      @required this.payButtoSubTitle,
      @required this.payButtonEnabled,
      @required this.payButtonOnTapEvent,
      @required this.detailOnTapEvent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        children: <Widget>[
          _payInfoWidget(),
          _detailButtonWidget(),
          PayBillButton(
            title: payButtonTitle,
            enabled: payButtonEnabled,
            subTitle: payButtoSubTitle,
            onTap: payButtonOnTapEvent,
          ),
        ],
      ),
    );
  }

  _detailButtonWidget() {
    return GestureDetector(
      onTap: detailOnTapEvent,
      child: Container(
        margin: EdgeInsets.only(right: 14),
        width: 44,
        child: Row(
          children: <Widget>[
            Text(
              '明细',
              style: TextStyle(
                decoration: TextDecoration.none,
                color: ThemeColors.colorA6A6A6,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            Container(
              width: 14,
              height: 14,
              margin: EdgeInsets.only(left: 5),
              color: ThemeColors.colorA6A6A6,
            )
          ],
        ),
      ),
    );
  }

  _returnAmountWidget() {
    return returnAmount != null &&
            returnAmount != '0' &&
            returnAmount.length > 0
        ? Container(
          margin: EdgeInsets.only(left: 48),
            width: 73,
            height: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(2.0),
              ),
              border: new Border.all(color: ThemeColors.colorA6A6A6, width: 1),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ThemeColors.color404040,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(2.0),
                      bottomLeft: Radius.circular(2.0),
                    ),
                  ),
                  child: Text(
                    '返现',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(2.0),
                        bottomRight: Radius.circular(2.0),
                      ),
                    ),
                    child: Text('￥$returnAmount',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                            color: ThemeColors.color4A4A4A,
                            fontSize: 8,
                            fontWeight: FontWeight.w500)),
                  ),
                )
              ],
            ),
          )
        : Container(width: 0,height: 0,color: Colors.green,);
  }

  _payInfoWidget() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 14, right: 5, top: 6, bottom: 6),
        // padding: EdgeInsets.only(left: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:  MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: "需支付 ",
                    style: TextStyle(
                      color: ThemeColors.color404040,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: '￥',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: ThemeColors.colorD0021B,
                        ),
                      ),
                      TextSpan(
                        text: payAmount,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: ThemeColors.colorD0021B,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            _returnAmountWidget(),
          ],
        ),
      ),
    );
  }
}
