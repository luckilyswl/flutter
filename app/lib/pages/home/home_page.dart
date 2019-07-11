import 'dart:convert';
import 'dart:math' as math;
import 'package:app/model/app_init_bean.dart' as AppInit;
import 'package:app/model/home_link_picker_bean.dart';
import 'package:app/model/req_business_list_bean.dart';
import 'package:app/model/search_condition_bean.dart' as SC;
import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/widget/hall_filter/hall_link_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/res/res_index.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:app/model/custom_scroll_bean.dart';
import 'package:app/Application.dart';
import 'package:app/model/event.dart';
import 'package:app/pages/pages_index.dart';
import 'package:app/model/home_info_bean.dart' as HomeInfo;
import 'package:app/model/home_buiness_list_bean.dart' as BusinessInfo;
import 'package:app/constant.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/*
 * 首页
 **/
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String _searchMotion;
  String _searchTip;
  bool _isCompany = false;
  HomeInfo.DataBean _dataBean;
  List<HomeInfo.TopMenuListBean> _topMenuList;
  List<HomeInfo.QuickDataListBean> _quickDataList;
  List<BusinessInfo.BusinessList> _businessList;

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
  List<MoreModel> moreLists = [];

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

  //商家列表接口请求bean
  ReqBusinessListBean reqBusinessListBean;

  //刷新控制器
  RefreshController _refreshController;

  //渐变色线段距离顶部距离
  var lineOffsetTop = 100.0;

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
  List<Widget> gridItems = List();

  //快速预订宽高
  var fastBookIconWidth = 0.0;
  var fastBookIconHeight = 0.0;

  //是否显示快速预订按钮
  var isShowFastBookIcon = false;

  //是否显示餐厅栏时间选择器
  var isShowHallTimeSelector = true;

  //顶部4个action
  List<Widget> mainActions = List();

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

  //当前加载的页数
  int page = 1;

  //当前餐厅筛选栏PopupWindow是否显示
  bool isHallPopupShow = false;

  //是否为第一次滚动测量组件宽高
  bool isFirstScrollToMeasure = true;

  //是否为空数据
  bool isEmpty = false;

  //当前城市名称
  String _currentCityName;

  //当前城市id
  int _currentCityId;

  //是否显示悬浮顶部actionbar
  bool isShowFloatingActionBar = false;

  @override
  void initState() {
    initData();
    _tabs = [
      Tab(text: '快速预订'),
      Tab(text: '团建&会议'),
    ];
    _tabController =
        TabController(initialIndex: 0, length: _tabs.length, vsync: this);

    _refreshController = RefreshController(initialRefresh: false);

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
      currentCity = DataUtils.getAppInitInfo().currentCity;
      _currentCityName = currentCity.cityName;
      _currentCityName ??= '广州市';
      _currentCityId = currentCity.cityId;
      _currentCityId ??= 2253;
      cityList = HomeFilterUtils.changeOpenCityDataToCityModelData(
          DataUtils.getAppInitInfo().openCitys, currentCity.cityName);
    } else {
      currentCity = AppInit.CurrentCity(cityId: 2253, cityName: '广州市');
      cityList = <CityModel>[CityModel(city: '广州市', hasBg: true)];
    }

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

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  void initData() {
    ///首页接口
    dio.get(Api.INDEX_HOME).then((data) {
      var sources = jsonDecode(data.data);
      HomeInfo.HomeInfoBean info = HomeInfo.HomeInfoBean.fromJson(sources);
      if (info.errorCode == Api.SUCCESS_CODE) {
        _dataBean = info.data;
        if (_dataBean != null) {
          _searchMotion = _dataBean.indexSearchMotion;
          _searchTip = _dataBean.indexSearchTip;
          _isCompany = _dataBean.isCompany == 1;
          _topMenuList = _dataBean.topMenu;
          _quickDataList = _dataBean.quickData;

          //保存推荐内容
          SpUtil.putString(Constant.sp_search_motion, _searchMotion);
          SpUtil.putString(Constant.sp_search_tip, _searchTip);

          Future.delayed(Duration(milliseconds: 200), () {
            //重新测量餐厅筛选栏offsetTop
            if (keyHall.currentContext != null) {
              RenderBox hall = keyHall.currentContext.findRenderObject();
              Offset offset = hall.localToGlobal(Offset.zero);
              offsetHallTop = offset.dy - 75;
            }

            //重新测量快速预订/团建高度
            if (keyFastBook.currentContext != null) {
              RenderBox fastBook =
                  keyFastBook.currentContext.findRenderObject();
              if (_isCompany) {
                fastBookHeight = fastBook.size.height + 145;
              } else {
                fastBookHeight = fastBook.size.height + 38;
              }
            }
          });
        }
      } else {
        Toast.toast(context, info.msg);
      }
    });

    ///搜索条件
    dio.get(Api.SEARCH_CONDITIONS).then((data) {
      var sources = jsonDecode(data.toString());
      SC.SearchConditionBean bean = SC.SearchConditionBean.fromJson(sources);
      SC.Data dataBean = bean.data;

      if (bean.errorCode == Api.SUCCESS_CODE) {
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
          moreLists =
              HomeFilterUtils.changeDataToMoreModelData(searchConditionData);
        });
      }
    });

    _businessList = [];

    ///商家列表请求数据
    reqBusinessListBean = ReqBusinessListBean();
    _getBusinessList();
  }

  ///获取商家列表
  _getBusinessList() {
    dio
        .get(Api.BUSINESS_LIST, queryParameters: reqBusinessListBean.toJson())
        .then((data) {
      var sources = jsonDecode(data.data);
      BusinessInfo.HomeBusinessInfo businessInfo =
          BusinessInfo.HomeBusinessInfo.fromJson(sources);
      if (businessInfo != null && businessInfo.errorCode == Api.SUCCESS_CODE) {
        isEmpty = ObjectUtil.isEmptyList(businessInfo.data.list);
        if (_refreshController.isLoading) {
          if (isEmpty) {
            _refreshController.loadNoData();
          } else {
            _refreshController.loadComplete();
            reqBusinessListBean.page = '${++page}';
          }
        }
        setState(() {
          if (isEmpty && 1 == page) {
            _businessList.clear();
            _businessList.add(null);
            page = 1;
            reqBusinessListBean.page = '1';
          } else {
            _businessList.addAll(businessInfo.data.list);
          }
        });
      } else {
        if (_refreshController.isLoading) {
          _refreshController.loadFailed();
        }
        Toast.toast(context, businessInfo.msg);
      }
    });
    print('${reqBusinessListBean.toJson()}');
  }

  /// 顶部菜单
  List<Widget> _initMainActions() {
    mainActions.clear();
    _topMenuList.forEach((f) {
      mainActions.add(_buildMainAction(f.imgUrl, f.adName,
          () => _clickTopMenuItem(_topMenuList.indexOf(f))));
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
          reqBusinessListBean.bookTime =
              '${searchConditionData.date[results[0]].date}' +
                  ' ${timeData[1].title}';
          _businessList?.clear();
          page = 1;
          reqBusinessListBean.page = '1';
          _getBusinessList();
          _dismissHallFilterPopupWindow();
        },
      ),
      hallNumPeopleSelector: HallCustomScrollSelector2(
        title: '，几位？',
        firstData: bitData,
        callback: (results) {
          reqBusinessListBean.numbers =
              searchConditionData.numbers[results[0]].toString();
          _businessList?.clear();
          page = 1;
          reqBusinessListBean.page = '1';
          _getBusinessList();
          _dismissHallFilterPopupWindow();
        },
      ),
      hallPerSelector: HallCustomScrollSelector3(
        title: '，预算多少？',
        firstData: budgetData,
        callback: (results) {
          reqBusinessListBean.priceOption = searchConditionData
              .priceOption.items[results[0]].value
              .toString();
          _businessList?.clear();
          page = 1;
          reqBusinessListBean.page = '1';
          _getBusinessList();
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
          setState(() {
            areaIndex = firstIndex;
            areaSubIndex = secondIndex;
          });

          //二级列表不能选择
          if (0 == firstIndex) {
            reqBusinessListBean.areaId = '';
            reqBusinessListBean.circleId = '';
          } else {
            reqBusinessListBean.areaId =
                areaSelectorBeans[firstIndex].id.toString();
            reqBusinessListBean.circleId = areaSelectorBeans[firstIndex]
                .subItems[secondIndex]
                .id
                .toString();
          }
          _businessList?.clear();
          page = 1;
          reqBusinessListBean.page = '1';
          _getBusinessList();
          _dismissHallFilterPopupWindow();
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
            setState(() {
              dishIndex = firstIndex;
              dishSubIndex = secondIndex;
            });

            //二级列表不能选择
            if (0 == firstIndex) {
              reqBusinessListBean.dishes = '';
            } else {
              reqBusinessListBean.dishes = dishSelectorBeans[firstIndex]
                  .subItems[secondIndex]
                  .id
                  .toString();
            }
            _businessList?.clear();
            page = 1;
            reqBusinessListBean.page = '1';
            _getBusinessList();
            _dismissHallFilterPopupWindow();
          },
          firstLevelIndex: dishIndex,
          secondLevelIndex: dishSubIndex,
          margin: EdgeInsets.only(top: 157)),
      hallMoreSelector: HallMoreSelector(
        moreLists: moreLists,
        dismissAction: _dismissHallFilterPopupWindow,
        sureCallback: () {
          String param = '';
          moreLists.forEach((f) {
            param = '';
            f.values.forEach((a) => param += ',$a');
            if (0 != f.values.length) {
              param = param.substring(1, param.length);
            }

            if (Constant.more_filter_room_type == f.key) {
              reqBusinessListBean.roomType = param;
            } else if (Constant.more_filter_environment == f.key) {
              reqBusinessListBean.environment = param;
            } else if (Constant.more_filter_distance_order == f.key) {
              reqBusinessListBean.distanceOrder = param;
            } else if (Constant.more_filter_devices == f.key) {
              reqBusinessListBean.devices = param;
            } else if (Constant.more_filter_scene == f.key) {
              reqBusinessListBean.scene = param;
            }
          });
          _businessList?.clear();
          page = 1;
          reqBusinessListBean.page = '1';
          _getBusinessList();
        },
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
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Container(
            height: 199,
            width: ScreenUtil.getScreenW(context),
            child: Image.asset(
              'assets/images/ic_home_bg.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),

            ///滚动监听
            child: NotificationListener(
              onNotification: (ScrollNotification notification) {
                ///不处理横向滚动
                if (Axis.horizontal == notification.metrics.axis) {
                  return;
                }

                scrollY = notification.metrics.pixels;

                ///滑到顶部清除输入框的焦点
                if (90 <= scrollY &&
                    (_nameFocusNode.hasFocus || _phoneFocusNode.hasFocus)) {
                  _nameFocusNode.unfocus();
                  _phoneFocusNode.unfocus();
                }

                if (isFirstScrollToMeasure) {
                  isFirstScrollToMeasure = false;

                  ///重新测量餐厅筛选栏offsetTop
                  RenderBox hall = keyHall.currentContext.findRenderObject();
                  Offset offset = hall.localToGlobal(Offset.zero);
                  offsetHallTop = offset.dy - 75;

                  ///重新测量快速预订/团建高度
                  RenderBox fastBook =
                      keyFastBook.currentContext.findRenderObject();
                  if (_isCompany) {
                    fastBookHeight = fastBook.size.height + 145;
                  } else {
                    fastBookHeight = fastBook.size.height + 10;
                  }
                }

                setState(() {
                  ///快速预订显示/隐藏
                  if (fastBookHeight <= scrollY) {
                    isShowFastBookIcon = true;
                  }

                  if (_isCompany) {
                    if (131 >= scrollY) {
                      isShowFastBookIcon = false;
                    }
                  } else {
                    if (24 >= scrollY) {
                      isShowFastBookIcon = false;
                    }
                  }

                  ///悬浮顶部actionbar
                  if (_isCompany) {
                    if (25 <= scrollY) {
                      isShowFloatingActionBar = true;
                    } else {
                      isShowFloatingActionBar = false;
                    }
                  } else {
                    isShowFloatingActionBar = true;
                  }

                  ///处理餐厅栏悬浮问题
                  isShowFloatingHall = offsetHallTop <= scrollY;
                });
              },
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: false,
                enablePullUp: true,
                onLoading: _getBusinessList,
                footer: ClassicFooter(
                  loadingText: '加载中...',
                  noDataText: '没有更多数据',
                  idleText: '上拉加载更多...',
                  failedText: '加载失败!',
                ),
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    _isCompany
                        ? Container(
                            padding: const EdgeInsets.only(left: 14, top: 5),
                            height: 25,
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              '广州请上座信息科技有限公司',
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        : SizedBox(),
                    _buildSearch(),
                    _topMenuList != null && _topMenuList.length != 0
                        ? Container(
                            width: ScreenUtil.getScreenW(context),
                            height: 107,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: _initMainActions(),
                            ),
                          )
                        : SizedBox(),
                    Container(
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
                                  icon: Image.asset('assets/images/ic_edit.png',
                                      width: 24, height: 24),
                                  title: textFastBookTime,
                                  callback: _showTimeSelector,
                                ),
                                Divider(
                                    height: 1, color: ThemeColors.colorDEDEDE),
                                0 == _tabIndex
                                    ? _buildRegionAndType()
                                    : _buildNameAndPhone(),
                                _buildSearchBtn(),
                                SizedBox(height: 14)
                              ],
                            ),
                          ),
                          Container(height: 10, color: ThemeColors.colorF2F2F2),
                          ObjectUtil.isEmptyList(_quickDataList)
                              ? SizedBox()
                              : SizedBox(height: 20),
                          ObjectUtil.isEmptyList(_quickDataList)
                              ? SizedBox()
                              : GridView.count(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(0),
                                  crossAxisCount: 4,
                                  scrollDirection: Axis.vertical,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 14,

                                  ///按宽高比例显示
                                  childAspectRatio: 1.5,
                                  physics: NeverScrollableScrollPhysics(),
                                  children:
                                      _buildGridTileList(_quickDataList.length),
                                ),
                          ObjectUtil.isEmptyList(_quickDataList)
                              ? SizedBox()
                              : SizedBox(height: 20),
                          ObjectUtil.isEmptyList(_quickDataList)
                              ? SizedBox()
                              : Container(
                                  height: 10, color: ThemeColors.colorF2F2F2),
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
                              ///显示没有找到符合的条件内容
                              if (0 == i && isEmpty) {
                                return Container(
                                  height: 487,
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
                                                  color:
                                                      ThemeColors.colorA6A6A6,
                                                  width: 1),
                                            ),
                                            child: FlatButton(
                                              onPressed: () =>
                                                  Application.getEventBus()
                                                      .fire(EventType.goServer),
                                              padding: const EdgeInsets.all(0),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14)),
                                              child: Text(
                                                '联系客服',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        ThemeColors.color404040,
                                                    fontWeight:
                                                        FontWeight.normal,
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
                                            ),
                                            child: RaisedButton(
                                              onPressed: () {
                                                reqBusinessListBean.keywords =
                                                    '';
                                                reqBusinessListBean.areaId = '';
                                                reqBusinessListBean.roomType =
                                                    '';
                                                reqBusinessListBean
                                                    .environment = '';
                                                reqBusinessListBean.devices =
                                                    '';
                                                reqBusinessListBean
                                                    .distanceOrder = '';
                                                reqBusinessListBean.dishes = '';
                                                reqBusinessListBean.circleId =
                                                    '';
                                                reqBusinessListBean
                                                    .priceOption = '';
                                                reqBusinessListBean.numbers =
                                                    '';
                                                reqBusinessListBean.bookTime =
                                                    '';
                                                reqBusinessListBean.priceOrder =
                                                    '';
                                                reqBusinessListBean.scene = '';
                                                reqBusinessListBean.page = '1';
                                                dateData?.forEach(
                                                    (f) => f.hasBg = false);
                                                timeData?.forEach(
                                                    (f) => f.hasBg = false);
                                                bitData?.forEach(
                                                    (f) => f.hasBg = false);
                                                budgetData?.forEach(
                                                    (f) => f.hasBg = false);
                                                moreLists?.forEach((f) =>
                                                    f.gridData.forEach((a) =>
                                                        a.hasBg = false));
                                                moreLists?.forEach(
                                                    (f) => f.values?.clear());
                                                areaIndex = 0;
                                                dishIndex = 0;
                                                _businessList?.clear();
                                                page = 1;
                                                _refreshController
                                                    .loadComplete();
                                                _getBusinessList();
                                              },
                                              color: ThemeColors.color404040,
                                              padding: const EdgeInsets.all(0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              child: Text(
                                                '重置条件',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.normal,
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

                              return GestureDetector(
                                onTap: () {
                                  _clickRestaurantItem(i);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: ItemHall(
                                    imgUrl: _businessList[i]?.imgUrl,
                                    title: _businessList[i]?.title,
                                    price: '¥' +
                                        _businessList[i]?.perPerson +
                                        "/人",
                                    location: _businessList[i]?.dishes +
                                        ' | ' +
                                        _businessList[i]?.zoneName +
                                        " · " +
                                        _businessList[i]?.distance,
                                    remark: _businessList[i]?.shopName,
                                  ),
                                ),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Offstage(
            offstage: !isShowFloatingActionBar,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/ic_action_bar_bg.png'),
                      fit: BoxFit.fill)),
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: _buildSearch(),
            ),
          ),
          Offstage(
            offstage: !isShowFloatingHall,
            child: Container(
              margin: const EdgeInsets.only(top: 74),
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

  ///餐厅列表item点击事件,跳转到餐厅详情页
  void _clickRestaurantItem(int i) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return BusinessDetailPage(_businessList[i].id);
    }));
  }

  /// 快速菜单网格布局
  List<Widget> _buildGridTileList(int length) {
    List<Widget> widgetList = List();
    for (int i = 0; i < length; i++) {
      widgetList.add(_buildGridItem(_quickDataList[i].imgUrl,
          _quickDataList[i].adName, () => _clickQuickMenuItem(i)));
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
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SearchResultPage(
                          dateData: dateData,
                          timeData: timeData,
                          bitData: bitData,
                          budgetData: budgetData,
                          moreLists: moreLists,
                          areaIndex: areaIndex,
                          dishIndex: dishIndex);
                    },
                    settings: RouteSettings(arguments: reqBusinessListBean),
                  ),
                );
              },
              child: Row(
                children: <Widget>[
                  Text(
                    '更多',
                    style: FontStyles.style12A6A6A6,
                  ),
                  Container(
                    width: 14,
                    height: 14,
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      'assets/images/ic_more_grey.png',
                      width: 9,
                      height: 9,
                      fit: BoxFit.fill,
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

  ///快速预定搜索按钮/团建提交按钮
  Widget _buildSearchBtn() {
    return Row(
      children: <Widget>[
        0 == _tabIndex
            ? Container(
                width: 94,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1, color: ThemeColors.colorF2C785),
                ),
                child: FlatButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () =>
                      Application.getEventBus().fire(EventType.goServer),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Center(
                          child: Image.asset(
                            'assets/images/ic_phone_gold.png',
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
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                gradient: Gradients.blueLinearGradient,
                borderRadius: BorderRadius.circular(4)),
            child: FlatButton(
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              color: Colors.transparent,
              onPressed: () {
                if (_tabIndex == 0) {
                  //todo:跳转到商家列表
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => SearchResultPage(
                              dateData: dateData,
                              timeData: timeData,
                              bitData: bitData,
                              areaIndex: areaIndex,
                              dishIndex: dishIndex,
                            ),
                        settings:
                            RouteSettings(arguments: reqBusinessListBean)),
                  );
                } else {
                  _privateBooking();
                }
              },
              child: Text(
                0 == _tabIndex ? '搜索' : '提交',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: ThemeColors.colorF2C785),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _privateBooking() {
    debugPrint('_privateBooking');
    if (phone.length == 11 && name.length > 0) {
      dio.post(Api.PRIVATE_BOOK, data: {
        "book_time":
            '${searchConditionData.date[dateIndex].date} ${searchConditionData.time[timeIndex]}:00',
        "number": searchConditionData.numbers[numberIndex].toString(),
        "phone": phone,
        "name": name
      }).then((data) {
        var sources = jsonDecode(data.toString());
        if (sources['error_code'] == Api.SUCCESS_CODE) {
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
    return Container(
      height: 50,
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
                  Text(currentCity.cityName, style: FontStyles.style12FFFFFF),
                  Image.asset('assets/images/ic_xiala_white.png',
                      width: 20, height: 20),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: _clickTopSearch,
              child: Container(
                height: 28,
                decoration: BoxDecoration(
                  color: ThemeColors.colorF2F2F2,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/ic_search_grey.png',
                        width: 14, height: 14, fit: BoxFit.fill),
                    SizedBox(width: 4),
                    Text(
                      _searchMotion != null ? _searchMotion + _searchTip : '',
                      style: FontStyles.style12A6A6A6,
                    )
                  ],
                ),
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
                      Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/ic_fastbook.png',
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
                  'assets/images/ic_kefu.png',
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
              child:
                  Image.network(icon, width: 28, height: 35, fit: BoxFit.fill),
            ),
          ),
          SizedBox(height: 12),
          Text(
            text,
            style: FontStyles.style12FFFFFF,
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
            labelPadding: const EdgeInsets.only(top: 10),
            isScrollable: false,
            indicatorColor: ThemeColors.colorF2C785,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: ThemeColors.color404040,
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
                gradient: Gradients.goldDarkLinearGradient,
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
                style: const TextStyle(
                    fontSize: 8, color: ThemeColors.color2A2A33),
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
                    child: Image.asset('assets/images/ic_xiala_grey.png',
                        width: 14, height: 14),
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
              icon: Image.asset('assets/images/ic_location.png',
                  width: 24, height: 24),
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
              icon: Image.asset('assets/images/ic_dish.png',
                  width: 24, height: 24),
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

            //二级列表不能选择
            if (0 == firstIndex) {
              reqBusinessListBean.areaId = '';
              reqBusinessListBean.circleId = '';
            } else {
              reqBusinessListBean.areaId =
                  areaSelectorBeans[firstIndex].id.toString();
              reqBusinessListBean.circleId = areaSelectorBeans[firstIndex]
                  .subItems[secondIndex]
                  .id
                  .toString();
            }
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

            //二级列表不能选择
            if (0 == firstIndex) {
              reqBusinessListBean.dishes = '';
            } else {
              reqBusinessListBean.dishes = dishSelectorBeans[firstIndex]
                  .subItems[secondIndex]
                  .id
                  .toString();
            }
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
              image: Image.asset('assets/images/ic_fastbook_name.png',
                  width: 24, height: 24),
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
                    image: Image.asset('assets/images/ic_fastbook_phone.png',
                        width: 24, height: 24),
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
    @required Image image,
    @required String hint,
    @required TextInputType inputType,
    @required FocusNode focusNode,
    @required TextEditingController controller,
  }) {
    return Row(
      children: <Widget>[
        image,
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
            setState(() {
              timeSelector.remove();
              dateIndex = results[0];
              timeIndex = results[1];
              numberIndex = results[2];
              textFastBookTime =
                  '${dateData[results[0]].title} ${dateData[results[0]].subTitle} ${timeData[results[1]].title}，${bitData[results[2]].title}';
            });
            reqBusinessListBean.bookTime =
                '${searchConditionData.date[results[0]].date}' +
                    ' ${timeData[1].title}';
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
    var marginTop = _isCompany
        ? MediaQuery.of(context).padding.top + 75
        : MediaQuery.of(context).padding.top + 50;
    if (25 >= scrollY) {
      marginTop -= scrollY;
    } else {
      marginTop = MediaQuery.of(context).padding.top + 50;
    }

    citySelectorPopupWindow = CitySelectorPopupWindow(
      position: _currentCityName,
      margin: marginTop,
      cityList: cityList,
      dismissAction: () => overlayCity.remove(),
      callback: (index) {
        if (-1 == index) {
          DataUtils.saveCityId(_currentCityId);
          setState(() {
            cityList.forEach((f) {
              if (_currentCityName == f.city) {
                f.hasBg = true;
              } else {
                f.hasBg = false;
              }
            });
            currentCity = AppInit.CurrentCity(
                cityName: _currentCityName, cityId: _currentCityId);
          });
          initData();
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

  ///顶部搜索点击事件
  _clickTopSearch() {
    Navigator.of(context).pushNamed(Page.SEARCH_PAGE);
  }

  @override
  bool get wantKeepAlive => true;
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  SliverAppBarDelegate({
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
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
