import 'package:app/api/net_index.dart';
import 'package:app/pages/business/map.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/dialog/invite_dialog.dart';
import 'package:app/widget/dialog/invite_pic_dialog.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:app/widget/save_image_toast.dart' as T;
import 'package:http/http.dart' as http;
import 'package:app/navigator/pop_route.dart';
import 'package:app/model/invite/invite_info_bean.dart' as Invite;

class InvitationPage extends StatefulWidget {
  final int orderId;

  InvitationPage({@required this.orderId});

  @override
  _InvitationPageState createState() => _InvitationPageState();
}

class _InvitationPageState extends State<InvitationPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String _name;
  String _welcome;
  Invite.Data _inviteInfo;
  int _inviteId = -1;
  List<Invite.Photos> _photosList = new List();

  double scroll = 0.0;
  double alpha = 0.0;

  @override
  void initState() {
    dio.get(Api.INVITATION_INFO_URL,
        queryParameters: {"order_id": widget.orderId.toString()}).then((data) {
      var sources = jsonDecode(data.data);
      Invite.InviteInfoBean bean = Invite.InviteInfoBean.fromJson(sources);
      if (bean.errorCode == "0") {
        Invite.Data info = bean.data;
        _inviteInfo = bean.data;
        _name = info.inviteName;
        _welcome = info.inviteDesc;
        _photosList = info.photos;
        _inviteId = info.id;
        setState(() {});
      } else {
        Toast.toast(context, bean.msg);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActionBar.buildActionBar(
        context,
        AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              '餐厅订好啦，座等你来！',
              style: new TextStyle(fontSize: 16, color: Colors.white),
            ),
            actions: <Widget>[
              new GestureDetector(
                onTap: () {
                  Toast.toast(context, '分享');
                },
                child: new Padding(
                  padding: EdgeInsets.only(right: 14),
                  child: Image.asset(
                    'assets/images/ic_share_w.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              )
            ],
            leading: new Padding(
              padding: EdgeInsets.only(left: 14),
              child: new GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: new Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/ic_back_w.png',
                      width: 20,
                      height: 20,
                    ),
                  )),
            )),
      ),
      body: _bodyWidget(),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _bodyWidget() {
    return new Container(
        color: Color(0xff202020),
        child: NotificationListener(
          onNotification: ((ScrollNotification notification) {
            scroll = notification.metrics.pixels;
            if (notification.metrics.axis == Axis.vertical && scroll > 0) {
              setState(() {
                alpha = scroll / 180.0;
              });
            }
          }),
          child: Stack(
            children: <Widget>[
              _scrollWidget(),
              _bottomWidget(),
              _floatButon(),
              _floatMore(),
            ],
          ),
        ));
  }

  Widget _floatMore() {
    return Positioned(
        bottom: 50,
        child: new Opacity(
          opacity: alpha <= 0 ? 1 : alpha >= 1.0 ? 0 : 1 - alpha,
          child: new Container(
            width: ScreenUtil.getScreenW(context),
            alignment: Alignment.center,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '下滑查看更多',
                  style: new TextStyle(
                    fontSize: 12,
                    color: Color(0xff54548C),
                  ),
                ),
                Image.asset(
                  'assets/images/ic_invite_more.png',
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
        ));
  }

  Widget _scrollWidget() {
    return new SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          new Container(
            width: ScreenUtil.getScreenW(context),
            height: 600,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage('assets/images/bg_invitation.png'),
                  fit: BoxFit.fill),
            ),
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(top: 200),
                  child: Text(
                    _name != null && _name.isNotEmpty ? _name : '',
                    style: new TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    _welcome != null && _welcome.isNotEmpty ? _welcome : '',
                    style: new TextStyle(
                      fontSize: 14,
                      color: Color(0xffBB9361),
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    '餐厅',
                    style: new TextStyle(
                      fontSize: 14,
                      color: ThemeColors.colorA6A6A6,
                    ),
                  ),
                ),
                new Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: new Container(
                      constraints: BoxConstraints(maxWidth: 200),
                      child: Text(
                        _inviteInfo != null ? _inviteInfo.businessName : '',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )),
                new Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: Text(
                    '房间',
                    style: new TextStyle(
                      fontSize: 14,
                      color: ThemeColors.colorA6A6A6,
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    _inviteInfo != null ? _inviteInfo.room : '',
                    style: new TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: Text(
                    '时间',
                    style: new TextStyle(
                      fontSize: 14,
                      color: ThemeColors.colorA6A6A6,
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    _inviteInfo != null ? _inviteInfo.dateTime : '',
                    style: new TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: Text(
                    '地址',
                    style: new TextStyle(
                      fontSize: 14,
                      color: ThemeColors.colorA6A6A6,
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: new GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return MapPage(
                              latitude: double.parse(_inviteInfo != null
                                  ? _inviteInfo.latitude
                                  : "0.0"),
                              longitude: double.parse(_inviteInfo != null
                                  ? _inviteInfo.longitude
                                  : '0.0'),
                              title: _inviteInfo != null
                                  ? _inviteInfo.address
                                  : '',
                              address: _inviteInfo != null
                                  ? _inviteInfo.address
                                  : '',
                            );
                          },
                        ),
                      );
                    },
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/ic_invite_location.png',
                          width: 14,
                          height: 14,
                        ),
                        Text(
                          _inviteInfo != null ? _inviteInfo.address : '',
                          style: new TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            margin: EdgeInsets.only(top: 30),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 124,
                  height: 1,
                  color: Color(0xffBB9361),
                ),
                new Text(
                  '· 停车位置 ·',
                  style: new TextStyle(
                    fontSize: 14,
                    color: Color(0xffBB9361),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 10),
                  width: 124,
                  height: 1,
                  color: Color(0xffBB9361),
                ),
              ],
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 14, left: 14, right: 14, bottom: 28),
            child: new Text(
              _inviteInfo != null ? _inviteInfo.parkingDesc : '',
              style: new TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          _photosList.length == 0
              ? new Container()
              : new Container(
                  margin: EdgeInsets.only(top: 0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 124,
                        height: 1,
                        color: Color(0xffBB9361),
                      ),
                      new Text(
                        '· 包房环境 ·',
                        style: new TextStyle(
                          fontSize: 14,
                          color: Color(0xffBB9361),
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.only(left: 10),
                        width: 124,
                        height: 1,
                        color: Color(0xffBB9361),
                      ),
                    ],
                  ),
                ),
          _photosList.length == 0
              ? new Container()
              : new Container(
                  margin: EdgeInsets.only(top: 14),
                  child: ListView.separated(
                    physics: new NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return new Container(
                        height: 230,
                        margin: EdgeInsets.only(left: 14, right: 14),
                        child: Image.asset('assets/images/room.png'),
                      );
                    },
                    separatorBuilder: (context, i) {
                      return new Container(
                        height: 7,
                      );
                    },
                    itemCount: 2,
                  ),
                ),
          new Container(
            margin: EdgeInsets.only(top: 30),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 124,
                  height: 1,
                  color: Color(0xffBB9361),
                ),
                new Text(
                  '· 餐厅介绍 ·',
                  style: new TextStyle(
                    fontSize: 14,
                    color: Color(0xffBB9361),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 10),
                  width: 124,
                  height: 1,
                  color: Color(0xffBB9361),
                ),
              ],
            ),
          ),
          new Container(
            margin: EdgeInsets.only(top: 14, left: 14, right: 14, bottom: 84),
            child: new Html(
              data: _inviteInfo != null ? _inviteInfo.businessDetail : '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatButon() {
    return new Positioned(
        bottom: 54,
        right: 10,
        child: new GestureDetector(
          onTap: () {
            _modifyInfo();
          },
          child: new Container(
            alignment: Alignment.center,
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Color(0x1a9b9b9b),
                    offset: new Offset(0, 5),
                    blurRadius: 5,
                    spreadRadius: 0)
              ],
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/ic_invite_modify.png',
                  width: 32,
                  height: 32,
                ),
                Text(
                  '修改信息',
                  style: new TextStyle(
                      fontSize: 8, color: ThemeColors.color404040),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _bottomWidget() {
    return new Positioned(
      bottom: 0,
      child: new Container(
        height: 44,
        width: ScreenUtil.getScreenW(context),
        child: new Row(
          children: <Widget>[
            /// 商家
            new GestureDetector(
              onTap: () {
                _lunchPhone('18816838523');
              },
              child: new Container(
                color: Colors.white,
                width: 50,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/ic_phone_b.png',
                      width: 15,
                      height: 15,
                    ),
                    Text(
                      '商家',
                      style: new TextStyle(
                          fontSize: 10, color: ThemeColors.color404040),
                    ),
                  ],
                ),
              ),
            ),

            /// 生成图片
            new GestureDetector(
              onTap: () {
                _showPicDialog();
              },
              child: new Container(
                width: 163,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      left:
                          BorderSide(color: ThemeColors.colorEDEDED, width: 1)),
                ),
                child: new Text(
                  '生成图片',
                  style: new TextStyle(
                      fontSize: 16, color: ThemeColors.color404040),
                ),
              ),
            ),

            /// 转发给好友
            Expanded(
                child: new GestureDetector(
              onTap: () {
                Toast.toast(context, '转发给好友');
              },
              child: new Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [Color(0xff54548C), Color(0xff363659)])),
                child: new Text(
                  '转发给好友',
                  style: new TextStyle(fontSize: 16, color: Color(0xffF2C785)),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  /// 修改信息
  _modifyInfo() {
    Navigator.of(context).push(
      PopRoute(
        child: new InviteDialog(
          title: '',
          message: _welcome != null && _welcome.isNotEmpty ? _welcome : '',
          inviteName: _name != null && _name.isNotEmpty ? _name : '',
          onPositivePressEvent: (name, welcome) {
            if (name == null || welcome == null) {
              T.SaveImageToast.toast(
                  context, (name == null ? '昵称' : '欢迎语') + '不能为空!', false);
              return;
            }

            dio.get(Api.INVITATION_MODIFY_URL, queryParameters: {
              "invite_name": name,
              "invite_desc": welcome,
              "id": _inviteId.toString()
            }).then((data) {
              if (data.statusCode == 200) {
                Navigator.pop(context);
                _name = name;
                _welcome = welcome;
                setState(() {});
              } else {
                Toast.toast(context, data.statusMessage.toString());
                return;
              }
            });
          },
          negativeText: '取消',
          positiveText: '确认',
          onCloseEvent: () {
            Navigator.pop(context);
          },
        ),
        dimissable: false,
      ),
    );
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

  /// 生成图片dialog
  _showPicDialog() {
    dio.get(Api.INVITATION_PIC_URL,
        queryParameters: {"order_id": widget.orderId.toString()}).then((data) {
      if (data.statusCode == 200) {
        var d = jsonDecode(data.toString());
        var imgUrl = d['data']['img_url'];

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return new InvitePicDialog(
                title: '',
                imgUrl: imgUrl,
                negativeText: '',
                positiveText: '保存',
                onCloseEvent: () {},
                onPositivePressEvent: () {
                  _saveImage(context, imgUrl);
                },
              );
            });
      }
    });
  }

  /*
   * 保存图片到相册
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
        Navigator.pop(context);
        T.SaveImageToast.toast(context, '成功保存至相册', true);
      } else {
        Navigator.pop(context);
        T.SaveImageToast.toast(context, '保存失败', false);
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
