import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:app/model/custom_scroll_bean.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:app/pages/pages_index.dart';

/*
 * 立即预订PopupWindow内容 Widget
 **/
class BookNowContent extends StatefulWidget {
  //包房数据
  List<BookNowModel> modelList;

  //日期数据
  List<CustomScrollBean> dateData = List();

  //时间数据
  List<CustomScrollBean> timeData = List();

  //位数数据
  List<CustomScrollBean> bitData = List();

  //包房详情model
  List<RoomModel> roomModel = List();

  //时间选择器
  OverlayEntry overlayTimeSelector;

  //点击时间选择器回调
  Function(bool isShowTimeSelector) callback;

  //定义回调接口
  Function(List<int> results) timeSelectorCallback;

  //选中的包房item索引
  Function(int index) roomIndexCallback;

  //包房时间区间
  String timeInterval;

  //选中item索引
  int selectIndex = -1;

  //时间和人数
  String timeAndNum;

  BookNowContentState bookNowContentState = BookNowContentState();

  set setTimeAndNum(String t) {
    this.timeAndNum = t;
    bookNowContentState.update();
  }

  set setModelList(List<BookNowModel> list) {}

  BookNowContent(
      {@required this.timeInterval = '',
      @required this.modelList,
      @required this.dateData,
      @required this.timeData,
      @required this.bitData,
      @required this.roomModel,
      @required this.callback,
      this.timeAndNum = '请点击选择',
      this.timeSelectorCallback,
      this.roomIndexCallback});

  @override
  State<StatefulWidget> createState() {
    return bookNowContentState;
  }
}

class BookNowContentState extends State<BookNowContent> {
  //时间和人数
  String timeAndNum = '请点击选择';

  void update() {
    setState(() {
      timeAndNum = widget.timeAndNum;
    });
  }

