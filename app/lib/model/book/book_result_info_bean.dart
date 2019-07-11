class BookResultInfoBean {
  String errorCode;
  String msg;
  BookResultData data;

  BookResultInfoBean({this.errorCode, this.msg, this.data});

  BookResultInfoBean.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    msg = json['msg'];
    data = json['data'] != null ? new BookResultData.fromJson(json['data']) : null;
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

class BookResultData {
  int orderStatus;
  String title;
  String description;
  int confirmStatus;
  int orderId;
  List<BookResultBanners> banners;
  String tips;

  BookResultData(
      {this.orderStatus,
      this.title,
      this.description,
      this.confirmStatus,
      this.orderId,
      this.banners,
      this.tips});

  BookResultData.fromJson(Map<String, dynamic> json) {
    orderStatus = json['order_status'];
    title = json['title'];
    description = json['description'];
    confirmStatus = json['confirm_status'];
    orderId = json['order_id'];
    if (json['banners'] != null) {
      banners = new List<BookResultBanners>();
      json['banners'].forEach((v) {
        banners.add(new BookResultBanners.fromJson(v));
      });
    }
    tips = json['tips'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_status'] = this.orderStatus;
    data['title'] = this.title;
    data['description'] = this.description;
    data['confirm_status'] = this.confirmStatus;
    data['order_id'] = this.orderId;
    if (this.banners != null) {
      data['banners'] = this.banners.map((v) => v.toJson()).toList();
    }
    data['tips'] = this.tips;
    return data;
  }
}

class BookResultBanners {
  String imgUrl;
  String refererUrl;
  int type;

  BookResultBanners({this.imgUrl, this.refererUrl, this.type});

  BookResultBanners.fromJson(Map<String, dynamic> json) {
    imgUrl = json['img_url'];
    refererUrl = json['referer_url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_url'] = this.imgUrl;
    data['referer_url'] = this.refererUrl;
    data['type'] = this.type;
    return data;
  }
}
