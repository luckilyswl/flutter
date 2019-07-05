import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class PayBillThirdWidget extends StatelessWidget {
  final Function onTap;
  final String title;
  final String subTitle;
  final bool selected;
  const PayBillThirdWidget(
      {Key key, this.title, this.subTitle, this.selected, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 14),
        padding: EdgeInsets.only(left: 7),
        decoration: ShapeDecoration(
          shape: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 32,
              height: 32,
              color: ThemeColors.color404040,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 21),
                width: 70,
                child: Text(
                  title,
                  style: TextStyle(
                    color: ThemeColors.color404040,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  color: ThemeColors.color404040,
                  width: 20,
                  height: 20,
                  margin: EdgeInsets.only(right: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
