class HomeInfoBean {
  String errorCode;
  String msg;
  DataBean data;

  HomeInfoBean({this.errorCode, this.msg, this.data});

  HomeInfoBean.fromJson(Map<String, dynamic> json) {    
    this.errorCode = json['error_code'];
    this.msg = json['msg'];
    this.data = json['data'] != null ? DataBean.fromJson(json['data']) : null;
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

class DataBean {
  String indexSearchMotion;
  String indexSearchTip;
  String pageTitle;
  int isCompany;
  List<QuickDataListBean> quickData;
  List<TopMenuListBean> topMenu;

  DataBean({this.indexSearchMotion, this.indexSearchTip, this.pageTitle, this.isCompany, this.quickData, this.topMenu});

  DataBean.fromJson(Map<String, dynamic> json) {    
    this.indexSearchMotion = json['index_search_motion'];
    this.indexSearchTip = json['index_search_tip'];
    this.pageTitle = json['page_title'];
    this.isCompany = json['is_company'];
    this.quickData = (json['quick_data'] as List)!=null?(json['quick_data'] as List).map((i) => QuickDataListBean.fromJson(i)).toList():null;
    this.topMenu = (json['top_menu'] as List)!=null?(json['top_menu'] as List).map((i) => TopMenuListBean.fromJson(i)).toList():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index_search_motion'] = this.indexSearchMotion;
    data['index_search_tip'] = this.indexSearchTip;
    data['page_title'] = this.pageTitle;
    data['is_company'] = this.isCompany;
    data['quick_data'] = this.quickData != null?this.quickData.map((i) => i.toJson()).toList():null;
    data['top_menu'] = this.topMenu != null?this.topMenu.map((i) => i.toJson()).toList():null;
    return data;
  }
}

class QuickDataListBean {
  String imgUrl;
  String refererUrl;
  String type;
  String desc;
  String adName;
  int id;
  int cityId;

  QuickDataListBean({this.imgUrl, this.refererUrl, this.type, this.desc, this.adName, this.id, this.cityId});

  QuickDataListBean.fromJson(Map<String, dynamic> json) {    
    this.imgUrl = json['img_url'];
    this.refererUrl = json['referer_url'];
    this.type = json['type'];
    this.desc = json['desc'];
    this.adName = json['ad_name'];
    this.id = json['id'];
    this.cityId = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_url'] = this.imgUrl;
    data['referer_url'] = this.refererUrl;
    data['type'] = this.type;
    data['desc'] = this.desc;
    data['ad_name'] = this.adName;
    data['id'] = this.id;
    data['city_id'] = this.cityId;
    return data;
  }
}

class TopMenuListBean {
  String imgUrl;
  String refererUrl;
  String type;
  String desc;
  String adName;
  int id;
  int cityId;

  TopMenuListBean({this.imgUrl, this.refererUrl, this.type, this.desc, this.adName, this.id, this.cityId});

  TopMenuListBean.fromJson(Map<String, dynamic> json) {    
    this.imgUrl = json['img_url'];
    this.refererUrl = json['referer_url'];
    this.type = json['type'];
    this.desc = json['desc'];
    this.adName = json['ad_name'];
    this.id = json['id'];
    this.cityId = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_url'] = this.imgUrl;
    data['referer_url'] = this.refererUrl;
    data['type'] = this.type;
    data['desc'] = this.desc;
    data['ad_name'] = this.adName;
    data['id'] = this.id;
    data['city_id'] = this.cityId;
    return data;
  }
}
