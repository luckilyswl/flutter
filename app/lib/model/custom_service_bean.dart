class CustomServiceBean {
  String errorCode;
  String msg;
  DataBean data;

  CustomServiceBean({this.errorCode, this.msg, this.data});

  CustomServiceBean.fromJson(Map<String, dynamic> json) {
    this.errorCode = json['error_code'];
    this.msg = json['msg'];
    this.data = json['data'] != null ? DataBean.fromJson(json['data']) : null;
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

class DataBean {
  String mobile;
  String phone;
  String qrcode;
  String wechatId;

  DataBean({this.mobile, this.phone, this.qrcode, this.wechatId});

  DataBean.fromJson(Map<String, dynamic> json) {    
    this.mobile = json['mobile'];
    this.phone = json['phone'];
    this.qrcode = json['qrcode'];
    this.wechatId = json['wechat_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['phone'] = this.phone;
    data['qrcode'] = this.qrcode;
    data['wechat_id'] = this.wechatId;
    return data;
  }
}
