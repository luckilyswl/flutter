import 'package:flutter/material.dart';
import 'package:app/res/res_index.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/model/custom_scroll_bean.dart';

/*
 * 立即预定弹窗 Widget
 **/
class BookNowPopupWindow extends StatefulWidget {
  //包房数据
  List<BookNowModel> modelList;

  //日期数据
  List<CustomScrollBean> dateData = List();

  //时间数据
  List<CustomScrollBean> timeData = List();

  //位数数据
  List<CustomScrollBean> bitData = List();

  //是否为预订弹窗
  bool isBook = true;

  //是否显示时间选择器
  bool isShowTimeSelector = false;

  //时间和人数
  String timeAndNum;

  BookNowPopupWindow(
      {@required this.modelList,
      @required this.dateData,
      @required this.timeData,
      @required this.bitData,
      this.timeAndNum = '请点击选择',
      this.isBook});

  @override
  State<StatefulWidget> createState() {
    return BookNowPopupWindowState(timeAndNum: timeAndNum);
  }
}

class BookNowPopupWindowState extends State<BookNowPopupWindow> {
  String timeAndNum;

  BookNowPopupWindowState({this.timeAndNum});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Opacity(
            opacity: widget.isShowTimeSelector ? 0 : 1,
            child: Container(
              color: ThemeColors.color96000000,
              width: ScreenUtil.getScreenW(context),
              height: ScreenUtil.getScreenH(context) - 44,
            ),
          ),
        ),

        ///底部安全区域
        Positioned(
          bottom: 0,
          child: Container(
            color: Colors.white,
            width: ScreenUtil.getScreenW(context),
            height: MediaQuery.of(context).padding.bottom,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: 444,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: ScreenUtil.getScreenW(context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          right: 14,
                          top: 14,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 32,
                              height: 32,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Center(
                                child: Image.asset(
                                  'assets/images/ic_menu.png',
                                  width: 15,
                                  height: 15,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(height: 40),
                            BookNowContent(
                              timeInterval: '(11:00-23:00)',
                              modelList: widget.modelList,
                              dateData: widget.dateData,
                              timeData: widget.timeData,
                              bitData: widget.bitData,
                              callback: (isShowTimeSelector) {
                                setState(() {
                                  widget.isShowTimeSelector =
                                      isShowTimeSelector;
                                });
                              },
                              timeSelectorCallback: (results) {},
                              roomIndexCallback: (index) {},
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                widget.isBook
                    ? Container(
                        height: 44,
                        width: ScreenUtil.getScreenW(context),
                        child: Row(
                          children: <Widget>[
                            new Container(
                              width: 50,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    top: BorderSide(
                                        color: ThemeColors.colorDEDEDE,
                                        width: 1)),
                              ),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                    width: 15,
                                    height: 15,
                                    color: ThemeColors.color404040,
                                  ),
                                  new Text(
                                    '客服',
                                    style: new TextStyle(
                                        fontSize: 10,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                        color: ThemeColors.color404040),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: new Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: ThemeColors.colorDEDEDE,
                                        width: 1)),
                                width: 50,
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Container(
                                      width: 15,
                                      height: 15,
                                      color: ThemeColors.color404040,
                                    ),
                                    new Text(
                                      '收藏',
                                      style: new TextStyle(
                                          fontSize: 10,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal,
                                          color: ThemeColors.color404040),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _book();
                                },
                                child: Container(
                                  color: ThemeColors.color404040,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '立即预订',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.none,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        color: Colors.white,
                        width: ScreenUtil.getScreenW(context),
                        height: 64,
                        padding: const EdgeInsets.only(
                            left: 14, right: 14, bottom: 14),
                        child: RaisedButton(
                          color: ThemeColors.color404040,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          onPressed: () {
                            _sure();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '确定',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///立即预订点击
  _book() {}

  ///确定按钮
  _sure() {}
}
