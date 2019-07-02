import 'package:flutter/material.dart';
import 'package:app/utils/shared_preferences.dart';
import 'package:app/res/theme_colors.dart';
import 'package:app/navigator/page_route.dart';
import 'dart:async';

/*
 * 启动页 
 **/
class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer _countdownTimer;
  int downNum = 1;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  @override
  void dispose() {
    if (null != _countdownTimer) {
      _countdownTimer.cancel();
      _countdownTimer = null;
    }
    super.dispose();
  }

  _initAsync() async {
    /// App启动时读取Sp数据，需要异步等待Sp初始化完成。
    await SpUtil.getInstance();

    /// 同步使用Sp。
    /// 是否显示引导页。
    /*if (SpUtil.getBool("key_guide", defValue: true)) {
        SpUtil.putBool("key_guide", false);
        _initBanner();
      } else {
        _initSplash();
      }*/
    _initSplash();
  }

  /// App引导页逻辑。
  void _initBanner() {}

  /// App广告页逻辑。
  void _initSplash() {
    if (null == _countdownTimer) {
      ///倒计时3秒
      _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (0 >= downNum) {
          _countdownTimer.cancel();
          Navigator.of(context).pushReplacementNamed(Page.ROOT_PAGE);
        } else {
          setState(() {
            downNum--;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              color: ThemeColors.colorD8D8D8,
              child: Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(right: 20, top: 40),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ThemeColors.color991A1A1A),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed(Page.ROOT_PAGE),
                    child: Text(
                      '跳过 $downNum',
                      style: const TextStyle(
                          fontSize: 14, color: ThemeColors.colorDEDEDE),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '请上座',
                      style: const TextStyle(
                          fontSize: 39, color: ThemeColors.color404040),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Container(
                      width: 11,
                      height: 28,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: ThemeColors.color404040),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          '企业版',
                          softWrap: true,
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 6,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    '值得信赖的商务接待管家',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: ThemeColors.colorA6A6A6,
                        fontSize: 12,
                        letterSpacing: 2.5),
                  ),
                ),
                SizedBox(
                  height: 24,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
