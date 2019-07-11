import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class OrderDetailContentWidget extends StatelessWidget {
  const OrderDetailContentWidget({Key key}) : super(key: key);

  _infoItemWidget(bool isLastOne) {
    return Container(
      margin: EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('消费总金额',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: ThemeColors.colorA6A6A6,
              )),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '￥100',
              style: TextStyle(
                  color: isLastOne
                      ? ThemeColors.colorD0021B
                      : ThemeColors.color404040,
                  fontSize: isLastOne ? 20 : 14,
                  fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: '(已退回)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: isLastOne
                        ? ThemeColors.colorD0021B
                        : ThemeColors.color404040,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(minHeight: 66),
            padding: EdgeInsets.only(left: 14, right: 14, top: 4, bottom: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _infoItemWidget(false),
                _infoItemWidget(false),
              ],
            ),
          ),
          Container(
            height: 1,
            color: ThemeColors.colorDEDEDE,
            margin: EdgeInsets.only(left: 14),
          ),
          Container(
            constraints: BoxConstraints(minHeight: 44),
            padding: EdgeInsets.only(left: 14, right: 14, top: 4, bottom: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _infoItemWidget(false),
                _infoItemWidget(false),
                _infoItemWidget(false),
                _infoItemWidget(false),
                _infoItemWidget(false),
                _infoItemWidget(true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
