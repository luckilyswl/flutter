import 'package:flutter/material.dart';
import 'package:app/res/res_index.dart';

/*
 * 首页-餐厅筛选栏 Widget
 **/
class HallFilter extends StatefulWidget {
  final VoidCallback regionCallback;
  final VoidCallback timeCallback;
  final VoidCallback numPeopleCallback;
  final VoidCallback dishCallback;
  final VoidCallback perCallback;
  final VoidCallback moreCallback;

  HallFilter({
    this.regionCallback,
    this.timeCallback,
    this.numPeopleCallback,
    this.dishCallback,
    this.perCallback,
    this.moreCallback,
  });

  @override
  State<StatefulWidget> createState() {
    return HallFilterState();
  }
}

class HallFilterState extends State<HallFilter> {
  @override
  Widget build(BuildContext context) {
    return _buildHallFilter();
  }

  ///创建餐厅筛选栏
  Widget _buildHallFilter() {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: Column(
        children: <Widget>[
          SizedBox(height: 8),
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: _buildHallFilterItem(
                    text: '区域',
                    isDark: true,
                    hasBorder: false,
                    callback: widget.regionCallback,
                  )),
              SizedBox(width: 7),
              Container(
                width: 1,
                height: 14,
                color: ThemeColors.colorA6A6A6,
              ),
              SizedBox(width: 7),
              Flexible(
                flex: 1,
                child: _buildHallFilterItem(
                    text: '时间',
                    isDark: true,
                    hasBorder: false,
                    callback: widget.timeCallback),
              ),
              SizedBox(width: 7),
              Container(
                width: 1,
                height: 14,
                color: ThemeColors.colorA6A6A6,
              ),
              SizedBox(width: 7),
              Flexible(
                flex: 1,
                child: _buildHallFilterItem(
                    text: '人数',
                    isDark: true,
                    hasBorder: false,
                    callback: widget.numPeopleCallback),
              ),
            ],
          ),
          SizedBox(height: 14),
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: _buildHallFilterItem(
                    text: '菜式',
                    isDark: false,
                    hasBorder: true,
                    callback: widget.dishCallback),
              ),
              SizedBox(width: 15),
              Flexible(
                flex: 1,
                child: _buildHallFilterItem(
                    text: '人均',
                    isDark: false,
                    hasBorder: true,
                    callback: widget.perCallback),
              ),
              SizedBox(width: 15),
              Flexible(
                flex: 1,
                child: _buildHallFilterItem(
                    text: '更多',
                    isDark: false,
                    hasBorder: true,
                    callback: widget.moreCallback),
              ),
            ],
          ),
          SizedBox(height: 14)
        ],
      ),
    );
  }

  ///创建餐厅筛选item
  Widget _buildHallFilterItem(
      {@required String text,
      @required bool isDark,
      @required bool hasBorder,
      @required VoidCallback callback}) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        color: Colors.transparent,
        child: Container(
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
                width: hasBorder ? 1 : 0,
                color:
                    hasBorder ? ThemeColors.colorA6A6A6 : Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: isDark
                    ? const TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 12,
                        color: ThemeColors.color404040,
                        fontWeight: FontWeight.w400)
                    : const TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: ThemeColors.colorA6A6A6),
              ),
              SizedBox(width: 2),
              SizedBox(
                width: 14,
                height: 14,
                child: Center(
                  child: Image.asset('assets/images/ic_message.png',
                      width: 8, height: 4, fit: BoxFit.fill),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
