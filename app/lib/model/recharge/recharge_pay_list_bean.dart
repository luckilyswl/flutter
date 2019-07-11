import 'package:app/model/pay/pay_info_list_bean.dart';

class RechargePayListBean {
	String errorCode;
	String msg;
	RechargePayListData data;

	RechargePayListBean({this.errorCode, this.msg, this.data});

	RechargePayListBean.fromJson(Map<String, dynamic> json) {
		errorCode = json['error_code'];
		msg = json['msg'];
		data = json['data'] != null ? new RechargePayListData.fromJson(json['data']) : null;
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

class RechargePayListData {
	List<PayInfoListOptions> options;
	RechargePayListOrder order;

	RechargePayListData({this.options, this.order});

	RechargePayListData.fromJson(Map<String, dynamic> json) {
		if (json['options'] != null) {
			options = new List<PayInfoListOptions>();
			json['options'].forEach((v) { options.add(new PayInfoListOptions.fromJson(v)); });
		}
		order = json['order'] != null ? new RechargePayListOrder.fromJson(json['order']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
		if (this.order != null) {
      data['order'] = this.order.toJson();
    }
		return data;
	}
}

class RechargePayListOrder {
	int orderId;
	String orderAmount;

	RechargePayListOrder({this.orderId, this.orderAmount});

	RechargePayListOrder.fromJson(Map<String, dynamic> json) {
		orderId = json['order_id'];
		orderAmount = json['order_amount'].toString();
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['order_id'] = this.orderId;
		data['order_amount'] = this.orderAmount;
		return data;
	}
}
