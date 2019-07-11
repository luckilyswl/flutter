import 'dart:async';

import 'package:app/constant.dart';
import 'package:app/model/app_init_bean.dart' as AppInit;
import 'package:app/navigator/page_route.dart';
import 'package:app/pages/pages_index.dart';
import 'package:app/res/res_index.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/utils_index.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  //图片链接
  String imgStr = '';

  //是否已经判断启动引导页
  bool isInit = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    if (null != _countdownTimer) {
      _countdownTimer.cancel();
      _countdownTimer = null;
    }
    super.dispose();
  }

  _init() {
    /// 是否显示引导页
    if (0 == SpUtil.getInt(Constant.flag_guide)) {
      _initGuide();
    } else {
      setState(() {
        isInit = true;
      });
      _initSplash();
    }
  }

  /// App引导页逻辑。
  void _initGuide() {
    Future.delayed(Duration(milliseconds: 1),
        () => Navigator.of(context).pushReplacementNamed(Page.GUIDE_PAGE));
  }

  /// App广告页逻辑。
  void _initSplash() {
    if (null == _countdownTimer) {
      ///获取广告图
      AppInit.Data data = DataUtils.getAppInitInfo();
      if (null != data &&
          !ObjectUtil.isEmptyList(data.bootItems) &&
          !ObjectUtil.isEmptyString(data.bootItems[0].imgUrl)) {
        setState(() {
          imgStr = data.bootItems[0].imgUrl;
        });
      }
      _startTimer();
    }
  }

  //启动倒计时
  _startTimer() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isInit
          ? SizedBox()
          : Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: ScreenUtil.getScreenW(context),
                    alignment: Alignment.topRight,
                    decoration: BoxDecoration(
                      color: ThemeColors.colorD8D8D8,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(imgStr),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(top: 40, right: 20),
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ThemeColors.color991A1A1A),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushReplacementNamed(Page.ROOT_PAGE),
                        child: Text(
                          '跳过 $downNum',
                          style: FontStyles.style14DEDEDE,
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
