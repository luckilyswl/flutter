import 'package:flutter/material.dart';
import 'package:app/res/res_index.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/model/custom_scroll_bean.dart';

//定义回调接口
typedef HallTimeSelectorCallback = Function(List<int> results);

/*
 * 餐厅筛选栏自定义横向选择器 Widget
 **/
class HallCustomScrollSelector extends StatefulWidget {
  final title;

  //第一行数据
  List<CustomScrollBean> firstData;

  //第二行数据
  List<CustomScrollBean> secondData;

  //回调函数
  HallTimeSelectorCallback callback;

  //日期,时间索引
  int firstIndex = 0;
  int secondIndex = 0;

  //是否为第二行显示的内容
  bool isBigMargin;

  HallCustomScrollSelector(
      {@required this.title,
      @required this.firstData,
      @required this.callback,
      this.secondData,
      this.isBigMargin = false});

  @override
  State<StatefulWidget> createState() {
    return HallCustomScrollSelectorState();
  }
}

class HallCustomScrollSelectorState extends State<HallCustomScrollSelector> {
  @override
  Widget build(BuildContext context) {
    return _buildHallTimeSelector();
  }

  Widget _buildHallTimeSelector() {
    return Container(
      height: null == widget.secondData ? 202 : 272,
      width: ScreenUtil.getScreenW(context),
      margin: EdgeInsets.only(top: widget.isBigMargin ? 157 : 115),
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Divider(color: ThemeColors.colorDEDEDE, height: 1),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 28, left: 28),
                    child: Text(
                      'Hi',
                      style: const TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 28,
                          color: ThemeColors.color404040,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: ThemeColors.color404040),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              CustomScrollList(
                  listData: widget.firstData,
                  callback: (index) => widget.firstIndex = index),
              null == widget.secondData
                  ? SizedBox(height: 0)
                  : SizedBox(height: 20),
              null == widget.secondData
                  ? SizedBox(height: 0)
                  : CustomScrollList(
                      listData: widget.secondData,
                      callback: (index) => widget.secondIndex = index),
              SizedBox(height: 40)
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 44,
              width: ScreenUtil.getScreenW(context),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          widget.firstData?.forEach((f) => f.hasBg = false);
                          widget.secondData?.forEach((f) => f.hasBg = false);

                          if (null != widget.firstData) {
                            widget.firstIndex = 0;
                            widget.firstData[0].hasBg = true;
                          }
                          if (null != widget.firstData) {
                            widget.secondIndex = 0;
                            widget.secondData[0].hasBg = true;
                          }
                        });
                      },
                      child: Container(
                        width: 145,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 1, color: ThemeColors.colorDEDEDE),
                          ),
                        ),
                        child: Text(
                          '重置',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, color: ThemeColors.color404040),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: ThemeColors.color404040,
                      child: InkWell(
                        onTap: () {
                          widget.callback(
                              [widget.firstIndex, widget.secondIndex]);
                        },
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          child: Text(
                            '确定',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
