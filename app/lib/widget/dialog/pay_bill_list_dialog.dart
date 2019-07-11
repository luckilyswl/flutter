import 'package:app/res/theme_colors.dart';
import 'package:flutter/material.dart';

class PayBillListDialog extends Dialog {
  final Function onCloseEvent;
  final String imgUrl;

  PayBillListDialog(
      {Key key, @required this.onCloseEvent, @required this.imgUrl})
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
          height: 488,
          child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))), //设置圆角
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image.network(imgUrl, fit: BoxFit.fill),
                ),
                Divider(
                  height: 1,
                  color: Color(0xFFDEDEDE),
                ),
                GestureDetector(
                  onTap: () {
                    onCloseEvent();
                  },
                  child: Container(
                    height: 50,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      '知道了',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ThemeColors.color404040,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
