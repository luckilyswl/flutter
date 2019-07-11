import 'package:app/Application.dart';
import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/event.dart';
import 'package:app/model/user_info_bean.dart' as User;
import 'package:app/navigator/page_route.dart';
import 'package:app/utils/data_utils.dart';
import 'package:app/widget/toast.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:app/widget/action_bar.dart';
import 'package:app/model/manager_home_bean.dart' as Manager;
import 'dart:convert';

/*
 * 管理
 **/
class ManagerPage extends StatefulWidget {
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _isLogin = false;
  TabController _controller;
  int _currentIndex = 0;
  var _filterText = "请上座信息科技有限公司";

  bool _isShowMask = false;
  bool _isShowDropDownItemWidget = false;
  GlobalKey _keyFilter = GlobalKey();
  AnimationController _animController;
  double _dropDownHeight = 0;
  Animation<double> _animation;
  var _dropDownItem;
  bool isShowDropDown = false;

  /// true: 用户 false: 企业
  bool isUser = false;
  bool enterpriseAccountShow = false;
  bool _canModify = false;

  /// 账户余额信息
  Manager.Account _account;

  /// 文章列表
  List<Manager.Articles> _articles;

  /// banner
  List<Manager.Banner> _banner;

  /// 公司信息
  Manager.CompanyInfo _companyInfo;

  /// 部门列表
  List<Manager.Departments> _departments;

  /// 未登录信息
  Manager.UnloginInfo _unloginInfo;

  /// 员工信息
  Manager.Employee _employee;

  /// option
  List<Manager.Options> _options;
  List<Manager.Items> _articleList;
  Map<int, Manager.Departments> _departmentMap = new Map();

  int _departmentId = 0;

