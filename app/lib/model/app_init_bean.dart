import 'package:flutter/cupertino.dart';

class AppInitInfoBean {
  String errorCode;
  String msg;
  Data data;

  AppInitInfoBean({this.errorCode, this.msg, this.data});

  AppInitInfoBean.fromJson(Map<String, dynamic> json) {
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
  CurrentCity currentCity;
  UpdateInfo updateInfo;
  String appVersion;
  List<BootItems> bootItems;
  List<CustomerService> customerService;
  String minAppVersion;
  List<Nav> nav;
  List<OpenCitys> openCitys;
  UserInfo userInfo;

  Data(
      {this.currentCity,
      this.updateInfo,
      this.appVersion,
      this.bootItems,
      this.customerService,
      this.minAppVersion,
      this.nav,
      this.openCitys,
      this.userInfo});

  Data.fromJson(Map<String, dynamic> json) {
    currentCity = json['current_city'] != null
        ? new CurrentCity.fromJson(json['current_city'])
        : null;
    updateInfo = json['update_info'] != null
        ? new UpdateInfo.fromJson(json['update_info'])
        : null;
    appVersion = json['app_version'];
    if (json['boot_items'] != null) {
      bootItems = new List<BootItems>();
      json['boot_items'].forEach((v) {
        bootItems.add(new BootItems.fromJson(v));
      });
    }
    if (json['customer_service'] != null) {
      customerService = new List<CustomerService>();
      json['customer_service'].forEach((v) {
        customerService.add(new CustomerService.fromJson(v));
      });
    }
    minAppVersion = json['min_app_version'];
    if (json['nav'] != null) {
      nav = new List<Nav>();
      json['nav'].forEach((v) {
        nav.add(new Nav.fromJson(v));
      });
    }
    if (json['open_citys'] != null) {
      openCitys = new List<OpenCitys>();
      json['open_citys'].forEach((v) {
        openCitys.add(new OpenCitys.fromJson(v));
      });
    }
    userInfo = json['user_info'] != null
        ? new UserInfo.fromJson(json['user_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.currentCity != null) {
      data['current_city'] = this.currentCity.toJson();
    }
    if (this.updateInfo != null) {
      data['update_info'] = this.updateInfo.toJson();
    }
    data['app_version'] = this.appVersion;
    if (this.bootItems != null) {
      data['boot_items'] = this.bootItems.map((v) => v.toJson()).toList();
    }
    if (this.customerService != null) {
      data['customer_service'] =
          this.customerService.map((v) => v.toJson()).toList();
    }
    data['min_app_version'] = this.minAppVersion;
    if (this.nav != null) {
      data['nav'] = this.nav.map((v) => v.toJson()).toList();
    }
    if (this.openCitys != null) {
      data['open_citys'] = this.openCitys.map((v) => v.toJson()).toList();
    }
    if (this.userInfo != null) {
      data['user_info'] = this.userInfo.toJson();
    }
    return data;
  }
}

class CurrentCity {
  int cityId;
  String cityName;

  CurrentCity({this.cityId, this.cityName});

  CurrentCity.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    cityName = json['city_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    return data;
  }
}

class UpdateInfo {
  String version;
  String size;
  String info;

  UpdateInfo({this.version, this.size, this.info});

  UpdateInfo.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    size = json['size'];
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['size'] = this.size;
    data['info'] = this.info;
    return data;
  }
}

class BootItems {
  String imgUrl;
  String url;
  int type;

  BootItems({this.imgUrl, this.url, this.type});

  BootItems.fromJson(Map<String, dynamic> json) {
    debugPrint(json.toString());
    imgUrl = json['img_url'];
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_url'] = this.imgUrl;
    data['url'] = this.url;
    data['type'] = this.type;
    return data;
  }
}

class CustomerService {
  String phone;
  int cityId;

  CustomerService({this.phone, this.cityId});

  CustomerService.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    cityId = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['city_id'] = this.cityId;
    return data;
  }
}

class Nav {
  String type;
  String icon;
  String name;

  Nav({this.type, this.icon, this.name});

  Nav.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    icon = json['icon'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['icon'] = this.icon;
    data['name'] = this.name;
    return data;
  }
}

class OpenCitys {
  int id;
  int regionId;
  String regionName;
  int isNew;

  OpenCitys({this.id, this.regionId, this.regionName, this.isNew});

  OpenCitys.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    regionId = json['region_id'];
    regionName = json['region_name'];
    isNew = json['is_new'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['region_id'] = this.regionId;
    data['region_name'] = this.regionName;
    data['is_new'] = this.isNew;
    return data;
  }
}

class UserInfo {
  int userId;
  String nickName;
  String avatarUrl;

  UserInfo({this.userId, this.nickName, this.avatarUrl});

  UserInfo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    nickName = json['nick_name'];
    avatarUrl = json['avatar_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['nick_name'] = this.nickName;
    data['avatar_url'] = this.avatarUrl;
    return data;
  }
}
