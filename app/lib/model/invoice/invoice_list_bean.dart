class InvoiceListBean {
  String errorCode;
  String msg;
  InvoiceListDataBean data;

  InvoiceListBean({this.errorCode, this.msg, this.data});

  InvoiceListBean.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    msg = json['msg'];
    data = json['data'] != null ? new InvoiceListDataBean.fromJson(json['data']) : null;
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

class InvoiceListDataBean {
  List<InvoiceModel> appEnterpriseInvoice;
  AppUserInvoice appUserInvoice;
  int isCompany;

  InvoiceListDataBean({this.appEnterpriseInvoice, this.appUserInvoice, this.isCompany});

  InvoiceListDataBean.fromJson(Map<String, dynamic> json) {
    if (json['app_enterprise_invoice'] != null) {
      appEnterpriseInvoice = new List<InvoiceModel>();
      json['app_enterprise_invoice'].forEach((v) {
        appEnterpriseInvoice.add(new InvoiceModel.fromJson(v));
      });
    }
    appUserInvoice = json['app_user_invoice'] != null
        ? new AppUserInvoice.fromJson(json['app_user_invoice'])
        : null;
    isCompany = json['is_company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appEnterpriseInvoice != null) {
      data['app_enterprise_invoice'] =
          this.appEnterpriseInvoice.map((v) => v.toJson()).toList();
    }
    if (this.appUserInvoice != null) {
      data['app_user_invoice'] = this.appUserInvoice.toJson();
    }
    data['is_company'] = this.isCompany;
    return data;
  }
}

class  InvoiceModel {
  int id;
  int userId;
  String bankAccount;
  String bankName;
  String companyAddress;
  String taxNumber;
  String taxTitle;
  String telphone;
  String email;
  int invoiceType;

  InvoiceModel(
      {this.id,
      this.userId,
      this.bankAccount,
      this.bankName,
      this.companyAddress,
      this.taxNumber,
      this.taxTitle,
      this.telphone,
      this.email,
      this.invoiceType});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bankAccount = json['bank_account'];
    bankName = json['bank_name'];
    companyAddress = json['company_address'];
    taxNumber = json['tax_number'];
    taxTitle = json['tax_title'];
    telphone = json['telphone'];
    email = json['email'];
    invoiceType = json['invoice_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['bank_account'] = this.bankAccount;
    data['bank_name'] = this.bankName;
    data['company_address'] = this.companyAddress;
    data['tax_number'] = this.taxNumber;
    data['tax_title'] = this.taxTitle;
    data['telphone'] = this.telphone;
    data['email'] = this.email;
    data['invoice_type'] = this.invoiceType;
    return data;
  }
}

class AppUserInvoice {
  List<InvoiceModel> companyInvoice;
  List<InvoiceModel> userInvoice;

  AppUserInvoice({this.companyInvoice, this.userInvoice});

  AppUserInvoice.fromJson(Map<String, dynamic> json) {
    if (json['company_invoice'] != null) {
      companyInvoice = new List<InvoiceModel>();
      json['company_invoice'].forEach((v) {
        companyInvoice.add(new InvoiceModel.fromJson(v));
      });
    }
    if (json['user_invoice'] != null) {
      userInvoice = new List<InvoiceModel>();
      json['user_invoice'].forEach((v) {
        userInvoice.add(new InvoiceModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.companyInvoice != null) {
      data['company_invoice'] =
          this.companyInvoice.map((v) => v.toJson()).toList();
    }
    if (this.userInvoice != null) {
      data['user_invoice'] = this.userInvoice.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
