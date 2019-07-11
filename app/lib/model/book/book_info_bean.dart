class BookInfoBean {
  String errorCode;
  String msg;
  BookInfoData data;

  BookInfoBean({this.errorCode, this.msg, this.data});

  BookInfoBean.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    msg = json['msg'];
    data = json['data'] != null ? new BookInfoData.fromJson(json['data']) : null;
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

class BookInfoData {
  List<String> bookNotice;
  List<String> compensateInfo;
  int enterprisePay;
  BookInfoGoodsInfo goodsInfo;
  int orderId;
  BookInfoPackage package;
  String refundTips;
  double reserveMoney;
  int balanceCanPay;
  int needConfirm;
  BookInfoAccount account;
  BookInfoBusinessInfo businessInfo;

  BookInfoData(
      {this.bookNotice,
      this.compensateInfo,
      this.enterprisePay,
      this.goodsInfo,
      this.orderId,
      this.package,
      this.refundTips,
      this.reserveMoney,
      this.balanceCanPay,
      this.needConfirm,
      this.account,
      this.businessInfo});

  BookInfoData.fromJson(Map<String, dynamic> json) {
    bookNotice = json['book_notice'] != null ? json['book_notice'].cast<String>() : null;
    compensateInfo = json['compensate_info'] != null ? json['compensate_info'].cast<String>() : null;
    enterprisePay = json['enterprise_pay'];
    goodsInfo = json['goods_info'] != null
        ? new BookInfoGoodsInfo.fromJson(json['goods_info'])
        : null;
    orderId = json['order_id'];
    package =
        json['package'] != null ? new BookInfoPackage.fromJson(json['package']) : null;
    refundTips = json['refund_tips'];
    reserveMoney = json['reserve_money'];
    balanceCanPay = json['balance_can_pay'];
    needConfirm = json['need_confirm'];
    account =
        json['account'] != null ? new BookInfoAccount.fromJson(json['account']) : null;
    businessInfo = json['business_info'] != null
        ? new BookInfoBusinessInfo.fromJson(json['business_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_notice'] = this.bookNotice;
    data['compensate_info'] = this.compensateInfo;
    data['enterprise_pay'] = this.enterprisePay;
    if (this.goodsInfo != null) {
      data['goods_info'] = this.goodsInfo.toJson();
    }
    data['order_id'] = this.orderId;
    if (this.package != null) {
      data['package'] = this.package.toJson();
    }
    data['refund_tips'] = this.refundTips;
    data['reserve_money'] = this.reserveMoney;
    data['balance_can_pay'] = this.balanceCanPay;
    data['need_confirm'] = this.needConfirm;
    if (this.account != null) {
      data['account'] = this.account.toJson();
    }
    if (this.businessInfo != null) {
      data['business_info'] = this.businessInfo.toJson();
    }
    return data;
  }
}

class BookInfoGoodsInfo {
  String date;
  int goodsId;
  int num;
  String roomName;
  String shopName;
  String bookTime;
  double price;
  int marketPrice;
  int busId;
  int roomId;
  String goodsName;
  int startTime;
  int endTime;
  int advanceTime;
  String bookDate;
  int advanceSecond;

  BookInfoGoodsInfo(
      {this.date,
      this.goodsId,
      this.num,
      this.roomName,
      this.shopName,
      this.bookTime,
      this.price,
      this.marketPrice,
      this.busId,
      this.roomId,
      this.goodsName,
      this.startTime,
      this.endTime,
      this.advanceTime,
      this.bookDate,
      this.advanceSecond});

  BookInfoGoodsInfo.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    goodsId = json['goods_id'];
    num = json['num'];
    roomName = json['room_name'];
    shopName = json['shop_name'];
    bookTime = json['book_time'];
    price = json['price'];
    marketPrice = json['market_price'];
    busId = json['bus_id'];
    roomId = json['room_id'];
    goodsName = json['goods_name'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    advanceTime = json['advance_time'];
    bookDate = json['book_date'];
    advanceSecond = json['advance_second'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['goods_id'] = this.goodsId;
    data['num'] = this.num;
    data['room_name'] = this.roomName;
    data['shop_name'] = this.shopName;
    data['book_time'] = this.bookTime;
    data['price'] = this.price;
    data['market_price'] = this.marketPrice;
    data['bus_id'] = this.busId;
    data['room_id'] = this.roomId;
    data['goods_name'] = this.goodsName;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['advance_time'] = this.advanceTime;
    data['book_date'] = this.bookDate;
    data['advance_second'] = this.advanceSecond;
    return data;
  }
}

class BookInfoPackage {
  String content;
  String img;
  List<String> imgList;
  int maxNum;
  int minNum;
  String name;
  String originalPrice;
  int packageId;
  String price;

  BookInfoPackage(
      {this.content,
      this.img,
      this.imgList,
      this.maxNum,
      this.minNum,
      this.name,
      this.originalPrice,
      this.packageId,
      this.price});

  BookInfoPackage.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    img = json['img'];
    imgList = json['img_list'] != null ? json['img_list'].cast<String>() : null;
    maxNum = json['max_num'];
    minNum = json['min_num'];
    name = json['name'];
    originalPrice = json['original_price'];
    packageId = json['package_id'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['img'] = this.img;
    data['img_list'] = this.imgList;
    data['max_num'] = this.maxNum;
    data['min_num'] = this.minNum;
    data['name'] = this.name;
    data['original_price'] = this.originalPrice;
    data['package_id'] = this.packageId;
    data['price'] = this.price;
    return data;
  }
}

class BookInfoAccount {
  int userId;
  String availableBalance;

  BookInfoAccount({this.userId, this.availableBalance});

  BookInfoAccount.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    availableBalance = json['available_balance'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['available_balance'] = this.availableBalance;
    return data;
  }
}

class BookInfoBusinessInfo {
  int id;
  int comId;
  String shopName;
  int cateId;
  int cityId;
  int isSign;
  int compensateOption;

  BookInfoBusinessInfo(
      {this.id,
      this.comId,
      this.shopName,
      this.cateId,
      this.cityId,
      this.isSign,
      this.compensateOption});

  BookInfoBusinessInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comId = json['com_id'];
    shopName = json['shop_name'];
    cateId = json['cate_id'];
    cityId = json['city_id'];
    isSign = json['is_sign'];
    compensateOption = json['compensate_option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['com_id'] = this.comId;
    data['shop_name'] = this.shopName;
    data['cate_id'] = this.cateId;
    data['city_id'] = this.cityId;
    data['is_sign'] = this.isSign;
    data['compensate_option'] = this.compensateOption;
    return data;
  }
}
