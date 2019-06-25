import 'dart:io';
import 'package:package_info/package_info.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util {
  static double getCurrentTime() {
    double nowTime = DateTime.now().millisecondsSinceEpoch / 1000;
    return nowTime;
  }

  static String getPlatform() {
    return Platform.isIOS ? "ios" : "android";
  }

  static Future<String> getUUID() async {
    SharedPreferences getInstence = await SharedPreferences.getInstance();
    String uuid = getInstence.getString("uuid");
    if (uuid != null) {
      return uuid;
    }
    var newUuid = new Uuid();
    uuid = newUuid.v1();
    getInstence.setString("uuid", uuid);
    return uuid;
  }

  static getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }
}
