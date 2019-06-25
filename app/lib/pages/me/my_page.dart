import 'package:flutter/material.dart';
import 'package:app/widget/toast.dart';
import 'package:app/widget/item_more.dart';
import 'package:app/res/theme_colors.dart';

/*
 * 我的
 **/
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  ///是否已登录
  static bool isLogined = false;

  ///登录卡片
  Widget loginCard;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginCard = isLogined
        ? _buildLoginedCard(0, '李春梅',
            company: '广州请上座信息科技有限公司',
            department: '产品部',
            position: '部门主管',
            phone: '13456789066',
            isUpdated: true)
        : _buildNoLoginCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('我的', style: new TextStyle(fontSize: 17)),
          centerTitle: true,
          backgroundColor: ThemeColors.color555C9E,
        ),
        body: Container(
          color: ThemeColors.colorEEEEEE,
          child: Column(
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
                    margin: EdgeInsets.only(top: 80),
                    decoration: BoxDecoration(
                      color: ThemeColors.color353535,
                    ),
                  ),
                  _buildCard(loginCard),
                ],
              ),
              _buildMyOrder(),
              Container(
                child: _buildMoreAction(),
              ),
            ],
          ),
        ));
  }

  ///创建登录卡片
  Widget _buildCard(Widget widget) {
    return

        ///自定义带阴影的card
        Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 56, left: 8, right: 8),
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
        Container(
          margin: EdgeInsets.only(top: 17),
          child: Text(
            '当前账号未登录',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 12),
          child: Text(
            '登录更多精彩',
            style: TextStyle(color: ThemeColors.color9B9B9B, fontSize: 12),
          ),
        ),
        Container(
          width: 145,
          height: 40,
          margin: EdgeInsets.only(top: 12, bottom: 24),
          child:

              ///带渐变色的按钮
              Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
                gradient: LinearGradient(
                    colors: [ThemeColors.color2E3576, ThemeColors.color555C9E],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
            child: RaisedButton(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23)),
              child: Text('点击登录',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: clickLogin,
            ),
          ),
        ),
      ],
    );
  }

  ///登录按钮点击事件
  void clickLogin() {
    setState(() {
      isLogined = !isLogined;
      loginCard = isLogined
          ? _buildLoginedCard(0, '李春梅',
              company: '广州请上座信息科技有限公司',
              department: '产品部',
              position: '部门主管',
              phone: '13456789066',
              isUpdated: true)
          : _buildNoLoginCard();
    });
    print('isLogined:' + isLogined.toString());
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
              Container(
                margin: const EdgeInsets.only(top: 18),
                child: Row(
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 1, left: 16),
                      padding: EdgeInsets.only(
                          top: 3, bottom: 3, left: 10, right: 10),
                      child: Text(
                        '管理员',
                        style: TextStyle(
                            color: ThemeColors.color583B04, fontSize: 10),
                      ),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                ThemeColors.colorFFEFD4,
                                ThemeColors.colorFFE3B1
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            width: 1,
                            color: ThemeColors.colorD9AE5E,
                          )),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 15),
                child: Offstage(
                  offstage: company.isEmpty,
                  child: Text(
                    company,
                    style: textStyle,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
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
        '我的收藏',
        'assets/images/ic_more.png',
        () => Toast.toast(context, '我的收藏'),
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
        () => Toast.toast(context, '设置'),
      ),
    ];

    //创建条目数量固定的item
    return ListView.separated(
      shrinkWrap: true,
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
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 40,
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/ic_menu.png', width: 16, height: 16),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Text(
                    '我的订单',
                    style:
                        TextStyle(color: ThemeColors.colorEEEEEE, fontSize: 14),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '查看全部订单',
                        style: TextStyle(
                            color: ThemeColors.color9B9B9B, fontSize: 12),
                      ),
                      Image.asset('assets/images/ic_more.png',
                          width: 16, height: 16)
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
