class PayCompleteBean {
  String errorCode;
  String msg;
  PayCompleteData data;

  PayCompleteBean({this.errorCode, this.msg, this.data});

  PayCompleteBean.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    msg = json['msg'];
    data = json['data'] != null ? new PayCompleteData.fromJson(json['data']) : null;
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

class PayCompleteData {
  List<PayCompleteBanners> banners;
  int orderId;
  int orderStatus;
  int paidStatus;
  String payAmount;
  List<PayCompletePayInfo> payInfo;
  String title;

  PayCompleteData(
      {this.banners,
      this.orderId,
      this.orderStatus,
      this.paidStatus,
      this.payAmount,
      this.payInfo,
      this.title});

  PayCompleteData.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = new List<PayCompleteBanners>();
      json['banners'].forEach((v) {
        banners.add(new PayCompleteBanners.fromJson(v));
      });
    }
    orderId = json['order_id'];
    orderStatus = json['order_status'];
    paidStatus = json['paid_status'];
    payAmount = json['pay_amount'].toString();
    if (json['pay_info'] != null) {
      payInfo = new List<PayCompletePayInfo>();
      json['pay_info'].forEach((v) {
        payInfo.add(new PayCompletePayInfo.fromJson(v));
      });
    }
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners.map((v) => v.toJson()).toList();
    }
    data['order_id'] = this.orderId;
    data['order_status'] = this.orderStatus;
    data['paid_status'] = this.paidStatus;
    data['pay_amount'] = this.payAmount;
    if (this.payInfo != null) {
      data['pay_info'] = this.payInfo.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    return data;
  }
}

class PayCompleteBanners {
  int id;
  String imgUrl;
  String refererUrl;
  int cityId;
  String type;
  String desc;
  String adName;

  PayCompleteBanners(
      {this.id,
      this.imgUrl,
      this.refererUrl,
      this.cityId,
      this.type,
      this.desc,
      this.adName});

  PayCompleteBanners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imgUrl = json['img_url'];
    refererUrl = json['referer_url'];
    cityId = json['city_id'];
    type = json['type'];
    desc = json['desc'];
    adName = json['ad_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['img_url'] = this.imgUrl;
    data['referer_url'] = this.refererUrl;
    data['city_id'] = this.cityId;
    data['type'] = this.type;
    data['desc'] = this.desc;
    data['ad_name'] = this.adName;
    return data;
  }
}

class PayCompletePayInfo {
  String title;
  String text;
  String desc;

  PayCompletePayInfo({this.title, this.text, this.desc});

  PayCompletePayInfo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['text'] = this.text;
    data['desc'] = this.desc;
    return data;
  }
}
