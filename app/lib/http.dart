import 'dart:io';
import 'package:app/utils/data_utils.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'dart:collection';
import 'api/api.dart';
import 'utils/util.dart';

class CustomInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) async {
    var defaultParameters = new SplayTreeMap();   //签名用
    var originalParameters = new SplayTreeMap();  //实际使用

    if (DataUtils.getLongitude() != 0 && DataUtils.getLatitude() != 0) {
      defaultParameters["longitude"] = DataUtils.getLongitude().toString();
    defaultParameters["latitude"] = DataUtils.getLatitude().toString();
    } else {
      defaultParameters["longitude"] = '';
      defaultParameters["latitude"] = '';
    }
    if (DataUtils.getCityId() != 0) {
      defaultParameters["city_id"] = DataUtils.getCityId().toString();
    }
    String sessionId = DataUtils.getSessionId();
    if (sessionId != null && sessionId.isNotEmpty) {
      defaultParameters["session_id"] = sessionId;
    }
    
    defaultParameters["app_platform"] = Util.getPlatform();
    defaultParameters["app_channel"] = "360";
    defaultParameters["app_version"] = await Util.getVersion();
    defaultParameters["timestamp"] = Util.getCurrentTime().toString();
    defaultParameters["device_id"] = await Util.getUUID();

    originalParameters.addAll(defaultParameters); //公共参数

    if (options.method == 'POST') {
      defaultParameters.addAll(options.data);
    } else {
      originalParameters.addAll(options.queryParameters); //业务参数
      defaultParameters.addAll(options.queryParameters);
    }

    String str2 = "";
    for (var key in defaultParameters.keys) {
      str2 = str2 + key + "=" + defaultParameters[key] + "&";
    }
    str2 += Api.API_KEY;

    var content = new Utf8Encoder().convert(str2);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()

    String apiSign = hex.encode(digest.bytes);

    originalParameters["api_sign"] = apiSign; //签名
    options.queryParameters = Map.from(originalParameters);
    // 打印网络请求日志
    String url = options.baseUrl + options.path;
    String query = "";
    String temp;
    Map<String, dynamic> map = options.queryParameters;
    map.forEach((String key, dynamic value) {
      temp = key + "=" + value.toString() + "&";
      query = query + temp;
    });
    print("网络请求: " + options.method + " " + url + "?" + query);
    return super.onRequest(options);
  }
  @override
  onResponse(Response response) {
    print(response.data.toString());
    return super.onResponse(response);
  }
}

var dio = new Dio(new BaseOptions(
    baseUrl: Api.BASE_URL,
    connectTimeout: 5000,
    receiveTimeout: 100000,
    contentType: ContentType.parse("application/x-www-form-urlencoded"),
    // Transform the response data to a String encoded with UTF8.
    // The default value is [ResponseType.JSON].
    responseType: ResponseType.plain
  )
);