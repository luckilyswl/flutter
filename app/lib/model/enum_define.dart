class PayType {
  static const int PERSONAL_PAY = 7;
  static const int ENTERPRISE_PAY = 10;
  static const int WX_PAY = 20;
  static const int ALI_PAY = 25;
}

class PayTargetType {
  static const int TARGET_NONE = 0;  //无法跳转
  static const int TARGET_PAY = 1;  //支付
  static const int TARGET_APPLICATION = 2;  //申请企业招待
  static const int TARGET_RECHARGE = 3;  //去充值
}

class OrderListType {
  static const int ORDER_TYPE_ALL = 0;  //全部订单
  static const int ORDER_TYPE_BOOK_WAITED = 1;  //待预订
  static const int ORDER_TYPE_PRESENT_WAITED = 2;  //待就餐
  static const int ORDER_TYPE_PAY_WAITED = 3;  //待买单
}

class OrderStatus {
  static const int ORDER_STATUS_PAY_WAITED = 0;  //未支付
  static const int ORDER_STATUS_BOOK_FINISH = 1;  //已交付订金
  static const int ORDER_STATUS_CANCEL = 2;  //申请企业招待
  static const int ORDER_STATUS_BOOK_REFUND = 3;  //订金退款中
  static const int ORDER_STATUS_BOOK_REFUND_FINISH = 4;  //订金退款完成
  static const int ORDER_STATUS_BE_PRESENTED = 5;  //已到场
  static const int ORDER_STATUS_FINISH = 6;  //已完成
  static const int ORDER_STATUS_REFUND = 7;  //全额退款中
  static const int ORDER_STATUS_REFUND_FINISH = 8;  //全额退款wancheng
  static const int ORDER_STATUS_BOOK_WAITED = 20;  //待预订
}