  void updateAll() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    timeAndNum = widget.timeAndNum;
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }

  Widget _buildWidget() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 14),
            Image.asset('assets/images/ic_blue_1.png', width: 14, height: 14),
            SizedBox(width: 10),
            Text(
              '什么时间，几位就餐',
              style: const TextStyle(
                  fontSize: 14,
                  color: ThemeColors.colorA6A6A6,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
        SizedBox(height: 14),
        Container(
          width: ScreenUtil.getScreenW(context) - 28,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: ThemeColors.color331A1A1A,
                  offset: Offset(0, 3),
                  blurRadius: 8,
                  spreadRadius: 0),
            ],
            gradient: Gradients.blueLinearGradient,
          ),
          child: FlatButton(
            onPressed: _clickTimeSelector,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 20),
                      Image.asset('assets/images/ic_time.png',
                          width: 24, height: 24, fit: BoxFit.cover),
                      SizedBox(width: 10),
                      Text(
                        timeAndNum,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                Image.asset('assets/images/ic_xuanzeyuyuexinxi.png',
                    width: 24, height: 24, fit: BoxFit.fill),
                SizedBox(width: 24),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            SizedBox(width: 14),
            Image.asset('assets/images/ic_blue_2.png', width: 14, height: 14),
            SizedBox(width: 10),
            Text(
              '哪个包房',
              style: const TextStyle(
                  fontSize: 14,
                  color: ThemeColors.colorA6A6A6,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(width: 4),
            Text(
              widget.timeInterval,
              style: const TextStyle(
                  fontSize: 12,
                  color: ThemeColors.colorA6A6A6,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
        SizedBox(height: 14),
        Container(
          width: ScreenUtil.getScreenW(context),
          height: 146,
          child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, i) {
                if (i == widget.modelList.length - 1) {
                  return Row(
                    children: <Widget>[
                      _buildItem(widget.modelList[i], i),
                      SizedBox(width: 14)
                    ],
                  );
                }
                return _buildItem(widget.modelList[i], i);
              },
              separatorBuilder: (context, i) => SizedBox(),
              itemCount: widget.modelList.length),
        ),
      ],
    );
  }

  Widget _buildItem(BookNowModel model, int index) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: <Widget>[
          SizedBox(width: 14),
          Container(
            width: 150,
            height: 146,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  width: 1,
                  color: model.hasBg
                      ? ThemeColors.color54548C
                      : ThemeColors.colorDEDEDE),
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _clickPhoto(index),
                      child: Container(
                        width: 150,
                        height: 100,
                        decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                            image: DecorationImage(
                                image: NetworkImage(model.imgUrl),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (widget.modelList[index].clickable) {
                          ///已经选中,点击则不选中
                          if (widget.modelList[index].hasBg) {
                            widget.selectIndex = -1;
                            if (null != widget.roomIndexCallback) {
                              widget.roomIndexCallback(-1);
                            }
                            setState(() {
                              widget.modelList[index].hasBg = false;
                            });
                            return;
                          }

                          widget.selectIndex = index;
                          if (null != widget.roomIndexCallback) {
                            widget.roomIndexCallback(index);
                          }
                          setState(() {
                            widget.modelList.forEach((f) => f.hasBg = false);
                            widget.modelList[index].hasBg = true;
                          });
                        }
                      },
                      child: Container(
                        width: 150,
                        height: 44,
                        color: Colors.transparent,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    model.title,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: ThemeColors.color404040,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    model.subtitle,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: ThemeColors.color404040,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              ],
                            ),
                            model.clickable
                                ? Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 31,
                                      height: 31,
                                      alignment: Alignment.bottomRight,
                                      decoration: model.hasBg
                                          ? BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(200),
                                                  bottomRight:
                                                      Radius.circular(4)),
                                              gradient:
                                                  Gradients.blueLinearGradient,
                                            )
                                          : BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(200),
                                                  bottomRight:
                                                      Radius.circular(4)),
                                              color: ThemeColors.colorDEDEDE),
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        margin: const EdgeInsets.only(
                                            right: 4, bottom: 4),
                                        child: Image.asset(
                                            'assets/images/ic_success.png'),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ObjectUtil.isEmpty(model.tips)
                    ? SizedBox()
                    : Positioned(
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(139, 87, 42, 1),
                              borderRadius: BorderRadius.circular(7)),
                          child: Text(
                            model.tips,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                ObjectUtil.isEmpty(model.desc)
                    ? SizedBox()
                    : Positioned(
                        top: 80,
                        child: Container(
                          width: 150,
                          height: 20,
                          alignment: Alignment.center,
                          color: model.clickable
                              ? ThemeColors.color96F5A623
                              : ThemeColors.color961A1A1A,
                          child: Text(
                            model.desc,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///点击时间选择器
  _clickTimeSelector() {
    widget.callback(true);
    Navigator.of(context).push(
      PopRoute(
        child: TimeSelectorDialog(
          dateData: widget.dateData,
          timeData: widget.timeData,
          bitData: widget.bitData,
          callback: (results) {
            Navigator.of(context).pop();
            Future.delayed(
                Duration(milliseconds: 60), () => widget.callback(false));
            setState(() {
              timeAndNum =
                  '${widget.dateData[results[0]].title} ${widget.dateData[results[0]].subTitle} ${widget.timeData[results[1]].title}, ${widget.bitData[results[2]].title}';
            });
            if (null != widget.timeSelectorCallback) {
              widget.timeSelectorCallback(results);
            }
          },
          dismissAction: () {
            Navigator.of(context).pop();
            Future.delayed(
                Duration(milliseconds: 60), () => widget.callback(false));
          },
        ),
        dimissable: true,
      ),
    );
  }

  ///item图片点击事件
  _clickPhoto(int index) {
    Navigator.of(context).push(PopRoute(
        child: RoomDetailPopupWindow(
            roomModel: widget.roomModel[index],
            callback: () {
              setState(() {
                widget.modelList.forEach((f) => f.hasBg = false);
                widget.modelList[index].hasBg = true;
              });
            }),
        dimissable: true));
  }
}

class BookNowModel {
  String imgUrl;
  String title;
  String subtitle;
  String tips;
  String desc;
  bool hasBg;
  bool clickable;

  BookNowModel(
      {@required this.imgUrl,
      @required this.title,
      @required this.subtitle,
      this.tips,
      this.desc,
      this.hasBg = false,
      this.clickable = true});

  BookNowModel.fromJson(Map<String, dynamic> json) {
    this.imgUrl = json['imgUrl'];
    this.title = json['title'];
    this.subtitle = json['subtitle'];
    this.tips = json['tips'];
    this.desc = json['desc'];
    this.hasBg = json['hasBg'];
    this.clickable = json['clickable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imgUrl'] = this.imgUrl;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['tips'] = this.tips;
    data['desc'] = this.desc;
    data['hasBg'] = this.hasBg;
    data['clickable'] = this.clickable;
    return data;
  }
}
