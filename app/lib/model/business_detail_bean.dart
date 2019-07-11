import 'package:app/model/room_info_bean.dart' as Room;

class DetailInfo {
  String errorCode;
  String msg;
  Data data;

  DetailInfo({this.errorCode, this.msg, this.data});

  DetailInfo.fromJson(Map<String, dynamic> json) {
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
  Activity activity;
  BookInfo bookInfo;
  BusinessInfo businessInfo;
  List<Cuisine> cuisine;
  List<Devices> devices;
  List<Photos> photos;
  List<MenusListBean> menus;
  int isCollected;

  Data(
      {this.activity,
      this.bookInfo,
      this.businessInfo,
      this.cuisine,
      this.devices,
      this.photos,
      this.menus});

  Data.fromJson(Map<String, dynamic> json) {
    activity = json['activity'] != null
        ? new Activity.fromJson(json['activity'])
        : null;
    bookInfo = json['book_info'] != null
        ? new BookInfo.fromJson(json['book_info'])
        : null;
    businessInfo = json['business_info'] != null
        ? new BusinessInfo.fromJson(json['business_info'])
        : null;
    if (json['cuisine'] != null) {
      cuisine = new List<Cuisine>();
      json['cuisine'].forEach((v) {
        cuisine.add(new Cuisine.fromJson(v));
      });
    }
    if (json['devices'] != null) {
      devices = new List<Devices>();
      json['devices'].forEach((v) {
        devices.add(new Devices.fromJson(v));
      });
    }
    isCollected = json['is_collected'];
    if (json['photos'] != null) {
      photos = new List<Photos>();
      json['photos'].forEach((v) {
        photos.add(new Photos.fromJson(v));
      });
    }
    if (json['menus'] != null) {
      menus = new List<MenusListBean>();
      json['menus'].forEach((v) {
        menus.add(new MenusListBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.activity != null) {
      data['activity'] = this.activity.toJson();
    }
    if (this.bookInfo != null) {
      data['book_info'] = this.bookInfo.toJson();
    }
    if (this.businessInfo != null) {
      data['business_info'] = this.businessInfo.toJson();
    }
    if (this.cuisine != null) {
      data['cuisine'] = this.cuisine.map((v) => v.toJson()).toList();
    }
    if (this.devices != null) {
      data['devices'] = this.devices.map((v) => v.toJson()).toList();
    }
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    if (this.menus != null) {
      data['menus'] = this.menus.map((v) => v.toJson()).toList();
    }
    data['is_collected'] = this.isCollected;
    return data;
  }
}

class Activity {
  String title;
  int pageType;

  Activity({this.title, this.pageType});

  Activity.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    pageType = json['page_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['page_type'] = this.pageType;
    return data;
  }
}

class BookInfo {
  List<Date> date;
  List<Room.Rooms> rooms;
  List<String> time;
  List<int> numbers;

  BookInfo({this.date, this.rooms, this.time});

  BookInfo.fromJson(Map<String, dynamic> json) {
    if (json['date'] != null) {
      date = new List<Date>();
      json['date'].forEach((v) {
        date.add(new Date.fromJson(v));
      });
    }
    if (json['rooms'] != null) {
      rooms = new List<Room.Rooms>();
      json['rooms'].forEach((v) {
        rooms.add(new Room.Rooms.fromJson(v));
      });
    }
    time = json['time'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.date != null) {
      data['date'] = this.date.map((v) => v.toJson()).toList();
    }
    if (this.rooms != null) {
      data['rooms'] = this.rooms.map((v) => v.toJson()).toList();
    }
    data['time'] = this.time;
    return data;
  }
}

class Date {
  String title;
  String week;
  int timestamp;
  String date;

  Date({this.title, this.week, this.timestamp, this.date});

  Date.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    week = json['week'];
    timestamp = json['timestamp'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['week'] = this.week;
    data['timestamp'] = this.timestamp;
    data['date'] = this.date;
    return data;
  }
}

class Rooms {
  int roomId;
  String roomName;
  double price;
  String detail;
  int shopMoney;
  String defaultImg;

  // List<Null> imgList;
  List<Devices> devices;
  String numberDesc;
  int number;
  int minNumber;
  GoodsInfo goodsInfo;

  Rooms(
      {this.roomId,
      this.roomName,
      this.price,
      this.detail,
      this.shopMoney,
      this.defaultImg,
      // this.imgList,
      this.devices,
      this.numberDesc,
      this.number,
      this.minNumber,
      this.goodsInfo});

  Rooms.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    roomName = json['room_name'];
    price = json['price'];
    detail = json['detail'];
    shopMoney = json['shop_money'];
    defaultImg = json['default_img'];
    // if (json['img_list'] != null) {
    //   imgList = new List<Null>();
    //   json['img_list'].forEach((v) {
    //     imgList.add(new Null.fromJson(v));
    //   });
    // }
    if (json['devices'] != null) {
      devices = new List<Devices>();
      json['devices'].forEach((v) {
        devices.add(new Devices.fromJson(v));
      });
    }
    numberDesc = json['number_desc'];
    number = json['number'];
    minNumber = json['min_number'];
    goodsInfo = json['goods_info'] != null
        ? new GoodsInfo.fromJson(json['goods_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['room_name'] = this.roomName;
    data['price'] = this.price;
    data['detail'] = this.detail;
    data['shop_money'] = this.shopMoney;
    data['default_img'] = this.defaultImg;
    // if (this.imgList != null) {
    //   data['img_list'] = this.imgList.map((v) => v.toJson()).toList();
    // }
    if (this.devices != null) {
      data['devices'] = this.devices.map((v) => v.toJson()).toList();
    }
    data['number_desc'] = this.numberDesc;
    data['number'] = this.number;
    data['min_number'] = this.minNumber;
    if (this.goodsInfo != null) {
      data['goods_info'] = this.goodsInfo.toJson();
    }
    return data;
  }
}

class Devices {
  int id;
  String icon;
  String title;

  Devices({this.id, this.icon, this.title});

  Devices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['icon'] = this.icon;
    data['title'] = this.title;
    return data;
  }
}

class GoodsInfo {
  int goodsId;
  int roomStatus;
  String tips;
  String desc;
  int available;
  int needConfirm;
  int sort;

  GoodsInfo(
      {this.goodsId,
      this.roomStatus,
      this.tips,
      this.desc,
      this.available,
      this.needConfirm,
      this.sort});

  GoodsInfo.fromJson(Map<String, dynamic> json) {
    goodsId = json['goods_id'];
    roomStatus = json['room_status'];
    tips = json['tips'];
    desc = json['desc'];
    available = json['available'];
    needConfirm = json['need_confirm'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goods_id'] = this.goodsId;
    data['room_status'] = this.roomStatus;
    data['tips'] = this.tips;
    data['desc'] = this.desc;
    data['available'] = this.available;
    data['need_confirm'] = this.needConfirm;
    data['sort'] = this.sort;
    return data;
  }
}

class BusinessInfo {
  int id;
  int comId;
  String shopName;
  int cateId;
  String minDesc;
  String title;
  String address;
  String img;
  String bigShowImg;
  String longitude;
  String latitude;
  String dishes;
  String circleName;
  String distance;
  int perPerson;
  String parkingDesc;
  String detail;
  String roomInfo;
  String parkingLongitude;
  String parkingLatitude;
  String parkingName;
  String parkingAddress;
  int isSign;

  BusinessInfo(
      {this.id,
      this.comId,
      this.shopName,
      this.cateId,
      this.minDesc,
      this.title,
      this.address,
      this.img,
      this.bigShowImg,
      this.longitude,
      this.latitude,
      this.dishes,
      this.circleName,
      this.distance,
      this.perPerson,
      this.parkingDesc,
      this.detail,
      this.roomInfo,
      this.parkingLongitude,
      this.parkingLatitude,
      this.parkingName,
      this.parkingAddress,
      this.isSign});

  BusinessInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comId = json['com_id'];
    shopName = json['shop_name'];
    cateId = json['cate_id'];
    minDesc = json['min_desc'];
    title = json['title'];
    address = json['address'];
    img = json['img'];
    bigShowImg = json['big_show_img'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    dishes = json['dishes'];
    circleName = json['circle_name'];
    distance = json['Distance'];
    perPerson = json['per_person'];
    parkingDesc = json['parking_desc'];
    detail = json['detail'];
    roomInfo = json['room_info'];
    parkingLongitude = json['parking_longitude'];
    parkingLatitude = json['parking_latitude'];
    parkingName = json['parking_name'];
    parkingAddress = json['parking_address'];
    isSign = json['is_sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['com_id'] = this.comId;
    data['shop_name'] = this.shopName;
    data['cate_id'] = this.cateId;
    data['min_desc'] = this.minDesc;
    data['title'] = this.title;
    data['address'] = this.address;
    data['img'] = this.img;
    data['big_show_img'] = this.bigShowImg;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['dishes'] = this.dishes;
    data['circle_name'] = this.circleName;
    data['Distance'] = this.distance;
    data['per_person'] = this.perPerson;
    data['parking_desc'] = this.parkingDesc;
    data['detail'] = this.detail;
    data['room_info'] = this.roomInfo;
    data['parking_longitude'] = this.parkingLongitude;
    data['parking_latitude'] = this.parkingLatitude;
    data['parking_name'] = this.parkingName;
    data['parking_address'] = this.parkingAddress;
    data['is_sign'] = this.isSign;
    return data;
  }
}

class Cuisine {
  int id;
  String title;
  String pic;
  String price;
  int isSign;

  Cuisine({this.id, this.title, this.pic, this.price, this.isSign});

  Cuisine.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    pic = json['pic'];
    price = json['price'];
    isSign = json['is_sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['pic'] = this.pic;
    data['price'] = this.price;
    data['is_sign'] = this.isSign;
    return data;
  }
}

class Photos {
  int id;
  String src;
  String title;
  String subTitle;

  Photos({this.id, this.src});

  Photos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    src = json['src'];
    title = json['title'];
    subTitle = json['subTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['src'] = this.src;
    data['title'] = this.title;
    data['subTitle'] = this.subTitle;
    return data;
  }
}

class BusinessDetailBean {
  List<MenusListBean> menus;

  BusinessDetailBean({this.menus});

  BusinessDetailBean.fromJson(Map<String, dynamic> json) {
    this.menus = (json['menus'] as List) != null
        ? (json['menus'] as List).map((i) => MenusListBean.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menus'] =
        this.menus != null ? this.menus.map((i) => i.toJson()).toList() : null;
    return data;
  }
}

class MenusListBean {
  String title;
  String numbers;
  String perPrice;
  String dishesMenus;
  int id;

  MenusListBean(
      {this.title, this.numbers, this.perPrice, this.dishesMenus, this.id});

  MenusListBean.fromJson(Map<String, dynamic> json) {
    this.title = json['title'];
    this.numbers = json['numbers'];
    this.perPrice = json['per_price'];
    this.dishesMenus = json['dishes_menus'];
    this.id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['numbers'] = this.numbers;
    data['per_price'] = this.perPrice;
    data['dishes_menus'] = this.dishesMenus;
    data['id'] = this.id;
    return data;
  }
}
