import 'package:app/model/home_link_picker_bean.dart';
import 'package:app/res/theme_colors.dart';
import 'package:app/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// 示例代码
// {
//  OverlayEntry areaPicker;
//  if (areaPicker == null) {
//       areaPicker = OverlayEntry(builder: (context) {
//         return HomeLinkPicker(
//           pickerBeans: <HomeLinkPickerBean>[
//             HomeLinkPickerBean(id: 0, name: '全部区域', subItems: <HomeLinkPickerBean>[]),
//             HomeLinkPickerBean(
//                 id: 0,
//                 name: '荔湾区',
//                 subItems: <HomeLinkPickerBean>[
//                   HomeLinkPickerBean(id: 0, name: '全部'),
//                   HomeLinkPickerBean(id: 0, name: '红楼'),
//                   HomeLinkPickerBean(id: 0, name: '沙面'),
//                 ]),
//             HomeLinkPickerBean(
//                 id: 0,
//                 name: '天河区',
//                 subItems: <HomeLinkPickerBean>[
//                   HomeLinkPickerBean(id: 0, name: '全部'),
//                   HomeLinkPickerBean(id: 0, name: '创工场'),
//                   HomeLinkPickerBean(id: 0, name: '黄埔村'),
//                 ]),
//             HomeLinkPickerBean(
//                 id: 0,
//                 name: '越秀区',
//                 subItems: <HomeLinkPickerBean>[
//                   HomeLinkPickerBean(id: 0, name: '全部'),
//                   HomeLinkPickerBean(id: 0, name: '红楼'),
//                   HomeLinkPickerBean(id: 0, name: '沙面'),
//                 ]),
//             HomeLinkPickerBean(
//                 id: 0,
//                 name: '海珠区',
//                 subItems: <HomeLinkPickerBean>[
//                   HomeLinkPickerBean(id: 0, name: '全部'),
//                   HomeLinkPickerBean(id: 0, name: '创工场'),
//                   HomeLinkPickerBean(id: 0, name: '黄埔村'),
//                 ]),
//           ],
//           onCloseEvent: () {
//             areaPicker.remove();
//           },
//           onFinishEvent: (firstIndex, secondIndex) {
//             debugPrint('firstIndex = ${firstIndex.toString()}, secondIndex = ${secondIndex.toString()}');
//             areaPicker.remove();
//           },
//           firstLevelIndex: 0,
//           secondLevelIndex: 0,
//         );
//       });
//     }
//     Overlay.of(context).insert(areaPicker);
// }

class HomeLinkPicker extends StatefulWidget {
  final List<HomeLinkPickerBean> pickerBeans;
  final Function onCloseEvent;
  final Function(int firstLevelIndex, int secondLevelIndex) onFinishEvent;
  final int firstLevelIndex;
  final int secondLevelIndex;

  HomeLinkPicker(
      {Key key,
      @required this.pickerBeans,
      @required this.onCloseEvent,
      @required this.onFinishEvent,
      @required this.firstLevelIndex,
      @required this.secondLevelIndex})
      : super(key: key);

  _HomeLinkPickerState createState() => _HomeLinkPickerState();
}

class _HomeLinkPickerState extends State<HomeLinkPicker> {
  int _firstLevelIndex;
  int _secondLevelIndex;

  double _firstLevelWidth;
  double _secondLevelWidth;

  List<HomeLinkPickerBean> _subTitles;

  @override
  void initState() {
    _firstLevelIndex = widget.firstLevelIndex;
    _firstLevelWidth =
        HomeFilterUtils.maxWidthWithPickerData(widget.pickerBeans);
    _secondLevelIndex = widget.secondLevelIndex;
    _subTitles = widget.pickerBeans[_firstLevelIndex].subItems;
    _secondLevelWidth = HomeFilterUtils.maxWidthWithPickerData(_subTitles);
    super.initState();
  }

  _headerWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20),
      height: 60,
      decoration: ShapeDecoration(
        shape: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomLeft,
              height: 60,
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: Text(
                      widget.pickerBeans[_firstLevelIndex].name,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        color: ThemeColors.color404040,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  widget.pickerBeans[_firstLevelIndex].subItems.length > 0
                      ? Container(
                          margin: EdgeInsets.only(left: 6, right: 6),
                          color: ThemeColors.colorDEDEDE,
                          width: 14,
                          height: 14,
                        )
                      : SizedBox(),
                  widget.pickerBeans[_firstLevelIndex].subItems.length > 0
                      ? SizedBox(
                          child: Text(
                            _subTitles[_secondLevelIndex].name,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: ThemeColors.color404040,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 15),
            width: 32,
            height: 32,
            child: Image.asset("assets/images/ic_phone.png",
                width: 15, height: 15),
          ),
        ],
      ),
    );
  }

  _itemWidget(String name, bool isActive, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        height: 40,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              name,
              style: TextStyle(
                decoration: TextDecoration.none,
                color: isActive
                    ? ThemeColors.color404040
                    : ThemeColors.colorA6A6A6,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            isActive
                ? Container(
                    color: ThemeColors.color404040,
                    width: 14,
                    height: 14,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  _titleListWidget() {
    return Container(
        width: _firstLevelWidth + 20 + 14,
        margin: EdgeInsets.only(left: 20, right: 15),
        child: ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: widget.pickerBeans.length,
          itemBuilder: (BuildContext context, int index) {
            return _itemWidget(
              widget.pickerBeans[index].name,
              index == _firstLevelIndex,
              () {
                debugPrint('onTap');
                setState(() {
                  _firstLevelIndex = index;
                  _subTitles = widget.pickerBeans[_firstLevelIndex].subItems;
                  _secondLevelIndex = 0;
                  _secondLevelWidth = HomeFilterUtils.maxWidthWithPickerData(
                      widget.pickerBeans[_firstLevelIndex].subItems);
                });
                if (_subTitles.length == 0) {
                  widget.onFinishEvent(_firstLevelIndex, _secondLevelIndex);
                }
              },
            );
          },
        ));
  }

  _subTitleListWidget() {
    return Container(
      width: _secondLevelWidth + 20 + 14,
      margin: EdgeInsets.only(right: 20, left: 15),
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: _subTitles.length,
        itemBuilder: (BuildContext context, int index) {
          return _itemWidget(
            _subTitles[index].name,
            index == _secondLevelIndex,
            () {
              setState(() {
                _secondLevelIndex = index;
              });
              widget.onFinishEvent(_firstLevelIndex, _secondLevelIndex);
            },
          );
        },
      ),
    );
  }

  _pickerContentWidget() {
    return Expanded(
      child: Row(
        children: <Widget>[
          _titleListWidget(),
          widget.pickerBeans[_firstLevelIndex].subItems.length > 0
              ? _subTitleListWidget()
              : SizedBox()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('width is ${context.size.width}');
    return Column(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            child: Container(
              color: Color.fromARGB(153, 0, 0, 0),
            ),
            onTap: () {
              widget.onCloseEvent();
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 444,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                color: Color.fromARGB(153, 0, 0, 0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    _headerWidget(),
                    _pickerContentWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).padding.bottom,
        )
      ],
    );
  }
}
