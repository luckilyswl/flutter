import 'package:app/res/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PayAlertDialog extends Dialog {
  final Function onLeftCloseEvent;
  final Function onRightCloseEvent;
  final String name;
  final String amout;

  PayAlertDialog(
      {Key key,
      @required this.onLeftCloseEvent,
      @required this.onRightCloseEvent,
      @required this.name,
      @required this.amout,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: SizedBox(
          width: 295,
          height: 191,
          child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))), //设置圆角
            color: ThemeColors.colorF7F7F7,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 10),
                        height: 40,
                        child: Text(
                          '支付金额',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ThemeColors.color404040,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 5),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "￥",
                            style: TextStyle(
                                color: ThemeColors.colorD0021B,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                            children: [
                              TextSpan(
                                text: amout,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.normal,
                                  color: ThemeColors.colorD0021B,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          '支付方式：$name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ThemeColors.colorA6A6A6,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: ThemeColors.colorDEDEDE,
                ),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                            child: Text(
                              '取消',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ThemeColors.colorA6A6A6,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: this.onLeftCloseEvent),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: ThemeColors.colorDEDEDE,
                      ),
                      Expanded(
                        child: GestureDetector(
                            child: Text(
                              '支付',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ThemeColors.color404040,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: this.onRightCloseEvent),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
