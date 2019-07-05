import 'package:app/res/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BookApplicationInfoDialog extends Dialog {
  final Function onLeftCloseEvent;
  final Function onRightCloseEvent;

  BookApplicationInfoDialog(
      {Key key,
      @required this.onLeftCloseEvent,
      @required this.onRightCloseEvent})
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
          height: 212,
          child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))), //设置圆角
            color: ThemeColors.colorF7F7F7,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10),
                  height: 48,
                  child: Text(
                    '未进行申请',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ThemeColors.color404040,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      '1. 您未进行申请，暂无法使用企业账户余额进行支付； \n2. 请按照用餐当天日期进行申请，申请通过后，可提前使用企业账户支付定金。',
                      style: TextStyle(
                        color: ThemeColors.color404040,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
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
                              '暂时不需要',
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
                              '马上去申请',
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
