import 'dart:convert';
import 'dart:io';

import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/app_init_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/pages/splash/splash.dart';
import 'package:app/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

void main() {
  dio.interceptors.add(new CustomInterceptor());
  runApp(MyApp());

  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。
    // 写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，
    // 写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _initFluwx();
    dio.get(Api.INIT).then((data) {
      var sources = jsonDecode(data.toString());
      AppInitInfoBean bean = AppInitInfoBean.fromJson(sources);
      Data dataBean = bean.data;
      if (bean.errorCode == Api.SUCCESS_CODE) {
        DataUtils.saveInitInfo(dataBean);
        DataUtils.saveCityId(dataBean.currentCity.cityId);
      }
    });
    super.initState();
  }

  _initFluwx() async {
    await fluwx.register(
        appId: "wxa9fef87b18258e5e",
        doOnAndroid: true,
        doOnIOS: true,
        enableMTA: false);
    var result = await fluwx.isWeChatInstalled();
    print("is installed $result");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '请上座',
      // 主題顏色
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      routes: Page.getRoutes(),
    );
  }
}
