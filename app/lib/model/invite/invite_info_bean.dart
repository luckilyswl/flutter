class InviteInfoBean {
  String errorCode;
  String msg;
  Data data;

  InviteInfoBean({this.errorCode, this.msg, this.data});

  InviteInfoBean.fromJson(Map<String, dynamic> json) {
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
  int id;
  String inviteName;
  String inviteDesc;
  String user;
  String businessName;
  String businessDetail;
  String address;
  String room;
  String dateTime;
  String longitude;
  String latitude;
  String isParking;
  String parkingDesc;
  String parkingName;
  String parkingAddress;
  String parkingLongitude;
  String parkingLatitude;
  String tel;
  RoomInfo roomInfo;
  List<Photos> photos;
  ShareInfo shareInfo;

  Data(
      {this.id,
      this.inviteName,
      this.inviteDesc,
      this.user,
      this.businessName,
      this.businessDetail,
      this.address,
      this.room,
      this.dateTime,
      this.longitude,
      this.latitude,
      this.isParking,
      this.parkingDesc,
      this.parkingName,
      this.parkingAddress,
      this.parkingLongitude,
      this.parkingLatitude,
      this.tel,
      this.roomInfo,
      this.photos,
      this.shareInfo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    inviteName = json['invite_name'];
    inviteDesc = json['invite_desc'];
    user = json['user'];
    businessName = json['business_name'];
    businessDetail = json['business_detail'];
    address = json['address'];
    room = json['room'];
    dateTime = json['date_time'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    isParking = json['is_parking'];
    parkingDesc = json['parking_desc'];
    parkingName = json['parking_name'];
    parkingAddress = json['parking_address'];
    parkingLongitude = json['parking_longitude'];
    parkingLatitude = json['parking_latitude'];
    tel = json['tel'];
    roomInfo = json['room_info'] != null
        ? new RoomInfo.fromJson(json['room_info'])
        : null;

    shareInfo = json['share_info'] != null
        ? new ShareInfo.fromJson(json['share_info'])
        : null;
    if (json['photos'] != null) {
      photos = new List<Photos>();
      json['photos'].forEach((v) {
        photos.add(new Photos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['invite_name'] = this.inviteName;
    data['invite_desc'] = this.inviteDesc;
    data['user'] = this.user;
    data['business_name'] = this.businessName;
    data['business_detail'] = this.businessDetail;
    data['address'] = this.address;
    data['room'] = this.room;
    data['date_time'] = this.dateTime;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['is_parking'] = this.isParking;
    data['parking_desc'] = this.parkingDesc;
    data['parking_name'] = this.parkingName;
    data['parking_address'] = this.parkingAddress;
    data['parking_longitude'] = this.parkingLongitude;
    data['parking_latitude'] = this.parkingLatitude;
    data['tel'] = this.tel;
    if (this.roomInfo != null) {
      data['room_info'] = this.roomInfo.toJson();
    }

    if (this.shareInfo != null) {
      data['share_info'] = this.shareInfo.toJson();
    }
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RoomInfo {
  String defaultImg;
  String roomName;

  RoomInfo({this.defaultImg, this.roomName});

  RoomInfo.fromJson(Map<String, dynamic> json) {
    defaultImg = json['default_img'];
    roomName = json['room_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['default_img'] = this.defaultImg;
    data['room_name'] = this.roomName;
    return data;
  }
}

class Photos {
  int id;
  String src;

  Photos({this.id, this.src});

  Photos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['src'] = this.src;
    return data;
  }
}

class ShareInfo {
  int shareType;
  Param param;

  ShareInfo({this.shareType, this.param});

  ShareInfo.fromJson(Map<String, dynamic> json) {
    shareType = json['share_type'];
    param = json['param'] != null ? new Param.fromJson(json['param']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['share_type'] = this.shareType;
    if (this.param != null) {
      data['param'] = this.param.toJson();
    }
    return data;
  }
}

class Param {
  String userName;
  String path;
  String hdImageData;

  Param({this.userName, this.path, this.hdImageData});

  Param.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    path = json['path'];
    hdImageData = json['hd_image_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['path'] = this.path;
    data['hd_image_data'] = this.hdImageData;
    return data;
  }
}
