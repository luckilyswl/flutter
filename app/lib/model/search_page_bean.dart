class SearchPageBean {
  String error_code;
  String msg;
  DataBean data;

  SearchPageBean({this.error_code, this.msg, this.data});

  SearchPageBean.fromJson(Map<String, dynamic> json) {
    this.error_code = json['error_code'].toString();
    this.msg = json['msg'];
    this.data = json['data'] != null ? DataBean.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error_code'] = this.error_code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class DataBean {
  List<BannerListBean> banner;
  List<String> history;
  List<HotSearchListBean> hotSearch;

  DataBean({this.banner, this.history, this.hotSearch});

  DataBean.fromJson(Map<String, dynamic> json) {
    this.banner = (json['banner'] as List) != null
        ? (json['banner'] as List)
            .map((i) => BannerListBean.fromJson(i))
            .toList()
        : null;
    List<dynamic> historyList = json['history'];
    this.history = new List();
    this.history.addAll(historyList.map((o) => o.toString()));
    this.hotSearch = (json['hot_search'] as List) != null
        ? (json['hot_search'] as List)
            .map((i) => HotSearchListBean.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner'] = this.banner != null
        ? this.banner.map((i) => i.toJson()).toList()
        : null;
    data['history'] = this.history;
    data['hot_search'] = this.hotSearch != null
        ? this.hotSearch.map((i) => i.toJson()).toList()
        : null;
    return data;
  }
}

class BannerListBean {
  String imgUrl;
  String refererUrl;
  int type;

  BannerListBean({this.imgUrl, this.refererUrl, this.type});

  BannerListBean.fromJson(Map<String, dynamic> json) {
    this.imgUrl = json['img_url'];
    this.refererUrl = json['referer_url'];
    this.type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_url'] = this.imgUrl;
    data['referer_url'] = this.refererUrl;
    data['type'] = this.type;
    return data;
  }
}

class HistoryListBean {
  String keyword;

  HistoryListBean({this.keyword});

  HistoryListBean.fromJson(Map<String, dynamic> json) {
    this.keyword = json['keyword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['keyword'] = this.keyword;
    return data;
  }
}

class HotSearchListBean {
  int id;
  String shopName;

  HotSearchListBean({this.id, this.shopName});

  HotSearchListBean.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.shopName = json['shop_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_name'] = this.shopName;
    return data;
  }
}
