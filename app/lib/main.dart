import 'dart:convert';
import 'dart:io';

import 'package:amap_base/amap_base.dart';
import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/app_init_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/pages/splash/splash.dart';
import 'package:app/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lifecycle_state/flutter_lifecycle_state.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

void main() async {
  await AMap.init('793ff6e98d0869310dc4d2a72476cace');

  /// App启动时读取Sp数据，需要异步等待Sp初始化完成。
  await SpUtil.getInstance();
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
  final _amapLocation = AMapLocation();
  var _result = '';

  @override
  void dispose() {
    _amapLocation.stopLocate();
    super.dispose();
  }

  @override
  void initState() {
    /// 初始化定位
    _initLocation();
    _initFluwx();
    super.initState();
  }

  //初始化定位监听
  void _initLocation() async {
    _amapLocation.init();

    final options = LocationClientOptions(
      isOnceLocation: true,
      locatingWithReGeocode: true,
    );

    _initData();

    if (await Permissions().requestPermission()) {
      _amapLocation.startLocate(options).listen((_) => setState(() {
            _result = '坐标：${_.longitude}，${_.latitude}';
            DataUtils.saveLatitude(_.latitude);
            DataUtils.saveLongitude(_.longitude);
          }));
    } else {
      setState(() {
        _result = "无定位权限";
      });
    }
    print(_result);
  }

  _initData() async {
    dio.get(Api.INIT).then((data) {
      var sources = jsonDecode(data.toString());
      AppInitInfoBean bean = AppInitInfoBean.fromJson(sources);
      Data dataBean = bean.data;
      if (bean.errorCode == Api.SUCCESS_CODE) {
        debugPrint(dataBean.currentCity.cityId.toString());
        DataUtils.saveInitInfo(dataBean);
        DataUtils.saveCityId(dataBean.currentCity.cityId);
      }
    });
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
      navigatorObservers: [routeObserver],
    );
  }
}
