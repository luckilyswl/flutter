class OrderCancelBean {
  String errorCode;
  String msg;
  OrderCancelData data;

  OrderCancelBean({this.errorCode, this.msg, this.data});

  OrderCancelBean.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    msg = json['msg'];
    data = json['data'] != null ? new OrderCancelData.fromJson(json['data']) : null;
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

class OrderCancelData {
  String title;
  String icon;
  String desc;
  String tips;
  List<OrderCancelBanners> banners;

  OrderCancelData({this.title, this.icon, this.desc, this.tips, this.banners});

  OrderCancelData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    icon = json['icon'];
    desc = json['desc'];
    tips = json['tips'];
    if (json['banners'] != null) {
      banners = new List<OrderCancelBanners>();
      json['banners'].forEach((v) {
        banners.add(new OrderCancelBanners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['icon'] = this.icon;
    data['desc'] = this.desc;
    data['tips'] = this.tips;
    if (this.banners != null) {
      data['banners'] = this.banners.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderCancelBanners {
  String imgUrl;
  int platformType;
  int routerType;
  String adName;
  OrderCancelParam param;

  OrderCancelBanners(
      {this.imgUrl,
      this.platformType,
      this.routerType,
      this.adName,
      this.param});

  OrderCancelBanners.fromJson(Map<String, dynamic> json) {
    imgUrl = json['img_url'];
    platformType = json['platform_type'];
    routerType = json['router_type'];
    adName = json['ad_name'];
    param = json['param'] != null ? new OrderCancelParam.fromJson(json['param']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_url'] = this.imgUrl;
    data['platform_type'] = this.platformType;
    data['router_type'] = this.routerType;
    data['ad_name'] = this.adName;
    if (this.param != null) {
      data['param'] = this.param.toJson();
    }
    return data;
  }
}

class OrderCancelParam {
  int a;

  OrderCancelParam({this.a});

  OrderCancelParam.fromJson(Map<String, dynamic> json) {
    a = json['a'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['a'] = this.a;
    return data;
  }
}
