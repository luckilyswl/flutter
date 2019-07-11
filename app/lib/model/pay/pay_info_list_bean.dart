class PayInfoListBean {
  String errorCode;
  String msg;
  PayInfoListData data;

  PayInfoListBean({this.errorCode, this.msg, this.data});

  PayInfoListBean.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    msg = json['msg'];
    data = json['data'] != null ? new PayInfoListData.fromJson(json['data']) : null;
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

class PayInfoListData {
  String businessSetAmount;
  List<PayInfoListCoupons> coupons;
  int enterprisePay;
  List<PayInfoListOptions> options;
  PayInfoListOrder order;
  List<PayInfoListPayInfo> payInfo;
  RechargeRecommend rechargeRecommend;
  PayInfoListSelectCoupon selectCoupon;
  PayInfoListAccountOption accountOption;

  PayInfoListData(
      {this.businessSetAmount,
      this.coupons,
      this.enterprisePay,
      this.options,
      this.order,
      this.payInfo,
      this.rechargeRecommend,
      this.selectCoupon,
      this.accountOption});

  PayInfoListData.fromJson(Map<String, dynamic> json) {
    businessSetAmount = json['business_set_amount'].toString();
    if (json['coupons'] != null) {
      coupons = new List<PayInfoListCoupons>();
      json['coupons'].forEach((v) {
        coupons.add(new PayInfoListCoupons.fromJson(v));
      });
    }
    enterprisePay = json['enterprise_pay'];
    if (json['options'] != null) {
      options = new List<PayInfoListOptions>();
      json['options'].forEach((v) {
        options.add(new PayInfoListOptions.fromJson(v));
      });
    }
    order = json['order'] != null ? new PayInfoListOrder.fromJson(json['order']) : null;
    if (json['pay_info'] != null) {
      payInfo = new List<PayInfoListPayInfo>();
      json['pay_info'].forEach((v) {
        payInfo.add(new PayInfoListPayInfo.fromJson(v));
      });
    }
    rechargeRecommend = json['recharge_recommend'] != null
        ? new RechargeRecommend.fromJson(json['recharge_recommend'])
        : null;
    selectCoupon = json['select_coupon'] != null
        ? new PayInfoListSelectCoupon.fromJson(json['select_coupon'])
        : null;
    accountOption = json['account_option'] != null
        ? new PayInfoListAccountOption.fromJson(json['account_option'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_set_amount'] = this.businessSetAmount;
    if (this.coupons != null) {
      data['coupons'] = this.coupons.map((v) => v.toJson()).toList();
    }
    data['enterprise_pay'] = this.enterprisePay;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    if (this.order != null) {
      data['order'] = this.order.toJson();
    }
    if (this.payInfo != null) {
      data['pay_info'] = this.payInfo.map((v) => v.toJson()).toList();
    }
    if (this.rechargeRecommend != null) {
      data['recharge_recommend'] = this.rechargeRecommend.toJson();
    }
    if (this.selectCoupon != null) {
      data['select_coupon'] = this.selectCoupon.toJson();
    }
    if (this.accountOption != null) {
      data['account_option'] = this.accountOption.toJson();
    }
    return data;
  }
}

class PayInfoListCoupons {
  int couponId;
  String title;
  double money;
  int offMoney;
  String expireTime;
  int expiring;
  String desc;
  int available;
  int active;
  String rules;
  int status;
  String affectedTime;
  int businessId;
  String couponDesc;

  PayInfoListCoupons(
      {this.couponId,
      this.title,
      this.money,
      this.offMoney,
      this.expireTime,
      this.expiring,
      this.desc,
      this.available,
      this.active,
      this.rules,
      this.status,
      this.affectedTime,
      this.businessId,
      this.couponDesc});

  PayInfoListCoupons.fromJson(Map<String, dynamic> json) {
    couponId = json['coupon_id'];
    title = json['title'];
    money = json['money'];
    offMoney = json['off_money'];
    expireTime = json['expire_time'];
    expiring = json['expiring'];
    desc = json['desc'];
    available = json['available'];
    active = json['active'];
    rules = json['rules'];
    status = json['status'];
    affectedTime = json['affected_time'];
    businessId = json['business_id'];
    couponDesc = json['coupon_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coupon_id'] = this.couponId;
    data['title'] = this.title;
    data['money'] = this.money;
    data['off_money'] = this.offMoney;
    data['expire_time'] = this.expireTime;
    data['expiring'] = this.expiring;
    data['desc'] = this.desc;
    data['available'] = this.available;
    data['active'] = this.active;
    data['rules'] = this.rules;
    data['status'] = this.status;
    data['affected_time'] = this.affectedTime;
    data['business_id'] = this.businessId;
    data['coupon_desc'] = this.couponDesc;
    return data;
  }
}

class PayInfoListOptions {
  int payId;
  String name;
  PayInfoListDesc desc;
  String icon;
  int recommend;
  SubBtn subBtn;
  List<PayInfoListPayInfo> payInfo;
  List<PayInfoListTips> tips;
  String rebateMoney;
  String payAmount;
  int available;

  PayInfoListOptions(
      {this.payId,
      this.name,
      this.desc,
      this.icon,
      this.recommend,
      this.subBtn,
      this.payInfo,
      this.tips,
      this.rebateMoney,
      this.payAmount,
      this.available});

  PayInfoListOptions.fromJson(Map<String, dynamic> json) {
    payId = json['pay_id'];
    name = json['name'];
    desc = json['desc'] != null ? new PayInfoListDesc.fromJson(json['desc']) : null;
    icon = json['icon'];
    recommend = json['recommend'];
    subBtn =
        json['sub_btn'] != null ? new SubBtn.fromJson(json['sub_btn']) : null;
    if (json['pay_info'] != null) {
      payInfo = new List<PayInfoListPayInfo>();
      json['pay_info'].forEach((v) {
        payInfo.add(new PayInfoListPayInfo.fromJson(v));
      });
    }
    if (json['tips'] != null) {
      tips = new List<PayInfoListTips>();
      json['tips'].forEach((v) {
        tips.add(new PayInfoListTips.fromJson(v));
      });
    }
    rebateMoney = json['rebate_money'].toString();
    payAmount = json['pay_amount'].toString();
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pay_id'] = this.payId;
    data['name'] = this.name;
    if (this.desc != null) {
      data['desc'] = this.desc.toJson();
    }
    data['icon'] = this.icon;
    data['recommend'] = this.recommend;
    if (this.subBtn != null) {
      data['sub_btn'] = this.subBtn.toJson();
    }
    if (this.payInfo != null) {
      data['pay_info'] = this.payInfo.map((v) => v.toJson()).toList();
    }
    if (this.tips != null) {
      data['tips'] = this.tips.map((v) => v.toJson()).toList();
    }
    data['rebate_money'] = this.rebateMoney;
    data['pay_amount'] = this.payAmount;
    data['available'] = this.available;
    return data;
  }
}

class PayInfoListDesc {
  String text;
  String type;

  PayInfoListDesc({this.text, this.type});

  PayInfoListDesc.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['type'] = this.type;
    return data;
  }
}

class SubBtn {
  String name;
  String url;
  String btnName;

  SubBtn({this.name, this.url});

  SubBtn.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    btnName = json['btn_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    data['btn_name'] = this.btnName;
    return data;
  }
}

class PayInfoListPayInfo {
  String icon;
  String title;
  String type;
  String value;

  PayInfoListPayInfo({this.icon, this.title, this.type, this.value});

  PayInfoListPayInfo.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    title = json['title'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['title'] = this.title;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

class PayInfoListTips {
  String text;

  PayInfoListTips({this.text});

  PayInfoListTips.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    return data;
  }
}

class PayInfoListOrder {
  String endMoney;
  String shopName;

  PayInfoListOrder({this.endMoney, this.shopName});

  PayInfoListOrder.fromJson(Map<String, dynamic> json) {
    endMoney = json['end_money'].toString();
    shopName = json['shop_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['end_money'] = this.endMoney;
    data['shop_name'] = this.shopName;
    return data;
  }
}

class RechargeRecommend {
  PayInfoListBtn btn;
  List<String> desc;
  String imgUrl;
  List<String> title;

  RechargeRecommend({this.btn, this.desc, this.imgUrl, this.title});

  RechargeRecommend.fromJson(Map<String, dynamic> json) {
    btn = json['btn'] != null ? new PayInfoListBtn.fromJson(json['btn']) : null;
    desc = json['desc'].cast<String>();
    imgUrl = json['img_url'];
    title = json['title'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.btn != null) {
      data['btn'] = this.btn.toJson();
    }
    data['desc'] = this.desc;
    data['img_url'] = this.imgUrl;
    data['title'] = this.title;
    return data;
  }
}

class PayInfoListBtn {
  String title;
  String type;

  PayInfoListBtn({this.title, this.type});

  PayInfoListBtn.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['type'] = this.type;
    return data;
  }
}

class PayInfoListSelectCoupon {
  int couponId;
  String title;
  double money;
  int offMoney;
  String expireTime;
  int expiring;
  String desc;
  int available;
  int active;
  String rules;
  int status;
  String affectedTime;
  int businessId;
  String couponDesc;

  PayInfoListSelectCoupon(
      {this.couponId,
      this.title,
      this.money,
      this.offMoney,
      this.expireTime,
      this.expiring,
      this.desc,
      this.available,
      this.active,
      this.rules,
      this.status,
      this.affectedTime,
      this.businessId,
      this.couponDesc});

  PayInfoListSelectCoupon.fromJson(Map<String, dynamic> json) {
    couponId = json['coupon_id'];
    title = json['title'];
    money = json['money'];
    offMoney = json['off_money'];
    expireTime = json['expire_time'];
    expiring = json['expiring'];
    desc = json['desc'];
    available = json['available'];
    active = json['active'];
    rules = json['rules'];
    status = json['status'];
    affectedTime = json['affected_time'];
    businessId = json['business_id'];
    couponDesc = json['coupon_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coupon_id'] = this.couponId;
    data['title'] = this.title;
    data['money'] = this.money;
    data['off_money'] = this.offMoney;
    data['expire_time'] = this.expireTime;
    data['expiring'] = this.expiring;
    data['desc'] = this.desc;
    data['available'] = this.available;
    data['active'] = this.active;
    data['rules'] = this.rules;
    data['status'] = this.status;
    data['affected_time'] = this.affectedTime;
    data['business_id'] = this.businessId;
    data['coupon_desc'] = this.couponDesc;
    return data;
  }
}

class PayInfoListAccountOption {
  String name;
  String amount;

  PayInfoListAccountOption({this.name, this.amount});

  PayInfoListAccountOption.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['amount'] = this.amount;
    return data;
  }
}
