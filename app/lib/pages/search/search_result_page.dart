import 'dart:convert';

import 'package:app/Application.dart';
import 'package:app/api/api.dart';
import 'package:app/constant.dart';
import 'package:app/http.dart';
import 'package:app/model/custom_scroll_bean.dart';
import 'package:app/model/event.dart';
import 'package:app/model/home_buiness_list_bean.dart' as BusinessInfo;
import 'package:app/model/home_link_picker_bean.dart';
import 'package:app/model/req_business_list_bean.dart';
import 'package:app/model/search_condition_bean.dart' as SC;
import 'package:app/pages/pages_index.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/model/common_bean.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/*
 * 搜索结果页/宴会宴请 Page
 **/
class SearchResultPage extends StatefulWidget {
  //日期数据
  List<CustomScrollBean> dateData;

  //时间数据
  List<CustomScrollBean> timeData;

  //位数数据
  List<CustomScrollBean> bitData;

  //预算数据
  List<CustomScrollBean> budgetData;

  //更多数据
  List<MoreModel> moreLists = [];

  //区域和菜系index
  int areaIndex = 0;
  int dishIndex = 0;

  SearchResultPage(
      {this.dateData,
      this.timeData,
      this.bitData,
      this.budgetData,
      this.moreLists,
      this.areaIndex,
      this.dishIndex});

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
  List<MoreModel> moreLists = [];

  //餐厅列表数据
  List<BusinessInfo.BusinessList> _businessList = List();

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

  //商家列表接口请求bean
  ReqBusinessListBean reqBusinessListBean;

  //餐厅筛选栏
  GlobalKey keyHallFilter = GlobalKey(debugLabel: 'search_result_hall');

  //文本控制器
  TextEditingController _textEditingController;

  //刷新控制器
  RefreshController _refreshController;

  //PopupWindow的类型
  int popupType = 0;

  //当前加载的页数
  int page = 1;

  //当前餐厅筛选栏PopupWindow是否显示
  bool isHallPopupShow = false;

  //是否为商务宴请
  bool isBusinessDinner = false;

  //餐厅列表是否为空
  bool isListEmpty = false;

  //当前是否为猜你喜欢数据
  bool isGuess = false;

  //餐厅筛选栏的高度
  double hallHeight = 0.0;

  //其他页面传递过来的搜索值
  String value;

  //输入框hint值
  var hintText;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();

    _refreshController = RefreshController(initialRefresh: false);

    _textEditingController.addListener(() {
      setState(() {});
    });

    //从sp中获取推荐内容
    hintText =
        SpUtil.getString(Constant.sp_search_motion, defValue: '附近热门推荐：') +
            SpUtil.getString(Constant.sp_search_tip, defValue: '至正小菜');

    _initHallFilterPopupWindow();

    _initData();

