class OrderListBean {
  String errorCode;
  String msg;
  OrderListData data;

  OrderListBean({this.errorCode, this.msg, this.data});

  OrderListBean.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    msg = json['msg'];
    data = json['data'] != null ? new OrderListData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error_code'] = this.errorCode;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class OrderListData {
  List<OrderListItem> list;

  OrderListData({this.list});

  OrderListData.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<OrderListItem>();
      json['list'].forEach((v) {
        list.add(new OrderListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderListItem {
  int orderId;
  String orderSn;
  String orderStatusText;
  int orderStatus;
  String businessName;
  int businessId;
  String imgUrl;
  String bookTime;
  int peopleNum;
  String roomInfo;
  String paidAmount;
  int confirmStatus;
  bool enterprisePay;

  OrderListItem(
      {this.orderId,
      this.orderSn,
      this.orderStatusText,
      this.orderStatus,
      this.businessName,
      this.businessId,
      this.imgUrl,
      this.bookTime,
      this.peopleNum,
      this.roomInfo,
      this.paidAmount,
      this.confirmStatus,
      this.enterprisePay = false});

  OrderListItem.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderSn = json['order_sn'];
    orderStatusText = json['order_status_text'];
    orderStatus = json['order_status'];
    businessName = json['business_name'];
    businessId = json['business_id'];
    imgUrl = json['img_url'];
    bookTime = json['book_time'];
    peopleNum = json['people_num'];
    roomInfo = json['room_info'];
    confirmStatus = json['confirm_status'];
    enterprisePay = json['enterprise_pay'];
    paidAmount = json['paid_amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_sn'] = this.orderSn;
    data['order_status_text'] = this.orderStatusText;
    data['order_status'] = this.orderStatus;
    data['business_name'] = this.businessName;
    data['business_id'] = this.businessId;
    data['img_url'] = this.imgUrl;
    data['book_time'] = this.bookTime;
    data['people_num'] = this.peopleNum;
    data['room_info'] = this.roomInfo;
    data['paid_amount'] = this.paidAmount;
    data['confirm_status'] = this.confirmStatus;
    data['enterprise_pay'] = this.enterprisePay;
    return data;
  }
}
