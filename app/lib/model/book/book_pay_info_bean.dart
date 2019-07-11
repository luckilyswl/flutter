class BookPayInfoBean {
  String errorCode;
  String msg;
  BookPayInfoData data;

  BookPayInfoBean({this.errorCode, this.msg, this.data});

  BookPayInfoBean.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    msg = json['msg'];
    data = json['data'] != null
        ? new BookPayInfoData.fromJson(json['data'])
        : null;
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

class BookPayInfoData {
  List<BookPayInfoOptions> options;
  int orderId;
  double orderAmout;
  String orderSn;
  int enterprisePay;

  BookPayInfoUserAccount userAccount;
  BookPayInfoOrderInfo orderInfo;
  BookPayInfoData(
      {this.options,
      this.orderId,
      this.orderAmout,
      this.orderSn,
      this.enterprisePay,
      this.userAccount,
      this.orderInfo});

  BookPayInfoData.fromJson(Map<String, dynamic> json) {
    if (json['option'] != null) {
      options = new List<BookPayInfoOptions>();
      json['option'].forEach((v) {
        options.add(new BookPayInfoOptions.fromJson(v));
      });
    }
    orderId = json['order_id'];
    orderAmout = json['order_amout'];
    orderSn = json['order_sn'];
    enterprisePay = json['enterprise_pay'];
    userAccount = json['user_account'] != null
        ? new BookPayInfoUserAccount.fromJson(json['user_account'])
        : null;
    orderInfo = json['order_info'] != null
        ? new BookPayInfoOrderInfo.fromJson(json['order_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.options != null) {
      data['option'] = this.options.map((v) => v.toJson()).toList();
    }
    data['order_id'] = this.orderId;
    data['order_amout'] = this.orderAmout;
    data['order_sn'] = this.orderSn;
    data['enterprise_pay'] = this.enterprisePay;
    if (this.userAccount != null) {
      data['user_account'] = this.userAccount.toJson();
    }
    if (this.orderInfo != null) {
      data['order_info'] = this.orderInfo.toJson();
    }
    return data;
  }
}

class BookPayInfoOptions {
  int payId;
  String name;
  String icon;
  int recommend;
  int available;
  String desc;

  BookPayInfoOptions(
      {this.payId,
      this.name,
      this.icon,
      this.recommend,
      this.available,
      this.desc});

  BookPayInfoOptions.fromJson(Map<String, dynamic> json) {
    payId = json['pay_id'];
    name = json['name'];
    icon = json['icon'];
    recommend = json['recommend'];
    available = json['available'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pay_id'] = this.payId;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['recommend'] = this.recommend;
    data['available'] = this.available;
    data['desc'] = this.desc;
    return data;
  }
}

class Desc {
  String text;
  String type;

  Desc({this.text, this.type});

  Desc.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['type'] = this.type;
    return data;
  }
}

class BookPayInfoUserAccount {
  int id;
  int userId;
  String availableBalance;
  String totalBalance;
  String freezeBalance;
  String usedBalance;
  String largessBalance;
  String rebateMoney;
  int createTime;
  int lastUpdateTime;

  BookPayInfoUserAccount(
      {this.id,
      this.userId,
      this.availableBalance,
      this.totalBalance,
      this.freezeBalance,
      this.usedBalance,
      this.largessBalance,
      this.rebateMoney,
      this.createTime,
      this.lastUpdateTime});

  BookPayInfoUserAccount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    availableBalance = json['available_balance'].toString();
    totalBalance = json['total_balance'].toString();
    freezeBalance = json['freeze_balance'].toString();
    usedBalance = json['used_balance'].toString();
    largessBalance = json['largess_balance'].toString();
    rebateMoney = json['rebate_money'].toString();
    createTime = json['create_time'];
    lastUpdateTime = json['last_update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['available_balance'] = this.availableBalance;
    data['total_balance'] = this.totalBalance;
    data['freeze_balance'] = this.freezeBalance;
    data['used_balance'] = this.usedBalance;
    data['largess_balance'] = this.largessBalance;
    data['rebate_money'] = this.rebateMoney;
    data['create_time'] = this.createTime;
    data['last_update_time'] = this.lastUpdateTime;
    return data;
  }
}

class BookPayInfoOrderInfo {
  int orderId;
  String orderSn;
  int userId;
  int orderStatus;
  int orderType;
  int payId;
  int endPayId;
  int payStatus;
  String unitPrice;
  String reserveMoney;
  String endMoney;
  String paidMoney;
  String endMoneyRealPay;
  String reserveName;
  String reserveMobile;
  int peopleNum;
  int bookDate;
  int bookTime;
  int businessId;
  String businessName;
  int comId;
  int cityId;
  int accountId;
  int activityId;
  int couponId;
  String discount;
  String orderTotalDeduct;
  String remark;
  int createTime;
  int bookPayTime;
  int lastUpdateTime;
  int integral;
  String integralMoney;
  String couponMoney;
  int isDelete;
  int confirmStatus;
  String endBalance;
  int confirmNotifyStatus;
  int orderCronTime;
  String totalPaidAmount;
  int settlementType;
  String discountMoney;

  BookPayInfoOrderInfo(
      {this.orderId,
      this.orderSn,
      this.userId,
      this.orderStatus,
      this.orderType,
      this.payId,
      this.endPayId,
      this.payStatus,
      this.unitPrice,
      this.reserveMoney,
      this.endMoney,
      this.paidMoney,
      this.endMoneyRealPay,
      this.reserveName,
      this.reserveMobile,
      this.peopleNum,
      this.bookDate,
      this.bookTime,
      this.businessId,
      this.businessName,
      this.comId,
      this.cityId,
      this.accountId,
      this.activityId,
      this.couponId,
      this.discount,
      this.orderTotalDeduct,
      this.remark,
      this.createTime,
      this.bookPayTime,
      this.lastUpdateTime,
      this.integral,
      this.integralMoney,
      this.couponMoney,
      this.isDelete,
      this.confirmStatus,
      this.endBalance,
      this.confirmNotifyStatus,
      this.orderCronTime,
      this.totalPaidAmount,
      this.settlementType,
      this.discountMoney});

  BookPayInfoOrderInfo.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderSn = json['order_sn'];
    userId = json['user_id'];
    orderStatus = json['order_status'];
    orderType = json['order_type'];
    payId = json['pay_id'];
    endPayId = json['end_pay_id'];
    payStatus = json['pay_status'];
    unitPrice = json['unit_price'].toString();
    reserveMoney = json['reserve_money'].toString();
    endMoney = json['end_money'].toString();
    paidMoney = json['paid_money'].toString();
    endMoneyRealPay = json['end_money_real_pay'].toString();
    reserveName = json['reserve_name'];
    reserveMobile = json['reserve_mobile'];
    peopleNum = json['people_num'];
    bookDate = json['book_date'];
    bookTime = json['book_time'];
    businessId = json['business_id'];
    businessName = json['business_name'];
    comId = json['com_id'];
    cityId = json['city_id'];
    accountId = json['account_id'];
    activityId = json['activity_id'];
    couponId = json['coupon_id'];
    discount = json['discount'].toString();
    orderTotalDeduct = json['order_total_deduct'].toString();
    remark = json['remark'];
    createTime = json['create_time'];
    bookPayTime = json['book_pay_time'];
    lastUpdateTime = json['last_update_time'];
    integral = json['integral'];
    integralMoney = json['integral_money'].toString();
    couponMoney = json['coupon_money'].toString();
    isDelete = json['is_delete'];
    confirmStatus = json['confirm_status'];
    endBalance = json['end_balance'].toString();
    confirmNotifyStatus = json['confirm_notify_status'];
    orderCronTime = json['order_cron_time'];
    totalPaidAmount = json['total_paid_amount'].toString();
    settlementType = json['settlement_type'];
    discountMoney = json['discount_money'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_sn'] = this.orderSn;
    data['user_id'] = this.userId;
    data['order_status'] = this.orderStatus;
    data['order_type'] = this.orderType;
    data['pay_id'] = this.payId;
    data['end_pay_id'] = this.endPayId;
    data['pay_status'] = this.payStatus;
    data['unit_price'] = this.unitPrice;
    data['reserve_money'] = this.reserveMoney;
    data['end_money'] = this.endMoney;
    data['paid_money'] = this.paidMoney;
    data['end_money_real_pay'] = this.endMoneyRealPay;
    data['reserve_name'] = this.reserveName;
    data['reserve_mobile'] = this.reserveMobile;
    data['people_num'] = this.peopleNum;
    data['book_date'] = this.bookDate;
    data['book_time'] = this.bookTime;
    data['business_id'] = this.businessId;
    data['business_name'] = this.businessName;
    data['com_id'] = this.comId;
    data['city_id'] = this.cityId;
    data['account_id'] = this.accountId;
    data['activity_id'] = this.activityId;
    data['coupon_id'] = this.couponId;
    data['discount'] = this.discount;
    data['order_total_deduct'] = this.orderTotalDeduct;
    data['remark'] = this.remark;
    data['create_time'] = this.createTime;
    data['book_pay_time'] = this.bookPayTime;
    data['last_update_time'] = this.lastUpdateTime;
    data['integral'] = this.integral;
    data['integral_money'] = this.integralMoney;
    data['coupon_money'] = this.couponMoney;
    data['is_delete'] = this.isDelete;
    data['confirm_status'] = this.confirmStatus;
    data['end_balance'] = this.endBalance;
    data['confirm_notify_status'] = this.confirmNotifyStatus;
    data['order_cron_time'] = this.orderCronTime;
    data['total_paid_amount'] = this.totalPaidAmount;
    data['settlement_type'] = this.settlementType;
    data['discount_money'] = this.discountMoney;
    return data;
  }
}
