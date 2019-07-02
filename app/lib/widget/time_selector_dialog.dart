import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/model/custom_scroll_bean.dart';
import 'package:flutter/material.dart';
import 'package:app/widget/widgets_index.dart';

//定义回调接口
typedef TimeSelectorCallback = Function(List<int> results);

/*
 * 时间选择器 Widget 
 **/
class TimeSelectorDialog extends StatefulWidget {
  final TimeSelectorCallback callback;

  //消失控制
  final VoidCallback dismissAction;

  //日期数据
  final List<CustomScrollBean> dateData;

  //时间数据
  final List<CustomScrollBean> timeData;

  //位数数据
  final List<CustomScrollBean> bitData;

  TimeSelectorDialog({
    @required this.dateData,
    @required this.timeData,
    @required this.bitData,
    @required this.callback,
    @required this.dismissAction,
  });

  @override
  State<StatefulWidget> createState() {
    return TimeSelectorState();
  }
}

class TimeSelectorState extends State<TimeSelectorDialog> {
  //日期,时间,位数索引
  int dateIndex = 0;
  int timeIndex = 0;
  int bitIndex = 0;

  @override
  Widget build(BuildContext context) {
    return _buildTimeSelector();
  }

  Widget _buildTimeSelector() {
    return Container(
      color: ThemeColors.color96000000,
      child: Column(
        children: <Widget>[
          Expanded(
              child: GestureDetector(
            onTap: widget.dismissAction,
            child: Container(color: Colors.transparent),
          )),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              color: Colors.white,
            ),
            width: ScreenUtil.getScreenW(context),
            height: 444,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
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
                            '，什么时间，几位就餐？',
                            style: const TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: ThemeColors.color404040),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 28),
                    CustomScrollList(
                        listData: widget.dateData,
                        callback: (index) {
                          setState(() {
                            dateIndex = index;
                          });
                        }),
                    SizedBox(height: 28),
                    CustomScrollList(
                      listData: widget.timeData,
                      callback: (index) {
                        setState(() {
                          timeIndex = index;
                        });
                      },
                    ),
                    SizedBox(height: 28),
                    CustomScrollList(
                      listData: widget.bitData,
                      callback: (index) {
                        setState(() {
                          bitIndex = index;
                        });
                      },
                    )
                  ],
                ),
                Positioned(
                  right: 14,
                  top: 14,
                  child: GestureDetector(
                    onTap: widget.dismissAction,
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: Center(
                        child: Image.asset('assets/images/ic_message.png',
                            width: 15, height: 15, fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 14,
                  child: Container(
                    height: 48,
                    margin: const EdgeInsets.only(left: 14, right: 14),
                    width: ScreenUtil.getScreenW(context) - 28,
                    child: RaisedButton(
                      onPressed: () {
                        widget.callback([dateIndex, timeIndex, bitIndex]);
                      },
                      color: ThemeColors.color404040,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '确定',
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                ///安全区域
                Positioned(
                  bottom: 0,
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).padding.bottom,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
