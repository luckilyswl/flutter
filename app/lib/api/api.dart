class Api {
  // URL
  static const String BASE_URL = 'http://m2.7vipseat.com';
  static const String API_KEY = "A6z26VmljpJujuL7cuGSLakc0tozFpnJ";

  //正式环境API地址和KEY---edit by bigticket 2019-06-28
  //static const String BASE_URL = 'https://m2.7shangzuo.com';
  //static const String API_KEY = "8U4qaVZvo20DBjKedL9jQzSwKoNXztAB";

  static const String SUCCESS_CODE = '0';
  static const String ERROR_IMAGE_CODE = '11001';
  static const String NEED_LOGIN_CODE = "10001";

  // 公共分类
  static const String INIT = '/app/init'; //初始数据
  static const String CUSTOMER_SERVICE = '/app/customerService'; //客户信息

  // 登录入口
  static const String USERNAME_LOGIN = '/app/username/login'; //企业账号登录
  static const String ENTERPRISE_REGISTER = '/app/enterprise/register'; //企业注册
  static const String SMS_CODE_SEND = '/app/smscode/send'; //发送验证码
  static const String WECHAT_LOGIN = '/app/wechat/login'; //企业注册
  static const String TELPHONE_LOGIN = '/app/telphone/login'; //手机号登录
  static const String TELPHONE_BIND = '/app/telphone/bind'; //绑定手机号
  static const String IMAGE_CODE = '/app/imageCode'; //获取图形验证码

  //首页
  static const String INDEX_HOME = '/app/index/home'; //企业账号登录
  static const String QUICK_BOOK = '/app/index/quickBook'; //快速预订
  static const String PRIVATE_BOOK = '/app/privateBooking'; //团建会议申请
  static const String SEARCH_CONDITIONS = "/app/searchConditions"; // 搜索条件
  static const String BUSINESS_LIST = "/app/business/list"; // 商家列表

  // 管理
  static const String MANAGER_URL = "/app/enterprise/home"; //企业首页

  // 我的
  static const String ME_URL = "/app/user/index"; //我的页面
  static const String USER_EDIT_URL = "/app/user/edit"; // 个人信息修改
  static const String EMPLOYEE_EDIT_URL = "/app/employee/edit"; // 企业用户信息修改

  //发票相关
  static const String INVOICE_LIST = "/app/invoice/invoiceList"; //发票列表
  static const String INVOICE_CREATE = "/app/invoice/saveUserInvoice"; //添加发票
  static const String INVOICE_EDIT = "/app/invoice/editUserInvoice"; //编辑发票
  static const String INVOICE_DELETE = "/app/invoice/deleteUserInvoice"; //删除发票

  //预定相关
  static const String BOOK_INFO = "/app/order/bookConfirm"; //预订页面
  static const String BOOK_ROOM = "/app/order/addOrder"; //下单
  static const String BOOK_PAY_RESULT = "/app/order/bookComplete"; //预订结果
  static const String BOOK_PAY = "/app/pay/bookPayRequest"; //预订支付
  static const String BOOK_PAY_LIST = "/app/pay/prepareBookPay"; //预订支付列表

  //买单
  static const String PAY_LIST = "/app/pay/prepareEndPay"; //买单支付列表
  static const String PAY_CONFIRM = "/app/pay/endPayRequest"; //下单
  static const String PAY_RESULT = "/app/order/paidComplete"; //买单结果

  // 商家詳情
  static const String DETAIL_URL = "/app/business/detail"; //商家详情
  static const String ROOM_URL = "/app/business/availableRoomList"; //房间列表
  static const String COLLECT_URL = "/app/collect/set"; // 收藏

  //搜索
  static const String SEARCH_PAGE_DATA = "/app/searchPageData"; //搜索页
  static const String SEARCH_DELETE = "/app/searchDeletd"; //清空最近搜索
  static const String SEARCH_COMMIT_DEMAND = "/app/search/commitDemand"; //提交需求

  //充值
  static const String RECHARGE_INFO = "/app/recharge/option"; //充值页
  static const String RECHARGE_PAY_LIST = "/app/recharge/preparePay"; //充值支付列表
  static const String RECHARGE_PAY_CONFIRM = "/app/recharge/pay"; //充值确认
  static const String RECHARGE_PAY_RESULT = "/app/recharge/paidComplete"; //充值成功

  //订单
  static const String ORDER_LIST = "/app/order/list"; //订单列表
  static const String ORDER_DETAIL = "/app/order/detail"; //订单详情

  //我的
  static const String LOGOUT = '/app/user/logout'; //退出登录
  static const String SUBMIT = '/app/feedback/submit'; //意见反馈

  // 邀请函
  static const String INVITATION_INFO_URL = "/app/invitation/info";
  // 邀请函图片
  static const String INVITATION_PIC_URL = "/app/invitation/createImage";
  // 修改邀请函
  static const String INVITATION_MODIFY_URL = "/app/invitation/edit";
}
