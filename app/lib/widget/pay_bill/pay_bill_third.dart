import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class PayBillThirdWidget extends StatelessWidget {
  final Function onTap;
  final String title;
  final String icon;
  final String subTitle;
  final bool selected;
  final bool lastOne;
  const PayBillThirdWidget(
      {Key key,
      this.title,
      this.icon,
      this.subTitle,
      this.selected,
      this.lastOne = false,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 14),
          padding: EdgeInsets.only(left: 7),
          decoration: ShapeDecoration(
            shape: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: lastOne ? Colors.transparent : Color(0xFFDEDEDE), style: BorderStyle.solid)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 32,
                height: 32,
                child: icon != null && icon.length > 0
                    ? Image.network(icon, fit: BoxFit.fill)
                    : Image.asset(
                        'assets/images/ic_pay_default.png',
                        width: 28,
                        height: 28,
                      ),
              ),
              Container(
                margin: EdgeInsets.only(left: 21),
                child: Text(
                  title,
                  style: TextStyle(
                    color: ThemeColors.color404040,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Container(
                child: subTitle != null && subTitle.length > 0
                    ? Container(
                        margin: EdgeInsets.only(left: 6),
                        alignment: Alignment.center,
                        height: 16,
                        decoration: new BoxDecoration(
                          border: new Border.all(
                              color: ThemeColors.colorA6A6A6,
                              width: 1.0), // 边色与边宽度
                          borderRadius: new BorderRadius.circular((2.0)), // 圆角度
                        ),
                        child: Text(
                          subTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ThemeColors.color404040,
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )
                    : Container(),
              ),
              Expanded(
                child: Container(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  color: selected ? Colors.green : ThemeColors.colorA6A6A6,
                  width: 20,
                  height: 20,
                  margin: EdgeInsets.only(right: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
