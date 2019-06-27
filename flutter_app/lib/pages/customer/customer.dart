/*import 'dart:io';
import 'package:flutter_app/http.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/res/theme_colors.dart';
import 'package:flutter_app/widget/save_image_toast.dart' as Toast;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_app/api/api.dart';*/



import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/res/theme_colors.dart';
/*import 'package:flutter_app/res/gradients.dart';
import 'package:flutter_app/widget/action_bar.dart';*/
import 'package:flutter_app/widget/save_image_toast.dart' as Toast;
import 'dart:convert';
import 'service_recommendation.dart';


const APPBAR_SCROLL_OFFSET = 100;

/*
 * 首页
 **/
class Customer extends StatefulWidget {
  @override
  _CustomerState createState() => _CustomerState();
}

/*
class Api{
  static const String BASE_URL = 'http://m2.7vipseat.com';
  static const String CUSTOMER_SERVICE = '/app/customerService';  //客户信息
}
*/


/*var dio = new Dio(
    new BaseOptions(
        baseUrl: Api.BASE_URL,
        connectTimeout: 5000,
        receiveTimeout: 100000,
        contentType: ContentType.parse("application/x-www-form-urlencoded"),
        responseType: ResponseType.plain
    )
);*/

class _CustomerState extends State<Customer> {

  //String _qrCode = 'https://img1.7shangzuo.com/images/20181211/1544506887_OZcsOFDS.jpeg';
  String _telephone = "020-22043398";
  //String _phone = "18816838523";

  String _qrCode;
  String _phone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio.get(Api.CUSTOMER_SERVICE).then((data){
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
        title: Text('企业专属客服',style: new TextStyle(fontSize:17 )),
        centerTitle: true,
        backgroundColor:Color(0xFF555C9E) ,
      ),
      body: _bodyWidget());
  }

  Widget  _bodyWidget() {
    var imageUrl = 'https://img1.7shangzuo.com/images/20181211/1544506887_OZcsOFDS.jpeg';
    return new SingleChildScrollView(
      child: new Container(
        color: Color(0xFFEDEDED),
        child: new Column(
          children: <Widget>[
            new Container(
              height: 200,
              color: Colors.white,
              child: new Column(
                children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(top: 28),
                      child: new Align(
                        alignment: Alignment.center,
                        child: new Text('客服热线',
                            style: new TextStyle(
                              color: Color(0xFF404040),
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                        ),
                      ),
                    ),

                  /*new Container(
                    width: 265,
                    height: 40,
                    margin: new EdgeInsets.only(top: 21),
                    child: new RaisedButton(
                      color: Color(0xFF555C9E),
                      onPressed: (){
                        _lunchPhone();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: new Card(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22)),
                          color: Color(0xFF555C9E),
                          child: new Row(
                            // 内部的子组件将从主轴中间位置开始排列
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // 图片
                              Image.asset(
                                  "assets/images/ic_book1.png",
                                  width: 24,
                                  height: 24,
                              ),

                              // 服务电话
                              new Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Text(
                                  //_tel.toString(),
                                  _phone.toString(),
                                  style: new TextStyle(
                                      fontSize: 16,
                                      color: ThemeColors.color1A1A1A),
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                  new Container(
                    width: 265,
                    height: 40,
                    margin: new EdgeInsets.only(top: 16),
                    child: new RaisedButton(
                      color: Color(0xFF555C9E),
                      onPressed: (){
                        _lunchPhone();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: new Card(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22)),
                          color: Color(0xFF555C9E),
                          child: new Row(
                            // 内部的子组件将从主轴中间位置开始排列
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // 图片
                              Image.asset("assets/images/ic_book1.png",
                                  width: 24, height: 24),

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
                  ),*/
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
                  Container(
                    width: 265.0,
                    height: 40.0,
                    margin: new EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      //gradient: Gradients.blueLinearGradient,
                    ),
                    child: RaisedButton(
                      color: Colors.transparent,
                      onPressed: () {
                        _lunchPhone();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22)),
                      child: Text(
                        '马上拨打电话联系专属客服',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Padding(
                padding: EdgeInsets.only(top: 30),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      width: 154,
                      height: 1,
                      color: Color(0xFF9B9B9B),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 14,right: 14),
                      child: new Text('or',
                        style: new TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9B9B9B)
                        ),
                      ),
                    ),
                    new Container(
                      width: 154,
                      height: 1,
                      color: Color(0xFF9B9B9B),
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
                  color: Color(0xFF404040)),
            ),
            new Container(
              margin: new EdgeInsets.only(top: 18),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 108,
                    height: 108,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: FadeInImage.assetNetwork(
                          placeholder: '',
                          image: _qrCode.toString()
                      ),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            //gradient: Gradient.blueLinearGradient,
                          ),
                          child: RaisedButton(
                            color: Colors.black45,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            onPressed: () {
                              _saveImage(context, imageUrl);
                            },
                            child: new Text(
                              '保存二维码',
                              style: new TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        new Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            //gradient: Gradient.blueLinearGradient,
                          ),
                          child: OutlineButton(
                            color: Colors.black45,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            onPressed: () {
                              _saveImage(context,imageUrl);
                            },
                            child: new Text(
                              '复制微信号',
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 14.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
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
                      ),
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
                      ),

                      /*IconButton(
                        icon: Image.asset("assets/images/service_2.png",
                            width: 32, height: 32),
                        onPressed: (){
                          return ServiceRecommendation();
                        },
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 13),
                        child: new Text(
                          '专业用餐推荐',
                          style: new TextStyle(
                              fontSize: 12,
                              color: ThemeColors.color404040
                          ),
                        ),
                      ),*/

                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      Image.asset("assets/images/service_1.png",
                          width: 32, height: 32),
                      new Padding(
                        padding: EdgeInsets.only(top: 13),
                        child: new Text(
                          '专属私人管家',
                          style: new TextStyle(
                              fontSize: 12, color: ThemeColors.color404040),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
      ])
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