    //组件渲染完成
    WidgetsBinding.instance.addPostFrameCallback((context) {
      RenderBox hallBox = keyHallFilter.currentContext.findRenderObject();
      setState(() {
        hallHeight = hallBox.size.height;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  ///获取商家列表
  _getBusinessList() {
    reqBusinessListBean.keywords = _textEditingController.text;
    dio
        .get(Api.BUSINESS_LIST, queryParameters: reqBusinessListBean.toJson())
        .then((data) {
      var sources = jsonDecode(data.data);
      BusinessInfo.HomeBusinessInfo businessInfo =
          BusinessInfo.HomeBusinessInfo.fromJson(sources);
      if (businessInfo != null && businessInfo.errorCode == Api.SUCCESS_CODE) {
        isListEmpty = ObjectUtil.isEmptyList(businessInfo.data.list);
        if ((isGuess && ObjectUtil.isEmptyList(businessInfo.data.guess)) ||
            (!isGuess && isListEmpty)) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
          reqBusinessListBean.page = '${++page}';
        }

        setState(() {
          if (isListEmpty && 1 == page && !isGuess) {
            isGuess = true;
            _businessList.clear();
            _businessList.add(null);
            _businessList.add(null);
            _businessList.addAll(businessInfo.data.guess);
          } else if (isGuess) {
            _businessList.addAll(businessInfo.data.guess);
          } else {
            isGuess = false;
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

  @override
  Widget build(BuildContext context) {
    if (null == reqBusinessListBean) {
      reqBusinessListBean = ModalRoute.of(context).settings.arguments;
      reqBusinessListBean ??= ReqBusinessListBean();
      reqBusinessListBean.page = '1';
      //把传递过来的值设置到输入框上
      _textEditingController.text = reqBusinessListBean.keywords;
      _getBusinessList();
    }

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
                        color: Colors.transparent,
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
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
                                    child: Center(
                                      child: Icon(Icons.search),
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
                                        child: TextFormField(
                                          controller: _textEditingController,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: ThemeColors.color404040),
                                          maxLines: 1,
                                          keyboardType: TextInputType.text,
                                          textInputAction:
                                              TextInputAction.search,
                                          onFieldSubmitted: (text) {
                                            isGuess = false;
                                            page = 1;
                                            reqBusinessListBean.page = '1';
                                            _businessList?.clear();
                                            _getBusinessList();
                                          },
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.only(top: 2),
                                            hintText: hintText,
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
                                  0 == _textEditingController.text.length
                                      ? SizedBox()
                                      : GestureDetector(
                                          onTap: () =>
                                              _textEditingController.clear(),
                                          child: Container(
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            child: Icon(Icons.clear),
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
                          textStyle: const TextStyle(
                            fontSize: 14,
                            color: ThemeColors.colorA6A6A6,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              ///显示没有找到符合的条件内容
                              if (0 == i && isGuess) {
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
                                                  color:
                                                      ThemeColors.colorA6A6A6,
                                                  width: 1),
                                            ),
                                            child: FlatButton(
                                              onPressed: _postDemand,
                                              padding: const EdgeInsets.all(0),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14)),
                                              child: Text(
                                                '上报需求',
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
                                              border: Border.all(
                                                  color:
                                                      ThemeColors.colorA6A6A6,
                                                  width: 1),
                                            ),
                                            child: FlatButton(
                                              onPressed: () {
                                                Application.getEventBus()
                                                    .fire(EventType.goServer);
                                                Navigator.of(context).popUntil(
                                                    ModalRoute.withName(
                                                        Page.ROOT_PAGE));
                                              },
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
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }

                              ///显示猜你喜欢行
                              if (1 == i && isGuess) {
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

                              return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (_) {
                                      return BusinessDetailPage(
                                          _businessList[i].id);
                                    }));
                                  },
                                  child: Container(
                                    color: Colors.white,
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
                                  ));
                            },
                            separatorBuilder: (context, i) {
                              if (isListEmpty && (0 == i || 1 == i)) {
                                return SizedBox();
                              }

                              return Container(
                                margin: const EdgeInsets.only(left: 144),
                                height: 1,
                                color: ThemeColors.colorDEDEDE,
                              );
                            },
                            itemCount: _businessList?.length,
                          ),
                        ),
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
          reqBusinessListBean.bookTime =
              '${searchConditionData.date[results[0]].date}' +
                  ' ${timeData[1].title}';
          isGuess = false;
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
          isGuess = false;
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
          isGuess = false;
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
          isGuess = false;
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
            isGuess = false;
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
          isGuess = false;
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
    dateData = widget.dateData;
    timeData = widget.timeData;
    bitData = widget.bitData;
    budgetData = widget.budgetData;
    moreLists = widget.moreLists;
    if (null != widget.areaIndex) {
      areaIndex = widget.areaIndex;
    }
    if (null != widget.dishIndex) {
      dishIndex = widget.dishIndex;
    }

    ///请求筛选条件
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
          dateData ??= HomeFilterUtils.changeDateDataToScrollData(
              searchConditionData.date);
          timeData ??= HomeFilterUtils.changeTimeDataToScrollData(
              searchConditionData.time);
          bitData ??= HomeFilterUtils.changeNumberDataToScrollData(
              searchConditionData.numbers);
          budgetData ??= HomeFilterUtils.changePriceOptionDataToScrollData(
              searchConditionData.priceOption);
          moreLists ??=
              HomeFilterUtils.changeDataToMoreModelData(searchConditionData);
        });
      }
    });
  }

  ///提交需求
  _postDemand() {
    dio.get(Api.SEARCH_COMMIT_DEMAND, queryParameters: {
      "keywords": _textEditingController.text
    }).then((data) {
      var body = jsonDecode(data.toString());
      CommonBean bean = CommonBean.fromJson(body);
      if (Api.SUCCESS_CODE == bean.errorCode) {
        Toast.toast(context, '上报成功，我们会尽快进行洽谈');
      } else {
        Toast.toast(context, bean?.msg);
      }
    });
  }
}
