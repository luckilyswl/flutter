class MyInfoBean {
  String errorCode;
  String msg;
  DataBean data;

  MyInfoBean({this.errorCode, this.msg, this.data});

  MyInfoBean.fromJson(Map<String, dynamic> json) {
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
  String rechargeDesc;
  String isCompany;
  CompanyBalanceBean companyBalance;
  CompanyInfoBean companyInfo;
  UserBalanceBean userBalance;
  UserInfoBean userInfo;

  DataBean(
      {this.rechargeDesc,
      this.isCompany,
      this.companyBalance,
      this.companyInfo,
      this.userBalance,
      this.userInfo});

  DataBean.fromJson(Map<String, dynamic> json) {
    this.rechargeDesc = json['recharge_desc'];
    this.isCompany = json['is_company'].toString();
    this.companyBalance = json['app_enterprise_balance'] != null
        ? CompanyBalanceBean.fromJson(json['app_enterprise_balance'])
        : null;
    this.companyInfo = json['app_enterprise_info'] != null
        ? CompanyInfoBean.fromJson(json['app_enterprise_info'])
        : null;
    this.userBalance = json['app_user_balance'] != null
        ? UserBalanceBean.fromJson(json['app_user_balance'])
        : null;
    this.userInfo = json['app_user_info'] != null
        ? UserInfoBean.fromJson(json['app_user_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recharge_desc'] = this.rechargeDesc;
    data['is_company'] = this.isCompany;
    if (this.companyBalance != null) {
      data['app_enterprise_balance'] = this.companyBalance.toJson();
    }
    if (this.companyInfo != null) {
      data['app_enterprise_info'] = this.companyInfo.toJson();
    }
    if (this.userBalance != null) {
      data['app_user_balance'] = this.userBalance.toJson();
    }
    if (this.userInfo != null) {
      data['app_user_info'] = this.userInfo.toJson();
    }
    return data;
  }
}

class CompanyBalanceBean {
  String availableBalance;
  String usedBalance;
  int id;
  int enId;
  String totalBalance;
  String freezeBalance;
  String largessBalance;
  int createTime;
  int lastUpdateTime;

  CompanyBalanceBean(
      {this.availableBalance,
      this.usedBalance,
      this.id,
      this.enId,
      this.totalBalance,
      this.freezeBalance,
      this.largessBalance,
      this.createTime,
      this.lastUpdateTime});

  CompanyBalanceBean.fromJson(Map<String, dynamic> json) {
    this.availableBalance = json['available_balance'].toString();
    this.usedBalance = json['used_balance'].toString();
    this.id = json['id'];
    this.enId = json['en_id'];
    this.totalBalance = json['total_balance'].toString();
    this.freezeBalance = json['freeze_balance'].toString();
    this.largessBalance = json['largess_balance'].toString();
    this.createTime = json['create_time'];
    this.lastUpdateTime = json['last_update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['available_balance'] = this.availableBalance;
    data['used_balance'] = this.usedBalance;
    data['id'] = this.id;
    data['en_id'] = this.enId;
    data['total_balance'] = this.totalBalance;
    data['freeze_balance'] = this.freezeBalance;
    data['largess_balance'] = this.largessBalance;
    data['create_time'] = this.createTime;
    data['last_update_time'] = this.lastUpdateTime;
    return data;
  }
}

class CompanyInfoBean {
  String employeeName;
  String companyName;
  String departmentName;
  String telphone;
  String adminRoleName;
  String headerRoleName;
  int enId;
  int employeeId;
  String isAdmin;
  String isHeader;

  CompanyInfoBean(
      {this.employeeName,
      this.companyName,
      this.departmentName,
      this.telphone,
      this.adminRoleName,
      this.headerRoleName,
      this.enId,
      this.employeeId,
      this.isAdmin,
      this.isHeader});

  CompanyInfoBean.fromJson(Map<String, dynamic> json) {
    this.employeeName = json['employee_name'];
    this.companyName = json['company_name'];
    this.departmentName = json['department_name'];
    this.telphone = json['telphone'];
    this.adminRoleName = json['admin_role_name'];
    this.headerRoleName = json['header_role_name'];
    this.enId = json['en_id'];
    this.employeeId = json['employee_id'];
    this.isAdmin = json['is_admin'].toString();
    this.isHeader = json['is_header'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_name'] = this.employeeName;
    data['company_name'] = this.companyName;
    data['department_name'] = this.departmentName;
    data['telphone'] = this.telphone;
    data['admin_role_name'] = this.adminRoleName;
    data['header_role_name'] = this.headerRoleName;
    data['en_id'] = this.enId;
    data['employee_id'] = this.employeeId;
    data['is_admin']  = this.isAdmin;
    data['is_header'] = this.isHeader;
    return data;
  }
}

class UserBalanceBean {
  int id;
  int userId;
  String availableBalance;
  String totalBalance;
  String freezeBalance;
  String usedBalance;
  String largessBalance;
  String rebateMoney;
  int createTime;
  int lastUpdateTime;

  UserBalanceBean(
      {this.id,
      this.userId,
      this.availableBalance,
      this.totalBalance,
      this.freezeBalance,
      this.usedBalance,
      this.largessBalance,
      this.rebateMoney,
      this.createTime,
      this.lastUpdateTime});

  UserBalanceBean.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.userId = json['user_id'];
    this.availableBalance = json['available_balance'].toString();
    this.totalBalance = json['total_balance'].toString();
    this.freezeBalance = json['freeze_balance'].toString();
    this.usedBalance = json['used_balance'].toString();
    this.largessBalance = json['largess_balance'].toString();
    this.rebateMoney = json['rebate_money'].toString();
    this.createTime = json['create_time'];
    this.lastUpdateTime = json['last_update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['available_balance'] = this.availableBalance;
    data['total_balance'] = this.totalBalance;
    data['freeze_balance'] = this.freezeBalance;
    data['used_balance'] = this.usedBalance;
    data['largess_balance'] = this.largessBalance;
    data['rebate_money'] = this.rebateMoney;
    data['create_time'] = this.createTime;
    data['last_update_time'] = this.lastUpdateTime;
    return data;
  }
}

class UserInfoBean {
  String nickName;
  String openid;
  String avatarUrl;
  String unionid;
  String bindPhone;
  String mobile;
  int userId;
  int registerTime;

  UserInfoBean(
      {this.nickName,
      this.openid,
      this.avatarUrl,
      this.unionid,
      this.bindPhone,
      this.mobile,
      this.userId,
      this.registerTime});

  UserInfoBean.fromJson(Map<String, dynamic> json) {
    this.nickName = json['nick_name'];
    this.openid = json['openid'];
    this.avatarUrl = json['avatar_url'];
    this.unionid = json['unionid'];
    this.bindPhone = json['bind_phone'];
    this.mobile = json['mobile'];
    this.userId = json['user_id'];
    this.registerTime = json['register_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nick_name'] = this.nickName;
    data['openid'] = this.openid;
    data['avatar_url'] = this.avatarUrl;
    data['unionid'] = this.unionid;
    data['bind_phone'] = this.bindPhone;
    data['mobile'] = this.mobile;
    data['user_id'] = this.userId;
    data['register_time'] = this.registerTime;
    return data;
  }
}
