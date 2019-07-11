class HomeBusinessInfo {
  String errorCode;
  String msg;
  Data data;

  HomeBusinessInfo({this.errorCode, this.msg, this.data});

  HomeBusinessInfo.fromJson(Map<String, dynamic> json) {
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
  String pageTitle;
  int pageNum;
  int pageSize;
  List<BusinessList> guess;
  List<Banners> banners;
  List<BusinessList> list;

  Data(
      {this.pageTitle,
      this.pageNum,
      this.pageSize,
      this.guess,
      this.banners,
      this.list});

  Data.fromJson(Map<String, dynamic> json) {
    pageTitle = json['page_title'];
    pageNum = json['page_num'];
    pageSize = json['page_size'];
    if (json['guess'] != null) {
      guess = new List();
      json['guess'].forEach((v) {
        guess.add(new BusinessList.fromJson(v));
      });
    }
    if (json['banners'] != null) {
      banners = new List();
      json['banners'].forEach((v) {
        banners.add(new Banners.fromJson(v));
      });
    }
    if (json['list'] != null) {
      list = new List();
      json['list'].forEach((v) {
        list.add(new BusinessList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_title'] = this.pageTitle;
    data['page_num'] = this.pageNum;
    data['page_size'] = this.pageSize;
    if (this.guess != null) {
      data['guess'] = this.guess.map((v) => v.toJson()).toList();
    }
    if (this.banners != null) {
      data['banners'] = this.banners.map((v) => v.toJson()).toList();
    }
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banners {
  String imgUrl;
  String refererUrl;
  int type;

  Banners({this.imgUrl, this.refererUrl, this.type});

  Banners.fromJson(Map<String, dynamic> json) {
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

class BusinessList {
  int id;
  String shopName;
  String address;
  String longitude;
  String latitude;
  String imgUrl;
  String title;
  String perPerson;
  String zoneName;
  String attribute;
  String distance;
  String dishes;

  BusinessList(
      {this.id,
      this.shopName,
      this.address,
      this.longitude,
      this.latitude,
      this.imgUrl,
      this.title,
      this.perPerson,
      this.zoneName,
      this.attribute,
      this.distance,
      this.dishes});

  BusinessList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopName = json['shop_name'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    imgUrl = json['img_url'];
    title = json['title'];
    perPerson = json['per_person'];
    zoneName = json['zone_name'];
    attribute = json['attribute'];
    distance = json['distance'];
    dishes = json['dishes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_name'] = this.shopName;
    data['address'] = this.address;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['img_url'] = this.imgUrl;
    data['title'] = this.title;
    data['per_person'] = this.perPerson;
    data['zone_name'] = this.zoneName;
    data['attribute'] = this.attribute;
    data['distance'] = this.distance;
    data['dishes'] = this.dishes;
    return data;
  }
}
