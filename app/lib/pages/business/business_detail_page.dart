import 'package:app/pages/business/imageviewer.dart';
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

  String _date;
  int _personNum;
  int _goodsId;

  /// 轮播图片
  List<Detail.Photos> _photos = new List();

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
  List<Detail.Rooms> _rooms;
  List<String> _times;

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

  //搜索条件
  SC.Data searchConditionData;

  //立即预定弹窗
  OverlayEntry overlayBookNow;

  ScrollController _scrollController;
  GlobalKey keyDetail = GlobalKey(debugLabel: 'keyDetail');

  //精选菜单数据
  List<MenuModel> menuList;

  //餐厅详情距离顶部距离
  double detailOffsetTop = 0.0;

  //是否显示立即预定弹窗
  bool isShowBookPopupWindow = false;

  //时间和人数
  String timeAndNum = '请点击选择';

  //精选菜单的高度
  double listHeight = 300;

  @override
  void initState() {
    super.initState();
    _businessId = widget.businessId;
    _initData();

    _controller =
        TabController(vsync: this, length: _tabs.length, initialIndex: 0);

    _scrollController = ScrollController();

    _hotDishes = [
      '澳洲黑安格斯牛柳',
      '“迪亚曼迪那”肉眼牛扒',
      '黑安格斯战斧牛扒',
      '香煎鹅肝',
      '经典凯撒沙拉',
      '经典凯撒沙拉',
    ];

    menuList = [
      MenuModel(
          title: '上座名厨精选菜单',
          numPeople: '(6-8人)',
          perPrice: 300,
          menus: ['湛江白切乡下土猪肉', '金耗蒸手打肉饼', 'XO酱爆深海墨鱼片', '鼓油王介辣局虾', '玫瑰鼓油鸡'],
          isExpanded: false,
          minHeight: 165),
      MenuModel(
          title: '上座名厨精选菜单',
          numPeople: '(6-8人)',
          perPrice: 300,
          menus: ['湛江白切乡下土猪肉', '金耗蒸手打肉饼', 'XO酱爆深海墨鱼片', '鼓油王介辣局虾', '玫瑰鼓油鸡'],
          isExpanded: false,
          minHeight: 165),
      MenuModel(
          title: '上座名厨精选菜单',
          numPeople: '(6-8人)',
          perPrice: 300,
          menus: ['湛江白切乡下土猪肉', '金耗蒸手打肉饼', 'XO酱爆深海墨鱼片', '鼓油王介辣局虾', '玫瑰鼓油鸡'],
          isExpanded: false,
          minHeight: 165),
    ];

    menuList.forEach((f) {
      f.maxHeight = f.menus.length * 20.0 + 135;
    });

    //组件渲染完成回调
    WidgetsBinding.instance.addPostFrameCallback((context) {
      RenderBox detailBox = keyDetail.currentContext.findRenderObject();
      Offset detailOffset = detailBox.localToGlobal(Offset.zero);
      detailOffsetTop = detailOffset.dy;
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
          // dateData = HomeFilterUtils.changeDateDataToScrollData(
          //     searchConditiodateDatanData.date);
          // timeData = HomeFilterUtils.changeTimeDataToScrollData(
          //     searchConditionData.time);
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
        _roomInfo = _businessInfo.roomInfo;

        _bookInfo = detailInfo.data.bookInfo;
        _dates = _bookInfo.date;
        _rooms = _bookInfo.rooms;
        _times = _bookInfo.time;

        modelList.clear();
        _rooms.forEach((f) {
          BookNowModel model = new BookNowModel(
              imgUrl: f.defaultImg, title: f.roomName, subtitle: f.numberDesc);
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
                                    'assets/images/ic_park.png',
                                    width: 28,
                                    height: 28,
                                  ),
                                ),

                                new Container(
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

                                new Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    '>',
                                    style: new TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ),

//                                  Image.asset('', width: 20, height: 20,)
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
                                          Toast.toast(context, '导航至停车场');
                                          Navigator.pop(context);
                                        },
                                        positiveText: '导航至停车场',
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
                                      'assets/images/ic_park.png',
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
                    Container(
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
                              alignment: Alignment.center,
                              width: 50,
                              child: new Text(
                                '>',
                                style: new TextStyle(
                                    fontSize: 20, color: Colors.grey),
                              ),
                            )
                          ],
                        )),

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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '--------',
                                style: new TextStyle(
                                    fontSize: 15, color: Colors.grey),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '上座预订',
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: ThemeColors.color404040,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '--------',
                                style: new TextStyle(
                                    fontSize: 15, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          BookNowContent(
                            timeInterval: _times != null
                                ? '(${_times[0]}-${_times[_times.length - 1]})'
                                : '',
                            modelList: modelList,
                            dateData: dateData,
                            timeData: timeData,
                            bitData: bitData,
                            callback: (isShowTimeSelector) {},
                            timeSelectorCallback: (results) {
                              _date = _dates[results[0]].date.toString() +
                                  " " +
                                  _times[results[1]] +
                                  ":00";
                              print(_date);
                              _personNum = results[2];
                              print(_personNum.toString());
                            },
                            roomIndexCallback: (index) {
                              _goodsId = _rooms[index].goodsInfo.goodsId;
                            },
                          ),
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
                      height: 10,
                      color: ThemeColors.colorDEDEDE,
                    ),

                    /// 精选菜单
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '--------',
                          style:
                              new TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '精选菜单',
                          style: const TextStyle(
                              fontSize: 20,
                              color: ThemeColors.color404040,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '--------',
                          style:
                              new TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      width: ScreenUtil.getScreenW(context),
                      height: listHeight,
                      child: ListView.separated(
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 0, right: 14, left: 0),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              BusinessMenu(
                                menu: menuList[i],
                                callback: () {},
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, i) {
                          return SizedBox(width: 0, height: 0);
                        },
                        itemCount: menuList.length,
                      ),
                    ),
                    /*new Container(
                      height: 380,
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 20),
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            width: ScreenUtil.getScreenW(context),
                            height: 300,
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: i == 0 ? 14 : 0,
                                      right: i == 2 ? 14 : 0),
                                  width: 170,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: ThemeColors.colorDEDEDE,
                                          width: 1)),
                                  child: new Container(
                                    alignment: Alignment.center,
                                    child: new Column(
                                      children: <Widget>[
                                        new Padding(
                                          padding: EdgeInsets.only(top: 14),
                                          child: Text(
                                            '上座名厨精选菜单',
                                            style: new TextStyle(
                                                fontSize: 14,
                                                color: ThemeColors.color404040,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(top: 8),
                                          child: Text(
                                            '(6-8人)',
                                            style: new TextStyle(
                                                fontSize: 12,
                                                color: ThemeColors.colorA6A6A6),
                                          ),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(top: 14),
                                          child: Text(
                                            '湛江白切乡下土猪肉\n金耗蒸手打肉饼',
                                            textAlign: TextAlign.center,
                                            style: new TextStyle(
                                                fontSize: 10,
                                                color: ThemeColors.color404040),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, i) {
                                return Container(
                                  width: 10,
                                );
                              },
                              itemCount: 3,
                            ),
                          ),
                        ],
                      ),
                    ),*/

                    new Container(
                      height: 10,
                      color: ThemeColors.colorDEDEDE,
                    ),

                    /// 餐厅设施
                    _facilitiesWidget(),

                    new Container(
                      height: 10,
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
                    child: new Container(
                      width: 50,
                      height: 50,
                      child: new Text(
                        '返回',
                        style: new TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )),

              /// 分享
              Positioned(
                  right: 0,
                  top: 30,
                  child: new GestureDetector(
                    onTap: () {
                      Toast.toast(context, '分享');
                    },
                    child: new Container(
                      width: 50,
                      height: 50,
                      child: new Text(
                        '分享',
                        style: new TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )),

              /// 立即预定
              _bookWidget(),
            ],
          ),
        ),
      ),
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
        color: Color(0xFF262626),
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
    return Container(
      color: Colors.white,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    '推荐菜品',
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
            height: 176,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return new Container(
                      margin: EdgeInsets.only(
                          left: i == 0 ? 14 : 0, right: i == 9 ? 14 : 0),
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
                              Image.asset(
                                'assets/images/ic_food.png',
                                height: 142,
                                fit: BoxFit.fill,
                              ),
                              Positioned(
                                right: 10,
                                bottom: 10,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 60,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Color(0x80000000),
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  child: new GestureDetector(
                                    onTap: () {
                                      Toast.toast(context, '查看大图$i');
                                    },
                                    child: Text(
                                      '查看大图',
                                      style: new TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          new Container(
                            height: 30,
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      '芝士焗澳洲花龙虾',
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
                                            text: "200",
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
                itemCount: 10),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 28),
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.start,
              children: _hotDishes.map((f) {
                return new Container(
                  padding:
                      EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.white,
                      border:
                          Border.all(color: ThemeColors.colorDEDEDE, width: 1)),
                  child: Text(
                    f,
                    softWrap: true,
                    style: new TextStyle(
                        fontSize: 12, color: ThemeColors.color404040),
                  ),
                );
              }).toList(),
            ),
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
            new Container(
              width: 50,
              decoration: new BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: ThemeColors.colorDEDEDE, width: 1)),
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 15,
                    height: 15,
                    color: ThemeColors.color404040,
                  ),
                  new Text(
                    '客服',
                    style: new TextStyle(
                        fontSize: 10, color: ThemeColors.color404040),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: new Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: ThemeColors.colorDEDEDE, width: 1)),
                width: 50,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      width: 15,
                      height: 15,
                      color: ThemeColors.color404040,
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
                  color: ThemeColors.color404040,
                  alignment: Alignment.center,
                  child: Text(
                    '立即预订',
                    style: new TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 立即预定
  _book() {
    if (_goodsId == 0) {
      Toast.toast(context, "该时段不可预定");
      return;
    }
    if (_date.isNotEmpty && _personNum > 0 && _goodsId > 0) {
      print(_date + _personNum.toString() + _goodsId.toString());
      Navigator.of(context).pushNamed(Page.BOOK_INFO_PAGE, arguments: {
        "goods_id": _goodsId,
        "book_time": _date,
        "num": _personNum
      });
    } else {
      Navigator.of(context).push(
        PopRoute(
          child: BookNowPopupWindow(
              modelList: modelList,
              dateData: dateData,
              timeData: timeData,
              bitData: bitData,
              isBook: true),
          dimissable: true,
        ),
      );
    }
  }

  /// 餐厅设施 网格布局
  Widget _facilitiesWidget() {
    return new Container(
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
                  '餐厅设施',
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
    return new Container(
      key: keyDetail,
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
                    '餐厅详情',
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
          new SingleChildScrollView(
            physics: new NeverScrollableScrollPhysics(),
            child: new Html(
              data: _roomDetail != null ? _roomDetail : '',
              padding: EdgeInsets.all(0),
              onImageTap: (src) {
                Detail.Photos photos = new Detail.Photos();
                photos.id = 1;
                photos.src = src;
                List<Detail.Photos> l = new List();
                l.add(photos);
                Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
                  return ImageViewer(0, l);
                }));
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

  @override
  bool get wantKeepAlive => true;
}
