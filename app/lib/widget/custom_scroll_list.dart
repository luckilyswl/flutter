import 'package:flutter/material.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/model/custom_scroll_bean.dart';

///定义回调接口
typedef IndexCallback = Function(int index);

/*
 * 自定义滚动List(点击自动滚动到中间) Widget
 **/
class CustomScrollList extends StatefulWidget {
  List<CustomScrollBean> listData;
  IndexCallback callback;

  CustomScrollList({this.listData, this.callback});

  @override
  State<StatefulWidget> createState() {
    return CustomScrollState();
  }
}

class CustomScrollState extends State<CustomScrollList> {
  //每个item的宽度
  final _ITEM_WIDTH = 72.0;

  //item可见范围的一半
  var itemHalf = 29;

  //屏幕宽度一半
  var screenWidthHalf;

  //listview滑动X
  var _scrollX = 0.0;

  //listview需要滑动的距离
  var _scrollOffset = 0.0;

  //最大滑动距离
  var _maxScroll = 0.0;

  //item可见范围中线X位置
  var _position = 0.0;

  //滑动控制器
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //渲染完成回调
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      screenWidthHalf = ScreenUtil.getScreenW(context) / 2;

      ///为了拿到maxScroll的值
      _scrollController.animateTo(0.01,
          duration: Duration(milliseconds: 1), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildRow();
  }

  //创建一行item
  Widget _buildRow() {
    return SizedBox(
      width: ScreenUtil.getScreenW(context),
      height: 50,

      ///滚动监听
      child: NotificationListener(
        onNotification: (ScrollNotification notification) {
          _scrollX = notification.metrics.pixels;
          _maxScroll = notification.metrics.maxScrollExtent;
        },
        child: ListView(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          padding: const EdgeInsets.all(0),
          scrollDirection: Axis.horizontal,
          children: widget.listData.map((model) {
            ///最后一个item
            if (widget.listData.length - 1 == widget.listData.indexOf(model)) {
              return _buildItem(model.title, model.subTitle, model.hasBg, () {
                _clickItem(model);
              }, isLastItem: true);
            }

            return _buildItem(model.title, model.subTitle, model.hasBg, () {
              _clickItem(model);
            });
          }).toList(),
        ),
      ),
    );
  }

  void _clickItem(CustomScrollBean model) {
    ///全部未选中
    widget.listData.forEach((f) => f.hasBg = false);

    ///选中点击的item
    setState(() {
      model.hasBg = true;
    });

    var clickIndex = widget.listData.indexOf(model);
    double scrollDistance = 0.0;

    ///防止ios默认回弹效果
    if (screenWidthHalf >= _ITEM_WIDTH * (clickIndex + 1) - itemHalf) {
      scrollDistance = 0;
    } else if (_maxScroll + screenWidthHalf <=
        _ITEM_WIDTH * ((clickIndex + 1))) {
      scrollDistance = _maxScroll;
    } else {
      ///计算屏幕左侧到item中线的距离
      _position = (_ITEM_WIDTH * (clickIndex + 1)) - _scrollX - itemHalf;

      ///计算item中线距离屏幕中线距离
      _scrollOffset = _position - screenWidthHalf;

      scrollDistance = _scrollX + _scrollOffset;
    }

    _scrollController.animateTo(scrollDistance,
        duration: Duration(milliseconds: 600), curve: Curves.ease);

    //回调索引值
    widget.callback(widget.listData.indexOf(model));
  }

  ///创建item
  Widget _buildItem(
      String title, String subTitle, bool hasBg, Function function,
      {bool isLastItem = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 14),
        GestureDetector(
          onTap: function,
          child: Container(
            padding: const EdgeInsets.only(left: 4, right: 4),
            height: 50,
            constraints: BoxConstraints(minWidth: 58),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: hasBg ? ThemeColors.color404040 : Colors.transparent),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: !hasBg ? ThemeColors.color404040 : Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                ObjectUtil.isEmptyString(subTitle)
                    ? SizedBox(height: 0)
                    : Text(
                        subTitle,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color:
                              !hasBg ? ThemeColors.color404040 : Colors.white,
                        ),
                      ),
              ],
            ),
          ),
        ),
        isLastItem ? SizedBox(width: 14) : SizedBox(width: 0)
      ],
    );
  }
}
