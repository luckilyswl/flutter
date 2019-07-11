import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/enum_define.dart';
import 'package:app/model/order/order_list_bean.dart';
import 'package:app/widget/order/order_list_item.dart';
import 'package:flutter/material.dart';

class OrderListPageWidget extends StatefulWidget {
  final int type;
  final Function(OrderListItem item) onTapEvent;

  OrderListPageWidget({Key key, @required this.type, @required this.onTapEvent}) : super(key: key);

  _OrderListPageWidgetState createState() => _OrderListPageWidgetState();
}

class _OrderListPageWidgetState extends State<OrderListPageWidget> {
  int _page = 1;
  int _pageSize = 20;
  List<OrderListItem> _orderList = <OrderListItem>[
    OrderListItem(
      businessName: 'XL SPACE东南亚料理餐吧',
      orderStatus: OrderStatus.ORDER_STATUS_PAY_WAITED,
      orderStatusText: '待预订',
      bookTime: '2019.6.27 周四 18:00',
      peopleNum: 4,
      roomInfo: '悠然明阁（6-8人房）',
      paidAmount: '0',
      enterprisePay: true,
    ),
    OrderListItem(
        businessName: 'XL SPACE东南亚料理餐吧',
        orderStatus: OrderStatus.ORDER_STATUS_BOOK_FINISH,
        orderStatusText: '正常',
        bookTime: '2019.6.27 周四 18:00',
        peopleNum: 4,
        roomInfo: '悠然明阁（6-8人房）',
        paidAmount: '0',
        confirmStatus: 0),
    OrderListItem(
        businessName: 'XL SPACE东南亚料理餐吧',
        orderStatus: OrderStatus.ORDER_STATUS_BOOK_FINISH,
        orderStatusText: '待确认',
        bookTime: '2019.6.27 周四 18:00',
        peopleNum: 4,
        roomInfo: '悠然明阁（6-8人房）',
        paidAmount: '0',
        confirmStatus: 1),
    OrderListItem(
        businessName: 'XL SPACE东南亚料理餐吧',
        orderStatus: OrderStatus.ORDER_STATUS_BOOK_FINISH,
        orderStatusText: '确认无房',
        bookTime: '2019.6.27 周四 18:00',
        peopleNum: 4,
        roomInfo: '悠然明阁（6-8人房）',
        paidAmount: '0',
        confirmStatus: 2),
    OrderListItem(
        businessName: 'XL SPACE东南亚料理餐吧',
        orderStatus: OrderStatus.ORDER_STATUS_BOOK_FINISH,
        orderStatusText: '确认有房',
        bookTime: '2019.6.27 周四 18:00',
        peopleNum: 4,
        roomInfo: '悠然明阁（6-8人房）',
        paidAmount: '0',
        confirmStatus: 3),
    OrderListItem(
      businessName: 'XL SPACE东南亚料理餐吧',
      orderStatus: OrderStatus.ORDER_STATUS_CANCEL,
      orderStatusText: '已取消',
      bookTime: '2019.6.27 周四 18:00',
      peopleNum: 4,
      roomInfo: '悠然明阁（6-8人房）',
      paidAmount: '0',
    ),
    OrderListItem(
      businessName: 'XL SPACE东南亚料理餐吧',
      orderStatus: OrderStatus.ORDER_STATUS_BOOK_REFUND,
      orderStatusText: '订金退款中',
      bookTime: '2019.6.27 周四 18:00',
      peopleNum: 4,
      roomInfo: '悠然明阁（6-8人房）',
      paidAmount: '0',
    ),
    OrderListItem(
      businessName: 'XL SPACE东南亚料理餐吧',
      orderStatus: OrderStatus.ORDER_STATUS_BOOK_REFUND_FINISH,
      orderStatusText: '订金退款完成',
      bookTime: '2019.6.27 周四 18:00',
      peopleNum: 4,
      roomInfo: '悠然明阁（6-8人房）',
      paidAmount: '0',
    ),
    OrderListItem(
      businessName: 'XL SPACE东南亚料理餐吧',
      orderStatus: OrderStatus.ORDER_STATUS_BE_PRESENTED,
      orderStatusText: '已到场',
      bookTime: '2019.6.27 周四 18:00',
      peopleNum: 4,
      roomInfo: '悠然明阁（6-8人房）',
      paidAmount: '0',
    ),
    OrderListItem(
      businessName: 'XL SPACE东南亚料理餐吧',
      orderStatus: OrderStatus.ORDER_STATUS_FINISH,
      orderStatusText: '已完成',
      bookTime: '2019.6.27 周四 18:00',
      peopleNum: 4,
      roomInfo: '悠然明阁（6-8人房）',
      paidAmount: '0',
    ),
    OrderListItem(
      businessName: 'XL SPACE东南亚料理餐吧',
      orderStatus: OrderStatus.ORDER_STATUS_REFUND,
      orderStatusText: '全额退款中',
      bookTime: '2019.6.27 周四 18:00',
      peopleNum: 4,
      roomInfo: '悠然明阁（6-8人房）',
      paidAmount: '0',
    ),
    OrderListItem(
      businessName: 'XL SPACE东南亚料理餐吧',
      orderStatus: OrderStatus.ORDER_STATUS_REFUND_FINISH,
      orderStatusText: '全额退款完成',
      bookTime: '2019.6.27 周四 18:00',
      peopleNum: 4,
      roomInfo: '悠然明阁（6-8人房）',
      paidAmount: '0',
    ),
    OrderListItem(
      businessName: 'XL SPACE东南亚料理餐吧',
      orderStatus: OrderStatus.ORDER_STATUS_BOOK_WAITED,
      orderStatusText: '待预订',
      bookTime: '2019.6.27 周四 18:00',
      peopleNum: 4,
      roomInfo: '悠然明阁（6-8人房）',
      paidAmount: '0',
    ),
  ];

  @override
  void initState() {
    // _initData();
    super.initState();
  }

  _initData() {
    dio.get(Api.ORDER_LIST, queryParameters: {
      "type": widget.type.toString(),
      "page": _page.toString(),
      "page_size": _pageSize.toString(),
    }).then((data) {});
  }

  _refreshData() {}

  _loadModeData() {}

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: _orderList.length * 2,
      itemBuilder: (BuildContext context, int index) {
        if (index % 2 == 0) {
          return Divider(height: 10, color: Colors.transparent);
        } else {
          final i = index ~/ 2;
          return OrderListItemWidget(orderListItem: _orderList[i], onTapEvent: () {
            widget.onTapEvent(_orderList[i]);
          },);
        }
      },
    );
  }
}
