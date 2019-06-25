import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:app/res/theme_colors.dart';
import 'package:app/widget/save_image_toast.dart' as Toast;
import 'dart:convert';


/*
 * 客服
 **/
class CustomerServicePage extends StatefulWidget {
  @override
  _CustomerServicePageState createState() => _CustomerServicePageState();
}

class _CustomerServicePageState extends State<CustomerServicePage> {

  // 二维码图片
  String _qrCode;
  // 客服热线号码
  String _phone = "";

  @override
  void initState() {
    super.initState();
    dio.get(Api.CUSTOMER_SERVICE).then((data) {
      var sources = jsonDecode(data.data.toString());
      setState(() {
        _phone = sources['data']['phone'];
        _qrCode = sources['data']['qrcode'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('企业专属客服', style: new TextStyle(fontSize: 17)),
          centerTitle: true,
          backgroundColor: ThemeColors.color555C9E,
        ),
        body: _bodyWidget());
  }

  /*
   * 单个 Child 可滚动的 Widget
   **/
  Widget _bodyWidget() {
    return new SingleChildScrollView(
      child: new Container(
        color: ThemeColors.colorEDEDED,
        child: new Column(
          children: <Widget>[
            new Container(
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  new Container(
                    width: 265,
                    height: 40,
                    margin: new EdgeInsets.only(top: 20),
                    child: new Card(
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22)),
                        color: ThemeColors.colorF1F1F1,
                        child: new Row(
                          // 内部的子组件将从主轴中间位置开始排列
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // 图片
                            Image.asset("assets/images/ic_kefurexian.png",
                                width: 16, height: 16),

                            // 服务电话
                            new Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Text(
                                _phone.toString(),
                                style: new TextStyle(
                                    fontSize: 16,
                                    color: ThemeColors.color1A1A1A),
                              ),
                            )
                          ],
                        )),
                  ),

                  // 拨打电话
                  new Container(
                    width: 265.0,
                    height: 40.0,
                    margin: new EdgeInsets.only(top: 20),
                    child: new Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22)),
                      color: ThemeColors.color555C9E,
                      child: new FlatButton(
                          onPressed: () {
                            _lunchPhone();
                          },
                          child: new Padding(
                            padding: new EdgeInsets.all(0.0),
                            child: new Text(
                              '马上拨打电话联系专属客服',
                              style: new TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                          )),
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
            new Padding(
              padding: EdgeInsets.only(top: 20),
              child: new Text(
                '二维码邀请',
                style: new TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.color404040),
              ),
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
                      child: FadeInImage.assetNetwork(
                        placeholder: '',
                        image: _qrCode.toString(),
                      ),
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
                          width: 150.0,
                          height: 28.0,
                          child: new Card(
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22)),
                            color: ThemeColors.color3F4688,
                            child: new FlatButton(
                              onPressed: () {
                                _saveImage(context, _qrCode.toString());
                              },
                              child: new Text(
                                '保存二维码图片到相册',
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 11.0),
                              ),
                            ),
                          ),
                        ),

                        new Padding(
                          padding: EdgeInsets.only(top: 13, left: 10),
                          child: new Text(
                            '1、打开微信扫一扫',
                            style: new TextStyle(
                                fontSize: 11, color: ThemeColors.color404040),
                          ),
                        ),

                        new Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: new Text(
                            '2、右上角“相册”选中图片',
                            style: new TextStyle(
                                fontSize: 11, color: ThemeColors.color404040),
                          ),
                        ),

                        new Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: new Text(
                            '3、添加私人专属秘书微信',
                            style: new TextStyle(
                                fontSize: 11, color: ThemeColors.color404040),
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
                ))
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
   * 拨打电话
   **/
  _lunchPhone() async {
    if (_phone.length == 0) {
      return;
    }
    var url = 'tel:$_phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
