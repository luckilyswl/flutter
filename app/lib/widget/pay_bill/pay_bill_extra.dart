import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class PayBillExtraWidget extends StatelessWidget {
  final String subTitle;
  const PayBillExtraWidget({Key key, this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 44,
      padding: EdgeInsets.only(left: 14, right: 14),
      child: Row(
        children: <Widget>[
          Text(
            '个人余额抵扣',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ThemeColors.color404040,
            ),
          ),
          Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: ThemeColors.colorA6A6A6,
                  ),
                )),
          ),
          Container(
            margin: EdgeInsets.only(left: 14),
            color: ThemeColors.color404040,
            width: 51,
            height: 28,
          ),
        ],
      ),
    );
  }
}
