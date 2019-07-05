import 'package:app/res/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BookPayInfoDialog extends Dialog {
  final Function onCloseEvent;

  BookPayInfoDialog(
      {Key key,
      @required this.onCloseEvent})
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
                    '订金说明',
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
                    padding: EdgeInsets.only(left: 20,right: 20),
                    child: Text('1. 免费取消，取消后订金即刻原路退回，取消后订金即刻原路退回； \n2. 帮人预订。他人买单后订金即刻原路退回，取消后订金即刻原路退回。',style: TextStyle(
                      color: ThemeColors.color404040,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),),
                  ),
                ),
                Divider(
                  height: 1,
                  color: Color(0xFFDEDEDE),
                ),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: Colors.white,
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
