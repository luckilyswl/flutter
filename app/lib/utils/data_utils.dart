import 'package:app/model/app_init_bean.dart' as AppInit;
import 'package:app/model/user_info_bean.dart';
import 'package:app/utils/shared_preferences.dart';

class DataUtils {
  static const String SP_IS_LOGIN = "isLogin";
  static const String SP_SESSION_ID = "sessionId";
  static const String SP_USER_INFO = "user";
  static const String SP_INIT_INFO = "initInfo";
  static const String SP_CITY_ID = "cityId";

  // 保存登录信息
  static saveLoginInfo(UserInfoBean userInfoBean) {
    if (userInfoBean != null) {
      SpUtil.putBool(SP_IS_LOGIN, true);
      SpUtil.putString(SP_SESSION_ID, userInfoBean.data.sessionId);
      SpUtil.putObject(SP_USER_INFO, userInfoBean);
    }
  }

  // 清除登录信息
  static clearLoginInfo() {
    SpUtil.remove(SP_SESSION_ID);
    SpUtil.remove(SP_IS_LOGIN);
    SpUtil.remove(SP_USER_INFO);
  }

  // 获取用户信息
  static UserInfoBean getUserInfo() {
    Map<String, dynamic> userInfo = SpUtil.getObject(SP_USER_INFO);
    if (userInfo == null) {
      return null;
    }
    UserInfoBean userInfoBean = UserInfoBean.fromJson(userInfo);
    return userInfoBean;
  }

  // 是否登录
  static bool isLogin() {
    bool isLogin = SpUtil.getBool(SP_IS_LOGIN);
    return isLogin != null && isLogin;
  }

  // 获取sessionId
  static String getSessionId() {
    String sessionId = SpUtil.getString(SP_SESSION_ID);
    if (sessionId == null) {
      return null;
    }
    return sessionId;
  }

  // 获取用户信息
  static AppInit.Data getAppInitInfo() {
    Map<String, dynamic> initInfo = SpUtil.getObject(SP_INIT_INFO);
    if (initInfo == null) {
      return null;
    }
    AppInit.Data dataBean = AppInit.Data.fromJson(initInfo);
    return dataBean;
  }

  // 保存初始化信息
  static saveInitInfo(AppInit.Data dataBean) {
    if (dataBean != null) {
      SpUtil.putObject(SP_INIT_INFO, dataBean.toJson());
    }
  }

  // 获取城市id
  static int getCityId() {
    int cityId = SpUtil.getInt(SP_CITY_ID);
    return cityId;
  }

  // 保存初始化信息
  static saveCityId(int cityId) {
    SpUtil.putInt(SP_CITY_ID, cityId);
  }
}
