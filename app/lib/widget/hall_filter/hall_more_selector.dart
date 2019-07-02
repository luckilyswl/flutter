import 'package:flutter/material.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';

/*
 * 餐厅筛选栏更多选择器 Widget
 **/
class HallMoreSelector extends StatefulWidget {
  //消失控制
  VoidCallback dismissAction;

  //更多数据
  List<MoreModel> moreLists;

  HallMoreSelector({this.moreLists, this.dismissAction});

  @override
  State<StatefulWidget> createState() {
    return HallMoreSelectorState();
  }
}

class HallMoreSelectorState extends State<HallMoreSelector> {
  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }

  Widget _buildWidget() {
    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 154),
          height: 414,
          width: ScreenUtil.getScreenW(context),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 370,
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 0),
                  itemBuilder: (context, i) {
                    return _buildFilter(i, widget.moreLists[i].gridData);
                  },
                  separatorBuilder: (context, i) {
                    return SizedBox(width: 0, height: 0);
                  },
                  itemCount: widget.moreLists.length,
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
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
                            ///全部选中重置
                            for (int i = 0, len = widget.moreLists.length;
                                i < len;
                                i++) {
                              for (GridDataListBean data
                                  in widget.moreLists[i].gridData) {
                                data.hasBg = false;
                              }
                              widget.moreLists[i].index = -1;
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
                          onTap: widget.dismissAction,
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
              )
            ],
          ),
        )
      ],
    );
  }

  ///创建一个筛选条件
  _buildFilter(int index, List<GridDataListBean> gridList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        Container(
          width: ScreenUtil.getScreenW(context),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              Text(
                widget.moreLists[index].type,
                style: const TextStyle(
                  fontSize: 16,
                  color: ThemeColors.color404040,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                ),
              ),
              widget.moreLists[index].showSingleCheck
                  ? Positioned(
                      bottom: 0,
                      right: 0,
                      child: Text(
                        '单选',
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: ThemeColors.colorA6A6A6,
                            decoration: TextDecoration.none),
                      ),
                    )
                  : SizedBox(width: 0, height: 0),
            ],
          ),
        ),
        SizedBox(height: 14),
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.76,
          children: gridList.map((f) {
            if (f.isShowMore) {
              return _buildBtn(gridList.indexOf(f), f.title, f.hasBg,
                  widget.moreLists[index],
                  isShowMore: true);
            }
            return _buildBtn(
                gridList.indexOf(f), f.title, f.hasBg, widget.moreLists[index]);
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  ///创建按钮
  Widget _buildBtn(int index, String title, bool hasBg, MoreModel moreData,
      {bool isShowMore = false}) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: hasBg ? ThemeColors.color404040 : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(width: 1, color: ThemeColors.colorDEDEDE),
      ),
      child: FlatButton(
        onPressed: () {
          moreData.index = index;
          setState(() {
            moreData.gridData.forEach((f) => f.hasBg = false);
            moreData.gridData[index].hasBg = true;
          });
        },
        color: Colors.transparent,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: 14,
                color: hasBg ? Colors.white : ThemeColors.color404040),
          ),
          isShowMore ? SizedBox(width: 2) : SizedBox(width: 0),
          isShowMore
              ? SizedBox(
                  width: 14,
                  height: 14,
                  child: Center(
                    child: Image.asset('assets/images/ic_message.png',
                        width: 8, height: 4, fit: BoxFit.fill),
                  ),
                )
              : SizedBox(width: 0),
        ]),
      ),
    );
  }
}

class MoreModel {
  String type;
  bool showSingleCheck;
  List<GridDataListBean> gridData;
  int index;

  MoreModel(
      {this.type, this.showSingleCheck = true, this.gridData, this.index = -1});

  MoreModel.fromJson(Map<String, dynamic> json) {
    this.type = json['type'];
    this.showSingleCheck = json['showSingleCheck'];
    this.index = json['index'];
    this.gridData = (json['gridData'] as List) != null
        ? (json['gridData'] as List)
            .map((i) => GridDataListBean.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['showSingleCheck'] = this.showSingleCheck;
    data['index'] = this.index;
    data['gridData'] = this.gridData != null
        ? this.gridData.map((i) => i.toJson()).toList()
        : null;
    return data;
  }
}

class GridDataListBean {
  String title;
  bool hasBg;
  bool isShowMore;

  GridDataListBean({this.title, this.hasBg = false, this.isShowMore = false});

  GridDataListBean.fromJson(Map<String, dynamic> json) {
    this.title = json['title'];
    this.hasBg = json['hasBg'];
    this.isShowMore = json['isShowMore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['hasBg'] = this.hasBg;
    data['isShowMore'] = this.isShowMore;
    return data;
  }
}
