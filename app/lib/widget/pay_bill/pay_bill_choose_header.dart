import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class PayBillChooseHeader extends StatelessWidget {
  const PayBillChooseHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      margin: EdgeInsets.only(left: 14, right: 14),
      alignment: Alignment.centerLeft,
      child: Text('选择买单方式',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: ThemeColors.color404040,
          )),
    );
  }
}