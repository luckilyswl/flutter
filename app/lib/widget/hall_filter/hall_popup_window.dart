import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/hall_filter/hall_link_selector.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';

/*
 * 餐厅筛选栏PopupWindow Widget 
 **/
class HallPopupWindow extends StatefulWidget {
  //显示哪个类型的内容
  int type;

  //餐厅筛选栏PopupWindow
  final VoidCallback dismissAction;

  //时间选择器
  HallCustomScrollSelector hallTimeSelector;

  //人数选择器
  HallCustomScrollSelector2 hallNumPeopleSelector;

  //人均预算选择器
  HallCustomScrollSelector3 hallPerSelector;

  //区域选择器
  HomeFliterLinkWidget hallRegionSelector;

  //菜系选择器
  HomeFliterLinkWidget hallDishSelector;

  //更多选择器
  HallMoreSelector hallMoreSelector;

  HallPopupWindowState hallPopupWindowState = HallPopupWindowState();

  ///popupWindow已经显示调用
  set setType(int t) {
    this.type = t;
    hallPopupWindowState.update();
  }

  HallPopupWindow(
      {@required this.type,
      @required this.dismissAction,
      this.hallTimeSelector,
      this.hallNumPeopleSelector,
      this.hallPerSelector,
      this.hallRegionSelector,
      this.hallDishSelector,
      this.hallMoreSelector});

  @override
  State<StatefulWidget> createState() {
    return hallPopupWindowState;
  }
}

class HallPopupWindowState extends State<HallPopupWindow> {
  //要显示的内容
  Widget myWidget;

  int type;

  ///刷新UI
  update() {
    setState(() {
      type = widget.type;
      _initWidget();
    });
  }

  @override
  initState() {
    super.initState();
    type = widget.type;

    _initWidget();
  }

  _initWidget() {
    switch (type) {
      case 0:
        myWidget = widget.hallRegionSelector;
        break;
      case 1:
        myWidget = widget.hallTimeSelector;
        break;
      case 2:
        myWidget = widget.hallNumPeopleSelector;
        break;
      case 3:
        myWidget = widget.hallDishSelector;
        break;
      case 4:
        myWidget = widget.hallPerSelector;
        break;
      case 5:
        myWidget = widget.hallMoreSelector;
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: ScreenUtil.getScreenW(context),
              height: MediaQuery.of(context).padding.top + 50,
              color: Colors.transparent,
            ),
            Container(
              width: ScreenUtil.getScreenW(context),
              height: (0 < type && 3 > type) ? 42 : 84,
            ),
            Expanded(
              child: GestureDetector(
                onTap: widget.dismissAction,
                child: Container(
                  width: ScreenUtil.getScreenW(context),
                  color: ThemeColors.color96000000,
                ),
              ),
            ),
          ],
        ),
        myWidget
      ],
    );
  }
}
