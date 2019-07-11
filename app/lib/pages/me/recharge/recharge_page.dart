import 'package:app/api/net_index.dart';
import 'package:app/http.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/pages/pages_index.dart';
import 'package:app/res/gradients.dart';
import 'package:app/res/theme_colors.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/dialog/recharge_protocol_dialog.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app/model/recharge/recharge_info_bean.dart' as Recharge;

class RechagrePage extends StatefulWidget {
  final int orderId;

  RechagrePage({@required this.orderId});
  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechagrePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  String _protocol;
  String _account;
  String _info;
  String _img;
  List<Recharge.Options> _optionList = new List();
  double _totalMoney = 0.0;
  int _orderId;

  @override
  void initState() {
    _orderId = widget.orderId;
    initData();
    super.initState();
  }

  initData() {
    if (widget.orderId != 0) {
      dio.get(Api.RECHARGE_INFO,
          queryParameters: {"order_id": widget.orderId}).then((data) {
        setData(data);
      });
    } else {
      dio.get(Api.RECHARGE_INFO).then((data) {
        setData(data);
      });
    }
  }

  setData(Response data) {
    var sources = jsonDecode(data.data);
    Recharge.RechargeInfoBean rechargeInfoBean =
        Recharge.RechargeInfoBean.fromJson(sources);
    Recharge.Data info = rechargeInfoBean.data;
    _protocol = info.agreement;
    _info = info.info;
    _account = info.account;
    _optionList = info.options;
    _img = info.businessImg;
    for (int i = 0; i < _optionList.length; i++) {
      if (_optionList[i].rechargeMoney == "1000") {
        _currentIndex = i;
        _calculateMoney();
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActionBar.buildActionBar(
          context,
          AppBar(
            actions: <Widget>[
              new Container(
                  child: new Row(
                children: <Widget>[
                  new GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return new RechargeProtocolDialog(
                              title: '请上座充值协议',
                              message: _protocol != null ? _protocol : '',
                              negativeText: '知道了',
                              onCloseEvent: () {
                                Navigator.pop(context);
                              },
                            );
                          });
                    },
                    child: new Text(
                      '充值协议',
                      style: new TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(right: 14, left: 4),
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: ThemeColors.colorD8D8D8),
                  )
                ],
              ))
            ],
            elevation: 0,
            title: Text('充值', style: new TextStyle(fontSize: 17)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          )),
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return Stack(
      children: <Widget>[
        _balanceWidget(),
        _scrollWidget(),
        _bottomWidget(),
        widget.orderId != 0 ? _floatButton() : SizedBox(),
      ],
    );
  }

  Widget _floatButton() {
    return Positioned(
        right: 14,
        bottom: 74,
        child: new GestureDetector(
          onTap: () {
            Toast.toast(context, '返回买单');
          },
          child: new Container(
            alignment: Alignment.center,
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              gradient: Gradients.returnBuyGradient,
            ),
            child: new Text(
              '返回\n买单',
              style: new TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  Widget _scrollWidget() {
    return Positioned(
      top: 44,
      bottom: 0,
      child: new SingleChildScrollView(
        child: new Container(
          width: ScreenUtil.getScreenW(context),
          child: new Column(
            children: <Widget>[
              _rechargeTips(),
              _rechargeMoney(),
              _gridWidget(),
              new Container(height: 10, color: ThemeColors.colorEDEDED),
              _img != null ? _moreTitle() : new Container(),
              _img != null
                  ? new Container(
                      margin: EdgeInsets.only(
                          top: 12, left: 14, right: 14, bottom: 70),
                      child: Image.network(
                        _img,
                      ),
                    )
                  : new Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _moreTitle() {
    return new Container(
      margin: EdgeInsets.only(top: 20),
      child: new Row(
        children: <Widget>[
          new Container(
            width: 2,
            height: 14,
            color: ThemeColors.color4A4A4A,
          ),
          new Container(
            margin: EdgeInsets.only(left: 12),
            width: 120,
            child: new Text(
              '部分充值可用餐厅',
              style:
                  new TextStyle(fontSize: 14, color: ThemeColors.color4A4A4A),
            ),
          ),
          Expanded(
              child: new GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(Page.SEARCH_RESULT_PAGE);
            },
            child: new Container(
                margin: EdgeInsets.only(right: 16),
                alignment: Alignment.centerRight,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '更多',
                      style: new TextStyle(
                          fontSize: 12, color: ThemeColors.color9B9B9B),
                    ),
                    Image.asset('assets/images/ic_more_g.png',
                        width: 16, height: 16),
                  ],
                )),
          ))
        ],
      ),
    );
  }

  Widget _gridWidget() {
    return new Container(
      margin: EdgeInsets.only(top: 14, left: 14, right: 14, bottom: 18),
      child: GridView.count(
        physics: new NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        primary: false,
        // 横向 Item 的个数
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 2.0,
        children:
            _buildGridList(_optionList.length != 0 ? _optionList.length : 0),
      ),
    );
  }

  List<Widget> _buildGridList(int length) {
    List<Widget> widgetList = new List();
    for (int i = 0; i < length; i++) {
      widgetList.add(new GestureDetector(
        onTap: () {
          _clickItem(i);
        },
        child: new Stack(
          children: <Widget>[
            new Container(
              width: 109,
              height: 55,
              decoration: _currentIndex == i
                  ? BoxDecoration(
                      color: Colors.white,
                      gradient: Gradients.blueLinearGradient,
                      borderRadius: BorderRadius.circular(4),
                      border:
                          Border.all(color: ThemeColors.color9B9B9B, width: 1),
                    )
                  : BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border:
                          Border.all(color: ThemeColors.color9B9B9B, width: 1),
                    ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        text: '¥',
                        style: new TextStyle(
                          fontSize: 12,
                          color: _currentIndex == i
                              ? Color(0xffFFEFD4)
                              : ThemeColors.color4A4A4A,
                        ),
                        children: [
                          TextSpan(
                              text: _optionList.length != 0
                                  ? _optionList[i].rechargeMoney
                                  : '0',
                              style: new TextStyle(
                                  fontSize: 18,
                                  color: _currentIndex == i
                                      ? Color(0xffFFEFD4)
                                      : ThemeColors.color4A4A4A))
                        ]),
                  ),
                  Text(
                    '返赠${_optionList.length != 0 ? _optionList[i].givingMoney : '0'}',
                    style: new TextStyle(
                        fontSize: 9,
                        color: _currentIndex == i
                            ? Colors.white
                            : ThemeColors.colorB8B5BA),
                  )
                ],
              ),
            ),
            _optionList.length != 0 && _optionList[i].recommend == 1
                ? Positioned(
                    left: 0,
                    top: 0,
                    child: new Container(
                      alignment: Alignment.center,
                      width: 43,
                      height: 13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4)),
                        color: Color(0xffFFEBD3),
                      ),
                      child: Text(
                        '本单推荐',
                        style: new TextStyle(
                            fontSize: 8,
                            color: Color(0xffD0021B),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                : Stack(),
          ],
        ),
      ));
    }
    return widgetList;
  }

  Widget _rechargeMoney() {
    return new Container(
        child: new Column(
      children: <Widget>[
        new Container(
          height: 65,
          margin: EdgeInsets.only(left: 14, right: 14, top: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color(0x1affd4a3),
            border: Border.all(color: Color(0xFFCFAC85), width: 1),
          ),
          child: new Row(
            children: <Widget>[
              new Container(
                  margin: EdgeInsets.only(left: 50),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _optionList.length != 0
                            ? _optionList[_currentIndex].rechargeMoney
                            : '0',
                        style: new TextStyle(
                            fontSize: 19, color: Color(0xFF8B572A)),
                      ),
                      Text(
                        '充值',
                        style: new TextStyle(
                          fontSize: 10,
                          color: Color(0xffE6BF93),
                        ),
                      ),
                    ],
                  )),
              new Padding(
                padding: EdgeInsets.only(left: 28, bottom: 10),
                child: Text(
                  '+',
                  style: new TextStyle(fontSize: 14, color: Color(0xff8B572A)),
                ),
              ),
              new Container(
                  margin: EdgeInsets.only(left: 28),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _optionList.length != 0
                            ? _optionList[_currentIndex].givingMoney
                            : '0',
                        style: new TextStyle(
                            fontSize: 19, color: Color(0xFF8B572A)),
                      ),
                      Text(
                        '反赠',
                        style: new TextStyle(
                          fontSize: 10,
                          color: Color(0xffE6BF93),
                        ),
                      ),
                    ],
                  )),
              new Padding(
                padding: EdgeInsets.only(left: 28, bottom: 10),
                child: Text(
                  '=',
                  style: new TextStyle(fontSize: 14, color: Color(0xff8B572A)),
                ),
              ),
              new Container(
                  margin: EdgeInsets.only(left: 28),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _totalMoney != null ? _totalMoney.toString() : '0',
                        style: new TextStyle(
                            fontSize: 19, color: Color(0xFF8B572A)),
                      ),
                      Text(
                        '到账',
                        style: new TextStyle(
                          fontSize: 10,
                          color: Color(0xffE6BF93),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        )
      ],
    ));
  }

  /// 充值说明
  Widget _rechargeTips() {
    return new Container(
      height: 102,
      color: ThemeColors.colorF1F1F1,
      alignment: Alignment.topLeft,
      child: new Padding(
        padding: EdgeInsets.only(left: 14, top: 14),
        child: Text(
          '充值说明：\n${_info != null ? _info : ''}',
          style: new TextStyle(fontSize: 12, color: ThemeColors.colorA6A6A6),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _balanceWidget() {
    return new Column(
      children: <Widget>[
        new Container(
          height: 44,
          decoration: BoxDecoration(gradient: Gradients.blueLinearGradient),
          child: new Row(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(left: 14),
                child: new Text(
                  '当前余额',
                  style: new TextStyle(
                      fontSize: 12, color: ThemeColors.colorA6A6A6),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 8),
                child: new Text(
                  '¥${_account != null ? _account : '0'}',
                  style: new TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bottomWidget() {
    return Positioned(
      bottom: 0,
      child: new Container(
        height: 50,
        width: ScreenUtil.getScreenW(context),
        child: new Row(
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(Page.CUSTOMER_SERVICE_PAGE);
              },
              child: new Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(
                            color: ThemeColors.colorDEDEDE, width: 1)),
                  ),
                  alignment: Alignment.center,
                  height: 50,
                  width: 60,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/ic_phone_b.png',
                        width: 24,
                        height: 24,
                      ),
                      Text(
                        '客服',
                        style: new TextStyle(
                            fontSize: 9, color: ThemeColors.color4A4A4A),
                      )
                    ],
                  )),
            ),
            Expanded(
                child: new GestureDetector(
              onTap: () {
                _recharge();
              },
              child: new Container(
                decoration: BoxDecoration(
                  gradient: Gradients.blueLinearGradient,
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '确认充值',
                      style: new TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '(充${_optionList.length != 0 ? _optionList[_currentIndex].rechargeMoney : '0'}'
                      '送${_optionList.length != 0 ? _optionList[_currentIndex].givingMoney : '0'})',
                      style: new TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  /// grid 点击事件
  _clickItem(int index) {
    setState(() {
      _currentIndex = index;
      _calculateMoney();
    });
  }

  /// 计算总金额
  _calculateMoney() {
    _totalMoney = double.parse(_optionList[_currentIndex].rechargeMoney) +
        double.parse(_optionList[_currentIndex].givingMoney);
  }

  /// 确认充值
  _recharge() {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) {
    //       return InvitationPage(
    //         orderId: 25014,
    //       );
    //     },
    //   ),
    // );
    debugPrint('_recharge');
    Navigator.of(context).pushNamed(Page.RECHARGE_PAY_PAGE, arguments: {
      'fromPay': _orderId != 0,
      'optionId': _optionList[_currentIndex].optionId
    });
  }

  @override
  bool get wantKeepAlive => true;
}
