class Api{
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
  static const String INIT = '/app/init';  //初始数据
  static const String CUSTOMER_SERVICE = '/app/customerService';  //客户信息
  
  // 登录入口
  static const String USERNAME_LOGIN = '/app/username/login';  //企业账号登录
  static const String ENTERPRISE_REGISTER = '/app/enterprise/register';  //企业注册
  static const String SMS_CODE_SEND = '/app/smscode/send';  //发送验证码
  static const String WECHAT_LOGIN = '/app/wechat/login';  //企业注册
  static const String TELPHONE_LOGIN = '/app/telphone/login';  //手机号登录
  static const String TELPHONE_BIND = '/app/telphone/bind';  //绑定手机号
  static const String IMAGE_CODE = '/app/imageCode';  //获取图形验证码

  //首页
  static const String INDEX_HOME = '/app/index/home';  //企业账号登录
  static const String QUICK_BOOK = '/app/index/quickBook';  //快速预订
  static const String PRIVATE_BOOK = '/app/privateBooking';  //团建会议申请
  static const String SEARCH_CONDITIONS = "/app/searchConditions"; // 搜索条件
  static const String BUSINESS_LIST = "/app/business/list"; // 商家列表

  // 管理
  static const String MANAGER_URL = "/app/enterprise/home";

  // 我的
  static const String ME_URL = "/app/user/index";

  // 商家詳情
  static const String DETAIL_URL = "/app/business/detail";
  static const String ROOM_URL = "/app/business/availableRoomList";
}