class SearchConditionBean {
  String errorCode;
  String msg;
  Data data;

  SearchConditionBean({this.errorCode, this.msg, this.data});

  SearchConditionBean.fromJson(Map<String, dynamic> json) {
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
  List<Areas> areas;
  List<Date> date;
  Devices devices;
  List<Dishes> dishes;
  DistanceOrder distanceOrder;
  Environment environment;
  List<String> moreFilter;
  List<int> numbers;
  PriceOption priceOption;
  PriceOrder priceOrder;
  RoomType roomType;
  Scene scene;
  List<String> time;

  Data(
      {this.areas,
      this.date,
      this.devices,
      this.dishes,
      this.distanceOrder,
      this.environment,
      this.moreFilter,
      this.numbers,
      this.priceOption,
      this.priceOrder,
      this.roomType,
      this.scene,
      this.time});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['areas'] != null) {
      areas = new List<Areas>();
      json['areas'].forEach((v) {
        areas.add(new Areas.fromJson(v));
      });
    }
    if (json['date'] != null) {
      date = new List<Date>();
      json['date'].forEach((v) {
        date.add(new Date.fromJson(v));
      });
    }
    devices =
        json['devices'] != null ? new Devices.fromJson(json['devices']) : null;
    if (json['dishes'] != null) {
      dishes = new List<Dishes>();
      json['dishes'].forEach((v) {
        dishes.add(new Dishes.fromJson(v));
      });
    }
    distanceOrder = json['distance_order'] != null
        ? new DistanceOrder.fromJson(json['distance_order'])
        : null;
    environment = json['environment'] != null
        ? new Environment.fromJson(json['environment'])
        : null;
    moreFilter = json['more_filter'].cast<String>();
    numbers = json['numbers'].cast<int>();
    priceOption = json['price_option'] != null
        ? new PriceOption.fromJson(json['price_option'])
        : null;
    priceOrder = json['price_order'] != null
        ? new PriceOrder.fromJson(json['price_order'])
        : null;
    roomType = json['room_type'] != null
        ? new RoomType.fromJson(json['room_type'])
        : null;
    scene = json['scene'] != null ? new Scene.fromJson(json['scene']) : null;
    time = json['time'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.areas != null) {
      data['areas'] = this.areas.map((v) => v.toJson()).toList();
    }
    if (this.date != null) {
      data['date'] = this.date.map((v) => v.toJson()).toList();
    }
    if (this.devices != null) {
      data['devices'] = this.devices.toJson();
    }
    if (this.dishes != null) {
      data['dishes'] = this.dishes.map((v) => v.toJson()).toList();
    }
    if (this.distanceOrder != null) {
      data['distance_order'] = this.distanceOrder.toJson();
    }
    if (this.environment != null) {
      data['environment'] = this.environment.toJson();
    }
    data['more_filter'] = this.moreFilter;
    data['numbers'] = this.numbers;
    if (this.priceOption != null) {
      data['price_option'] = this.priceOption.toJson();
    }
    if (this.priceOrder != null) {
      data['price_order'] = this.priceOrder.toJson();
    }
    if (this.roomType != null) {
      data['room_type'] = this.roomType.toJson();
    }
    if (this.scene != null) {
      data['scene'] = this.scene.toJson();
    }
    data['time'] = this.time;
    return data;
  }
}

class Areas {
  int areaId;
  String name;
  List<Circles> circles;

  Areas({this.areaId, this.name, this.circles});

  Areas.fromJson(Map<String, dynamic> json) {
    areaId = json['area_id'];
    name = json['name'];
    if (json['circles'] != null) {
      circles = new List<Circles>();
      json['circles'].forEach((v) {
        circles.add(new Circles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area_id'] = this.areaId;
    data['name'] = this.name;
    if (this.circles != null) {
      data['circles'] = this.circles.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Circles {
  int circleId;
  String name;

  Circles({this.circleId, this.name});

  Circles.fromJson(Map<String, dynamic> json) {
    circleId = json['circle_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['circle_id'] = this.circleId;
    data['name'] = this.name;
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

class Devices {
  List<Items> items;
  int multiple;
  String name;

  Devices({this.items, this.multiple, this.name});

  Devices.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    multiple = json['multiple'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['multiple'] = this.multiple;
    data['name'] = this.name;
    return data;
  }
}

class Items {
  int value;
  String text;

  Items({this.value, this.text});

  Items.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['text'] = this.text;
    return data;
  }
}

class Dishes {
  int id;
  String name;
  int parentId;
  List<Dishes> subItems;

  Dishes({this.id, this.name, this.parentId, this.subItems});

  Dishes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    if (json['sub_items'] != null) {
      subItems = new List<Dishes>();
      json['sub_items'].forEach((v) {
        subItems.add(new Dishes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['parent_id'] = this.parentId;
    if (this.subItems != null) {
      data['sub_items'] = this.subItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DistanceOrder {
  List<DistanceItems> items;
  int multiple;
  String name;

  DistanceOrder({this.items, this.multiple, this.name});

  DistanceOrder.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<DistanceItems>();
      json['items'].forEach((v) {
        items.add(new DistanceItems.fromJson(v));
      });
    }
    multiple = json['multiple'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['multiple'] = this.multiple;
    data['name'] = this.name;
    return data;
  }
}

class DistanceItems {
  int value;
  String text;

  DistanceItems({this.value, this.text});

  DistanceItems.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['text'] = this.text;
    return data;
  }
}

class Environment {
  List<Items> items;
  int multiple;
  String name;

  Environment({this.items, this.multiple, this.name});

  Environment.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    multiple = json['multiple'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['multiple'] = this.multiple;
    data['name'] = this.name;
    return data;
  }
}

class PriceOption {
  List<Items> items;
  int multiple;
  String name;

  PriceOption({this.items, this.multiple, this.name});

  PriceOption.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    multiple = json['multiple'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['multiple'] = this.multiple;
    data['name'] = this.name;
    return data;
  }
}

class PriceOrder {
  List<Items> items;
  int multiple;
  String name;

  PriceOrder({this.items, this.multiple, this.name});

  PriceOrder.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    multiple = json['multiple'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['multiple'] = this.multiple;
    data['name'] = this.name;
    return data;
  }
}

class RoomType {
  List<Items> items;
  int multiple;
  String name;

  RoomType({this.items, this.multiple, this.name});

  RoomType.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    multiple = json['multiple'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['multiple'] = this.multiple;
    data['name'] = this.name;
    return data;
  }
}

class Scene {
  List<Items> items;
  int multiple;
  String name;

  Scene({this.items, this.multiple, this.name});

  Scene.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    multiple = json['multiple'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['multiple'] = this.multiple;
    data['name'] = this.name;
    return data;
  }
}
