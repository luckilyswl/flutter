import 'package:app/model/enum_define.dart';
import 'package:app/model/order/order_list_bean.dart';
import 'package:app/navigator/pop_route.dart';
import 'package:app/pages/business/map.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/order/order_detail_cancel_sheet.dart';
import 'package:app/widget/order/order_detail_contact_sheet.dart';
import 'package:app/widget/order/order_detail_content.dart';
import 'package:app/widget/order/order_detail_footer.dart';
import 'package:app/widget/order/order_detail_header.dart';
import 'package:app/widget/order/order_detail_navi_sheet.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';
import 'package:url_launcher/url_launcher.dart';

/*
 * 订单详情页面
 **/
class OrderDetailPage extends StatefulWidget {
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage>
    with SingleTickerProviderStateMixin {
  OrderListItem orderListItem;
  List<String> tel = <String>["020-62218951", "13658426842"];
  List<String> reasons = <String>[
    "预订信息填错了",
    "无法按时就餐",
    "行程不确定",
    "有更吸引我的餐厅",
    "餐厅态度恶劣"
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _cancelOrder() {
    Navigator.of(context).push(
      PopRoute(
        child: OrderDetailCancelSheet(
          reasons: ["预订信息填错了", "无法按时就餐", "行程不确定", "有更吸引我的餐厅", "餐厅态度恶劣"],
          onCancelEvent: (int index, String reason) {
            //取消订单
            debugPrint('index = $index,reason = $reason');
            Navigator.pop(context);
          },
          onCloseEvent: () {
            Navigator.pop(context);
          },
        ),
        dimissable: true,
      ),
    );
  }
  
  _contactBusiness() {
    if (tel != null && tel.length > 0) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return OrderDetailContactSheet(
              tel: tel,
              onCallEvent: (String telNum) {
                Navigator.pop(context);
                _lunchPhone(telNum);
              },
              onCancelEvent: () {
                Navigator.pop(context);
              },
            );
          });
    } else {
      Toast.toast(context, '暂无商家联系方式');
    }
  }

  /*
   * 拨打电话
   **/
  _lunchPhone(String phone) async {
    if (phone.length == 0) {
      return;
    }
    var url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _showNaviInfo() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return OrderDetailNaviSheet(
            onBusinessEvent: () {
              Navigator.pop(context);
              _naviToBusiness();
            },
            onParkEvent: () {
              Navigator.pop(context);
            },
            onCancelEvent: () {
              Navigator.pop(context);
            },
          );
        });
  }

  _naviToBusiness() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return MapPage(
          latitude: double.parse("23.107115"),
          longitude: double.parse("113.340760"),
          title: '花园酒店名仕阁',
          address: '天河区黄埔大道309号羊城创意园一路二巷');
    }));
  }

  _naviToPark() {}

  @override
  Widget build(BuildContext context) {
    /*获取传递过来的参数*/
    Map<String, dynamic> orderInfo = ModalRoute.of(context).settings.arguments;
    if (orderListItem == null && orderInfo != null) {
      orderListItem = orderInfo["orderListItem"];
    }

    return Scaffold(
        appBar: PreferredSize(
          child: Container(
            child: AppBar(
              title: Text('订单详情'),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            decoration: BoxDecoration(
              gradient: Gradients.loginBgLinearGradient,
            ),
          ),
          preferredSize: Size(MediaQuery.of(context).size.width, 45),
        ),
        body: Container(
          color: Colors.white,
          child: SafeArea(
            child: Container(
              color: ThemeColors.colorF2F2F2,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: LayoutBuilder(
                        builder: (BuildContext cotext,
                            BoxConstraints viewportConstraints) {
                          return SingleChildScrollView(
                            child: new ConstrainedBox(
                              constraints: new BoxConstraints(minHeight: 367),
                              child: new IntrinsicHeight(
                                child: Stack(
                                  children: <Widget>[
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        OrderDetailHeader(
                                          onContactEvent: () =>
                                              _contactBusiness(),
                                          onNaviEvent: () => _showNaviInfo(),
                                          onTapBusinessEvent: () {},
                                          isCanceled: orderListItem
                                                  .orderStatus ==
                                              OrderStatus.ORDER_STATUS_CANCEL,
                                        ),
                                        OrderDetailContentWidget(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    OrderDetailFooter(orderInfo: orderListItem),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
