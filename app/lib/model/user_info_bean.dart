class UserInfoBean {
  String errorCode;
  String msg;
  Data data;

  UserInfoBean({this.errorCode, this.msg, this.data});

  UserInfoBean.fromJson(Map<String, dynamic> json) {
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
  AppEnterpriseInfo appEnterpriseInfo;
  AppUserInfo appUserInfo;
  String isBindPhone;
  String isCompany;
  String sessionId;

  Data(
      {this.appEnterpriseInfo,
        this.appUserInfo,
        this.isBindPhone,
        this.isCompany,
        this.sessionId});

  Data.fromJson(Map<String, dynamic> json) {
    appEnterpriseInfo = json['app_enterprise_info'] != null
        ? new AppEnterpriseInfo.fromJson(json['app_enterprise_info'])
        : null;
    appUserInfo = json['app_user_info'] != null
        ? new AppUserInfo.fromJson(json['app_user_info'])
        : null;
    isBindPhone = json['is_bind_phone'].toString();
    isCompany = json['is_company'].toString();
    sessionId = json['session_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appEnterpriseInfo != null) {
      data['app_enterprise_info'] = this.appEnterpriseInfo.toJson();
    }
    if (this.appUserInfo != null) {
      data['app_user_info'] = this.appUserInfo.toJson();
    }
    data['is_bind_phone'] = this.isBindPhone;
    data['is_company'] = this.isCompany;
    data['session_id'] = this.sessionId;
    return data;
  }
}

class AppEnterpriseInfo {
  int employeeId;
  String employeeName;
  int employeeNo;
  int userId;
  int enId;
  String telphone;
  String deparmentName;
  int departmentId;
  String email;
  String isAdmin;
  String isHeader;

  AppEnterpriseInfo(
      {this.employeeId,
        this.employeeName,
        this.employeeNo,
        this.userId,
        this.enId,
        this.telphone,
        this.deparmentName,
        this.departmentId,
        this.email,
        this.isAdmin,
        this.isHeader});

  AppEnterpriseInfo.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    employeeName = json['employee_name'];
    employeeNo = json['employee_no'];
    userId = json['user_id'];
    enId = json['en_id'];
    telphone = json['telphone'];
    deparmentName = json['deparment_name'];
    departmentId = json['department_id'];
    email = json['email'];
    isAdmin = json['is_admin'].toString();
    isHeader = json['is_header'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = this.employeeId;
    data['employee_name'] = this.employeeName;
    data['employee_no'] = this.employeeNo;
    data['user_id'] = this.userId;
    data['en_id'] = this.enId;
    data['telphone'] = this.telphone;
    data['deparment_name'] = this.deparmentName;
    data['department_id'] = this.departmentId;
    data['email'] = this.email;
    data['is_admin'] = this.isAdmin;
    data['is_header'] = this.isHeader;
    return data;
  }
}

class AppUserInfo {
  int userId;
  String nickName;
  String openid;
  String avatarUrl;
  String unionid;
  int registerTime;
  String bindPhone;
  String mobile;

  AppUserInfo(
      {this.userId,
        this.nickName,
        this.openid,
        this.avatarUrl,
        this.unionid,
        this.registerTime,
        this.bindPhone,
        this.mobile});

  AppUserInfo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    nickName = json['nick_name'];
    openid = json['openid'];
    avatarUrl = json['avatar_url'];
    unionid = json['unionid'];
    registerTime = json['register_time'];
    bindPhone = json['bind_phone'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['nick_name'] = this.nickName;
    data['openid'] = this.openid;
    data['avatar_url'] = this.avatarUrl;
    data['unionid'] = this.unionid;
    data['register_time'] = this.registerTime;
    data['bind_phone'] = this.bindPhone;
    data['mobile'] = this.mobile;
    return data;
  }
}
