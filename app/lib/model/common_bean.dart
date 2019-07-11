class CommonBean {
  String errorCode;
  String msg;
  DataBean data;

  CommonBean({this.errorCode, this.msg, this.data});

  CommonBean.fromJson(Map<String, dynamic> json) {
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
  DataBean();

  DataBean.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
