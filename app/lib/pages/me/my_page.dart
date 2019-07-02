import 'package:app/Application.dart';
import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/event.dart';
import 'package:app/model/user_info_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/res/gradients.dart';
import 'package:app/res/theme_colors.dart';
import 'package:app/utils/data_utils.dart';
import 'package:app/utils/shared_preferences.dart';
import 'package:app/widget/item_more.dart';
import 'package:app/widget/red_point.dart';
import 'package:flutter/material.dart';
import 'package:app/widget/action_bar.dart';
import 'package:app/widget/toast.dart';
import 'dart:convert';
import 'package:app/model/my_info_bean.dart' as MyInfo;

/*
 * 我的
 **/
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  ///是否已登录
  bool isLogin = false;

  ///登录卡片
  Widget loginCard;
  /// 用户信息
  MyInfo.UserInfoBean _userInfoBean;
  /// 用户余额信息
  MyInfo.UserBalanceBean _userBalanceBean;
  /// 企业信息
  MyInfo.CompanyInfoBean _companyInfoBean;
  /// 企业余额信息
  MyInfo.CompanyBalanceBean _companyBalanceBean;

  /// true: 用户 false: 企业
  bool isUser = true;
  bool isAdmin = false;
  bool isHeader = false;
  String _availableBalance;
  /// 充值描述
  String _rechargeDesc;

  @override
  void initState() {
    super.initState();
    initData();
    initEventBus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initData() {
    UserInfoBean userInfo = DataUtils.getUserInfo();
    if (userInfo != null) {
      dio.get(Api.ME_URL).then((data) {
        var sources = jsonDecode(data.data);
        MyInfo.MyInfoBean info = MyInfo.MyInfoBean.fromJson(sources);
        MyInfo.DataBean dataBean = info.data;
        _rechargeDesc = dataBean.rechargeDesc;
        _userInfoBean = dataBean.userInfo;
        _companyInfoBean = dataBean.companyInfo;
        _userBalanceBean = dataBean.userBalance;
        _companyBalanceBean = dataBean.companyBalance;

        if (this.mounted) {
          setState(() {
            isAdmin = _companyInfoBean.isAdmin == "1" ? true : false;
            isHeader = _companyInfoBean.isHeader == "1" ? true : false;
            isUser = !(dataBean.isCompany == "1");
            isLogin = true;
            _availableBalance = isUser ? _userBalanceBean.availableBalance.toString()
                : _companyBalanceBean.availableBalance.toString();
            loginCard = _buildLoginedCard(
                0,
                isUser ? _userInfoBean.nickName : _companyInfoBean.employeeName,
                company: _companyInfoBean.companyName,
                department: _companyInfoBean.departmentName,
                position: _companyInfoBean.isHeader == "1" ? "部门主管" : '',
                phone: isUser ? _userInfoBean.bindPhone : _companyInfoBean.telphone,
                isUpdated: true
            );
          });
        }
      });
    }
  }

  void initEventBus() {
    Application.getEventBus().on<String>().listen((event) {
      if (event == EventType.loginSuccess) {
        initData();
      } else if (event == EventType.logout) {
        if (this.mounted) {
          setState(() {
            isLogin = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActionBar.buildActionBar(
        context,
        AppBar(
          title: Text('我的', style: const TextStyle(fontSize: 17)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Container(
        color: ThemeColors.colorEEEEEE,
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ///填满属性double.infinity
                Image.asset(
                  'assets/images/me_bg.png',
                  height: 81,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                Container(
                  height: 24,
                  margin: const EdgeInsets.only(top: 80),
                  decoration: BoxDecoration(
                    color: ThemeColors.color353535,
                  ),
                ),
                _buildCard(isLogin ? loginCard : _buildNoLoginCard()),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            isLogin ? _buildMyOrder() : Container(),
            SizedBox(
              height: 8,
            ),
            isLogin ? _buildMyBalance() : Container(),
            SizedBox(
              height: 8,
            ),
            _buildMoreAction(),
          ],
        ),
      ),
    );
  }

  ///创建登录卡片
  Widget _buildCard(Widget widget) {
    return

        ///自定义带阴影的card
        Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 56, left: 8, right: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
                color: ThemeColors.colorD0000000,
                offset: Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 0)
          ]),
      child: widget,
    );
  }

  ///未登录card
  Widget _buildNoLoginCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 17,
        ),
        Text(
          '当前账号未登录',
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          '登录更多精彩',
          style: const TextStyle(color: ThemeColors.color9B9B9B, fontSize: 12),
        ),
        Container(
          width: 145,
          height: 40,
          margin: const EdgeInsets.only(top: 12, bottom: 24),
          child:

              ///带渐变色的按钮
              Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              gradient: Gradients.blueLinearGradient,
            ),
            child: RaisedButton(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23)),
              child: Text('点击登录',
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: _clickLogin,
            ),
          ),
        ),
      ],
    );
  }

  ///已登录card
  Widget _buildLoginedCard(int type, String name,
      {String company = "",
      String department = "",
      String position = "",
      String phone = "",
      bool isUpdated = false}) {
    const textStyle = TextStyle(
      color: ThemeColors.color9B9B9B,
      fontSize: 12,
    );

    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.topRight,
          child: Image.asset('assets/images/ic_me_change.png',
              width: 45, height: 45),
        ),
        Container(
          padding: const EdgeInsets.only(left: 18),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 18,
              ),
              Row(
                children: <Widget>[
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  isAdmin ? Container(
                    margin: const EdgeInsets.only(top: 1, left: 16),
                    padding:
                        EdgeInsets.only(top: 3, bottom: 3, left: 10, right: 10),
                    child: Text(
                      '管理员',
                      style: const TextStyle(
                          color: ThemeColors.color583B04, fontSize: 10),
                    ),
                    decoration: BoxDecoration(
                        gradient: Gradients.goldLightLinearGradient,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          width: 1,
                          color: ThemeColors.colorD9AE5E,
                        )),
                  ) : new SizedBox(width: 0,),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: (isUser ? 0 : 15)),
                child: isUser ? new SizedBox(height: 0) : Text(company, style: textStyle,),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Offstage(
                    offstage: department.isEmpty,
                    child: Text(
                      department,
                      style: textStyle,
                    ),
                  ),
                  Offstage(
                    offstage: position.isEmpty,
                    child: Text(
                      position,
                      style: textStyle,
                    ),
                  )
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: Offstage(
                  offstage: phone.isEmpty,
                  child: Text(
                    phone,
                    style: textStyle,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  ///更多功能item
  Widget _buildMoreAction() {
    var listTiles = [
      ItemMore.buildItemMore(
        'assets/images/ic_message.png',
        '联系客服',
        'assets/images/ic_more.png',
        () => Toast.toast(context, '联系客服'),
      ),
      ItemMore.buildItemMore(
        'assets/images/ic_edit.png',
        '意见反馈',
        'assets/images/ic_more.png',
        () => Toast.toast(context, '意见反馈'),
      ),
      ItemMore.buildItemMore(
        'assets/images/ic_edit.png',
        '设置',
        'assets/images/ic_more.png',
        () => _setting()
      ),
    ];

    if (isLogin) {
      listTiles.insert(
          1,
          ItemMore.buildItemMore(
            'assets/images/ic_edit.png',
            '我的收藏',
            'assets/images/ic_more.png',
            () => Toast.toast(context, '我的收藏'),
          ));
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
          color: Colors.transparent,
        );
      },
      itemCount: listTiles.length,
    );
  }

  ///我的订单
  Widget _buildMyOrder() {
    var orderList = [
      _buildMyOrderItem('assets/images/ic_qianbao.png', '待付款',
          () => Toast.toast(context, '待付款'),
          showRedPoint: true),
      _buildMyOrderItem('assets/images/ic_daijiucan.png', '待就餐/使用',
          () => Toast.toast(context, '待就餐/使用'),
          showRedPoint: false),
      _buildMyOrderItem('assets/images/ic_daimaidan.png', '待买单',
          () => Toast.toast(context, '待买单'),
          showRedPoint: false),
      _buildMyOrderItem('assets/images/ic_qianbao.png', '待付款',
          () => Toast.toast(context, '待付款'),
          showRedPoint: false),
      _buildMyOrderItem('assets/images/ic_qianbao.png', '待付款',
          () => Toast.toast(context, '待付款'),
          showRedPoint: false),
    ];

    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 40,
            color: Colors.white,
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/ic_menu.png', width: 16, height: 16),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Text(
                    '我的订单',
                    style: const TextStyle(
                        color: ThemeColors.color222222, fontSize: 14),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _clickAllOrder,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '查看全部订单',
                          style: const TextStyle(
                              color: ThemeColors.color9B9B9B, fontSize: 12),
                        ),
                        Image.asset('assets/images/ic_more.png',
                            width: 16, height: 16)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            color: ThemeColors.colorE3E3E3,
          ),
          Container(
            height: 94,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) => orderList[i],
              separatorBuilder: (context, i) => Container(
                    width: 1,
                    height: double.infinity,
                    color: ThemeColors.colorE3E3E3,
                  ),
              itemCount: orderList.length,
            ),
          ),
        ],
      ),
    );
  }

  ///创建我的余额
  Widget _buildMyBalance() {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          height: 40,
          padding: const EdgeInsets.only(left: 14, right: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/ic_wodeyue.png',
                  width: 16, height: 16),
              SizedBox(
                width: 8,
              ),
              Text(
                '我的余额',
                style: const TextStyle(
                    color: ThemeColors.color222222, fontSize: 14),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: _clickBalanceDetail,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '查看余额明细',
                        style: const TextStyle(
                            color: ThemeColors.color9B9B9B, fontSize: 12),
                      ),
                      Image.asset('assets/images/ic_more.png',
                          width: 16, height: 16)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 1,
          color: ThemeColors.colorE3E3E3,
        ),
        Container(
          color: Colors.white,
          height: 90,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    _availableBalance.toString(),
                    style: const TextStyle(
                        color: ThemeColors.colorD39857, fontSize: 28),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    margin: const EdgeInsets.only(bottom: 35),
                    child: Text(
                      '元',
                      style: const TextStyle(
                          color: ThemeColors.color222222, fontSize: 12),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                width: 1,
                color: ThemeColors.colorDCDCDC,
                height: 30,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 21,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 42),
                      child: GestureDetector(
                        onTap: _clickRecharge,
                        child: Container(
                          width: 104,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: Gradients.goldDarkLinearGradient,
                            border: Border.all(
                                width: 1, color: ThemeColors.colorD39857),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/ic_recharge.png',
                                  width: 16,
                                  height: 16,
                                ),
                                Container(
                                  width: 2,
                                ),
                                Text(
                                  '立即充值',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 11,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 29),
                      child: Text(
                        _rechargeDesc,
                        style: const TextStyle(
                            color: ThemeColors.color583B04, fontSize: 10),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///创建我的订单item
  Widget _buildMyOrderItem(String icon, String text, VoidCallback callback,
      {bool showRedPoint}) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: callback,
        child: Container(
          width: 94,
          height: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(icon, width: 28, height: 28),
                    SizedBox(
                      height: 9,
                    ),
                    Text(
                      text,
                      style: const TextStyle(
                          fontSize: 12, color: ThemeColors.color9B9B9B),
                    )
                  ],
                ),
              ),
              Offstage(
                offstage: !showRedPoint,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16, right: 16),
                    child: RedPoint(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///查看全部订单点击事件
  void _clickAllOrder() {
    Toast.toast(context, '敬请期待');
  }

  ///余额明细
  void _clickBalanceDetail() {
    Toast.toast(context, '敬请期待');
  }

  ///登录按钮点击事件
  void _clickLogin() {
    setState(() {
      Navigator.of(context).pushNamed(Page.LOGIN_PAGE);
    });
  }

  ///立即充值点击事件
  void _clickRecharge() {
    Toast.toast(context, '敬请期待');
  }

  void _setting() {
    Navigator.of(context).pushNamed(Page.SETTING_PAGE);
  }

  @override
  bool get wantKeepAlive => true;
}
