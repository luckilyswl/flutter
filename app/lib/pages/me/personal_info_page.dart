import 'package:app/Application.dart';
import 'package:app/api/net_index.dart';
import 'package:app/model/event.dart';
import 'package:app/model/user_info_bean.dart';
import 'package:app/pages/article/article_page.dart';
import 'package:app/res/gradients.dart';
import 'package:app/res/theme_colors.dart';
import 'package:app/utils/screen_util.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/action_bar.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PersonalInfoPage extends StatefulWidget {
  final bool isUser;
  final String name;
  final String phone;
  final String company;
  final String department;
  final String position;

  PersonalInfoPage(
      {@required this.name,
      @required this.phone,
      @required this.company,
      @required this.department,
      @required this.position,
      @required this.isUser});

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TextEditingController _controller = new TextEditingController();

  bool _isCompany = false;
  @override
  void initState() {
    super.initState();
    
    UserInfoBean user = DataUtils.getUserInfo();
    if (user.data.isCompany == "1") {
      _isCompany = true;
    } else {
      _isCompany = false;
    }

    _controller = TextEditingController();
    _controller.text = widget.name;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(
        affinity: TextAffinity.upstream,
        offset: widget.name.length,
      ),
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActionBar.buildActionBar(
        context,
        AppBar(
          title: Text('个人信息', style: const TextStyle(fontSize: 16)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: _bodyWidget(),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _bodyWidget() {
    return new Container(
      color: ThemeColors.colorEEEEEE,
      child: new Stack(
        children: <Widget>[
          Container(
            width: ScreenUtil.getScreenW(context),
            child: new Column(
              children: <Widget>[
                /// 名字
                new Container(
                  width: ScreenUtil.getScreenW(context),
                  margin: EdgeInsets.only(left: 12, right: 12, top: 20),
                  height: 44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          '名字',
                          style: new TextStyle(
                              fontSize: 14, color: ThemeColors.color404040),
                        ),
                      ),
                      new Container(
                        width: 50,
                      ),
                      new Expanded(
                        child: new Container(
                          width: 200,
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 10),
                          child: new TextField(
                            controller: _controller,
                            textAlign: TextAlign.end,
                            style: new TextStyle(
                                fontSize: 14,
                                color: ThemeColors.color1A1A1A,
                                fontWeight: FontWeight.bold),
                            autofocus: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(right: 14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                /// 手机号
                new Container(
                  width: ScreenUtil.getScreenW(context),
                  margin: EdgeInsets.only(left: 12, right: 12, top: 10),
                  height: 44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          '手机号',
                          style: new TextStyle(
                              fontSize: 14, color: ThemeColors.color404040),
                        ),
                      ),
                      new Expanded(
                        child: new Container(
                          width: 200,
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 20),
                          child: new Text(
                            widget.phone != null ? widget.phone : '',
                            style: new TextStyle(
                              fontSize: 14,
                              color: ThemeColors.colorA6A6A6,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                /// 公司
                widget.isUser
                    ? new Container()
                    : new Container(
                        width: ScreenUtil.getScreenW(context),
                        margin: EdgeInsets.only(left: 12, right: 12, top: 10),
                        height: 44,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: new Row(
                          children: <Widget>[
                            new Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                '公司',
                                style: new TextStyle(
                                    fontSize: 14,
                                    color: ThemeColors.color404040),
                              ),
                            ),
                            new Expanded(
                              child: new Container(
                                width: 200,
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(right: 20),
                                child: new Text(
                                  widget.company != null ? widget.company : '',
                                  style: new TextStyle(
                                    fontSize: 14,
                                    color: ThemeColors.colorA6A6A6,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                /// 部门
                widget.isUser
                    ? new Container()
                    : new Container(
                        width: ScreenUtil.getScreenW(context),
                        margin: EdgeInsets.only(left: 12, right: 12, top: 10),
                        height: 44,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: new Row(
                          children: <Widget>[
                            new Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                '部门',
                                style: new TextStyle(
                                    fontSize: 14,
                                    color: ThemeColors.color404040),
                              ),
                            ),
                            new Expanded(
                              child: new Container(
                                width: 200,
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(right: 20),
                                child: new Text(
                                  widget.department,
                                  style: new TextStyle(
                                    fontSize: 14,
                                    color: ThemeColors.colorA6A6A6,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                /// 职位
                widget.isUser
                    ? new Container()
                    : new Container(
                        width: ScreenUtil.getScreenW(context),
                        margin: EdgeInsets.only(left: 12, right: 12, top: 10),
                        height: 44,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: new Row(
                          children: <Widget>[
                            new Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                '职位',
                                style: new TextStyle(
                                    fontSize: 14,
                                    color: ThemeColors.color404040),
                              ),
                            ),
                            new Expanded(
                              child: new Container(
                                width: 200,
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(right: 20),
                                child: new Text(
                                  widget.position != null
                                      ? widget.position
                                      : '',
                                  style: new TextStyle(
                                    fontSize: 14,
                                    color: ThemeColors.colorA6A6A6,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
          _saveButton(),
        ],
      ),
    );
  }

  Widget _saveButton() {
    return new Positioned(
      bottom: 0,
      child: new Container(
          height: 70,
          width: ScreenUtil.getScreenW(context),
          color: Colors.white,
          child: new GestureDetector(
            onTap: () {
              dio.get(_isCompany ? Api.EMPLOYEE_EDIT_URL : Api.USER_EDIT_URL, queryParameters: {
                "name": _controller.text,
              }).then((data) {
                var d = jsonDecode(data.toString());
                if (d['error_code'] == "0") {
                  Application.getEventBus().fire(EventType.personalInfoEdit);
                  Navigator.pop(context);
                  Toast.toast(context, '保存成功');
                } else {
                  Toast.toast(context, d['msg']);
                }
              });
            },
            child: new Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(14),
              height: 44,
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [Color(0xff54548C), Color(0xff363659)]),
                borderRadius: BorderRadius.circular(5),
              ),
              child: new Text(
                '保存',
                style: new TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
