class ManagerHomeInfo {
  String errorCode;
  String msg;
  Data data;

  ManagerHomeInfo({this.errorCode, this.msg, this.data});

  ManagerHomeInfo.fromJson(Map<String, dynamic> json) {
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
  Account account;
  List<Articles> articles;
  List<Banner> banner;
  CompanyInfo companyInfo;
  List<Departments> departments;
  Employee employee;
  int enterpriseAccountShow;
  /// 是否可编辑
  int companyEditable;
  List<Options> options;
  UnloginInfo unloginInfo;

  Data({this.account, this.articles, this.banner, this.companyInfo, this.departments, this.employee, this.enterpriseAccountShow, this.options, this.unloginInfo});

  Data.fromJson(Map<String, dynamic> json) {
    account = json['account'] != null ? new Account.fromJson(json['account']) : null;
    if (json['articles'] != null) {
      articles = new List<Articles>();
      json['articles'].forEach((v) { articles.add(new Articles.fromJson(v)); });
    }
    if (json['banner'] != null) {
      banner = new List<Banner>();
      json['banner'].forEach((v) { banner.add(new Banner.fromJson(v)); });
    }
    companyInfo = json['company_info'] != null ? new CompanyInfo.fromJson(json['company_info']) : null;
    if (json['departments'] != null) {
      departments = new List<Departments>();
      json['departments'].forEach((v) { departments.add(new Departments.fromJson(v)); });
    }
    employee = json['employee'] != null ? new Employee.fromJson(json['employee']) : null;
    enterpriseAccountShow = json['enterprise_account_show'];
    companyEditable = json['company_editable'];
    if (json['options'] != null) {
      options = new List<Options>();
      json['options'].forEach((v) { options.add(new Options.fromJson(v)); });
    }
    unloginInfo = json['unlogin_info'] != null ? new UnloginInfo.fromJson(json['unlogin_info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.account != null) {
      data['account'] = this.account.toJson();
    }
    if (this.articles != null) {
      data['articles'] = this.articles.map((v) => v.toJson()).toList();
    }
    if (this.banner != null) {
      data['banner'] = this.banner.map((v) => v.toJson()).toList();
    }
    if (this.companyInfo != null) {
      data['company_info'] = this.companyInfo.toJson();
    }
    if (this.departments != null) {
      data['departments'] = this.departments.map((v) => v.toJson()).toList();
    }
    if (this.employee != null) {
      data['employee'] = this.employee.toJson();
    }
    data['enterprise_account_show'] = this.enterpriseAccountShow;
    data['company_editable'] = this.companyEditable;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    if (this.unloginInfo != null) {
      data['unlogin_info'] = this.unloginInfo.toJson();
    }
    return data;
  }
}

class Account {
  String balance;
  String desc;
  String rechargeDesc;
  String title;
  /// 1. 管理员  2. 部门预算
  int type;

  Account({this.balance, this.desc, this.rechargeDesc, this.title, this.type});

  Account.fromJson(Map<String, dynamic> json) {
    balance = json['balance'].toString();
    desc = json['desc'];
    rechargeDesc = json['recharge_desc'];
    title = json['title'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['desc'] = this.desc;
    data['recharge_desc'] = this.rechargeDesc;
    data['title'] = this.title;
    data['type'] = this.type;
    return data;
  }
}

class Articles {
  int typeId;
  String name;
  List<Items> items;

  Articles({this.typeId, this.name, this.items});

  Articles.fromJson(Map<String, dynamic> json) {
    typeId = json['type_id'];
    name = json['name'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type_id'] = this.typeId;
    data['name'] = this.name;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Employee {
  int employeeId;
  String employeeName;
  int isAdmin;

  Employee({this.employeeId, this.employeeName, this.isAdmin});

  Employee.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    employeeName = json['employee_name'];
    isAdmin = json['is_admin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = this.employeeId;
    data['employee_name'] = this.employeeName;
    data['is_admin'] = this.isAdmin;
    return data;
  }
}


class Items {
  int id;
  String title;
  String description;
  String content;
  int categoryId;

  Items({this.id, this.title, this.description, this.content, this.categoryId});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    content = json['content'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['content'] = this.content;
    data['category_id'] = this.categoryId;
    return data;
  }
}

class Banner {
  int id;
  String imgUrl;
  String refererUrl;
  int cityId;
  String type;
  String desc;
  String adName;

  Banner({this.id, this.imgUrl, this.refererUrl, this.cityId, this.type, this.desc, this.adName});

  Banner.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  imgUrl = json['img_url'];
  refererUrl = json['referer_url'];
  cityId = json['city_id'];
  type = json['type'];
  desc = json['desc'];
  adName = json['ad_name'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['img_url'] = this.imgUrl;
  data['referer_url'] = this.refererUrl;
  data['city_id'] = this.cityId;
  data['type'] = this.type;
  data['desc'] = this.desc;
  data['ad_name'] = this.adName;
  return data;
  }
}

class EnterpriseBanner {
  int id;
  String imgUrl;
  String refererUrl;
  int cityId;
  String type;
  String desc;
  String adName;

  EnterpriseBanner(
      {this.id,
      this.imgUrl,
      this.refererUrl,
      this.cityId,
      this.type,
      this.desc,
      this.adName});

  EnterpriseBanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imgUrl = json['img_url'];
    refererUrl = json['referer_url'];
    cityId = json['city_id'];
    type = json['type'];
    desc = json['desc'];
    adName = json['ad_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['img_url'] = this.imgUrl;
    data['referer_url'] = this.refererUrl;
    data['city_id'] = this.cityId;
    data['type'] = this.type;
    data['desc'] = this.desc;
    data['ad_name'] = this.adName;
    return data;
  }
}

class EnterprisiePresentBanner {
  int id;
  String imgUrl;
  String refererUrl;
  int cityId;
  String type;
  String desc;
  String adName;

  EnterprisiePresentBanner(
      {this.id,
      this.imgUrl,
      this.refererUrl,
      this.cityId,
      this.type,
      this.desc,
      this.adName});

  EnterprisiePresentBanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imgUrl = json['img_url'];
    refererUrl = json['referer_url'];
    cityId = json['city_id'];
    type = json['type'];
    desc = json['desc'];
    adName = json['ad_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['img_url'] = this.imgUrl;
    data['referer_url'] = this.refererUrl;
    data['city_id'] = this.cityId;
    data['type'] = this.type;
    data['desc'] = this.desc;
    data['ad_name'] = this.adName;
    return data;
  }
}

class CompanyInfo {
  int id;
  String enterpriseName;
  String telphone;
  String joinQrcodeUrl;

  CompanyInfo(
      {this.id, this.enterpriseName, this.telphone, this.joinQrcodeUrl});

  CompanyInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enterpriseName = json['enterprise_name'];
    telphone = json['telphone'];
    joinQrcodeUrl = json['join_qrcode_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['enterprise_name'] = this.enterpriseName;
    data['telphone'] = this.telphone;
    data['join_qrcode_url'] = this.joinQrcodeUrl;
    return data;
  }
}

class Departments {
  int id;
  int parentId;
  String departmentName;
  String desc;
  int level;
  List<Departments> subItems;

  Departments(
      {this.id, this.parentId, this.departmentName, this.desc, this.subItems});

  Departments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    departmentName = json['department_name'];
    desc = json['desc'];
    if (json['sub_items'] != null) {
      subItems = new List<Departments>();
      json['sub_items'].forEach((v) {
        subItems.add(new Departments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['department_name'] = this.departmentName;
    data['desc'] = this.desc;
    data['level'] = this.level;
    if (this.subItems != null) {
      data['sub_items'] = this.subItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UnloginInfo {
  String title;
  String desc;

  UnloginInfo({this.title, this.desc});

  UnloginInfo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['desc'] = this.desc;
    return data;
  }
}

class Options {
  String icon;
  String name;
  String url;
  int notice;
  String type;

  Options({this.icon, this.name, this.url, this.notice, this.type});

  Options.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    name = json['name'];
    url = json['url'];
    notice = json['notice'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['name'] = this.name;
    data['url'] = this.url;
    data['notice'] = this.notice;
    data['type'] = this.type;
    return data;
  }
}
