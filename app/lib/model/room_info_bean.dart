class RoomInfo {
  String errorCode;
  String msg;
  Data data;

  RoomInfo({this.errorCode, this.msg, this.data});

  RoomInfo.fromJson(Map<String, dynamic> json) {
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
  List<Rooms> rooms;

  Data({this.rooms});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['rooms'] != null) {
      rooms = new List<Rooms>();
      json['rooms'].forEach((v) {
        rooms.add(new Rooms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rooms != null) {
      data['rooms'] = this.rooms.map((v) => v.toJson()).toList();
    }
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
  List<ImgList> imgList;
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
      this.imgList,
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
    if (json['img_list'] != null) {
      imgList = new List<ImgList>();
      json['img_list'].forEach((v) {
        imgList.add(new ImgList.fromJson(v));
      });
    }
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
    if (this.imgList != null) {
      data['img_list'] = this.imgList.map((v) => v.toJson()).toList();
    }
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

class ImgList {
  int id;
  int roomId;
  String src;
  String info;

  ImgList({this.id, this.roomId, this.src, this.info});

  ImgList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['room_id'];
    src = json['src'];
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_id'] = this.roomId;
    data['src'] = this.src;
    data['info'] = this.info;
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
