import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class PayBillButton extends StatelessWidget {
  final Function onTap;
  final String title;
  final String subTitle;
  final bool enabled;

  const PayBillButton(
      {Key key,
      @required this.onTap,
      @required this.title,
      this.subTitle,
      @required this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _payButtonWidget(enabled),
    );
  }

  List<Widget> _payButtonWidgets(bool enabled) {
    List<Widget> buttonWidgets = <Widget>[
      Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: enabled ? Colors.white : ThemeColors.colorA6A6A6,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ];

    if (subTitle != null && subTitle.length > 0) {
      buttonWidgets.add(
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: enabled ? Colors.white : ThemeColors.colorA6A6A6,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }
    return buttonWidgets;
  }

  _payButtonWidget(bool enabled) {
    return GestureDetector(
      onTap: () {
        if (enabled) {
          onTap();
        }
      },
      child: Container(
        width: 145,
        color: enabled ? ThemeColors.color404040 : ThemeColors.colorDEDEDE,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _payButtonWidgets(enabled),
        ),
      ),
    );
  }
}
