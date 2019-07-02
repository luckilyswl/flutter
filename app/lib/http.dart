import 'dart:io';
import 'package:app/utils/data_utils.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'api/api.dart';
import 'utils/util.dart';

class CustomInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) async {
    var defaultParameters = new SplayTreeMap();
    defaultParameters["longitude"] = "113.3100967407226";
    defaultParameters["latitude"] = "23.07718849182129";
    if (DataUtils.getCityId() != 0) {
      debugPrint(DataUtils.getCityId().toString());
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
    defaultParameters.addAll(options.queryParameters);

    String str2 = "";
    for (var key in defaultParameters.keys) {
      str2 = str2 + key + "=" + defaultParameters[key] + "&";
    }
    str2 += Api.API_KEY;

    var content = new Utf8Encoder().convert(str2);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()

    String apiSign = hex.encode(digest.bytes);
    defaultParameters["api_sign"] = apiSign;

    // 打印网络请求日志
    options.queryParameters = Map.from(defaultParameters);
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