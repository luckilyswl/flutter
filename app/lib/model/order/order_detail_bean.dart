class OrderDetailBean {
  String errorCode;
  String msg;
  OrderDetailData data;

  OrderDetailBean({this.errorCode, this.msg, this.data});

  OrderDetailBean.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    msg = json['msg'];
    data = json['data'] != null ? new OrderDetailData.fromJson(json['data']) : null;
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

class OrderDetailData {
  String orderStatusText;
  String confirmStatusText;
  OrderDetailOrderInfo orderInfo;
  OrderDetailGoodsInfo goodsInfo;
  OrderDetailBusinessInfo businessInfo;
  List<OrderDetailPayInfo> payInfo;

  OrderDetailData(
      {this.orderStatusText,
      this.confirmStatusText,
      this.orderInfo,
      this.goodsInfo,
      this.businessInfo,
      this.payInfo});

  OrderDetailData.fromJson(Map<String, dynamic> json) {
    orderStatusText = json['order_status_text'];
    confirmStatusText = json['confirm_status_text'];
    orderInfo = json['order_info'] != null
        ? new OrderDetailOrderInfo.fromJson(json['order_info'])
        : null;
    goodsInfo = json['goods_info'] != null
        ? new OrderDetailGoodsInfo.fromJson(json['goods_info'])
        : null;
    businessInfo = json['business_info'] != null
        ? new OrderDetailBusinessInfo.fromJson(json['business_info'])
        : null;
    if (json['pay_info'] != null) {
      payInfo = new List<OrderDetailPayInfo>();
      json['pay_info'].forEach((v) {
        payInfo.add(new OrderDetailPayInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_status_text'] = this.orderStatusText;
    data['confirm_status_text'] = this.confirmStatusText;
    if (this.orderInfo != null) {
      data['order_info'] = this.orderInfo.toJson();
    }
    if (this.goodsInfo != null) {
      data['goods_info'] = this.goodsInfo.toJson();
    }
    if (this.businessInfo != null) {
      data['business_info'] = this.businessInfo.toJson();
    }
    if (this.payInfo != null) {
      data['pay_info'] = this.payInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetailOrderInfo {
  String orderId;
  String orderSn;
  String userId;
  String orderStatus;
  String payStatus;
  String businessName;
  String reserveMoney;
  String orderType;
  String reserveName;
  String reserveMobile;
  String peopleNum;
  int bookDate;
  String bookTime;
  String addTime;
  String businessId;
  String endMoney;
  String confirmStatus;

  OrderDetailOrderInfo(
      {this.orderId,
      this.orderSn,
      this.userId,
      this.orderStatus,
      this.payStatus,
      this.businessName,
      this.reserveMoney,
      this.orderType,
      this.reserveName,
      this.reserveMobile,
      this.peopleNum,
      this.bookDate,
      this.bookTime,
      this.addTime,
      this.businessId,
      this.endMoney,
      this.confirmStatus});

  OrderDetailOrderInfo.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderSn = json['order_sn'];
    userId = json['user_id'];
    orderStatus = json['order_status'];
    payStatus = json['pay_status'];
    businessName = json['business_name'];
    reserveMoney = json['reserve_money'];
    orderType = json['order_type'];
    reserveName = json['reserve_name'];
    reserveMobile = json['reserve_mobile'];
    peopleNum = json['people_num'];
    bookDate = json['book_date'];
    bookTime = json['book_time'];
    addTime = json['add_time'];
    businessId = json['business_id'];
    endMoney = json['end_money'];
    confirmStatus = json['confirm_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_sn'] = this.orderSn;
    data['user_id'] = this.userId;
    data['order_status'] = this.orderStatus;
    data['pay_status'] = this.payStatus;
    data['business_name'] = this.businessName;
    data['reserve_money'] = this.reserveMoney;
    data['order_type'] = this.orderType;
    data['reserve_name'] = this.reserveName;
    data['reserve_mobile'] = this.reserveMobile;
    data['people_num'] = this.peopleNum;
    data['book_date'] = this.bookDate;
    data['book_time'] = this.bookTime;
    data['add_time'] = this.addTime;
    data['business_id'] = this.businessId;
    data['end_money'] = this.endMoney;
    data['confirm_status'] = this.confirmStatus;
    return data;
  }
}

class OrderDetailGoodsInfo {
  String goodsId;
  String goodsName;
  String roomId;
  String roomName;
  String startTime;
  String endTime;

  OrderDetailGoodsInfo(
      {this.goodsId,
      this.goodsName,
      this.roomId,
      this.roomName,
      this.startTime,
      this.endTime});

  OrderDetailGoodsInfo.fromJson(Map<String, dynamic> json) {
    goodsId = json['goods_id'];
    goodsName = json['goods_name'];
    roomId = json['room_id'];
    roomName = json['room_name'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goods_id'] = this.goodsId;
    data['goods_name'] = this.goodsName;
    data['room_id'] = this.roomId;
    data['room_name'] = this.roomName;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}

class OrderDetailBusinessInfo {
  String shopName;
  String cateId;
  String img;
  List<String> tel;
  String isSign;
  String address;
  String longitude;
  String latitude;
  String isParking;
  String parkingDesc;
  String parkingName;
  String parkingAddress;
  String parkingLongitude;
  String parkingLatitude;

  OrderDetailBusinessInfo(
      {this.shopName,
      this.cateId,
      this.img,
      this.tel,
      this.isSign,
      this.address,
      this.longitude,
      this.latitude,
      this.isParking,
      this.parkingDesc,
      this.parkingName,
      this.parkingAddress,
      this.parkingLongitude,
      this.parkingLatitude});

  OrderDetailBusinessInfo.fromJson(Map<String, dynamic> json) {
    shopName = json['shop_name'];
    cateId = json['cate_id'];
    img = json['img'];
    tel = json['tel'].cast<String>();
    isSign = json['is_sign'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    isParking = json['is_parking'];
    parkingDesc = json['parking_desc'];
    parkingName = json['parking_name'];
    parkingAddress = json['parking_address'];
    parkingLongitude = json['parking_longitude'];
    parkingLatitude = json['parking_latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_name'] = this.shopName;
    data['cate_id'] = this.cateId;
    data['img'] = this.img;
    data['tel'] = this.tel;
    data['is_sign'] = this.isSign;
    data['address'] = this.address;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['is_parking'] = this.isParking;
    data['parking_desc'] = this.parkingDesc;
    data['parking_name'] = this.parkingName;
    data['parking_address'] = this.parkingAddress;
    data['parking_longitude'] = this.parkingLongitude;
    data['parking_latitude'] = this.parkingLatitude;
    return data;
  }
}

class OrderDetailPayInfo {
  String title;
  String subTitle;
  String text;
  String desc;
  String style;

  OrderDetailPayInfo({this.title, this.subTitle, this.text, this.desc, this.style});

  OrderDetailPayInfo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subTitle = json['sub_title'];
    text = json['text'];
    desc = json['desc'];
    style = json['style'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['sub_title'] = this.subTitle;
    data['text'] = this.text;
    data['desc'] = this.desc;
    data['style'] = this.style;
    return data;
  }
}
