import 'package:app/model/room_info_bean.dart';
import 'package:app/model/user_info_bean.dart' as User;
import 'package:app/pages/business/imageviewer.dart';
import 'dart:math' as math;
import 'package:app/pages/business/map.dart';
import 'package:app/pages/business/pagination.dart';
import 'package:app/widget/dialog/common_dialog.dart';
import 'package:app/widget/toast.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:app/model/custom_scroll_bean.dart';
import 'package:app/model/search_condition_bean.dart' as SC;
import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'dart:convert';
import 'package:app/pages/pages_index.dart';
import 'package:app/model/business_detail_bean.dart' as Detail;
import 'package:flutter_html/flutter_html.dart';
import 'package:app/pages/business/business_menu.dart';

class BusinessDetailPage extends StatefulWidget {
  final int businessId;

  BusinessDetailPage(this.businessId);

  @override
  _BusinessDetailState createState() => _BusinessDetailState();
}

class _BusinessDetailState extends State<BusinessDetailPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _businessId;
  double scroll = 0.0;
  double alpha = 0.0;
  List<String> _tabs = ['餐厅', '预定', '详情'];
  TabController _controller;
  int _currentIndex = 0;
  bool _isCollect = false;

  String _date;
  int _personNum;
  int _goodsId = -1;

  BookNowPopupWindow popupWindow;

  /// 上座预订
  BookNowContent bookNowContent;

  /// 轮播图片
  List<Detail.Photos> _photos = new List();

  /// 精选菜单
  List<Detail.MenusListBean> _menuList = new List();

  ///精选菜单数据
  List<MenuModel> menuList = [];

  /// 商家信息
  Detail.BusinessInfo _businessInfo;

  /// 图片标题，子标题
  String _title, _subTitle;
  List<String> _hotDishes = new List();

  /// 活动
  Detail.Activity _activity;

  /// 设施
  List<Detail.Devices> _devices;

  /// 预定信息
  Detail.BookInfo _bookInfo;
  List<Detail.Date> _dates;
  List<Rooms> _rooms;
  List<String> _times;

  /// 包房详情
  List<RoomModel> roomModel = List();

  /// 推荐菜品列表
  List<Detail.Cuisine> _cuisineList = new List();

  /// 没有图片的推荐菜品
  List<String> _cuisineTitleList = new List();

  /// 商家详情
  String _roomDetail;

  /// 预定需知
  String _roomInfo;

  String _dialogMessage = '';

  //包房数据
  List<BookNowModel> modelList = new List();

  //日期数据
  List<CustomScrollBean> dateData = List();

  //时间数据
  List<CustomScrollBean> timeData = List();

  //位数数据
  List<CustomScrollBean> bitData = List();

  //html解析的图片数组
  List<Detail.Photos> htmlPhotos = new List();

  //搜索条件
  SC.Data searchConditionData;

  //立即预定弹窗
  OverlayEntry overlayBookNow;

  ScrollController _scrollController;
  GlobalKey keyDetail = GlobalKey(debugLabel: 'keyDetail');

  //餐厅详情距离顶部距离
  double detailOffsetTop = 0.0;
  double dishesItemMaxHeight = 0.0;

  //是否显示立即预定弹窗
  bool isShowBookPopupWindow = false;

  //时间和人数
  String timeAndNum = '请点击选择';

  //精选菜单的高度
  double listHeight = 190;

  int _dateIndex = -1;
  int _timeIndex = -1;
  int _personNumIndex = -1;
  int _roomIndex = -1;

  @override
  void initState() {
    super.initState();
    _businessId = widget.businessId;
    _initData();

    _controller =
        TabController(vsync: this, length: _tabs.length, initialIndex: 0);

    _scrollController = ScrollController();

    //组件渲染完成回调
    WidgetsBinding.instance.addPostFrameCallback((context) {
      if (keyDetail.currentContext != null) {
        RenderBox detailBox = keyDetail.currentContext.findRenderObject();
        Offset detailOffset = detailBox.localToGlobal(Offset.zero);
        detailOffsetTop = detailOffset.dy;
      }
    });
  }

  void _initData() {
    ///搜索条件
    dio.get(Api.SEARCH_CONDITIONS).then((data) {
      var sources = jsonDecode(data.toString());
      SC.SearchConditionBean bean = SC.SearchConditionBean.fromJson(sources);
      SC.Data dataBean = bean.data;

      if (bean.errorCode == Api.SUCCESS_CODE) {
        setState(() {
          searchConditionData = dataBean;
          bitData = HomeFilterUtils.changeNumberDataToScrollData(
              searchConditionData.numbers);
        });
      }
    });

    /// 获取商家详情
    dio.get(Api.DETAIL_URL,
        queryParameters: {"business_id": _businessId.toString()}).then((data) {
      var sources = jsonDecode(data.data);
      Detail.DetailInfo detailInfo = Detail.DetailInfo.fromJson(sources);
      if (detailInfo.errorCode == "0") {
        _photos = detailInfo.data.photos;
        _businessInfo = detailInfo.data.businessInfo;
        _title = _businessInfo.title;
        _subTitle = _businessInfo.minDesc;
        _activity = detailInfo.data.activity;
        _dialogMessage = _businessInfo.parkingDesc;
        _devices = detailInfo.data.devices;
        _roomDetail = _businessInfo.detail;
        _isCollect = detailInfo.data.isCollected == 1;

        ///解析富文本中的图片链接
        var startPos = 0;
        var endPos = 0;
        var tempStr = '';
        List<String> htmlImgUrls = [];

        while (0 < (startPos = _roomDetail.indexOf('src="', startPos))) {
          if (0 < startPos) {
            startPos += 5;
          } else {
            break;
          }
          endPos = _roomDetail.indexOf('g"', startPos) + 1;
          tempStr = _roomDetail.substring(startPos, endPos);
          htmlImgUrls.add(tempStr);
          startPos = endPos;
        }
        for (int i = 0, len = htmlImgUrls.length; i < len; i++) {
          htmlPhotos.add(Detail.Photos(id: i, src: htmlImgUrls[i]));
        }

        _roomInfo = _businessInfo.roomInfo;
        _cuisineList = detailInfo.data.cuisine;
        _menuList = detailInfo.data.menus;

        /// 筛选出只有标题的推荐菜品
        _cuisineList.forEach((f) {
          if (f.pic == null || f.pic.isEmpty) {
            _cuisineTitleList.add(f.title);
            _cuisineList.remove(f);
          }
        });

        _bookInfo = detailInfo.data.bookInfo;
        _dates = _bookInfo.date;
        _rooms = _bookInfo.rooms;
        _times = _bookInfo.time;

        /// 精选菜单数据
        if (_menuList.length > 0) {
          _menuList.forEach((f) {
            List<String> dishes = f.dishesMenus.split(',');
            MenuModel bean = new MenuModel(
              title: f.title,
              numPeople: f.numbers,
              perPrice: f.perPrice,
              menus: dishes,
              isExpanded: false,
            );
            bean.maxHeight = bean.menus.length * 20.0 + 135;
            menuList.add(bean);
          });
        }

        modelList.clear();
        _rooms.forEach((f) {
          BookNowModel model = new BookNowModel(
              imgUrl: f.defaultImg,
              title: f.roomName,
              subtitle: f.numberDesc,
              clickable: f.goodsInfo.available == 1,
              tips: f.goodsInfo.tips,
              desc: f.goodsInfo.desc,
              hasBg: _rooms.indexOf(f) == _roomIndex);
          modelList.add(model);
        });

        dateData.clear();
        _dates.forEach((f) {
          CustomScrollBean bean = new CustomScrollBean();
          bean.title = f.title;
          bean.subTitle = f.week;
          if (_dates.indexOf(f) == 0) {
            bean.hasBg = true;
          } else {
            bean.hasBg = false;
          }
          dateData.add(bean);
        });

        timeData.clear();
        _times.forEach((f) {
          CustomScrollBean bean = new CustomScrollBean();
          bean.title = f;
          if (_times.indexOf(f) == 0) {
            bean.hasBg = true;
          } else {
            bean.hasBg = false;
          }
          timeData.add(bean);
        });

        /// 设置包房信息
        _setRoomInfo();

        bookNowContent = BookNowContent(
          timeInterval: _times != null
              ? '(${_times[0]}-${_times[_times.length - 1]})'
              : '',
          modelList: modelList,
          dateData: dateData,
          timeData: timeData,
          bitData: bitData,
          roomModel: roomModel,
          callback: (isShowTimeSelector) {},
          timeSelectorCallback: (results) {
            _dateIndex = results[0];
            _timeIndex = results[1];
            _personNumIndex = results[2];

            timeAndNum = '${dateData[results[0]].title} '
                '${dateData[results[0]].subTitle} '
                '${timeData[results[1]].title}, '
                '${bitData[results[2]].title}';

            /// 获取包房信息
            _getAvailableRoomList();
          },
          roomIndexCallback: (index) {
            _roomIndex = index;
            _goodsId = index != -1 ? _rooms[index].goodsInfo.goodsId : 0;
            setState(() {});
          },
        );

        /// 延时计算 商家详情高度
        Future.delayed(Duration(milliseconds: 450), () {
          setState(() {
            if (keyDetail.currentContext != null) {
              RenderBox detailBox = keyDetail.currentContext.findRenderObject();
              Offset detailOffset = detailBox.localToGlobal(Offset.zero);
              detailOffsetTop = detailOffset.dy;
            }
          });
        });
        setState(() {});
      } else {
        Toast.toast(context, detailInfo.msg);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: NotificationListener(
          onNotification: ((ScrollNotification notification) {
            scroll = notification.metrics.pixels;

            ///顶部actionbar动态改变透明度
            if (notification.metrics.axis == Axis.vertical &&
                scroll >= 0 &&
                scroll <= 180) {
              setState(() {
                alpha = scroll / 180.0;
              });
            }
            //滚动到上座预订以上
            if (notification.metrics.axis == Axis.vertical && scroll < 398) {
              setState(() {
                _controller.index = 0;
              });
              return;
            }

            //滚动到上座预订位置
            if (notification.metrics.axis == Axis.vertical &&
                scroll >= 398 &&
                scroll < detailOffsetTop - 80) {
              setState(() {
                _controller.index = 1;
              });
              return;
            }

            //滚动到餐厅详情位置
            if (notification.metrics.axis == Axis.vertical &&
                scroll >= detailOffsetTop - 70 &&
                scroll < notification.metrics.maxScrollExtent) {
              setState(() {
                _controller.index = 2;
              });
              return;
            }
          }),
          child: Stack(
            children: <Widget>[
              new SingleChildScrollView(
                controller: _scrollController,
                child: new Column(
                  children: <Widget>[
                    /// 轮播图
                    new Container(
                      child: Pagination(context, _photos, _title, _subTitle),
                      height: 250,
                    ),

                    /// 餐厅信息
                    new Container(
                      height: 85,
                      width: ScreenUtil.getScreenW(context),
                      color: Colors.white,
                      child: new Stack(
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(left: 14, top: 14),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _businessInfo != null
                                      ? _businessInfo.shopName
                                      : '',
                                  style: new TextStyle(
                                      fontSize: 20,
                                      color: ThemeColors.color1A1A1A),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    _businessInfo != null
                                        ? '${_businessInfo.dishes} '
                                            '| ${_businessInfo.circleName} '
                                            '| ${_businessInfo.distance}'
                                        : '',
                                    style: new TextStyle(
                                        fontSize: 14,
                                        color: ThemeColors.colorA6A6A6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Positioned(
                              right: 16,
                              bottom: 20,
                              child: new RichText(
                                text: TextSpan(
                                    text: "¥",
                                    style: new TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFD0021B),
                                    ),
                                    children: [
                                      TextSpan(
                                          text: _businessInfo != null
                                              ? _businessInfo.perPerson
                                                  .toString()
                                              : '',
                                          style: new TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFD0021B),
                                          )),
                                      TextSpan(
                                          text: "/人 起",
                                          style: new TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFFD0021B),
                                          ))
                                    ]),
                              )),
                        ],
                      ),
                    ),

                    new Container(
                      height: 1,
                      color: ThemeColors.colorDEDEDE,
                      margin: EdgeInsets.only(left: 14),
                    ),

                    /// 餐厅地址
                    new Container(
                        height: 68,
                        color: Colors.white,
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                                child: new Row(
                              children: <Widget>[
                                new Padding(
                                  padding: EdgeInsets.only(left: 14),
                                  child: Image.asset(
                                    'assets/images/ic_detail_location.png',
                                    width: 32,
                                    height: 32,
                                  ),
                                ),
                                new GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return MapPage(
                                              latitude: double.parse(
                                                  _businessInfo.latitude),
                                              longitude: double.parse(
                                                  _businessInfo.longitude),
                                              title: _businessInfo.title,
                                              address: _businessInfo.address);
                                        },
                                      ),
                                    );
                                  },
                                  child: new Container(
                                    margin: EdgeInsets.only(left: 10),
                                    width: 203,
                                    child: Text(
                                      _businessInfo != null
                                          ? _businessInfo.address
                                          : '',
                                      style: new TextStyle(
                                        fontSize: 14,
                                        color: ThemeColors.color404040,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Image.asset(
                                    'assets/images/ic_detail_more.png',
                                    width: 14,
                                    height: 14,
                                  ),
                                ),
                              ],
                            )),
                            Container(
                              width: 1,
                              height: 40,
                              color: ThemeColors.colorDEDEDE,
                            ),
                            Container(
                              width: 72,
                              alignment: Alignment.center,
                              child: new GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return new CommonDialog(
                                        title: '',
                                        message: _dialogMessage.isNotEmpty
                                            ? _dialogMessage
                                            : '暂无停车信息',
                                        onPositivePressEvent: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) {
                                                return MapPage(
                                                    latitude: double.parse(
                                                        _businessInfo
                                                            .parkingLatitude),
                                                    longitude: double.parse(
                                                        _businessInfo
                                                            .parkingLongitude),
                                                    title: _businessInfo
                                                        .parkingName,
                                                    address: _businessInfo
                                                        .parkingAddress);
                                              },
                                            ),
                                          );
                                        },
                                        positiveText:
                                            (_businessInfo.address.isNotEmpty &&
                                                    _businessInfo
                                                        .parkingName.isNotEmpty)
                                                ? '导航至停车场'
                                                : '',
                                        negativeText: '知道了',
                                        onCloseEvent: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
                                },
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/ic_detail_park.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    new Padding(
                                      padding: EdgeInsets.only(top: 6),
                                      child: Text(
                                        '车怎么停',
                                        style: new TextStyle(
                                            fontSize: 10,
                                            color: ThemeColors.color404040),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),

                    Container(
                      height: 10,
                      color: ThemeColors.colorDEDEDE,
                    ),

                    /// 活动
                    new GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return RechagrePage(
                                orderId: 0,
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 44,
                        color: Colors.white,
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              child: new Row(
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(left: 14),
                                    child: Text(
                                      '活动',
                                      style: new TextStyle(
                                          fontSize: 14,
                                          color: ThemeColors.colorA6A6A6),
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      _activity != null ? _activity.title : '',
                                      style: new TextStyle(
                                          fontSize: 14,
                                          color: ThemeColors.color404040),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            Container(
                              margin: EdgeInsets.only(right: 0),
                              alignment: Alignment.center,
                              width: 50,
                              child: Image.asset(
                                'assets/images/ic_detail_more2.png',
                                width: 20,
                                height: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    new Container(
                      height: 10,
                      color: ThemeColors.colorDEDEDE,
                    ),

                    /// 上座预定
                    Container(
                      width: ScreenUtil.getScreenW(context),
                      constraints: BoxConstraints(minHeight: 358),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Image.asset(
                              'assets/images/ic_text_shangzuoyuding.png',
                              width: 204,
                              height: 20),
                          SizedBox(height: 20),
                          null == bookNowContent
                              ? SizedBox(
                                  width: ScreenUtil.getScreenW(context),
                                  height: 300)
                              : bookNowContent,
                        ],
                      ),
                    ),

                    new Container(
                      height: 10,
                      color: ThemeColors.colorDEDEDE,
                    ),

                    /// 推荐菜菜品
                    _hotDishesWidget(),

                    new Container(
                      height: _cuisineList.length == 0 ? 0 : 10,
                      color: ThemeColors.colorDEDEDE,
                    ),

                    /// 精选菜单
                    menuList.length > 0 ? SizedBox(height: 20) : SizedBox(),
                    menuList.length > 0
                        ? Image.asset(
                            'assets/images/ic_text_jingxuancaidan.png',
                            width: 204,
                            height: 20)
                        : SizedBox(),
                    menuList.length > 0
                        ? Container(
                            alignment: Alignment.topLeft,
                            width: ScreenUtil.getScreenW(context),
                            height: listHeight,
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: menuList.map((f) {
                                  if (menuList.length - 1 ==
                                      menuList?.indexOf(f)) {
                                    return Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: _buildBusinessMenu(
                                          menuList?.indexOf(f)),
                                    );
                                  }
                                  return _buildBusinessMenu(
                                      menuList?.indexOf(f));
                                }).toList(),
                              ),
                            ),
                          )
                        : new Container(),
                    new Container(
                      height: menuList.length > 0 ? 10 : 0,
                      color: ThemeColors.colorDEDEDE,
                    ),

                    /// 餐厅设施
                    _facilitiesWidget(),

                    new Container(
                      height:
                          _roomDetail == null || _roomDetail.isEmpty ? 0 : 10,
                      color: ThemeColors.colorDEDEDE,
                    ),

                    /// 餐厅详情
                    _detailWidget(),

                    new Container(
                      height: 10,
                      color: ThemeColors.colorDEDEDE,
                    ),

                    /// 预定需知
                    _bookNotice(),
                  ],
                ),
              ),

              /// 顶部ActionBar
              _actionBarWidget(),

              /// 返回
              Positioned(
                left: 14,
                top: 30,
                child: new GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: new Opacity(
                    opacity: alpha <= 0 ? 1 : alpha >= 1.0 ? 0 : 1 - alpha,
                    child: new Container(
                      alignment: Alignment.center,
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        color: Color(0x80000000),
                      ),
                      child: Image.asset(
                        'assets/images/ic_back_w.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
              ),

              /// 返回
              Positioned(
                left: 14,
                top: 34,
                child: new GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: new Opacity(
                      opacity: alpha <= 0 ? 0 : alpha >= 1.0 ? 1 : alpha,
                      child: new Container(
                        child: Image.asset(
                          'assets/images/ic_back_w.png',
                          width: 20,
                          height: 20,
                        ),
                      )),
                ),
              ),

              /// 分享
              Positioned(
                right: 0,
                top: 30,
                child: new GestureDetector(
                  onTap: () {
                    Toast.toast(context, '分享');
                  },
                  child: new Opacity(
                    opacity: alpha <= 0 ? 1 : alpha >= 1.0 ? 0 : 1 - alpha,
                    child: new Container(
                      margin: EdgeInsets.only(right: 14),
                      alignment: Alignment.center,
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        color: Color(0x80000000),
                      ),
                      child: Image.asset(
                        'assets/images/ic_share_w.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
              ),

              /// 分享
              Positioned(
                right: 0,
                top: 34,
                child: new GestureDetector(
                  onTap: () {
                    Toast.toast(context, '分享');
                  },
                  child: new Opacity(
                    opacity: alpha <= 0 ? 0 : alpha >= 1.0 ? 1 : alpha,
                    child: new Container(
                      margin: EdgeInsets.only(right: 14),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/ic_share_w.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
              ),

              /// 立即预定
              _bookWidget(),
            ],
          ),
        ),
      ),
    );
  }

  ///创建精选菜单
  Widget _buildBusinessMenu(int i) {
    return BusinessMenu(
      menu: menuList[i],
      callback: () {
        ///遍历找到item中最大高度,并赋值给ListView
        var maxHeight = 0.0;
        var hasExpanded = false;
        for (int i = 0, len = menuList.length; i < len; i++) {
          if (menuList[i].isExpanded) {
            hasExpanded = true;
            maxHeight = math.max(maxHeight, menuList[i].maxHeight);
          }
        }
        if (!hasExpanded) {
          maxHeight = 150;
          detailOffsetTop = detailOffsetTop - dishesItemMaxHeight + 150;
        } else {
          detailOffsetTop = detailOffsetTop - dishesItemMaxHeight;
          dishesItemMaxHeight = maxHeight;
          detailOffsetTop = detailOffsetTop + dishesItemMaxHeight - 150;
        }

        setState(() {
          listHeight = maxHeight + 40;
        });
      },
    );
  }

  _onTabChanged(int index) {
    setState(() {
      _currentIndex = _controller.index;
    });
    switch (_controller.index) {
      case 0:
        _scrollController.animateTo(0,
            duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        break;
      case 1:
        _scrollController.animateTo((468 - 70.0),
            duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        Future.delayed(Duration(milliseconds: 450), () {
          setState(() {
            alpha = 1;
          });
        });
        break;
      case 2:
        _scrollController.animateTo((detailOffsetTop - 70),
            duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        Future.delayed(Duration(milliseconds: 450), () {
          setState(() {
            alpha = 1;
          });
        });
        break;
    }
  }

  /// 顶部ActionBar
  Widget _actionBarWidget() {
    return new Opacity(
      opacity: alpha <= 0 ? 0 : alpha >= 1.0 ? 1 : alpha,
      child: new Container(
        alignment: Alignment.center,
        height: 70,
        decoration: BoxDecoration(
          image: new DecorationImage(
              image: AssetImage('assets/images/bg_bar.png'), fit: BoxFit.fill),
        ),
        child: new Container(
          width: 200,
          alignment: Alignment.center,
          child: new TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            controller: _controller,
            isScrollable: false,
            tabs: _tabs.map((f) {
              return new Container(
                margin: EdgeInsets.only(bottom: 14),
                alignment: Alignment.bottomCenter,
                child: new Text(
                  f,
                  style: new TextStyle(
                      fontSize: _tabs.indexOf(f) == _currentIndex ? 16 : 14,
                      color: Colors.white),
                ),
              );
            }).toList(),
            onTap: (index) => _onTabChanged(index),
          ),
        ),
      ),
    );
  }

  /// 推荐菜品
  Widget _hotDishesWidget() {
    return _cuisineList.length == 0
        ? new Container()
        : Container(
            color: Colors.white,
            child: new Column(
              children: <Widget>[
                SizedBox(height: 20),
                Image.asset('assets/images/ic_text_tuijiancaipin.png',
                    width: 204, height: 20),
                SizedBox(height: 20),
                new Container(
                  height: 176,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return new Container(
                            margin: EdgeInsets.only(
                                left: i == 0 ? 14 : 0,
                                right: i == _cuisineList.length - 1 ? 14 : 0),
                            width: 283,
                            height: 176,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: ThemeColors.colorDEDEDE, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: new Column(
                              children: <Widget>[
                                new Stack(
                                  children: <Widget>[
                                    _cuisineList != null
                                        ? new Container(
                                            height: 142,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(4),
                                                  topRight: Radius.circular(4),
                                                ),
                                                image: new DecorationImage(
                                                    image: NetworkImage(
                                                      _cuisineList[i].pic,
                                                    ),
                                                    fit: BoxFit.fill)),
                                          )
                                        : new Container(),
                                    Positioned(
                                      right: 10,
                                      bottom: 10,
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 60,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Color(0x80000000),
                                          borderRadius:
                                              BorderRadius.circular(11),
                                        ),
                                        child: new GestureDetector(
                                          onTap: () {
                                            Detail.Photos photos =
                                                new Detail.Photos();
                                            photos.id = 1;
                                            photos.src = _cuisineList[i].pic;
                                            List<Detail.Photos> l = new List();
                                            l.add(photos);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) {
                                                  return ImageViewer(0, l);
                                                },
                                              ),
                                            );
                                          },
                                          child: Text(
                                            '查看大图',
                                            style: new TextStyle(
                                                fontSize: 10,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                new Container(
                                  height: 30,
                                  child: new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            _cuisineList != null
                                                ? _cuisineList[i].title
                                                : '',
                                            style: new TextStyle(
                                                fontSize: 14,
                                                color: ThemeColors.color404040),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        margin: EdgeInsets.only(right: 10),
                                        width: 80,
                                        child: RichText(
                                            text: TextSpan(
                                                text: "¥",
                                                style: new TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFFD39857),
                                                ),
                                                children: [
                                              TextSpan(
                                                  text: _cuisineList != null
                                                      ? _cuisineList[i]
                                                          .price
                                                          .toString()
                                                      : '',
                                                  style: new TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFFD39857),
                                                    fontWeight: FontWeight.w600,
                                                  )),
                                              TextSpan(
                                                  text: "/份",
                                                  style: new TextStyle(
                                                    color: Color(0xFFD39857),
                                                  ))
                                            ])),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ));
                      },
                      separatorBuilder: (context, i) {
                        return new Container(
                          width: 14,
                          color: Colors.white,
                        );
                      },
                      itemCount:
                          _cuisineList != null ? _cuisineList.length : 0),
                ),
                _cuisineTitleList.length > 0
                    ? new Padding(
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 14, bottom: 28),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.start,
                          children: _cuisineTitleList.map((f) {
                            return new Container(
                              padding: EdgeInsets.only(
                                  left: 8, right: 8, top: 4, bottom: 4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: ThemeColors.colorDEDEDE,
                                      width: 1)),
                              child: Text(
                                f,
                                softWrap: true,
                                style: new TextStyle(
                                    fontSize: 12,
                                    color: ThemeColors.color404040),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : new Container(
                        margin: EdgeInsets.only(bottom: 28),
                      ),
              ],
            ),
          );
  }

  /// 立即预定widget
  Widget _bookWidget() {
    return Positioned(
      bottom: 0,
      child: new Container(
        height: 44,
        width: ScreenUtil.getScreenW(context),
        child: new Row(
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(Page.CUSTOMER_SERVICE_PAGE);
              },
              child: new Container(
                width: 50,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top:
                          BorderSide(color: ThemeColors.colorDEDEDE, width: 1)),
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      child: Image.asset(
                        'assets/images/ic_detail_services.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    new Text(
                      '客服',
                      style: new TextStyle(
                          fontSize: 10, color: ThemeColors.color404040),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _collectOrUnCollect();
              },
              child: new Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: ThemeColors.colorDEDEDE, width: 1)),
                width: 50,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      _isCollect
                          ? 'assets/images/ic_collection.png'
                          : 'assets/images/ic_uncollection.png',
                      width: 20,
                      height: 20,
                    ),
                    new Text(
                      '收藏',
                      style: new TextStyle(
                          fontSize: 10, color: ThemeColors.color404040),
                    ),
                  ],
                ),
              ),
            ),
            new Expanded(
              child: new GestureDetector(
                onTap: () {
                  _book();
                },
                child: new Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [Color(0xff54548C), Color(0xff363659)]),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '立即预订',
                    style:
                        new TextStyle(fontSize: 16, color: Color(0xffF2C785)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 取消收藏/收藏
  _collectOrUnCollect() {
    User.UserInfoBean user = DataUtils.getUserInfo();
    if (user == null) {
      Navigator.of(context).pushNamed(Page.LOGIN_PAGE);
      return;
    }
    _isCollect = !_isCollect;
    Map<String, dynamic> queryParameters = {};
    queryParameters["business_id"] = _businessId.toString();
    queryParameters["is_collected"] = _isCollect ? "1" : "0";
    dio.post(Api.COLLECT_URL, data: queryParameters).then((data) {
      if (data.statusCode == 0) {
        setState(() {
          _isCollect = !_isCollect;
        });
      }
    });
    setState(() {
      Toast.toast(context,  _isCollect ?  '收藏成功' : '取消收藏');
    });
  }

  /// 立即预定
  _book() {
    if (_checkToBook()) {
      _date = _dates[_dateIndex].date + " " + _times[_timeIndex] + ":00";
      _personNum = _personNumIndex;
      if (_goodsId != -1 && _rooms[_roomIndex].goodsInfo.available == 0) {
        Toast.toast(context, "该时段不可预定");
        return;
      }
      _bookInfo.numbers = searchConditionData.numbers;
      if (_date.isNotEmpty && _personNum > 0) {
        print(_date.toString() + _personNum.toString() + _goodsId.toString());
        Navigator.of(context).pushNamed(Page.BOOK_INFO_PAGE, arguments: {
          "timeIndex": _timeIndex,
          "roomIndex": _roomIndex,
          "dateIndex": _dateIndex,
          "numberIndex": _personNumIndex,
          "bookInfo": _bookInfo,
          "businessId": _businessId,
        });
      }
    }
  }

  bool isShowDialog = false;

  /// 检测是否信息全部选择，没有则弹出选择
  bool _checkToBook() {
    User.UserInfoBean user = DataUtils.getUserInfo();
    if (user == null) {
      Toast.toast(context, '您还没有登录，请进行登录');
      Navigator.of(context).pushNamed(Page.LOGIN_PAGE);
      return false;
    }

    if (_roomIndex == -1 || _dateIndex == -1) {
      if (isShowDialog) {
        return false;
      }
      isShowDialog = true;

      popupWindow = BookNowPopupWindow(
        modelList: modelList,
        dateData: dateData,
        timeData: timeData,
        bitData: bitData,
        roomModel: roomModel,
        timeAndNum: timeAndNum,
        isBook: true,
        timeSelectorCallback: (results) {
          _dateIndex = results[0];
          _timeIndex = results[1];
          _personNumIndex = results[2];

          timeAndNum = '${dateData[results[0]].title} '
              '${dateData[results[0]].subTitle} '
              '${timeData[results[1]].title}, '
              '${bitData[results[2]].title}';

          /// 获取包房信息
          _getAvailableRoomList();

          bookNowContent.setTimeAndNum = timeAndNum;
        },
        roomIndexCallback: (index) {
          print('$index');
          setState(() {
            _roomIndex = index;
            _goodsId = index != -1 ? _rooms[index].goodsInfo.goodsId : -1;

            modelList.forEach((f) => f.hasBg = false);
            if (-1 != index) {
              modelList[index].hasBg = true;
            }
            bookNowContent.setTimeAndNum = timeAndNum;
          });
        },
        bookCallBack: () {
          _book();
        },
        dimissCallBack: () {
          isShowDialog = false;
        },
      );

      Navigator.of(context).push(
        PopRoute(
          child: popupWindow,
          dimissable: true,
        ),
      );
      return false;
    }
    return true;
  }

  /// 餐厅设施 网格布局
  Widget _facilitiesWidget() {
    return new Container(
        child: new Column(
      children: <Widget>[
        SizedBox(height: 20),
        Image.asset('assets/images/ic_text_cantingsheshi.png',
            width: 204, height: 20),
        new Container(
          child: GridView.count(
            physics: new NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            primary: false,
            // 横向 Item 的个数
            crossAxisCount: 5,
            children: _buildGridList(_devices != null ? _devices.length : 0),
          ),
        )
      ],
    ));
  }

  /// 餐厅设施 Item 布局
  List<Widget> _buildGridList(int length) {
    List<Widget> widgetList = new List();
    for (int i = 0; i < length; i++) {
      widgetList.add(new Container(
        child: new Column(
          children: <Widget>[
            Image.network(_devices[i].icon, width: 24, height: 24),
            new Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                _devices[i].title,
                style:
                    new TextStyle(fontSize: 12, color: ThemeColors.color404040),
              ),
            ),
          ],
        ),
      ));
    }
    return widgetList;
  }

  /// 餐厅详情
  Widget _detailWidget() {
    return _roomDetail == null || _roomDetail.isEmpty
        ? new Container()
        : new Container(
            key: keyDetail,
            child: new Column(
              children: <Widget>[
                SizedBox(height: 20),
                Image.asset('assets/images/ic_text_cantingxiangqing.png',
                    width: 204, height: 20),
                SizedBox(height: 20),
                new SingleChildScrollView(
                  physics: new NeverScrollableScrollPhysics(),
                  child: new Html(
                    data: _roomDetail != null ? _roomDetail : '',
                    padding: EdgeInsets.all(0),
                    onImageTap: (src) {
                      var index = 0;
                      for (int i = 0, len = htmlPhotos.length; i < len; i++) {
                        if (src == htmlPhotos[i].src) {
                          index = i;
                          break;
                        }
                      }
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ImageViewer(index, htmlPhotos);
                          });
                    },
                  ),
                )
              ],
            ),
          );
  }

  /// 预定须知
  Widget _bookNotice() {
    return Container(
      margin: EdgeInsets.only(bottom: 44),
      child: new Column(
        children: <Widget>[
          new Container(
            width: ScreenUtil.getScreenW(context),
            height: 60,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '--------',
                  style: new TextStyle(fontSize: 15, color: Colors.grey),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    '预定需知',
                    style: new TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.color404040),
                  ),
                ),
                Text(
                  '--------',
                  style: new TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),
          new Container(
              margin: EdgeInsets.only(left: 14, right: 14, bottom: 28),
              child: SingleChildScrollView(
                physics: new NeverScrollableScrollPhysics(),
                child: Html(
                  data: _roomInfo != null ? _roomInfo : '',
                  padding: EdgeInsets.all(0),
                ),
              ))
        ],
      ),
    );
  }

  /// 获取包房信息
  _getAvailableRoomList() {
    if (_dateIndex != -1 && _timeIndex != -1 && _personNumIndex != -1) {
      _date = _dates[_dateIndex].date + " " + _times[_timeIndex] + ":00";
      dio.get(Api.ROOM_URL, queryParameters: {
        "business_id": _businessId.toString(),
        "book_date": _date,
        "num": _personNumIndex.toString()
      }).then((data) {
        var sources = jsonDecode(data.data);
        RoomInfo info = RoomInfo.fromJson(sources);
        setState(() {
          _rooms = info.data.rooms;
          _bookInfo.rooms = _rooms;
          if (_roomIndex != -1 && _rooms[_roomIndex].goodsInfo.available == 0) {
            _roomIndex = -1;
          }
          modelList.clear();
          _rooms.forEach((f) {
            debugPrint(f.goodsInfo.available.toString());
            BookNowModel model = new BookNowModel(
                imgUrl: f.defaultImg,
                title: f.roomName,
                subtitle: f.numberDesc,
                clickable: f.goodsInfo.available == 1,
                tips: f.goodsInfo.tips,
                desc: f.goodsInfo.desc,
                hasBg: _rooms.indexOf(f) == _roomIndex);
            modelList.add(model);
          });
          bookNowContent.bookNowContentState.updateAll();
          if (popupWindow != null) {
            popupWindow.state.updateAll();
          }
          _setRoomInfo();
        });
      });
    }
  }

  /// 设置包房详情信息
  _setRoomInfo() {
    roomModel.clear();
    _bookInfo.rooms.forEach((f) {
      RoomModel bean = RoomModel();
      bean.devices = f.devices;
      bean.roomName = f.roomName;
      bean.price = f.price.toString();
      bean.numPeople = f.numberDesc;
      bean.recommendPrice = f.shopMoney.toString();
      bean.roomInfo = f.detail;
      bean.isClickable = 1 == f.goodsInfo.available;

      /// 图片
      List<ImgModel> list = new List();
      if (f.imgList.length == 0) {
        ImgModel imgModel = new ImgModel();
        imgModel.imgUrl = f.defaultImg;
        imgModel.id = 0;
        list.add(imgModel);
      } else {
        for (int i = 0; i < f.imgList.length; i++) {
          ImgModel imgModel = new ImgModel();
          imgModel.imgUrl = f.imgList[i].src;
          imgModel.id = i;
          list.add(imgModel);
        }
      }

      bean.imgUrls = list;
      roomModel.add(bean);
    });
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
