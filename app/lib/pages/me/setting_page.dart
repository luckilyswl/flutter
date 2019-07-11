import 'dart:async';

import 'package:app/Application.dart';
import 'package:app/api/api.dart';
import 'package:app/model/common_bean.dart';
import 'package:app/model/event.dart';
import 'package:app/pages/pages_index.dart';
import 'package:app/res/gradients.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/data_utils.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/action_bar.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:app/http.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

/*
 * 设置页 Page
 **/
class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with TickerProviderStateMixin {
  //加载中弹窗
  OverlayEntry loadingDialog;

  //2s时间任务
  Timer timer;

  //是否已经登录
  bool isLogin;

  //新旧版本
  String currentVersion = '';
  String newVersion = 'v 1.0.2';

  //缓存
  String cacheStr = '2.08MB';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        currentVersion = '版本号 v ${packageInfo.version}';
      });
    });

    CacheUtil.instance.loadCache().then((data) {
      setState(() {
        cacheStr = '${NumUtil.getNumByValueDouble(data / 1024 / 1024, 2)}MB';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (null == isLogin) {
      isLogin = ModalRoute.of(context).settings.arguments;
      isLogin ??= false;
    }

    return WillPopScope(
        child: Scaffold(
          appBar: ActionBar.buildActionBar(
              context,
              AppBar(
                elevation: 0,
                title: Text('设置', style: TextStyle(fontSize: 17)),
                centerTitle: true,
                backgroundColor: Colors.transparent,
              )),
          body: _bodyWidget(),
        ),
        onWillPop: () {
          if (null != timer && timer.isActive) {
            timer.cancel();
          }
          if (null != loadingDialog) {
            loadingDialog.remove();
            loadingDialog = null;
            return Future.value(false);
          }
          return Future.value(true);
        });
  }

  Widget _bodyWidget() {
    return Container(
      color: Colors.white,
      width: ScreenUtil.getScreenW(context),
      height: ScreenUtil.getScreenH(context) -
          44 -
          MediaQuery.of(context).padding.top,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.only(top: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '$currentVersion',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 26),
            _buildMoreAction(),
            Divider(height: 1, color: ThemeColors.colorDEDEDE),
            SizedBox(height: 25),
            isLogin
                ? Container(
                    height: 44,
                    margin: const EdgeInsets.only(left: 14, right: 14),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: Gradients.blueLinearGradient,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        _logout();
                      },
                      child: Text(
                        '退出登录',
                        style: FontStyles.style16FFFFFF,
                      ),
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 40),
            Text('Copyright ©️ 2019', style: FontStyles.style12A6A6A6),
            SizedBox(height: 8),
            Text('请上座科技 版权所有', style: FontStyles.style12A6A6A6),
            SizedBox(height: 62)
          ],
        ),
      ),
    );
  }

  ///更多功能item
  Widget _buildMoreAction() {
    var listTiles = [
      ItemMore.buildItemMore(
        'assets/images/ic_edit.png',
        '意见反馈',
        'assets/images/ic_more.png',
        () => Navigator.of(context).pushNamed(Page.FEEDBACK_PAGE),
      ),
      ItemMore.buildItemMore(
        'assets/images/ic_edit.png',
        '版本升级',
        'assets/images/ic_more.png',
        () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ForceUpgradeDialog(
                  version: '1.0.2',
                  apkSize: '25.8',
                  upgradeContent: '1.修复bug\n2.优化性能\n3.优化性能\n4.优化性能\n',
                  onUpgradeEvent: () => Navigator.of(context).pop(),
                ),
          );
        },
        moreText: newVersion,
      ),
      ItemMore.buildItemMore(
          'assets/images/ic_edit.png', '清除缓存', 'assets/images/ic_more.png', () {
        CacheUtil.instance.clearCache().then((data) {
          if (0 == data) {
            loadingDialog = OverlayEntry(builder: (context) => LoadingDialog());
            Overlay.of(context).insert(loadingDialog);

            timer = Timer(Duration(seconds: 2), () {
              if (null != loadingDialog) {
                loadingDialog.remove();
              }
              loadingDialog = null;
              Toast.toast(context, '已清除缓存');
              setState(() {
                cacheStr =
                    '${NumUtil.getNumByValueDouble(data / 1024 / 1024, 2)}MB';
              });
            });
          }
        });
      }, moreText: cacheStr),
      ItemMore.buildItemMore('assets/images/ic_edit.png', '用户协议',
          'assets/images/ic_more.png', () {}),
      ItemMore.buildItemMore('assets/images/ic_edit.png', '关注请上座',
          'assets/images/ic_more.png', _toAttention),
    ];

    if (isLogin) {
      listTiles.insert(
        0,
        ItemMore.buildItemMore(
          'assets/images/ic_edit.png',
          '账号与安全',
          'assets/images/ic_more.png',
          () => Navigator.of(context).pushNamed(Page.ACCOUNT_AND_SAFE_PAGE),
        ),
      );
    }

    //创建条目数量固定的item
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return listTiles[i];
      },
      separatorBuilder: (context, i) {
        return Divider(
          height: 1,
          color: ThemeColors.colorDEDEDE,
        );
      },
      itemCount: listTiles.length,
    );
  }

  ///退出登录
  _logout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CommonDialog(
            title: '确认退出登录吗？',
            message: '',
            negativeText: '取消',
            positiveText: '确定',
            onPositivePressEvent: () {
              dio.get(Api.LOGOUT).then((data) {
                var body = jsonDecode(data.toString());
                CommonBean bean = CommonBean.fromJson(body);
                if (Api.SUCCESS_CODE == bean.errorCode) {
                  DataUtils.clearLoginInfo();
                  Application.getEventBus().fire(EventType.logout);
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(Page.ROOT_PAGE));
                } else {
                  Toast.toast(context, bean?.msg);
                }
              });
            },
            onCloseEvent: () => Navigator.of(context).pop(),
          ),
    );
  }

  ///关注请上座
  _toAttention() {
    //复制微信号到剪贴板
    ClipboardData data = ClipboardData(text: 'qingshangzuoqiyeban');
    Clipboard.setData(data);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CommonDialog(
            title: 'qingshangzuoqiyeban',
            message: '已复制微信号',
            isMessageCenter: true,
            negativeText: '返回',
            positiveText: '去微信关注',
            onPositivePressEvent: () {
              _openWx();
              Navigator.of(context).pop();
            },
            onCloseEvent: () => Navigator.of(context).pop(),
          ),
    );
  }

  ///打开微信
  _openWx() async {
    if (await canLaunch('vnd.weixin://')) {
      await launch('vnd.weixin://');
    } else {
      await launch('weixin://');
    }
  }
}
