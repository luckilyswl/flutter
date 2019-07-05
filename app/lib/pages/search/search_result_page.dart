import 'package:flutter/material.dart';
import 'package:app/res/res_index.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/model/custom_scroll_bean.dart';
import 'package:app/model/home_link_picker_bean.dart';
import 'dart:convert';
import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/search_condition_bean.dart' as SC;
import 'package:app/model/home_buiness_list_bean.dart' as BusinessInfo;
import 'package:app/Application.dart';
import 'package:app/model/event.dart';
import 'package:app/pages/pages_index.dart';

/*
 * 搜索结果页/宴会宴请 Page
 **/
class SearchResultPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchResultPageState();
  }
}

class SearchResultPageState extends State<SearchResultPage> {
  //餐厅筛选栏PopupWindow
  OverlayEntry overlayEntryHallWindow;

  //餐厅筛选栏PopupWindow内容
  HallPopupWindow hallPopupWindow;

  //日期数据
  List<CustomScrollBean> dateData;

  //时间数据
  List<CustomScrollBean> timeData;

  //位数数据
  List<CustomScrollBean> bitData;

  //预算数据
  List<CustomScrollBean> budgetData;

  //更多数据
  List<MoreModel> moreLists;

  //餐厅列表数据
  List<BusinessInfo.BusinessList> _businessList = List();

  //猜你喜欢数据
  List<BusinessInfo.BusinessList> likeList = List();

  //区域数据
  List<HomeLinkPickerBean> areaSelectorBeans;
  int areaIndex = 0;
  int areaSubIndex = 0;
  String areaTitle = '区域';
  String areaSubtitle = '全部';

  //菜系数据
  List<HomeLinkPickerBean> dishSelectorBeans;
  int dishIndex = 0;
  int dishSubIndex = 0;
  String dishTitle = '菜系';
  String dishSubtitle = '全部';

  //筛选条件
  SC.Data searchConditionData;

  //餐厅筛选栏
  GlobalKey keyHallFilter = GlobalKey(debugLabel: 'search_result_hall');

  //文本控制器
  TextEditingController _textEditingController;

  //PopupWindow的类型
  int popupType = 0;

  //当前餐厅筛选栏PopupWindow是否显示
  bool isHallPopupShow = false;

  //是否为商务宴请
  bool isBusinessDinner = false;

  //是否为空数据
  bool isEmpty = false;

  //餐厅筛选栏的高度
  double hallHeight = 0.0;

  //其他页面传递过来的搜索值
  String value = '';

