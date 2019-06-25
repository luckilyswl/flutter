import 'package:flutter/material.dart';
import 'package:app/navigator/tab_navigator.dart';
import 'http.dart';
import 'package:app/navigator/page_route.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:app/api/api.dart';

void main() {
  dio.interceptors.add(new CustomInterceptor());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initFluwx();
  }

  _initFluwx() async {
    await fluwx.register(
        appId: "wx04cce8428b1e77e4",
        doOnAndroid: true,
        doOnIOS: true,
        enableMTA: false
    );
    var result = await fluwx.isWeChatInstalled();
    print("is installed $result");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabNavigator(),
      routes: Page.getRoutes(),
    );
  }
}
