import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class PayBillEnterpriseWidget extends StatelessWidget {
  final String subTitle;
  final Function onTap;
  final bool selected;
  const PayBillEnterpriseWidget({Key key, this.subTitle, @required this.onTap, @required this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 73,
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 45,
              height: 45,
              color: ThemeColors.color404040,
            ),
            Container(
              margin: EdgeInsets.only(left: 14),
              child: Text(
                '企业账户',
                style: TextStyle(
                  color: ThemeColors.color404040,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: (subTitle != null && subTitle.length > 0)
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        subTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: ThemeColors.colorA6A6A6,
                        ),
                      ))
                  : SizedBox(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  onTap();
                },
                child: Container(
                  color: ThemeColors.color404040,
                  width: 20,
                  height: 20,
                  margin: EdgeInsets.only(left: 14, right: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