  @override
  void initState() {
    super.initState();
    moreLists = [
      MoreModel(type: '距离', showSingleCheck: false, gridData: [
        GridDataListBean(title: '离我最近'),
      ]),
      MoreModel(type: '环境', gridData: [
        GridDataListBean(title: '高档会所'),
        GridDataListBean(title: '私房菜'),
        GridDataListBean(title: '无敌江景'),
        GridDataListBean(title: '星级酒店'),
        GridDataListBean(title: '别墅'),
        GridDataListBean(title: '更多', isShowMore: true),
      ]),
      MoreModel(type: '包房设施', gridData: [
        GridDataListBean(title: '电视'),
        GridDataListBean(title: '洗手间'),
        GridDataListBean(title: '麻将桌'),
        GridDataListBean(title: '茶桌'),
        GridDataListBean(title: 'KTV设备'),
        GridDataListBean(title: '投影'),
      ]),
      MoreModel(type: '包房设施', gridData: [
        GridDataListBean(title: '电视'),
        GridDataListBean(title: '洗手间'),
        GridDataListBean(title: '麻将桌'),
        GridDataListBean(title: '茶桌'),
        GridDataListBean(title: 'KTV设备'),
        GridDataListBean(title: '投影'),
      ]),
      MoreModel(type: '包房设施', gridData: [
        GridDataListBean(title: '电视'),
        GridDataListBean(title: '洗手间'),
        GridDataListBean(title: '麻将桌'),
        GridDataListBean(title: '茶桌'),
        GridDataListBean(title: 'KTV设备'),
        GridDataListBean(title: '投影'),
      ]),
    ];

    _textEditingController = TextEditingController();

    _initHallFilterPopupWindow();

    _initData();

    WidgetsBinding.instance.addPostFrameCallback((context) {
      RenderBox hallBox = keyHallFilter.currentContext.findRenderObject();
      setState(() {
        hallHeight = hallBox.size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    value = ModalRoute.of(context).settings.arguments;
    if (null == value) {
      value = '';
    }
    //把传递过来的值设置到输入框上
    _textEditingController.text = value;

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: ScreenUtil.getScreenW(context),
              height: 75,
              decoration: BoxDecoration(gradient: Gradients.blueLinearGradient),
            ),
            Expanded(
              child: Container(color: Colors.white),
            ),
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                width: ScreenUtil.getScreenW(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 14),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 20,
                        height: 20,
                        color: Colors.transparent,
                        alignment: Alignment.centerLeft,
                        child: Image.asset('assets/images/ic_message.png',
                            width: 14, height: 14, fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: !isBusinessDinner
                          ? Container(
                              height: 28,
                              decoration: BoxDecoration(
                                color: ThemeColors.colorF2F2F2,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/ic_message.png',
                                        width: 9,
                                        height: 9,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Container(
                                      height: 28,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: TextField(
                                          controller: _textEditingController,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: ThemeColors.color404040),
                                          maxLines: 1,
                                          keyboardType: TextInputType.text,
                                          textInputAction:
                                              TextInputAction.search,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.only(top: 2),
                                            hintText: '附近热门推荐：至正小菜',
                                            border: InputBorder.none,
                                            hintStyle: const TextStyle(
                                                decoration: TextDecoration.none,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12,
                                                color: ThemeColors.colorA6A6A6),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _textEditingController.clear(),
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Image.asset(
                                        'assets/images/ic_message.png',
                                        width: 14,
                                        height: 14,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              '商务宴请',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w400),
                            ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        Application.getEventBus().fire(EventType.goServer);
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName(Page.ROOT_PAGE));
                      },
                      child: Container(
                        height: 50,
                        color: Colors.transparent,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/ic_server.png',
                              width: 16,
                              height: 16,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(height: 2),
                            Text(
                              '客服',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.none,
                                  fontSize: 8,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1),
              Container(
                width: ScreenUtil.getScreenW(context),
                height: ScreenUtil.getScreenH(context) -
                    MediaQuery.of(context).padding.top +
                    50,
                child: Column(
                  children: <Widget>[
                    Container(
                      key: keyHallFilter,
                      child: HallFilter(
                        timeCallback: _clickHallTime,
                        numPeopleCallback: _clickHallNumPeople,
                        perCallback: _clickHallPer,
                        regionCallback: _clickHallRegion,
                        dishCallback: _clickHallDish,
                        moreCallback: _clickHallMore,
                      ),
                    ),
                    Container(
                      width: ScreenUtil.getScreenW(context),
                      height: ScreenUtil.getScreenH(context) -
                          hallHeight -
                          50 -
                          MediaQuery.of(context).padding.top,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          ///显示没有找到符合的条件内容
                          if (0 == i && isEmpty) {
                            return Container(
                              height: 196,
                              width: ScreenUtil.getScreenW(context),
                              color: Colors.white,
                              alignment: Alignment.center,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 40),
                                  Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 14),
                                  Text(
                                    '“ 没找到符合的条件内容 ”',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: ThemeColors.colorA6A6A6,
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.none),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        width: 80,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                              color: ThemeColors.colorA6A6A6,
                                              width: 1),
                                        ),
                                        child: FlatButton(
                                          onPressed: () {},
                                          padding: const EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14)),
                                          child: Text(
                                            '上报需求',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: ThemeColors.color404040,
                                                fontWeight: FontWeight.normal,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 14),
                                      Container(
                                        width: 80,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                              color: ThemeColors.colorA6A6A6,
                                              width: 1),
                                        ),
                                        child: FlatButton(
                                          onPressed: () {},
                                          padding: const EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14)),
                                          child: Text(
                                            '联系客服',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: ThemeColors.color404040,
                                                fontWeight: FontWeight.normal,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }

                          ///显示猜你喜欢行
                          if (1 == i && isEmpty) {
                            return Container(
                              height: 34,
                              width: ScreenUtil.getScreenW(context),
                              color: ThemeColors.colorF2F2F2,
                              padding: const EdgeInsets.only(left: 16),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '猜你喜欢',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: ThemeColors.color404040,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none),
                              ),
                            );
                          }

                          return ItemHall(
                            imgUrl: _businessList[i]?.imgUrl,
                            title: _businessList[i]?.title,
                            price: '￥' + _businessList[i]?.perPerson + "/人",
                            location: _businessList[i].dishes +
                                ' | ' +
                                _businessList[i]?.zoneName +
                                " · " +
                                _businessList[i]?.distance,
                            remark: _businessList[i]?.shopName,
                          );
                        },
                        separatorBuilder: (context, i) {
                          return Container(
                            margin: const EdgeInsets.only(left: 144),
                            height: 1,
                            color: ThemeColors.colorDEDEDE,
                          );
                        },
                        itemCount: _businessList.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///初始化餐厅菜单栏要显示的组件
  _initHallFilterPopupWindow() {
    hallPopupWindow = HallPopupWindow(
      type: popupType,
      dismissAction: _dismissHallFilterPopupWindow,
      hallTimeSelector: HallCustomScrollSelector(
        title: '，什么时间？',
        firstData: dateData,
        secondData: timeData,
        callback: (results) {
          _dismissHallFilterPopupWindow();
        },
      ),
      hallNumPeopleSelector: HallCustomScrollSelector2(
        title: '，几位？',
        firstData: bitData,
        callback: (results) {
          _dismissHallFilterPopupWindow();
        },
      ),
      hallPerSelector: HallCustomScrollSelector3(
        title: '，预算多少？',
        firstData: budgetData,
        callback: (results) {
          _dismissHallFilterPopupWindow();
        },
        isBigMargin: true,
      ),
      hallRegionSelector: HomeFliterLinkWidget(
        pickerBeans: areaSelectorBeans,
        onCloseEvent: () {
          _dismissHallFilterPopupWindow();
        },
        onFinishEvent: (firstIndex, secondIndex) {
          _dismissHallFilterPopupWindow();
          setState(() {
            areaIndex = firstIndex;
            areaSubIndex = secondIndex;
          });
        },
        firstLevelIndex: areaIndex,
        secondLevelIndex: areaSubIndex,
        margin: EdgeInsets.only(top: 115),
      ),
      hallDishSelector: HomeFliterLinkWidget(
          pickerBeans: dishSelectorBeans,
          onCloseEvent: () {
            _dismissHallFilterPopupWindow();
          },
          onFinishEvent: (firstIndex, secondIndex) {
            _dismissHallFilterPopupWindow();
            setState(() {
              dishIndex = firstIndex;
              dishSubIndex = secondIndex;
            });
          },
          firstLevelIndex: dishIndex,
          secondLevelIndex: dishSubIndex,
          margin: EdgeInsets.only(top: 157)),
      hallMoreSelector: HallMoreSelector(
        moreLists: moreLists,
        dismissAction: _dismissHallFilterPopupWindow,
      ),
    );

    overlayEntryHallWindow = OverlayEntry(builder: (context) {
      return hallPopupWindow;
    });
  }

  ///控制餐厅筛选栏PopupWindow消失
  _dismissHallFilterPopupWindow() {
    isHallPopupShow = false;
    overlayEntryHallWindow.remove();
  }

  ///显示餐厅筛选栏
  _showHallPopupWindow(int type) {
    popupType = type;
    if (isHallPopupShow) {
      hallPopupWindow.setType = popupType;
    } else {
      isHallPopupShow = true;
      _initHallFilterPopupWindow();
      Overlay.of(context).insert(overlayEntryHallWindow);
    }
  }

  ///餐厅筛选区域选择器
  _clickHallRegion() {
    _showHallPopupWindow(0);
  }

  ///餐厅筛选时间选择器
  _clickHallTime() {
    _showHallPopupWindow(1);
  }

  ///餐厅筛选人数选择器
  _clickHallNumPeople() {
    _showHallPopupWindow(2);
  }

  ///餐厅筛选菜系选择器
  _clickHallDish() {
    _showHallPopupWindow(3);
  }

  ///餐厅筛选人均选择器
  _clickHallPer() {
    _showHallPopupWindow(4);
  }

  ///餐厅筛选更多选择器
  _clickHallMore() {
    _showHallPopupWindow(5);
  }

  _initData() {
    ///请求筛选条件
    dio.get(Api.SEARCH_CONDITIONS).then((data) {
      var sources = jsonDecode(data.toString());
      SC.SearchConditionBean bean = SC.SearchConditionBean.fromJson(sources);
      SC.Data dataBean = bean.data;

      if (bean.errorCode == "0") {
        setState(() {
          searchConditionData = dataBean;
          areaSelectorBeans = HomeFilterUtils.changeAreaDataToPickerData(
              searchConditionData.areas);
          dishSelectorBeans = HomeFilterUtils.changeDishDataToPickerData(
              searchConditionData.dishes);
          dateData = HomeFilterUtils.changeDateDataToScrollData(
              searchConditionData.date);
          timeData = HomeFilterUtils.changeTimeDataToScrollData(
              searchConditionData.time);
          bitData = HomeFilterUtils.changeNumberDataToScrollData(
              searchConditionData.numbers);
          budgetData = HomeFilterUtils.changePriceOptionDataToScrollData(
              searchConditionData.priceOption);
        });
      }
    });

    ///请求餐厅列表数据
    dio.get(Api.BUSINESS_LIST,
        queryParameters: {"page": "1", "page_size": "20"}).then((data) {
      var sources = jsonDecode(data.data);
      BusinessInfo.HomeBusinessInfo businessInfo =
          BusinessInfo.HomeBusinessInfo.fromJson(sources);
      if (businessInfo != null && businessInfo.errorCode == "0") {
        _businessList = businessInfo.data.list;
      } else {
        Toast.toast(context, businessInfo.msg);
      }
    });
  }
}
