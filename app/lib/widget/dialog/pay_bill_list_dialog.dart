import 'package:app/res/theme_colors.dart';
import 'package:flutter/material.dart';

class PayBillListDialog extends Dialog {
  final Function onCloseEvent;

  PayBillListDialog({Key key, @required this.onCloseEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: SizedBox(
          width: 295,
          height: 488,
          child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))), //设置圆角
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: ThemeColors.colorA6A6A6,
                  ),
                ),
                Divider(
                  height: 1,
                  color: Color(0xFFDEDEDE),
                ),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: GestureDetector(
                      child: Text(
                        '知道了',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ThemeColors.color404040,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: this.onCloseEvent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
