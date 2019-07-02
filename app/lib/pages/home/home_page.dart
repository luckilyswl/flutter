import 'dart:convert';
import 'dart:math' as math;
import 'package:app/model/app_init_bean.dart' as AppInit;
import 'package:app/model/home_link_picker_bean.dart';
import 'package:app/model/search_condition_bean.dart' as SC;
import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/widget/hall_filter/hall_link_selector.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/res/res_index.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:app/model/custom_scroll_bean.dart';
import 'package:app/Application.dart';
import 'package:app/model/event.dart';
import 'package:app/model/home_info_bean.dart' as HomeInfo;
import 'package:app/model/home_buiness_list_bean.dart' as BusinessInfo;

/*
 * 首页
 **/
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final style12white = TextStyle(fontSize: 12, color: Colors.white);
  final style12a6a6a6 = TextStyle(fontSize: 12, color: ThemeColors.colorA6A6A6);

  String _searchMotion;
  String _searchTip;
  bool _isCompany = false;
  HomeInfo.DataBean _dataBean;
  List<HomeInfo.TopMenuListBean> _topMenuList;
  List<HomeInfo.QuickDataListBean> _quickDataList;
  List<BusinessInfo.BusinessList> _businessList = new List();

  //快速滚动到餐厅栏位置时间
  final int scrollToTopDuration = 110;

  //Tab控制器和tab
  TabController _tabController;
  var _tabs;

  //姓名和手机EditText监听器
  TextEditingController _nameController;
  TextEditingController _phoneController;
  FocusNode _nameFocusNode;
  FocusNode _phoneFocusNode;

  //listview滚动控制器
  ScrollController _scrollController;

  //日期数据
  List<CustomScrollBean> dateData;

  //时间数据
  List<CustomScrollBean> timeData;

  //位数数据
  List<CustomScrollBean> bitData;

  //预算数据
  List<CustomScrollBean> budgetData;

  //城市选择器组件数据
  List<CityModel> cityList;
  AppInit.CurrentCity currentCity;

  //更多数据
  List<MoreModel> moreLists;

  //餐厅筛选栏key
  GlobalKey keyHall = GlobalKey(debugLabel: 'keyHall');

  //快速预订/团建部分key
  GlobalKey keyFastBook = GlobalKey(debugLabel: 'keyFastBook');

  //餐厅筛选栏时间
  OverlayEntry overlayTime;

  //餐厅筛选栏PopupWindow
  OverlayEntry overlayEntryHallWindow;

  //时间选择器BottomSheetDialog
  OverlayEntry timeSelector;

  //城市选择器
  OverlayEntry overlayCity;

  //餐厅筛选栏PopupWindow内容
  HallPopupWindow hallPopupWindow;

  //城市选择器内容
  CitySelectorPopupWindow citySelectorPopupWindow;

  //渐变色线段距离顶部距离
  var lineOffsetTop = 100.0;

  //是否显示渐变线段
  var isShowLine = true;

  //快速预订/团建部分
  var fastBookHeight = 0.0;

  //餐厅筛选栏距离顶部距离
  var offsetHallTop;

  //餐厅筛选栏的高度
  var hallHeight = 90.0;

  //是否显示悬浮餐厅菜单栏
  var isShowFloatingHall = false;

  //tab索引
  var _tabIndex = 0;

  //GridView组件
  List<Widget> gridItems = new List();

  //快速预订宽高
  var fastBookIconWidth = 0.0;
  var fastBookIconHeight = 0.0;

  //是否显示快速预订按钮
  var isShowFastBookIcon = false;

  //是否显示餐厅栏时间选择器
  var isShowHallTimeSelector = true;

  //顶部4个action
  List<Widget> mainActions = new List();

  //餐厅列表
  var hallList = [];

  //滑动距离
  double scrollY = 0.0;

  //快速预订
  var textFastBookTime = '你好，什么时间，几位？';

  //快速预订-区域选择
  OverlayEntry areaPicker;
  List<HomeLinkPickerBean> areaSelectorBeans;
  int areaIndex = 0;
  int areaSubIndex = 0;
  String areaTitle = '区域';
  String areaSubtitle = '全部';

  //快速预订-菜系选择
  OverlayEntry dishPicker;
  List<HomeLinkPickerBean> dishSelectorBeans;
  int dishIndex = 0;
  int dishSubIndex = 0;
  String dishTitle = '菜系';
  String dishSubtitle = '全部';

  //团建&会议
  int dateIndex = 0;
  int timeIndex = 0;
  int numberIndex = 0;
  String phone = '';
  String name = '';

  SC.Data searchConditionData;

  //PopupWindow的类型
  int popupType = 0;

  //当前餐厅筛选栏PopupWindow是否显示
  bool isHallPopupShow = false;

  @override
  void initState() {
    initData();

    _tabs = [
      Tab(text: '快速预订'),
      Tab(text: '团建&会议'),
    ];
    _tabController =
        TabController(initialIndex: 0, length: _tabs.length, vsync: this);

    _nameController = TextEditingController();
    _nameController.addListener(() {
      setState(() {
        name = _nameController.text;
      });
    });
    _phoneController = TextEditingController();
    _phoneController.addListener(() {
      setState(() {
        phone = _phoneController.text;
      });
    });
    _nameFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();

    _scrollController = ScrollController();

    dateData = [];
    timeData = [];
    bitData = [];
    budgetData = [];
    if (DataUtils.getAppInitInfo() != null) {
      cityList = HomeFilterUtils.changeOpenCityDataToCityModelData(
          DataUtils.getAppInitInfo().openCitys);
      currentCity = DataUtils.getAppInitInfo().currentCity;
    } else {
      currentCity = AppInit.CurrentCity(cityId: 2253, cityName: '广州市');
      cityList = <CityModel>[CityModel(city: '广州市', hasBg: true)];
    }

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

    _initHallFilterPopupWindow();

    //组件渲染完成回调,测量餐厅筛选栏顶部距离
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      //餐厅筛选栏
      RenderBox hall = keyHall.currentContext.findRenderObject();
      Offset offset = hall.localToGlobal(Offset.zero);
      offsetHallTop = offset.dy - 75;

      //快速预订/团建
      RenderBox fastBook = keyFastBook.currentContext.findRenderObject();

      setState(() {
        fastBookHeight = fastBook.size.height + 145;
        hallHeight = hall.size.height;
      });
    });

    super.initState();
  }

  void initData() {
    dio.get(Api.INDEX_HOME).then((data) {
      var sources = jsonDecode(data.data);
      HomeInfo.HomeInfoBean info = HomeInfo.HomeInfoBean.fromJson(sources);
      if (info.errorCode == "0"){
        _dataBean = info.data;
        if (_dataBean != null) {
          _searchMotion = _dataBean.indexSearchMotion;
          _searchTip = _dataBean.indexSearchTip;
          _isCompany = _dataBean.isCompany == 1;
          _topMenuList = _dataBean.topMenu;
          _quickDataList = _dataBean.quickData;
        }
      } else {
        Toast.toast(context, info.msg);
      }
    });

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

    dio.get(Api.BUSINESS_LIST,
        queryParameters: {"page": "1", "page_size": "20"}).then((data) {
          var sources = jsonDecode(data.data);
          BusinessInfo.HomeBusinessInfo businessInfo = BusinessInfo.HomeBusinessInfo.fromJson(sources);
          if (businessInfo != null && businessInfo.errorCode == "0") {
            _businessList = businessInfo.data.list;
          } else {
            Toast.toast(context, businessInfo.msg);
          }
    });
  }

  /// 顶部菜单
  List<Widget> _initMainActions() {
    mainActions.clear();
    _topMenuList.forEach((f) {
      mainActions.add(_buildMainAction(f.imgUrl, f.adName, ()=>_clickTopMenuItem(_topMenuList.indexOf(f))));
    });
    return mainActions;
  }

  /// 顶部菜单点击事件
  void _clickTopMenuItem(int i) {
    Toast.toast(context, _topMenuList[i].adName);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 50.4,
            decoration: BoxDecoration(gradient: Gradients.blueLinearGradient),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25),

            ///滚动监听
            child: NotificationListener(
              onNotification: (ScrollNotification notification) {
                scrollY = notification.metrics.pixels;

                //滑到顶部清除输入框的焦点
                if (172 <= scrollY &&
                    (_nameFocusNode.hasFocus || _phoneFocusNode.hasFocus)) {
                  _nameFocusNode.unfocus();
                  _phoneFocusNode.unfocus();
                }

                setState(() {
                  ///用渐变色线段处理组件之间默认的距离
                  if (25 < scrollY) {
                    isShowLine = false;
                  } else {
                    isShowLine = true;
                    lineOffsetTop = 100 - scrollY;
                  }

                  //快速预订显示/隐藏
                  if (fastBookHeight <= scrollY) {
                    isShowFastBookIcon = true;
                  } else if (131 >= scrollY) {
                    isShowFastBookIcon = false;
                  }

                  ///处理餐厅栏悬浮问题
                  isShowFloatingHall = offsetHallTop <= scrollY;
                });
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(left: 14, top: 5),
                      decoration:
                          BoxDecoration(gradient: Gradients.blueLinearGradient),
                      height: 25,
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        '广州请上座信息科技有限公司',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  _buildSearch(),
                  _topMenuList != null && _topMenuList.length != 0? SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      decoration:
                          BoxDecoration(gradient: Gradients.blueLinearGradient),
                      height: 107,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _initMainActions(),
                      ),
                    ),
                  ) : new SliverToBoxAdapter(child: new Container(height: 0,),),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            key: keyFastBook,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            child: Column(
                              children: <Widget>[
                                _buildTabBar(),
                                _buildDropDownTitle(
                                  icon: Image.asset(
                                    'assets/images/ic_message.png',
                                    width: 14,
                                    height: 16,
                                    fit: BoxFit.fill,
                                  ),
                                  title: textFastBookTime,
                                  callback: _showTimeSelector,
                                ),
                                Divider(
                                    height: 1, color: ThemeColors.colorDEDEDE),
                                0 == _tabIndex
                                    ? _buildRegionAndType()
                                    : _buildNameAndPhone(),
                                _buildSearchBtn(),
                              ],
                            ),
                          ),
                          Container(height: 14, color: ThemeColors.colorF2F2F2),
                          SizedBox(height: 20),
                          GridView.count(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(0),
                            crossAxisCount: 4,
                            scrollDirection: Axis.vertical,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 14,

                            ///按��例显示
                            childAspectRatio: 1.5,
                            physics: NeverScrollableScrollPhysics(),
                            //children: gridItems != null ? gridItems : new List(),
                            children: _buildGridTileList(_quickDataList != null ? _quickDataList.length : 0),
                          ),
                          SizedBox(height: 20),
                          Container(height: 10, color: ThemeColors.colorF2F2F2),
                          _buildHallTitle(),
                          Container(
                            key: keyHall,
                            child: HallFilter(
                              timeCallback: () {
                                _clickScrollToTop();
                                Future.delayed(
                                    Duration(milliseconds: scrollToTopDuration),
                                    _clickHallTime);
                              },
                              numPeopleCallback: () {
                                _clickScrollToTop();
                                Future.delayed(
                                    Duration(milliseconds: scrollToTopDuration),
                                    _clickHallNumPeople);
                              },
                              perCallback: () {
                                _clickScrollToTop();
                                Future.delayed(
                                    Duration(milliseconds: scrollToTopDuration),
                                    _clickHallPer);
                              },
                              regionCallback: () {
                                _clickScrollToTop();
                                Future.delayed(
                                    Duration(milliseconds: scrollToTopDuration),
                                    _clickHallRegion);
                              },
                              dishCallback: () {
                                _clickScrollToTop();
                                Future.delayed(
                                    Duration(milliseconds: scrollToTopDuration),
                                    _clickHallDish);
                              },
                              moreCallback: () {
                                _clickScrollToTop();
                                Future.delayed(
                                    Duration(milliseconds: scrollToTopDuration),
                                    _clickHallMore);
                              },
                            ),
                          ),
                          ListView.separated(
                            padding: const EdgeInsets.all(0),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return ItemHall(
                                  imgUrl: _businessList[i].imgUrl,
                                  title: _businessList[i].title,
                                  price: '￥' + _businessList[i].perPerson + "/人",
                                  //location: '粤菜 | 广州大道南 · 1.95km',
                                  location: _businessList[i].dishes + ' | '
                                      + _businessList[i].zoneName + " · "
                                      + _businessList[i].distance,
                                  remark: _businessList[i].shopName);
                            },
                            separatorBuilder: (context, i) {
                              return SizedBox(height: 0);
                            },
                            itemCount: _businessList.length,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 24),
            height: 2,
            decoration: BoxDecoration(gradient: Gradients.blueLinearGradient),
          ),
          Offstage(
            offstage: !isShowLine,
            child: Container(
              margin: EdgeInsets.only(top: lineOffsetTop),
              height: 1,
              decoration: BoxDecoration(gradient: Gradients.blueLinearGradient),
            ),
          ),
          Offstage(
            offstage: !isShowFloatingHall,
            child: Container(
              margin: const EdgeInsets.only(top: 75),
              width: double.infinity,
              color: Colors.white,
              height: hallHeight,
              child: HallFilter(
                timeCallback: _clickHallTime,
                numPeopleCallback: _clickHallNumPeople,
                perCallback: _clickHallPer,
                regionCallback: _clickHallRegion,
                dishCallback: _clickHallDish,
                moreCallback: _clickHallMore,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 快速菜单网格布局
  List<Widget> _buildGridTileList(int length) {
    List<Widget> widgetList = new List();
    for (int i = 0; i < length; i++) {
      widgetList.add(_buildGridItem(_quickDataList[i].imgUrl, _quickDataList[i].adName, ()=>_clickQuickMenuItem(i)));
    }
    return widgetList;
  }

  /// 快速菜单点击事件
  void _clickQuickMenuItem(int i) {
    Toast.toast(context, _quickDataList[i].adName);
  }

  ///创建全部餐厅标题
  Container _buildHallTitle() {
    return Container(
      height: 52,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Text(
            '全部餐厅',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ThemeColors.color1A1A1A),
          ),
          Positioned(
            right: 0,
            child: Row(
              children: <Widget>[
                Text(
                  '更多',
                  style: style12a6a6a6,
                ),
                Container(
                  width: 14,
                  height: 14,
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'assets/images/ic_message.png',
                    width: 9,
                    height: 9,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///快速预定搜索按钮/团建提交按钮
  Widget _buildSearchBtn() {
    return Row(
      children: <Widget>[
        0 == _tabIndex
            ? GestureDetector(
                onTap: () {
                  Application.getEventBus().fire(EventType.goServer);
                },
                child: Container(
                  width: 94,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 1,
                      color: ThemeColors.colorA6A6A6,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Center(
                          child: Image.asset(
                            'assets/images/ic_message.png',
                            width: 12,
                            height: 13,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Text(
                        '订餐秘书',
                        style: const TextStyle(
                          fontSize: 12,
                          color: ThemeColors.color404040,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(width: 0),
        0 == _tabIndex ? SizedBox(width: 14) : SizedBox(width: 0),
        Expanded(
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            color: ThemeColors.color1A1A1A,
            onPressed: () {
              debugPrint('_privateBooking');
              if (_tabIndex == 0) {
                //todo:跳转到商家列表
              } else {
                _privateBooking();
              }
            },
            child: Text(
              0 == _tabIndex ? '搜索' : '提交',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  _privateBooking() {
    debugPrint('_privateBooking');
    if (phone.length == 11 && name.length > 0) {
      dio.post(Api.PRIVATE_BOOK, queryParameters: {
        "book_time":
            '${searchConditionData.date[dateIndex].date} ${searchConditionData.time[timeIndex]}:00',
        "number": searchConditionData.numbers[numberIndex].toString(),
        "phone": phone,
        "name": name
      }).then((data) {
        var sources = jsonDecode(data.toString());
        if (sources['error_code'] == '0') {
          SaveImageToast.toast(context, '已成功提交需求', true);
        } else {
          Toast.toast(context, sources['msg']);
        }
      });
    } else {
      Toast.toast(context, '请输入姓名和手机号');
    }
  }

  ///创建搜索栏
  Widget _buildSearch() {
    ///SliverPersistentHeader好处为可以固定高度不变同时,设置渐变背景色
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 50,
        maxHeight: 50,
        child: Container(
          decoration: BoxDecoration(gradient: Gradients.blueLinearGradient),
          height: 50,
          width: 50,
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: _clickCityPick,
                child: Container(
                  color: Colors.transparent,
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 14),
                      Text(currentCity.cityName, style: style12white),
                      SizedBox(
                        width: 20,
                        height: double.infinity,
                        child: Center(
                          child: Image.asset(
                            'assets/images/ic_message.png',
                            width: 8,
                            height: 4,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: ThemeColors.colorF2F2F2,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                      Text(
                        _searchMotion != null ? _searchMotion + _searchTip : '',
                        style: style12a6a6a6,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 18),
              isShowFastBookIcon
                  ? GestureDetector(
                      onTap: () {
                        _tabController.index = 0;
                        setState(() {
                          _tabIndex = 0;
                        });
                        Future.delayed(Duration(milliseconds: 200), () {
                          setState(() {
                            isShowFastBookIcon = false;
                          });
                        });
                        _scrollController.animateTo(_isCompany ? 132 : 0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
                      child: Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/ic_message.png',
                                width: 16,
                                height: 16,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(height: 2),
                              Text(
                                '快速预定',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 8, color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(width: 10)
                        ],
                      ),
                    )
                  : SizedBox(width: 0),
              GestureDetector(
                onTap: () {
                  if (isHallPopupShow) {
                    overlayTime.remove();
                  }
                  Application.getEventBus().fire(EventType.goServer);
                },
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
                      style: const TextStyle(fontSize: 8, color: Colors.white),
                    )
                  ],
                ),
              ),
              SizedBox(width: 17),
            ],
          ),
        ),
      ),
    );
  }

  ///创建顶部主要的4个action
  Widget _buildMainAction(String icon, String text, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 45,
            height: 45,
            child: Center(
              child: Image.network(icon, width: 28, height: 35, fit: BoxFit.fill),
            ),
          ),
          SizedBox(height: 12),
          Text(
            text,
            style: style12white,
          )
        ],
      ),
    );
  }

  ///创建TabBar
  Widget _buildTabBar() {
    return Container(
      alignment: Alignment.center,
      height: 40,
      width: double.infinity,
      decoration: ShapeDecoration(
        shape: UnderlineInputBorder(
            borderSide: BorderSide(
                color: ThemeColors.colorDEDEDE,
                width: 1,
                style: BorderStyle.solid)),
      ),
      child: Stack(
        children: <Widget>[
          TabBar(
            controller: _tabController,
            tabs: _tabs,
            labelPadding: EdgeInsets.only(top: 10),
            isScrollable: false,
            indicatorColor: ThemeColors.color3F4688,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: ThemeColors.color3F4688,
            labelStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelColor: ThemeColors.colorA6A6A6,
            unselectedLabelStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
            onTap: (int index) {
              this.setState(() {
                _tabIndex = index;
              });
            },
          ),
          Positioned(
            top: 8,
            right: ScreenUtil.getScreenW(context) * 0.106,
            child: Container(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
              decoration: BoxDecoration(
                color: ThemeColors.color555C9E,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: Text(
                '定制',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 8, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///下拉标题组件,1个icon,2个标题
  Widget _buildDropDownTitle(
      {@required Image icon,
      @required String title,
      @required VoidCallback callback,
      String subTitle = ''}) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        color: Colors.transparent,
        height: 52,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 24,
              height: 24,
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(6, 4, 4, 4),
                child: icon,
              ),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style:
                  const TextStyle(fontSize: 16, color: ThemeColors.color404040),
            ),
            SizedBox(width: 6),
            ObjectUtil.isEmptyString(subTitle)
                ? SizedBox(width: 0)
                : Container(
                    height: 24,
                    padding: const EdgeInsets.only(top: 4),
                    alignment: Alignment.center,
                    child: Text(
                      subTitle,
                      style: const TextStyle(
                          fontSize: 10, color: ThemeColors.color404040),
                    ),
                  ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(
                  width: 14,
                  height: 14,
                  child: Center(
                    child: Image.asset('assets/images/ic_message.png',
                        width: 8, height: 4, fit: BoxFit.fill),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///创建快速预定tab区域和菜系
  Widget _buildRegionAndType() {
    return SizedBox(
      height: 52,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: _buildDropDownTitle(
              icon: Image.asset('assets/images/ic_message.png',
                  width: 12, height: 16, fit: BoxFit.fill),
              title: areaTitle,
              subTitle: areaSubtitle,
              callback: () {
                _showAreaPicker();
              },
            ),
          ),
          Container(
            height: 24,
            width: 1,
            color: ThemeColors.colorDEDEDE,
          ),
          Flexible(
            flex: 1,
            child: _buildDropDownTitle(
              icon: Image.asset('assets/images/ic_message.png',
                  width: 20, height: 14, fit: BoxFit.fill),
              title: dishTitle,
              subTitle: dishSubtitle,
              callback: () {
                _showDishPicker();
              },
            ),
          )
        ],
      ),
    );
  }

  ///显示区域选择器Dialog
  _showAreaPicker() {
    debugPrint('_showAreaPicker');
    if (areaPicker == null) {
      areaPicker = OverlayEntry(builder: (context) {
        return HomeLinkPicker(
          pickerBeans: areaSelectorBeans,
          onCloseEvent: () {
            areaPicker.remove();
          },
          onFinishEvent: (firstIndex, secondIndex) {
            debugPrint(
                'firstIndex = ${firstIndex.toString()}, secondIndex = ${secondIndex.toString()}');
            areaPicker.remove();
            setState(() {
              areaIndex = firstIndex;
              areaTitle = areaSelectorBeans[areaIndex].aliasName;
              areaSubIndex = secondIndex;
              areaSubtitle = areaSelectorBeans[areaIndex].subItems.length > 0
                  ? areaSelectorBeans[areaIndex]
                      .subItems[areaSubIndex]
                      .aliasName
                  : '全部';
            });
          },
          firstLevelIndex: areaIndex,
          secondLevelIndex: areaSubIndex,
        );
      });
    }
    Overlay.of(context).insert(areaPicker);
  }

  ///显示菜系选择器Dialog
  _showDishPicker() {
    if (dishPicker == null) {
      dishPicker = OverlayEntry(builder: (context) {
        return HomeLinkPicker(
          pickerBeans: dishSelectorBeans,
          onCloseEvent: () {
            dishPicker.remove();
          },
          onFinishEvent: (firstIndex, secondIndex) {
            debugPrint(
                'firstIndex = ${firstIndex.toString()}, secondIndex = ${secondIndex.toString()}');
            dishPicker.remove();
            setState(() {
              dishIndex = firstIndex;
              dishTitle = dishSelectorBeans[dishIndex].aliasName;
              dishSubIndex = secondIndex;
              dishSubtitle = dishSelectorBeans[dishIndex].subItems.length > 0
                  ? dishSelectorBeans[dishIndex]
                      .subItems[dishSubIndex]
                      .aliasName
                  : '全部';
            });
          },
          firstLevelIndex: dishIndex,
          secondLevelIndex: dishSubIndex,
        );
      });
    }
    Overlay.of(context).insert(dishPicker);
  }

  ///创建姓名和手机
  Widget _buildNameAndPhone() {
    return SizedBox(
      height: 52,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: _buildTextEdiText(
              tvBig: 'N',
              tvSm: 'am',
              hint: '姓名',
              inputType: TextInputType.text,
              focusNode: _nameFocusNode,
              controller: _nameController,
            ),
          ),
          Container(
            color: ThemeColors.colorDEDEDE,
            width: 1,
            height: 24,
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(width: 14),
                Expanded(
                  child: _buildTextEdiText(
                    tvBig: 'P',
                    tvSm: 'hon',
                    hint: '手机',
                    inputType: TextInputType.phone,
                    focusNode: _phoneFocusNode,
                    controller: _phoneController,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ///组件1个Text,一个EditText
  Widget _buildTextEdiText({
    @required String tvBig,
    @required String tvSm,
    @required String hint,
    @required TextInputType inputType,
    @required FocusNode focusNode,
    @required TextEditingController controller,
  }) {
    return Row(
      children: <Widget>[
        Container(
          width: 28,
          height: 24,
          padding: const EdgeInsets.fromLTRB(2, 4, 2, 4),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: tvBig,
                  style: const TextStyle(
                      fontSize: 12, color: ThemeColors.color404040)),
              TextSpan(
                  text: tvSm,
                  style: const TextStyle(
                      fontSize: 8, color: ThemeColors.color404040)),
            ]),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: inputType,
            focusNode: focusNode,
            cursorRadius: Radius.circular(0),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 16,
                color: ThemeColors.colorA6A6A6,
              ),
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }

  ///创建GridView item
  Widget _buildGridItem(String icon, String title, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: 54,
        height: 20,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child:
                  Image.network(icon, width: 32, height: 32, fit: BoxFit.cover),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style:
                  const TextStyle(fontSize: 12, color: ThemeColors.color404040),
            )
          ],
        ),
      ),
    );
  }

  ///创建时间选择器
  Widget _showTimeSelector() {
    if (null == timeSelector) {
      timeSelector = OverlayEntry(builder: (context) {
        return TimeSelectorDialog(
          dateData: dateData,
          timeData: timeData,
          bitData: bitData,
          callback: (results) {
            print('$results');
            setState(() {
              timeSelector.remove();
              dateIndex = results[0];
              timeIndex = results[1];
              numberIndex = results[2];
              textFastBookTime =
                  '${dateData[results[0]].title} ${dateData[results[0]].subTitle} ${timeData[results[1]].title}，${bitData[results[2]].title}';
            });
          },
          dismissAction: () => timeSelector.remove(),
        );
      });
    }
    Overlay.of(context).insert(timeSelector);
  }

  ///点击滚动到顶部
  _clickScrollToTop() {
    _scrollController.animateTo(offsetHallTop,
        duration: Duration(milliseconds: 100), curve: Curves.easeIn);
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

  ///城市选择
  _clickCityPick() {
    var marginTop = MediaQuery.of(context).padding.top + 76;
    if (25 >= scrollY) {
      marginTop -= scrollY;
    } else {
      marginTop = MediaQuery.of(context).padding.top + 51;
    }

    citySelectorPopupWindow = CitySelectorPopupWindow(
      position: currentCity.cityName,
      margin: marginTop,
      cityList: cityList,
      dismissAction: () => overlayCity.remove(),
      callback: (index) {
        if (-1 == index) {
          Toast.toast(context, '你点击了定位城市');
        } else {
          AppInit.OpenCitys openCity =
              DataUtils.getAppInitInfo().openCitys[index];
          if (openCity.regionId != currentCity.cityId) {
            DataUtils.saveCityId(openCity.regionId);
            setState(() {
              currentCity = AppInit.CurrentCity(
                  cityName: openCity.regionName, cityId: openCity.regionId);
            });
            initData();
          }
        }
        overlayCity.remove();
      },
    );

    overlayCity = OverlayEntry(builder: (context) => citySelectorPopupWindow);
    Overlay.of(context).insert(overlayCity);
  }

  @override
  bool get wantKeepAlive => true;
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
