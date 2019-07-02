import 'package:app/model/home_link_picker_bean.dart';
import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class HomeFliterLinkWidget extends StatefulWidget {
  final List<HomeLinkPickerBean> pickerBeans;
  final Function onCloseEvent;
  final Function(int firstLevelIndex, int secondLevelIndex) onFinishEvent;
  final int firstLevelIndex;
  final int secondLevelIndex;
  final EdgeInsetsGeometry margin;

  HomeFliterLinkWidget(
      {Key key,
      @required this.margin,
      @required this.pickerBeans,
      @required this.onCloseEvent,
      @required this.onFinishEvent,
      @required this.firstLevelIndex,
      @required this.secondLevelIndex})
      : super(key: key);

  _HomeFliterLinkWidgetState createState() => _HomeFliterLinkWidgetState();
}

class _HomeFliterLinkWidgetState extends State<HomeFliterLinkWidget> {
  int _firstLevelIndex;
  int _secondLevelIndex;

  List<HomeLinkPickerBean> _subTitles;

  @override
  void initState() {
    _firstLevelIndex = widget.firstLevelIndex;
    _subTitles = widget.pickerBeans[_firstLevelIndex].subItems;
    _secondLevelIndex = widget.secondLevelIndex;
    super.initState();
  }

  _itemWidget(
      String name, bool isActive, bool isFirstList, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: isFirstList ? EdgeInsets.all(0) : EdgeInsets.only(left: 15),
        padding: isFirstList
            ? EdgeInsets.only(left: 15)
            : EdgeInsets.only(right: 15),
        decoration: ShapeDecoration(
          shape: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: isFirstList
                      ? Colors.transparent
                      : ThemeColors.colorDEDEDE,
                  style: BorderStyle.solid)),
          color: isFirstList
              ? (isActive ? Colors.white : ThemeColors.colorF2F2F2)
              : Colors.white,
        ),
        height: 44,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              name,
              style: TextStyle(
                decoration: TextDecoration.none,
                color: isFirstList
                    ? ThemeColors.color404040
                    : (isActive
                        ? ThemeColors.color404040
                        : ThemeColors.colorA6A6A6),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            isFirstList
                ? Container()
                : isActive
                    ? Container(
                        padding: EdgeInsets.only(right: 15),
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
        color: ThemeColors.colorF2F2F2,
        width: MediaQuery.of(context).size.width / 2,
        height: 352,
        child: ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: widget.pickerBeans.length,
          itemBuilder: (BuildContext context, int index) {
            return _itemWidget(
              widget.pickerBeans[index].name,
              index == _firstLevelIndex,
              true,
              () {
                debugPrint('onTap');
                setState(() {
                  _firstLevelIndex = index;
                  _subTitles = widget.pickerBeans[_firstLevelIndex].subItems;
                  _secondLevelIndex = 0;
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
      color: Colors.white,
      width: MediaQuery.of(context).size.width / 2,
      height: 352,
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: _subTitles.length,
        itemBuilder: (BuildContext context, int index) {
          return _itemWidget(
            _subTitles[index].name,
            index == _secondLevelIndex,
            false,
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
              : SizedBox(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: widget.margin,
      height: 352,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          _pickerContentWidget(),
        ],
      ),
    );
  }
}