  @override
  void initState() {
    super.initState();
    initData(0);
    initEventBus();

    _animController = new AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
    }
    if (_animController != null) {
      _animController.dispose();
    }
  }

  void initData(int departmentId) {
    User.UserInfoBean userInfo = DataUtils.getUserInfo();
    if (userInfo != null) {
      User.Data data =  userInfo.data;
      isUser = !(data.isCompany == "1");
      _isLogin = true;
      if (!isUser) {
        dio.get(Api.MANAGER_URL, queryParameters: {"department_id" : departmentId.toString()}).then((data) {
          var sources = jsonDecode(data.data);
          Manager.ManagerHomeInfo info =
          Manager.ManagerHomeInfo.fromJson(sources);
          Manager.Data md = info.data;
          if (md != null) {
            if (this.mounted) {
              setState(() {
                _canModify = md.companyEditable == 0;
                enterpriseAccountShow = md.enterpriseAccountShow == 0 ? false : true;
                _account = md.account;
                _articles = md.articles;
                _banner = md.banner;
                _companyInfo = md.companyInfo;
                _departments = md.departments;
                _employee = md.employee;
                _unloginInfo = md.unloginInfo;
                _options = md.options;
                _articleList = _articles[0].items;

                _controller = TabController(
                    vsync: this, length: _articles.length, initialIndex: 0);
                //TabBar监听器
                _controller.addListener(() => _onTabChanged());

                // 将返回的部门信息转成一个数组
                initDepartments(1);
                _departments.clear();
                Manager.Departments d = new Manager.Departments();
                d.departmentName = "请上座信息科技有限公司";
                d.level = 1;
                d.id = 0;
                _departments.add(d);
                _departmentMap.forEach((k, v) {
                  _departments.add(v);
                });
              });
            }
          }
        });
      }
    }
  }

  /// 通过递归将部门信息按照层级放到Map
  void initDepartments(int level) {
    _departments.forEach((f) {
      f.level = level;
      _departmentMap[f.id] = f;
      if (f.subItems != null && f.subItems.length > 0) {
        _departments = f.subItems;
        initDepartments(level + 1);
      }
    });
  }

  void initEventBus() {
    Application.getEventBus().on<String>().listen((event) {
      if (this.mounted) {
        setState(() {
          if (event == EventType.loginSuccess) {
            initData(0);
          } else if (event == EventType.logout) {
            _isLogin = false;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initDropDownItem();
    return Scaffold(
      appBar: ActionBar.buildActionBar(
          context,
          AppBar(
            elevation: 0,
            title: Text('企业管理', style: new TextStyle(fontSize: 17)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              // 客服
              IconButton(
                  icon: _isLogin
                      ? Image.asset('assets/images/ic_server.png',
                          width: 30, height: 30)
                      : new Container(),
                  onPressed: () {
                    _goServer();
                  })
            ],
          )),
      body: _isLogin ? _loginWidget() : _noLoginWidget(),
    );
  }

  Widget _companyWidget(){
    return SingleChildScrollView(
      child: new Container(
        margin: new EdgeInsets.only(top: 20),
        child: new Stack(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Container(
                      margin: new EdgeInsets.only(left: 26),
                      alignment: Alignment.center,
                      width: 52,
                      height: 52,
                      decoration: new BoxDecoration(
                          gradient: new LinearGradient(colors: [
                            ThemeColors.color2E3576,
                            ThemeColors.color555C9E
                          ]),
                          borderRadius: BorderRadius.circular(200)),
                      child: new Text(
                        '座',
                        style: new TextStyle(
                          fontSize: 30,
                          color: ThemeColors.colorFFEBD3,
                        ),
                      ),
                    ),
                    new Container(
                        margin: new EdgeInsets.only(left: 14),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Text(_companyInfo != null ? _companyInfo.enterpriseName : "",
                                    style: new TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ThemeColors.color404040)),
                                _canModify ? new Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: new GestureDetector(
                                      onTap: () {
                                        _modify();
                                      },
                                      child: Image.asset(
                                          'assets/images/ic_modify.png',
                                          width: 14,
                                          height: 14),
                                    )) : new Container(),
                              ],
                            ),
                            new Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: new Text('公司ID：${_companyInfo != null ? _companyInfo.id : ''}',
                                    style: new TextStyle(
                                        fontSize: 10,
                                        color: ThemeColors.color404040)))
                          ],
                        ))
                  ],
                ),

                new Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    new Container(
                      margin: new EdgeInsets.only(top: 20, left: 14, right: 14),
                      height: _account != null ? 80 : 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x26000000),
                              offset: new Offset(0, 3),
                              blurRadius: 8,
                              spreadRadius: 0)
                        ],
                      ),
                      child: new Container(
                          key: _keyFilter,
                          margin: EdgeInsets.only(bottom: _account != null ? 25.0 : 0.0),
                          child: new Row(
                            children: <Widget>[
                              // 条件筛选
                              new GestureDetector(
                                onTap: () {
                                  _showDropDownItemWidget();
                                },
                                child: new Container(
                                  child: new Row(
                                    children: <Widget>[
                                      new Expanded(
                                        child: new Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: new Text(_filterText,
                                              style: new TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                  ThemeColors.color404040)),
                                        ),
                                      ),
                                      new Container(
                                        alignment: Alignment.centerRight,
                                        width: 30,
                                        child: new Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Image.asset(
                                                'assets/images/ic_xiala.png',
                                                width: 14,
                                                height: 14)),
                                      )
                                    ],
                                  ),
                                  margin: EdgeInsets.only(left: 14),
                                  width: 208,
                                  height: 28,
                                  decoration: !isShowDropDown
                                      ? new BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(14),
                                      gradient: new LinearGradient(colors: [
                                        ThemeColors.colorF8E2C3,
                                        ThemeColors.colorF1CD9F
                                      ]))
                                      : new BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: new Radius.circular(10),
                                          topRight:
                                          new Radius.circular(10)),
                                      gradient: new LinearGradient(colors: [
                                        ThemeColors.colorF8E2C3,
                                        ThemeColors.colorF1CD9F
                                      ])),
                                ),
                              ),

                              // 查看明细
                              new Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: new GestureDetector(
                                  onTap: () {
                                    _lookDetail();
                                  },
                                  child: new Row(
                                    children: <Widget>[
                                      new Text(
                                        '查看余额明细',
                                        style: new TextStyle(
                                            fontSize: 12,
                                            color: ThemeColors.color66401F),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.only(left: 2),
                                        child: Image.asset(
                                            'assets/images/ic_more_b.png',
                                            width: 12,
                                            height: 12),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),

                    _account != null ? new Container(
                      margin: new EdgeInsets.only(top: 75, left: 14, right: 14),
                      height: 75,
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(colors: [
                          ThemeColors.color2E3576,
                          ThemeColors.color555C9E
                        ]),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x26000000),
                              offset: new Offset(0, 3),
                              blurRadius: 8,
                              spreadRadius: 0)
                        ],
                      ),
                      child: _account.type == 1 ? _adminAccountWidget() : _headerAccountWidget()
                    ) : new Container(),
                  ],
                ),

                new Container(
                  margin: EdgeInsets.only(top: 28),
                  child: new GridView.count(
                    physics: new NeverScrollableScrollPhysics(),
                    // 由item指定高度
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(4.0),
                    primary: false,
                    // 竖向间距
                    mainAxisSpacing: 12.0,
                    // 横向 Item 的个数
                    crossAxisCount: 4,
                    // 横向间距
                    crossAxisSpacing: 4.0,
                    children: _buildGridTileList(
                        _options != null ? _options.length : 0),
                  ),
                ),

                _banner != null && _banner.length > 0
                    ? new Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 14, right: 14),
                  height: 85,
                  decoration: BoxDecoration(
                    image: new DecorationImage(
                        image: new NetworkImage(_banner[0].imgUrl)
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                )
                    : new Container(),

                new Container(
                  margin: EdgeInsets.only(top: 24, left: 14),
                  alignment: Alignment.topLeft,
                  child: Text(
                    '帮助中心',
                    style: new TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.color404040),
                  ),
                ),

                // TabBar
                _articles != null
                    ? new Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: new Align(
                    alignment: Alignment.centerLeft,
                    child: new TabBar(
                      controller: _controller,
                      isScrollable: true,
                      labelPadding: EdgeInsets.only(left: 12),
                      indicator: new BoxDecoration(),
                      tabs: _articles.map((f) {
                        return new Container(
                          alignment: Alignment.center,
                          width: 78,
                          height: 24,
                          decoration: _articles.indexOf(f) == _currentIndex
                              ? BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: new LinearGradient(colors: [
                                ThemeColors.color2E3576,
                                ThemeColors.color555C9E
                              ]))
                              : BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: ThemeColors.colorEEEEEE),
                          child: Text(
                            f.name,
                            style: new TextStyle(
                                fontSize: 12,
                                color:
                                _articles.indexOf(f) == _currentIndex
                                    ? Colors.white
                                    : ThemeColors.color9B9B9B),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
                    : new Container(),

                // 文章列表
                _articleList != null
                    ? new Container(
                  child: new ListView.separated(
                    itemBuilder: (context, i) {
                      return new GestureDetector(
                        onTap: () {
                          _onHelpItemClick(i);
                        },
                        child: new Container(
                          margin: EdgeInsets.only(left: 14),
                          alignment: Alignment.centerLeft,
                          height: 44,
                          child: Text(
                            "${i + 1}、" + _articleList[i].description,
                            style: new TextStyle(
                                fontSize: 12,
                                color: ThemeColors.color4A4A4A),
                          ),
                        ),
                      );
                    },
                    itemCount: _articleList.length,
                    separatorBuilder: (context, i) {
                      return Container(
                        margin: EdgeInsets.only(left: 14, right: 14),
                        height: 1,
                        color: ThemeColors.colorDCDCDC,
                      );
                    },
                    physics: new NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                  ),
                )
                    : new Container(),

              ],
            ),
            _buildDropDownWidget(),
          ],
        ),
      ),
    );
  }

  Widget _adminAccountWidget() {
    return new Row(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(left: 20),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Text(
                '实时可用余额：',
                style: new TextStyle(
                    fontSize: 12, color: Colors.white),
              ),
              new Text(
                _account.balance,
                style: new TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        new Container(
          margin: EdgeInsets.only(left: 26),
          width: 1,
          height: 24,
          color: Colors.white,
        ),
        new Row(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(left: 20),
              width: 80,
              height: 28,
              decoration: BoxDecoration(
                gradient: new LinearGradient(colors: [
                  ThemeColors.colorFFF1E4,
                  ThemeColors.colorFCE6C8
                ]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: new FlatButton(
                  onPressed: () {
                    _recharge();
                  },
                  child: new Text(
                    '立即充值',
                    style: new TextStyle(
                        fontSize: 12,
                        color: Color(0xFF89551C)),
                  )),
            ),
            new SizedBox(
              width: 5,
            ),
            new Container(
              width: 80,
              height: 28,
              decoration: BoxDecoration(
                gradient: new LinearGradient(colors: [
                  ThemeColors.colorFFF1E4,
                  ThemeColors.colorFCE6C8
                ]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: new FlatButton(
                  onPressed: () {
                    _budgetManager();
                  },
                  child: new Text(
                    '预算管理',
                    style: new TextStyle(
                        fontSize: 12,
                        color: Color(0xFF89551C)),
                  )),
            ),
          ],
        )
      ],
    );
  }

  Widget _headerAccountWidget() {
    return new Row(
      children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(padding: EdgeInsets.only(left: 20),
                  child: new Text(
                    '当前可用预算：',
                    style: new TextStyle(
                        fontSize: 12, color: Color(0xB3FFFFFF)),
                  ),
                ),

                new Text(
                  _account.balance,
                  style: new TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),

            _account.desc.isNotEmpty ? new Padding(padding: EdgeInsets.only(top: 12, left: 40),
              child: new Text(_account.desc, style: new TextStyle(
                fontSize: 9,
                color: ThemeColors.colorA6A6A6
              ),),
            ) : new Container(),
          ],
        ),


        new Container(
          margin: EdgeInsets.only(left: 26),
          width: 1,
          height: 24,
          color: Color(0xB3FFFFFF),
        ),

        new Container(
          margin: EdgeInsets.only(left: 26),
          child: new Container(
            width: 80,
            height: 28,
            decoration: BoxDecoration(
              gradient: new LinearGradient(colors: [
                ThemeColors.colorFFF1E4,
                ThemeColors.colorFCE6C8
              ]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: new FlatButton(
                onPressed: () {
                  _budgetManager();
                },
                child: new Text(
                  '预算管理',
                  style: new TextStyle(
                      fontSize: 12,
                      color: Color(0xFF89551C)),
                )),
          ),
        )
      ],
    );
  }

  Widget _loginWidget() {
    if (!isUser) {
      return _companyWidget();
    } else {
      return _noLoginWidget();
    }
  }

  /*
   * 下拉选项
   **/
  Widget _buildDropDownWidget() {
    RenderBox renderBoxRed;
    double top = 0;
    if (_dropDownHeight != 0) {
      renderBoxRed = _keyFilter.currentContext.findRenderObject();
      top = renderBoxRed.size.height;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: _account != null ? top + 28 : top + 28 + 28, left: 28),
      child: new Column(
        children: <Widget>[
          Container(
            child: new Row(
              children: <Widget>[
                new Container(
                  width: 208,
                  height: _animation == null ? 0 : _animation.value,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: new Radius.circular(10),
                          bottomRight: new Radius.circular(10)),
                      gradient: new LinearGradient(colors: [
                        ThemeColors.colorF8E2C3,
                        ThemeColors.colorF1CD9F
                      ])),
                  child: _dropDownItem,
                ),
                new Expanded(
                  child: new GestureDetector(
                    onTap: () {
                      _hideDropDownItemWidget();
                    },
                    child: new Container(
                      height: _animation == null ? 0 : _animation.value,
                      color: Colors.transparent,
                    ),
                  ),
                )
              ],
            ),
          ),
          _mask()
        ],
      ),
    );
  }

  Widget _mask() {
    if (_isShowMask) {
      return GestureDetector(
        onTap: () {
          _hideDropDownItemWidget();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color.fromRGBO(0, 0, 0, 0),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget _noLoginWidget() {
    return new SingleChildScrollView(
      child: new Container(
        alignment: Alignment.center,
        child: new Column(
          children: <Widget>[
            new Padding(
                padding: EdgeInsets.only(top: 40),
                child: new Text(
                  '该页面仅为企业用户提供服务',
                  style: new TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.color404040),
                )),
            new Padding(
              padding: EdgeInsets.only(top: 40),
              child: new CircleAvatar(
                backgroundColor: ThemeColors.colorEEEEEE,
                radius: 75.0,
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 40, left: 68, right: 68),
              child: new Text(
                '请用已绑定企业的账号进行登录，若您的企业需要开通服务，请前往企业注册页面提交信息',
                style: new TextStyle(
                  fontSize: 14,
                  height: 1.2,
                  color: ThemeColors.colorA6A6A6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            new Container(
              margin: new EdgeInsets.only(top: 40),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 企业注册
                  new Container(
                    width: 140.0,
                    height: 40.0,
                    child: new Card(
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                            side: new BorderSide(
                                width: 1, color: ThemeColors.color3F4688),
                            borderRadius: BorderRadius.circular(22)),
                        color: Colors.white,
                        child: new FlatButton(
                            onPressed: () {
                              _register();
                            },
                            child: new Text(
                              '企业注册',
                              style: new TextStyle(
                                  fontSize: 16, color: ThemeColors.color3F4688),
                            ))),
                  ),

                  // 前往登录
                  !_isLogin ? new Container(
                    width: 140,
                    height: 40,
                    child: new Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22)),
                      color: ThemeColors.color555C9E,
                      child: new FlatButton(
                        onPressed: () {
                          _goLogin();
                        },
                        child: new Text(
                          '前往登录',
                          style:
                              new TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ) : new Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGridTileList(int number) {
    List<Widget> widgetList = new List();

    for (int i = 0; i < number; i++) {
      widgetList.add(
        new GestureDetector(
          onTap: (){
            _clickGridItem(i);
          },
          child: new Container(
            child: new Column(
              children: <Widget>[
                _options != null
                    ? Image.network(_options[i].icon, width: 32, height: 32)
                    : Image.asset('assets/images/ic_service1.png',
                    width: 32, height: 32),
                new Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: new Text(
                    _options != null ? _options[i].name : '',
                    style: new TextStyle(
                        fontSize: 12, color: ThemeColors.color404040),
                  ),
                )
              ],
            ),
          ),
        )

      );
    }
    return widgetList;
  }

  _clickGridItem(int i) {
    Toast.toast(context, _options[i].name);
  }

  /*
   * 企业注册
   **/
  _register() {
    Navigator.of(context).pushNamed(Page.REGISTER_PAGE);
  }

  /*
   * 前往登录
   **/
  _goLogin() {
    Navigator.of(context).pushNamed(Page.LOGIN_PAGE);
  }

  _goServer() {
    Application.getEventBus().fire(EventType.goServer);
  }

  _modify() {
    Toast.toast(context, 'modify');
  }

  _lookDetail() {
    Toast.toast(context, '查看明细');
  }

  _recharge() {
    Toast.toast(context, '立即充值');
  }

  _budgetManager() {
    Toast.toast(context, '预算管理');
  }

  _onTabChanged() {
    if (_controller.indexIsChanging) {
      if (this.mounted) {
        this.setState(() {
          _articleList = _articles[_controller.index].items;
          _currentIndex = _controller.index;
        });
      }
    }
  }

  _showDropDownItemWidget() {
    setState(() {
      isShowDropDown = !isShowDropDown;
    });
    _dropDownHeight = 160;
    _isShowDropDownItemWidget = !_isShowDropDownItemWidget;
    _isShowMask = !_isShowMask;

    _animation =
        new Tween(begin: 0.0, end: _dropDownHeight).animate(_animController)
          ..addListener(() {
            //这行如果不写，没有动画效果
            setState(() {});
          });

    if (_animation.status == AnimationStatus.completed) {
      _animController.reverse();
    } else {
      _animController.forward();
    }
  }

  _hideDropDownItemWidget() {
    setState(() {
      isShowDropDown = false;
    });
    _isShowDropDownItemWidget = !_isShowDropDownItemWidget;
    _isShowMask = !_isShowMask;
    _animController.reverse();
  }

  /*
   * 帮助中心 item 点击事件
   **/
  _onHelpItemClick(int i) {
    Toast.toast(context, _articleList[i].description.toString());
  }

  /*
   * 初始化下拉列表
   **/
  void initDropDownItem() {
    _dropDownItem = _departments != null ? Container(
      margin: EdgeInsets.only(top: 8),
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return new GestureDetector(
              onTap: () {
                _clickDropItem(i);
              },
              child: new Container(
                margin: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                height: 30,
                child: _levelDepartment(_departments[i].departmentName, _departments[i].level)
              ),
            );
          },
          separatorBuilder: (context, i) {
            return new Container(
              margin: EdgeInsets.only(left: 14, right: 14),
              height: 1,
              color: Colors.white,
            );
          },
          itemCount: _departments.length),
    ) : new Container();
  }

  Widget _levelDepartment(String name, int level) {
    return new Padding(padding: EdgeInsets.only(
        left: level == 1 ? 0 : level == 2 ? 20 : 40),
      child: Text(
        level == 1 ? name : level == 2 ? "└  " + name : "└  " + name,
        style: new TextStyle(
            fontSize: 12, color: ThemeColors.color404040),
      ),
    );
  }

  /*
   * 下拉筛选点击事件
   **/
  _clickDropItem(int i) {
    setState(() {
      _filterText = _departments[i].departmentName;
      initData(_departments[i].id);
      _hideDropDownItemWidget();
    });
  }

  @override
  bool get wantKeepAlive => true;
}
