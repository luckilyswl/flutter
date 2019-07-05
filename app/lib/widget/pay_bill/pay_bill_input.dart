import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class PayBillInputWidget extends StatelessWidget {
  const PayBillInputWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 89,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 42,
            margin: EdgeInsets.only(left: 14, right: 14),
            alignment: Alignment.centerLeft,
            child: Text(
              '消费总金额',
              style: TextStyle(
                color: ThemeColors.color404040,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 14, right: 14),
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Text(
                    '￥',
                    style: TextStyle(
                      color: ThemeColors.color404040,
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        controller: null,
                        focusNode: null,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: ThemeColors.color404040,
                        ),
                        decoration: InputDecoration(
                          hintText: '请咨询服务员后输入',
                          hintStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: ThemeColors.colorA6A6A6,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
