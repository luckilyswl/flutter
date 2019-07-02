import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:app/res/theme_colors.dart';
import 'package:app/res/gradients.dart';
import 'package:app/widget/action_bar.dart';
import 'package:app/widget/save_image_toast.dart' as Toast;
import 'package:app/widget/toast.dart' as T;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:app/model/custom_service_bean.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/*
 * 客服
 **/
class CustomerServicePage extends StatefulWidget{
  @override
  _CustomerServicePageState createState() => _CustomerServicePageState();
}

class _CustomerServicePageState extends State<CustomerServicePage> with AutomaticKeepAliveClientMixin{
  // 二维码图片
  String _qrCode = "";

  // 客服热线号码
  String _phone = "";

  String _mobile = "";
  String _weChatId = "";

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    dio.get(Api.CUSTOMER_SERVICE).then((data) {
      var sources = jsonDecode(data.toString());
      CustomServiceBean bean  = CustomServiceBean.fromJson(sources);
      DataBean dataBean = bean.data;

      if (bean.errorCode == "0") {
        setState(() {
          _phone = dataBean.phone;
          _qrCode = dataBean.qrcode;
          _mobile = dataBean.mobile;
          _weChatId = dataBean.wechatId;
        });
      } else {
        T.Toast.toast(context, bean.msg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ActionBar.buildActionBar(
            context,
            AppBar(
              elevation: 0,
              title: Text('企业专属客服', style: new TextStyle(fontSize: 17)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
            )),
        body: _bodyWidget());
  }

  /*
   * 单个 Child 可滚动的 Widget
   **/
  Widget _bodyWidget() {
    return Container(
      height: double.infinity,
      color: ThemeColors.colorEDEDED,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              color: Colors.white,
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: new Align(
                      alignment: Alignment.center,
                      child: new Text(
                        '客服热线',
                        style: new TextStyle(
                          color: ThemeColors.color404040,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  new Container(
                    width: 230,
                    height: 44,
                    margin: new EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: Gradients.blueLinearGradient,
                      boxShadow: [BoxShadow(
                          color: Color(0x26000000),
                          offset: new Offset(0, 3),
                          blurRadius: 10,
                          spreadRadius: 0
                      )],
                    ),
                    child: new RaisedButton(
                      elevation: 0,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22)),
                        onPressed: (){
                          _lunchPhone(_phone);
                        },
                        child: new Row(
                          // 内部的子组件将从主轴中间位置开始排列
                          children: <Widget>[
                            // 图片
                            Image.asset("assets/images/ic_phone.png",
                                width: 24, height: 24),

                            Container(
                              margin: EdgeInsets.only(left: 20, right: 0),
                              width: 1,
                              height: 20,
                              color: ThemeColors.colorA6A6A6,
                            ),

                            // 服务电话
                            _phone.isNotEmpty ? new Padding(
                              padding: EdgeInsets.only(left: 26),
                              child: Text(
                                _phone.toString(),
                                style: new TextStyle(
                                    fontSize: 16,
                                    color: Colors.white
                                ),
                              ),
                            ) : new Expanded(

                              child: new SpinKitCircle(color: Colors.white, size: 15,),
                            )
                          ],
                        )),
                  ),

                  // 拨打电话
                  Container(
                    width: 230.0,
                    height: 44.0,
                    margin: new EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: Gradients.blueLinearGradient,
                      boxShadow: [BoxShadow(
                          color: Color(0x26000000),
                          offset: new Offset(0, 3),
                          blurRadius: 10,
                          spreadRadius: 0
                      )],
                    ),
                    child: RaisedButton(
                      elevation: 0,
                      color: Colors.transparent,
                      onPressed: () {
                        _lunchPhone(_mobile);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22)),
                      child: new Row(
                        children: <Widget>[
                          Image.asset("assets/images/ic_phone.png",
                              width: 24, height: 24),

                          Container(
                            margin: EdgeInsets.only(left: 20, right: 0),
                            width: 1,
                            height: 20,
                            color: ThemeColors.colorA6A6A6,
                          ),

                          _mobile.isNotEmpty ? new Padding(padding: EdgeInsets.only(left: 26),
                            child: Text(
                              _mobile,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 16.0),
                            ),
                          ) : new Expanded(
                              child: new SpinKitCircle(color: Colors.white, size: 15)
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              ),
            ),
            new Padding(
                padding: EdgeInsets.only(top: 30),
                child: new Row(
                  // 内部的子组件将从主轴中间位置开始排列
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      width: 154,
                      height: 1,
                      color: ThemeColors.color9B9B9B,
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 14, right: 14),
                      child: new Text('or',
                          style: new TextStyle(
                              fontSize: 12, color: ThemeColors.color9B9B9B)),
                    ),
                    new Container(
                      width: 154,
                      height: 1,
                      color: ThemeColors.color9B9B9B,
                    ),
                  ],
                )),
            SizedBox(
              height: 15,
            ),
            Text(
              '微信专属客服',
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.color404040),
            ),
            new Container(
              margin: new EdgeInsets.only(top: 18),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 加载网络圆角图片
                  new Container(
                    width: 108,
                    height: 108,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: _qrCode == null || _qrCode.isEmpty
                          ? new Container(child: new SpinKitCircle(color: Colors.grey, size: 15), color: Colors.white)
                          : Image.network(_qrCode.toString()),
                    ),
                  ),

                  new Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: new Column(
                      // 左侧对齐
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // 保存二维码到相册
                        new Container(
                          width: 175.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: Gradients.blackLinearGradient,
                          ),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            color: Colors.transparent,
                            onPressed: () {
                              _saveImage(context, _qrCode);
                            },
                            child: new Text(
                              '保存二维码',
                              style: new TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                          ),
                        ),

                        new Container(
                          margin: EdgeInsets.only(top: 14),
                          width: 175.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: new Border.all(
                              width: 2,
                              color: ThemeColors.color1A1A1A
                            ),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            color: Colors.white,
                            onPressed: () {
                              _copyWeChatId(_weChatId);
                            },
                            child: new Text(
                              '复制微信号',
                              style: new TextStyle(
                                  color: ThemeColors.color1A1A1A, fontSize: 14.0),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              margin: EdgeInsets.only(top: 42, bottom: 46),
              child: new Row(
                // 主轴等分
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      Image.asset("assets/images/service_1.png",
                          width: 32, height: 32),
                      new Padding(
                        padding: EdgeInsets.only(top: 13),
                        child: new Text(
                          '全天候服务',
                          style: new TextStyle(
                              fontSize: 12, color: ThemeColors.color404040),
                        ),
                      )
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      Image.asset("assets/images/service_2.png",
                          width: 32, height: 32),
                      new Padding(
                        padding: EdgeInsets.only(top: 13),
                        child: new Text(
                          '专业用餐推荐',
                          style: new TextStyle(
                              fontSize: 12, color: ThemeColors.color404040),
                        ),
                      )
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      Image.asset("assets/images/service_1.png",
                          width: 32, height: 32),
                      new Padding(
                        padding: EdgeInsets.only(top: 13),
                        child: new Text(
                          '专业用餐推荐',
                          style: new TextStyle(
                              fontSize: 12, color: ThemeColors.color404040),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /*
   * 保存二维码到相册
   **/
  _saveImage(BuildContext context, String url) async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.disabled) {
      PermissionHandler().requestPermissions(<PermissionGroup>[
        PermissionGroup.storage, // 在这里添加需要的权限
      ]);
    } else {
      var response = await http.get(url);
      final result = await ImageGallerySaver.save(response.bodyBytes);
      if (result) {
        Toast.SaveImageToast.toast(context, '保存相册', true);
      } else {
        Toast.SaveImageToast.toast(context, '保存失败', false);
      }
    }
  }

  /*
   * 复制微信号
   **/
  _copyWeChatId(String id) {
    Clipboard.setData(ClipboardData(text: id));
    Toast.SaveImageToast.toast(context, '复制成功', true);
  }

  /*
   * 拨打电话
   **/
  _lunchPhone(String phone) async {
    if (phone.length == 0) {
      return;
    }
    var url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  bool get wantKeepAlive => true;
}
