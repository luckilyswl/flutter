class ReqBusinessListBean {
  String page;
  String pageSize;
  String areaId;
  String circleId;
  String environment;
  String scene;
  String devices;
  String roomType;
  String distanceOrder;
  String priceOrder;
  String priceOption;
  String dishes;
  String numbers;
  String bookTime;
  String keywords;

  ReqBusinessListBean({
    this.page = '1',
    this.pageSize = '20',
    this.areaId = '',
    this.circleId = '',
    this.environment = '',
    this.scene = '',
    this.devices = '',
    this.roomType = '',
    this.distanceOrder = '',
    this.priceOrder = '',
    this.priceOption = '',
    this.dishes = '',
    this.numbers = '',
    this.bookTime = '',
    this.keywords = '',
  });

  ReqBusinessListBean.fromJson(Map<String, dynamic> json) {
    this.page = json['page'];
    this.pageSize = json['page_size'];
    this.areaId = json['area_id'];
    this.circleId = json['circle_id'];
    this.environment = json['environment'];
    this.scene = json['scene'];
    this.devices = json['devices'];
    this.roomType = json['room_type'];
    this.distanceOrder = json['distance_order'];
    this.priceOrder = json['price_order'];
    this.priceOption = json['price_option'];
    this.dishes = json['dishes'];
    this.numbers = json['numbers'];
    this.bookTime = json['book_time'];
    this.keywords = json['keywords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['page_size'] = this.pageSize;
    data['area_id'] = this.areaId;
    data['circle_id'] = this.circleId;
    data['environment'] = this.environment;
    data['scene'] = this.scene;
    data['devices'] = this.devices;
    data['room_type'] = this.roomType;
    data['distance_order'] = this.distanceOrder;
    data['price_order'] = this.priceOrder;
    data['price_option'] = this.priceOption;
    data['dishes'] = this.dishes;
    data['numbers'] = this.numbers;
    data['book_time'] = this.bookTime;
    data['keywords'] = this.keywords;
    return data;
  }
}
