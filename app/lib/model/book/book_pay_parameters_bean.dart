class BookPayParametersBean {
  String errorCode;
  String msg;
  BookPayParametersData data;

  BookPayParametersBean({this.errorCode, this.msg, this.data});

  BookPayParametersBean.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    msg = json['msg'];
    data = json['data'] != null
        ? new BookPayParametersData.fromJson(json['data'])
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

class BookPayParametersData {
  String paymentType;
  String payCode;
  int orderId;
  int payId;
  BookPayParametersPayParam payParam;

  BookPayParametersData(
      {this.paymentType,
      this.payCode,
      this.orderId,
      this.payId,
      this.payParam});

  BookPayParametersData.fromJson(Map<String, dynamic> json) {
    paymentType = json['payment_type'];
    payCode = json['pay_code'];
    orderId = json['order_id'];
    payId = json['pay_id'];
    payParam = json['pay_param'] != null
        ? new BookPayParametersPayParam.fromJson(json['pay_param'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_type'] = this.paymentType;
    data['pay_code'] = this.payCode;
    data['order_id'] = this.orderId;
    data['pay_id'] = this.payId;
    if (this.payParam != null) {
      data['pay_param'] = this.payParam.toJson();
    }
    return data;
  }
}

class BookPayParametersPayParam {
  String partnerId;
  String prepayId;
  String package;
  String nonceStr;
  String timeStamp;
  String paySign;
  String queryString;
  String appId;
  int orderId;
  String signType;
  bool sanBox;

  BookPayParametersPayParam(
      {this.partnerId,
      this.prepayId,
      this.package,
      this.nonceStr,
      this.timeStamp,
      this.paySign,
      this.queryString,
      this.appId,
      this.orderId,
      this.signType,
      this.sanBox});

  BookPayParametersPayParam.fromJson(Map<String, dynamic> json) {
    partnerId = json['partner_id'];
    prepayId = json['prepay_id'];
    package = json['package'];
    nonceStr = json['nonce_str'];
    timeStamp = json['time_stamp'];
    paySign = json['pay_sign'];
    queryString = json['query_string'];
    appId = json['app_id'];
    orderId = json['order_id'];
    signType = json['sign_type'];
    sanBox = json['san_box'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['partner_id'] = this.partnerId;
    data['prepay_id'] = this.prepayId;
    data['package'] = this.package;
    data['nonce_str'] = this.nonceStr;
    data['time_stamp'] = this.timeStamp;
    data['pay_sign'] = this.paySign;
    data['query_string'] = this.queryString;
    data['app_id'] = this.appId;
    data['order_id'] = this.orderId;
    data['sign_type'] = this.signType;
    data['san_box'] = this.sanBox;
    return data;
  }
}

class PayParametersAlipayParam {
  int orderId;
  double totalAmount;
  String orderString;

  PayParametersAlipayParam({this.orderId, this.totalAmount, this.orderString});

  PayParametersAlipayParam.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    totalAmount = json['total_amount'];
    orderString = json['order_string'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['total_amount'] = this.totalAmount;
    data['order_string'] = this.orderString;
    return data;
  }
}
