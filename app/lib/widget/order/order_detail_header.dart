import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class OrderDetailHeader extends StatelessWidget {
  final Function onContactEvent;
  final Function onNaviEvent;
  final Function onTapBusinessEvent;
  final bool isCanceled;

  const OrderDetailHeader(
      {Key key,
      @required this.onContactEvent,
      @required this.onNaviEvent,
      @required this.onTapBusinessEvent,
      @required this.isCanceled})
      : super(key: key);

  _statusWidget() {
    return Container(
      height: 40,
      padding: EdgeInsets.only(left: 14, right: 14, top: 6),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            width: 28,
            height: 28,
            color: Colors.white,
          ),
          Expanded(
            child: Text('待预订',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          )
        ],
      ),
    );
  }

  _bookInfoItemWidget(String title, String subTitle) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 28,
            height: 16,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              border: new Border.all(
                  color: ThemeColors.colorA6A6A6, width: 1.0), // 边色与边宽度
              borderRadius: new BorderRadius.circular((2.0)), // 圆角度
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ThemeColors.colorA6A6A6,
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                subTitle,
                style: TextStyle(
                  color: ThemeColors.color404040,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _darkButton(String title, VoidCallback onPressed, bool needMargin) {
    return Container(
      width: 68,
      height: 24,
      margin: needMargin ? EdgeInsets.only(right: 10) : EdgeInsets.all(0),
      child: FlatButton(
        padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            )),
        onPressed: onPressed,
        textColor: Colors.white,
        color: ThemeColors.colorA6A6A6,
        highlightColor: ThemeColors.colorA6A6A6,
        colorBrightness: Brightness.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        clipBehavior: Clip.antiAlias,
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }

  _bookInfoCardWidget() {
    return Container(
      height: 194,
      margin: EdgeInsets.only(left: 14, top: 8, right: 14),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.circular((8.0)), // 圆角度
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 36,
            padding: EdgeInsets.only(left: 14, right: 14),
            decoration: ShapeDecoration(
              shape: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ThemeColors.colorDEDEDE,
                      style: BorderStyle.solid)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '花园酒店名仕阁',
                  style: TextStyle(
                    color: ThemeColors.color404040,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    onTapBusinessEvent();
                  },
                  child: Container(
                    color: ThemeColors.colorA6A6A6,
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _bookInfoItemWidget('时间', '2019.6.27 周四 18:00'),
                  _bookInfoItemWidget('人数', '4位'),
                  _bookInfoItemWidget('包房', '悠然明阁（6-8人房）'),
                  _bookInfoItemWidget('预订', '李先生 13625726879'),
                ],
              ),
            ),
          ),
          Container(
            height: 44,
            padding: EdgeInsets.only(left: 14, right: 14),
            decoration: ShapeDecoration(
              shape: Border(
                top: BorderSide(
                    color: ThemeColors.colorDEDEDE, style: BorderStyle.solid),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _darkButton('联系商家', () {
                  onContactEvent();
                }, true),
                _darkButton('一键导航', () {
                  onNaviEvent();
                }, false),
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
        height: 256,
        decoration: isCanceled ? BoxDecoration(
          color: ThemeColors.colorA6A6A6,
        ) : BoxDecoration(
          gradient: Gradients.loginBgLinearGradient,
        ),
        child: Column(
          children: <Widget>[
            _statusWidget(),
            _bookInfoCardWidget(),
          ],
        ));
  }
}
