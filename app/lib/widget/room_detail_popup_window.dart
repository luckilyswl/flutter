import 'package:flutter/material.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'widgets_index.dart';

/*
 * 包房详情PopupWindow Widget
 **/
class RoomDetailPopupWindow extends StatefulWidget {
  //包房详情model
  RoomModel roomModel = RoomModel();

  //选择回调
  VoidCallback callback;

  RoomDetailPopupWindow({@required this.roomModel, @required this.callback});

  @override
  State<StatefulWidget> createState() {
    return RoomDetailPopupWindowState();
  }
}

class RoomDetailPopupWindowState extends State<RoomDetailPopupWindow>
    with TickerProviderStateMixin {
  //banner指示器
  List<IndicatorModel> indicatorsData;

  //tabs
  List<Tab> _tabs;
  TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.roomModel.devices = [
      DevicesListBean(img: 'assets/images/ic_wifi.png', value: '无线上网'),
      DevicesListBean(img: 'assets/images/ic_wifi.png', value: '空调'),
      DevicesListBean(img: 'assets/images/ic_wifi.png', value: '洗手间'),
      DevicesListBean(img: 'assets/images/ic_wifi.png', value: '茶桌'),
      DevicesListBean(img: 'assets/images/ic_wifi.png', value: '电视'),
      DevicesListBean(img: 'assets/images/ic_wifi.png', value: '投影'),
      DevicesListBean(img: 'assets/images/ic_wifi.png', value: '麻将台'),
      DevicesListBean(img: 'assets/images/ic_wifi.png', value: 'KTV设备'),
      DevicesListBean(img: 'assets/images/ic_wifi.png', value: '窗边景观'),
      DevicesListBean(img: 'assets/images/ic_wifi.png', value: '吧台'),
    ];
    widget.roomModel.roomInfo =
        '普通收费标准：128元/小时，一道茶258元起，配有茶艺师冲泡服务。 会务收费标准： 1、包房3小时，标准价1399元，提供茶水+茶点8份+水果盘4份； 2、配有茶艺师在旁加茶，超时按258元/小时收取； 3、白天时段可以享受折扣。 3、白天时段可以享受折扣。';
    widget.roomModel.roomName = '拿破仑房';
    widget.roomModel.numPeople = '6-8人';
    widget.roomModel.price = 50;
    widget.roomModel.recommendPrice = 3000;
    widget.roomModel.imgUrls = [
      ImgModel(id: 0, imgUrl: 'assets/images/ic_food.png'),
      ImgModel(id: 1, imgUrl: 'assets/images/ic_food.png'),
      ImgModel(id: 2, imgUrl: 'assets/images/ic_food.png'),
    ];

    indicatorsData = [];
    for (int i = 0, len = widget.roomModel.imgUrls.length; i < len; i++) {
      if (0 == i) {
        indicatorsData.add(IndicatorModel(id: i, hasBg: true));
      } else {
        indicatorsData.add(IndicatorModel(id: i, hasBg: false));
      }
    }

    _tabs = [];
    if (!ObjectUtil.isEmptyList(widget.roomModel.devices) &&
        !ObjectUtil.isEmptyString(widget.roomModel.roomInfo)) {
      _tabs.add(Tab(text: '包房设备'));
      _tabs.add(Tab(text: '包房说明'));
    }
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: ThemeColors.color96000000,
            width: ScreenUtil.getScreenW(context),
            height: ScreenUtil.getScreenH(context) - 44,
          ),
        ),

        ///底部安全区域
        Positioned(
          bottom: 0,
          child: Container(
            color: Colors.white,
            width: ScreenUtil.getScreenW(context),
            height: MediaQuery.of(context).padding.bottom,
          ),
        ),

        ///主体
        Positioned(
          bottom: 0,
          child: Container(
            width: ScreenUtil.getScreenW(context),
            height: ObjectUtil.isEmptyList(widget.roomModel.devices) &&
                    ObjectUtil.isEmpty(widget.roomModel.roomInfo)
                ? 450
                : 550,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 215,
                          margin:
                              const EdgeInsets.only(left: 8, top: 8, right: 8),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            clipBehavior: Clip.antiAlias,
                            child: CustomBanner(
                              bannerStories: widget.roomModel.imgUrls,
                              onTap: (id) => _clickPhoto(id),
                              onPageChange: (id) {
                                print('change: $id');
                                setState(() {
                                  indicatorsData
                                      .forEach((f) => f.hasBg = false);
                                  indicatorsData[id].hasBg = true;
                                });
                              },
                              autoScroll: false,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: 14,
                          child: Row(
                            children: indicatorsData
                                .map((f) => _buildIndicator(f))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(height: 14),
                        Container(
                          width: ScreenUtil.getScreenW(context) - 28,
                          child: Stack(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.roomModel?.roomName,
                                    style: FontStyles.style20404040,
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    '容纳人数：${widget.roomModel?.numPeople}',
                                    style: FontStyles.style12A6A6A6,
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    '推荐消费：${NumUtil.getNumByValueDouble(widget.roomModel?.recommendPrice, 0)}',
                                    style: FontStyles.style14404040,
                                  ),
                                  SizedBox(height: 2)
                                ],
                              ),
                              Positioned(
                                top: 6,
                                right: 0,
                                child: Column(
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: '¥',
                                            style: FontStyles.style14404040),
                                        TextSpan(
                                            text:
                                                '${NumUtil.getNumByValueDouble(widget.roomModel.price, 0)}',
                                            style: FontStyles.style28404040)
                                      ]),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: 48,
                                      height: 14,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          border: Border.all(
                                              color: ThemeColors.color404040,
                                              width: 1)),
                                      child: Text(
                                        '需付订金',
                                        style: FontStyles.style10404040,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ObjectUtil.isEmptyList(widget.roomModel.devices) ||
                            ObjectUtil.isEmpty(widget.roomModel.roomInfo)
                        ? SizedBox()
                        : Container(
                            width: 180,
                            height: 30,
                            child: Material(
                              color: Colors.transparent,
                              child: TabBar(
                                controller: _tabController,
                                tabs: _tabs,
                                labelPadding: EdgeInsets.only(top: 0),
                                isScrollable: false,
                                indicatorColor: ThemeColors.color404040,
                                indicatorWeight: 2,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelColor: ThemeColors.color404040,
                                labelStyle: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.none,
                                ),
                                unselectedLabelColor: ThemeColors.colorA6A6A6,
                                unselectedLabelStyle: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.none,
                                ),
                                onTap: (int index) {
                                  this.setState(() {
                                    _tabIndex = index;
                                  });
                                },
                              ),
                            ),
                          ),
                    ObjectUtil.isEmptyList(widget.roomModel.devices) &&
                            ObjectUtil.isEmpty(widget.roomModel.roomInfo)
                        ? SizedBox()
                        : ObjectUtil.isEmptyList(widget.roomModel.devices) &&
                                !ObjectUtil.isEmpty(widget.roomModel.roomInfo)
                            ? _buildPageInfo()
                            : !ObjectUtil.isEmptyList(
                                        widget.roomModel.devices) &&
                                    ObjectUtil.isEmpty(
                                        widget.roomModel.roomInfo)
                                ? _buildPageDevices()
                                : !ObjectUtil.isEmptyList(
                                            widget.roomModel.devices) &&
                                        !ObjectUtil.isEmpty(
                                            widget.roomModel.roomInfo) &&
                                        0 == _tabIndex
                                    ? _buildPageDevices()
                                    : _buildPageInfo()
                  ],
                ),

                ///选择按钮
                Positioned(
                  bottom: 14,
                  left: 14,
                  child: Container(
                    height: 50,
                    width: ScreenUtil.getScreenW(context) - 28,
                    child: RaisedButton(
                      color: widget.roomModel.isClickable
                          ? ThemeColors.color404040
                          : ThemeColors.colorDEDEDE,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      onPressed: _clickChoose,
                      child: Text(
                        '选择',
                        textAlign: TextAlign.center,
                        style: FontStyles.style16FFFFFF,
                      ),
                    ),
                  ),
                ),

                ///关闭按钮
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.topRight,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(242, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(200),
                          topRight: Radius.circular(8)),
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 28,
                        height: 28,
                        margin: const EdgeInsets.only(right: 8, top: 8),
                        child: Center(
                          child: Image.asset('assets/images/ic_menu.png',
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///创建banner 指示器
  Widget _buildIndicator(IndicatorModel model) {
    return Row(
      children: <Widget>[
        SizedBox(width: 6),
        Container(
          width: 12,
          height: 4,
          decoration: BoxDecoration(
            color:
                model.hasBg ? Colors.white : Color.fromARGB(127, 255, 255, 255),
            borderRadius: BorderRadius.circular(1),
          ),
        )
      ],
    );
  }

  ///创建包房设备item
  Widget _buildGridItem(String imgUrl, String value) {
    return Container(
      child: Column(children: <Widget>[
        Image.asset(imgUrl, width: 24, height: 24, fit: BoxFit.cover),
        SizedBox(height: 6),
        Text(value, style: FontStyles.style10404040),
      ]),
    );
  }

  ///创建包房设备
  Widget _buildPageDevices() {
    return Container(
      width: ScreenUtil.getScreenW(context),
      height: 150,
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: GridView.count(
        crossAxisCount: 5,
        scrollDirection: Axis.vertical,
        mainAxisSpacing: 15,
        crossAxisSpacing: 20,
        shrinkWrap: true,
        childAspectRatio: 1.2,
        children: widget.roomModel.devices
            .map((f) => _buildGridItem(f.img, f.value))
            .toList(),
      ),
    );
  }

  ///创建包房说明
  Widget _buildPageInfo() {
    return Container(
      width: ScreenUtil.getScreenW(context),
      height: 150,
      padding: const EdgeInsets.all(14),
      child: SingleChildScrollView(
        child: Text(
          widget.roomModel.roomInfo,
          softWrap: true,
          style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: ThemeColors.colorA6A6A6,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  ///选择点击事件
  _clickChoose() {
    if (widget.roomModel.isClickable) {
      widget.callback();
    }
    Navigator.of(context).pop();
  }

  ///图片点击事件
  _clickPhoto(int id) {}
}

class RoomModel {
  String roomName;
  String numPeople;
  String roomInfo;
  double recommendPrice;
  double price;
  bool isClickable;
  List<ImgModel> imgUrls;
  List<DevicesListBean> devices;

  RoomModel(
      {this.roomName,
      this.numPeople,
      this.roomInfo,
      this.recommendPrice,
      this.price,
      this.devices,
      this.imgUrls,
      this.isClickable = true});

  RoomModel.fromJson(Map<String, dynamic> json) {
    this.roomName = json['roomName'];
    this.numPeople = json['numPeople'];
    this.roomInfo = json['roomInfo'];
    this.recommendPrice = json['recommendPrice'];
    this.price = json['price'];
    this.devices = (json['devices'] as List) != null
        ? (json['devices'] as List)
            .map((i) => DevicesListBean.fromJson(i))
            .toList()
        : null;
    this.isClickable = json['isClickable'];
    if (json['imgUrls'] != null) {
      imgUrls = new List<ImgModel>();
      json['imgUrls'].forEach((v) {
        imgUrls.add(new ImgModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomName'] = this.roomName;
    data['numPeople'] = this.numPeople;
    data['roomInfo'] = this.roomInfo;
    data['recommendPrice'] = this.recommendPrice;
    data['price'] = this.price;
    data['devices'] = this.devices != null
        ? this.devices.map((i) => i.toJson()).toList()
        : null;
    if (this.imgUrls != null) {
      data['imgUrls'] = this.imgUrls.map((v) => v.toJson()).toList();
    }
    data['isClickable'] = this.isClickable;
    return data;
  }
}

class DevicesListBean {
  String img;
  String value;

  DevicesListBean({@required this.img, @required this.value});

  DevicesListBean.fromJson(Map<String, dynamic> json) {
    this.img = json['img'];
    this.value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    data['value'] = this.value;
    return data;
  }
}

class IndicatorModel {
  bool hasBg;
  int id;

  IndicatorModel({this.hasBg, this.id});

  IndicatorModel.fromJson(Map<String, dynamic> json) {
    this.hasBg = json['hasBg'];
    this.id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasBg'] = this.hasBg;
    data['id'] = this.id;
    return data;
  }
}
