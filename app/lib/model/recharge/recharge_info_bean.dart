class RechargeInfoBean {
  String errorCode;
  String msg;
  Data data;

  RechargeInfoBean({this.errorCode, this.msg, this.data});

  RechargeInfoBean.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String account;
  String agreement;
  String businessImg;
  String info;
  List<Options> options;

  Data(
      {this.account,
      this.agreement,
      this.businessImg,
      this.info,
      this.options});

  Data.fromJson(Map<String, dynamic> json) {
    account = json['account'].toString();
    agreement = json['agreement'];
    businessImg = json['business_img'];
    info = json['info'];
    if (json['options'] != null) {
      options = new List<Options>();
      json['options'].forEach((v) {
        options.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['agreement'] = this.agreement;
    data['business_img'] = this.businessImg;
    data['info'] = this.info;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  int optionId;
  String rechargeMoney;
  String givingMoney;
  int recommend;

  Options(
      {this.optionId, this.rechargeMoney, this.givingMoney, this.recommend});

  Options.fromJson(Map<String, dynamic> json) {
    optionId = json['option_id'];
    rechargeMoney = json['recharge_money'].toString();
    givingMoney = json['giving_money'].toString();
    recommend = json['recommend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option_id'] = this.optionId;
    data['recharge_money'] = this.rechargeMoney;
    data['giving_money'] = this.givingMoney;
    data['recommend'] = this.recommend;
    return data;
  }
}
