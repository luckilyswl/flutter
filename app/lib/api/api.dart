class Api{
  // URL
  static const String BASE_URL = 'http://m2.7vipseat.com';
  static const String API_KEY = "A6z26VmljpJujuL7cuGSLakc0tozFpnJ";
  
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
}