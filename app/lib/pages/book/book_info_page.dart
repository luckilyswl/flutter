import 'dart:convert';

import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/custom_scroll_bean.dart';
import 'package:app/navigator/pop_route.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/dialog/book_application_dialog.dart';
import 'package:app/widget/dialog/book_pay_info_dialog.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:app/model/search_condition_bean.dart' as SC;

/*
 * 预定成功页面
 **/
class BookInfoPage extends StatefulWidget {
  @override
  _BookInfoPageState createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage>
    with SingleTickerProviderStateMixin {
  bool _needConfirm = true;
  bool _isOpen = false;
  List<String> _payList;
  bool isMale = true;
  bool needInvoice = true;

  //包房数据
  List<BookNowModel> modelList;

  //日期数据
  List<CustomScrollBean> dateData = List();

  //时间数据
  List<CustomScrollBean> timeData = List();

  //位数数据
  List<CustomScrollBean> bitData = List();

  //搜索条件
  SC.Data searchConditionData;

  @override
  void initState() {
    _payList = <String>["个人账户", "微信支付", "支付宝"];

    modelList = [
      BookNowModel(
          imgUrl: 'assets/images/ic_default_qrcode.png',
          title: '拿破仑房',
          subtitle: '6-8人',
          hasBg: true),
      BookNowModel(
          imgUrl: 'assets/images/ic_default_qrcode.png',
          title: '路易十三房',
          subtitle: '6-8人',
          hasBg: false),
      BookNowModel(
          imgUrl: 'assets/images/ic_default_qrcode.png',
          title: '亚历山大',
          subtitle: '8-10人',
          hasBg: false),
      BookNowModel(
          imgUrl: 'assets/images/ic_default_qrcode.png',
          title: '拿破仑房',
          subtitle: '6-8人',
          hasBg: false),
    ];

    initData();

    super.initState();
  }

  initData() {
    ///搜索条件
    dio.get(Api.SEARCH_CONDITIONS).then((data) {
      var sources = jsonDecode(data.toString());
      SC.SearchConditionBean bean = SC.SearchConditionBean.fromJson(sources);
      SC.Data dataBean = bean.data;

      if (bean.errorCode == Api.SUCCESS_CODE) {
        setState(() {
          searchConditionData = dataBean;
          dateData = HomeFilterUtils.changeDateDataToScrollData(
              searchConditionData.date);
          timeData = HomeFilterUtils.changeTimeDataToScrollData(
              searchConditionData.time);
          bitData = HomeFilterUtils.changeNumberDataToScrollData(
              searchConditionData.numbers);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _payResult() {
    Navigator.of(context).pushNamed(Page.BOOK_PAY_PAGE);
  }

  _issueInvoice() {
    Navigator.of(context).pushNamed(Page.ISSUE_PAGE);
  }

  _editInfo() {
    Navigator.of(context).push(
      PopRoute(
        child: BookNowPopupWindow(
          modelList: modelList,
          dateData: dateData,
          timeData: timeData,
          bitData: bitData,
          isBook: false,
        ),
        dimissable: true,
      ),
    );
  }

  _bookInfoItemWidget(String title, String subTitle) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 28,
            height: 16,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              border: new Border.all(
                  color: ThemeColors.colorA6A6A6, width: 1.0), // 边色与边宽度
              borderRadius: new BorderRadius.circular((2.0)), // 圆角度
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ThemeColors.colorA6A6A6,
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                subTitle,
                style: TextStyle(
                  color: ThemeColors.color404040,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _bookInfoWidget() {
    return Container(
      height: 146,
      decoration: BoxDecoration(
        gradient: Gradients.loginBgLinearGradient,
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(14, 6, 14, 14),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.circular((8.0)), // 圆角度
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 36,
              padding: EdgeInsets.only(left: 14, right: 14),
              decoration: ShapeDecoration(
                shape: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                '花园酒店名仕阁',
                style: TextStyle(
                  color: ThemeColors.color404040,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _bookInfoItemWidget('时间', '今天 周三(6.12) 18:00'),
                            _bookInfoItemWidget('人数', '4位'),
                            _bookInfoItemWidget('包房', '悠然明阁（6-8人房）'),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 72,
                        height: 24,
                        decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.circular((12.0)), // 圆角度
                        ),
                        child: FlatButton(
                          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Text("修改信息",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ThemeColors.color404040,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              )),
                          onPressed: () {
                            _editInfo();
                          },
                          textTheme: ButtonTextTheme.normal,
                          textColor: ThemeColors.color404040,
                          disabledTextColor: ThemeColors.color404040,
                          color: Colors.transparent,
                          disabledColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          // 按下的背景色
                          splashColor: Colors.transparent,
                          // 水波纹颜色
                          colorBrightness: Brightness.light,
                          // 主���
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              side: BorderSide(
                                  color: ThemeColors.colorA6A6A6,
                                  style: BorderStyle.solid,
                                  width: 1)),
                          clipBehavior: Clip.antiAlias,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _mutileInputWidget(String title, String hint,
      TextEditingController controller, FocusNode focusNode) {
    return Container(
        constraints: BoxConstraints(maxHeight: 80, minHeight: 50),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              width: 14,
              height: 6,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(right: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 70,
                      child: Text(
                        title,
                        style: TextStyle(
                          color: ThemeColors.color404040,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: hint,
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFA6A6A6),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  _inputWidget(String title, String hint, TextEditingController controller,
      FocusNode focusNode) {
    return Container(
        height: 50,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 4, right: 4),
              width: 6,
              height: 6,
              color: ThemeColors.color404040,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(right: 14),
                decoration: ShapeDecoration(
                  shape: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 70,
                      child: Text(
                        title,
                        style: TextStyle(
                          color: ThemeColors.color404040,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 14),
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: hint,
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFA6A6A6),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  _nameWidget(String title, String hint, TextEditingController controller,
      FocusNode focusNode) {
    return Container(
        height: 50,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 4, right: 4),
              width: 6,
              height: 6,
              color: ThemeColors.color404040,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(right: 14),
                decoration: ShapeDecoration(
                  shape: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 70,
                      child: Text(
                        title,
                        style: TextStyle(
                          color: ThemeColors.color404040,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 14),
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: hint,
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFA6A6A6),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 104,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 48,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: isMale
                                  ? ThemeColors.color404040
                                  : Colors.white,
                              borderRadius:
                                  new BorderRadius.circular((12.0)), // 圆角度
                            ),
                            child: FlatButton(
                              padding:
                                  new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Text("先生",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isMale
                                        ? Colors.white
                                        : ThemeColors.colorA6A6A6,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  )),
                              onPressed: () {
                                setState(() {
                                  isMale = true;
                                });
                              },
                              textTheme: ButtonTextTheme.normal,
                              textColor: isMale
                                  ? Colors.white
                                  : ThemeColors.colorA6A6A6,
                              disabledTextColor: ThemeColors.color404040,
                              color: Colors.transparent,
                              disabledColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              // 按下的背景色
                              splashColor: Colors.transparent,
                              // 水波纹颜色
                              colorBrightness: Brightness.light,
                              // 主���
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  side: BorderSide(
                                      color: isMale
                                          ? ThemeColors.color404040
                                          : ThemeColors.colorA6A6A6,
                                      style: BorderStyle.solid,
                                      width: 1)),
                              clipBehavior: Clip.antiAlias,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                            ),
                          ),
                          Container(
                            width: 48,
                            height: 24,
                            decoration: new BoxDecoration(
                              color: isMale
                                  ? Colors.white
                                  : ThemeColors.color404040,
                              borderRadius:
                                  new BorderRadius.circular((12.0)), // 圆角度
                            ),
                            child: FlatButton(
                              padding:
                                  new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Text("女士",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isMale
                                        ? ThemeColors.colorA6A6A6
                                        : Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  )),
                              onPressed: () {
                                setState(() {
                                  isMale = false;
                                });
                              },
                              textTheme: ButtonTextTheme.normal,
                              textColor: isMale
                                  ? ThemeColors.colorA6A6A6
                                  : Colors.white,
                              disabledTextColor: ThemeColors.color404040,
                              color: Colors.transparent,
                              disabledColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              // 按下的背景色
                              splashColor: Colors.transparent,
                              // 水波纹颜色
                              colorBrightness: Brightness.light,
                              // 主题
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  side: BorderSide(
                                      color: isMale
                                          ? ThemeColors.colorA6A6A6
                                          : ThemeColors.color404040,
                                      style: BorderStyle.solid,
                                      width: 1)),
                              clipBehavior: Clip.antiAlias,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  _getInvoiceWidget() {
    if (needInvoice) {
      return GestureDetector(
        onTap: () {
          _issueInvoice();
        },
        child: Container(
          height: 60,
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.only(left: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 70,
                  padding: EdgeInsets.only(top: 13),
                  child: Text(
                    '发票抬头',
                    style: TextStyle(
                      color: ThemeColors.color404040,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(top: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          '广州请上座信息科技有限公司',
                          style: TextStyle(
                            color: ThemeColors.color404040,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          '税号 9144010MA5AKYNN11',
                          style: TextStyle(
                            color: ThemeColors.colorA6A6A6,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 20,
                    height: 20,
                    color: ThemeColors.color404040,
                    margin: EdgeInsets.only(right: 14),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        height: 44,
        padding: EdgeInsets.only(left: 14, right: 14),
        child: Row(
          children: <Widget>[
            Text('发票',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ThemeColors.color404040,
                )),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  color: ThemeColors.color404040,
                  width: 51,
                  height: 28,
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  _enterpriseWidget() {
    return Container(
      color: Colors.white,
      height: 44,
      padding: EdgeInsets.only(left: 14, right: 14),
      child: Row(
        children: <Widget>[
          Text('企业招待',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ThemeColors.color404040,
              )),
          Container(
            margin: EdgeInsets.only(left: 14),
            width: 42,
            height: 16,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular((2.0)), // 圆角度
              color: ThemeColors.color404040,
            ),
            child: Text(
              '免订金',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  _showApplicationDialog();
                },
                child: Container(
                  color: ThemeColors.color404040,
                  width: 51,
                  height: 28,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _showApplicationDialog() {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BookApplicationInfoDialog(
            onLeftCloseEvent: () {
              Navigator.pop(context);
            },
            onRightCloseEvent: () {
              Navigator.pop(context);
              Toast.toast(context, '敬请期待');
            },
          );
        });
  }

  _service() {}

  _subscriptionWidget() {
    return Container(
      color: Colors.white,
      height: 60,
      padding: EdgeInsets.only(left: 14),
      child: Row(
        children: <Widget>[
          Text('包房订金',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ThemeColors.color404040,
              )),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.only(right: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "￥ ",
                        style: TextStyle(
                            color: ThemeColors.color404040,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                        children: [
                          TextSpan(
                            text: "100",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: ThemeColors.color404040,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular((2.0)), // 圆角度
                        color: ThemeColors.colorFF97A3.withAlpha(51),
                      ),
                      child: Text(
                        '消费/取消后原路退回',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ThemeColors.colorD0021B,
                            fontSize: 10,
                            fontWeight: FontWeight.normal),
                      ),
                      padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 68,
            margin: EdgeInsets.only(top: 11, bottom: 11),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: Border(
                left: BorderSide(
                    color: Color(0xFFDEDEDE), style: BorderStyle.solid),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    color: ThemeColors.color404040,
                    width: 21,
                    height: 21,
                  ),
                  onTap: () {
                    showDialog<Null>(
                        context: context, //BuildContext对象
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return BookPayInfoDialog(
                            onCloseEvent: () {
                              Navigator.pop(context);
                            },
                          );
                        });
                  },
                ),
                Text(
                  '订金说明',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ThemeColors.color404040,
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _dividerWidget() {
    return Container(
      height: 10,
    );
  }

  List<Widget> _getListWidgets() {
    return <Widget>[
      _bookInfoWidget(),
      _subscriptionWidget(),
      _dividerWidget(),
      _nameWidget('预订人', '请填写到场用餐人姓氏', null, null),
      _inputWidget('联系手机', '用于商家沟通联系', null, null),
      _mutileInputWidget('备注', '如有其它要求，可在此留言', null, null),
      _dividerWidget(),
      _getInvoiceWidget(),
      _dividerWidget(),
      _enterpriseWidget()
    ];
  }

  _getListContent() {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: _getListWidgets().length,
      itemBuilder: (BuildContext context, int index) {
        return _getListWidgets()[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          child: AppBar(
            title: Text('预定信息'),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  _service();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 14),
                  alignment: Alignment.centerRight,
                  child: Text(
                    '客服',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            gradient: Gradients.loginBgLinearGradient,
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 45),
      ),
      body: Container(
          color: ThemeColors.colorF2F2F2,
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _getListContent(),
                ),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 14, right: 14),
                          child: Row(
                            children: <Widget>[
                              Text("需支付",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: ThemeColors.color404040,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  )),
                              RichText(
                                textAlign: TextAlign.center,
                                text: _isOpen
                                    ? TextSpan(
                                        text: "￥ ",
                                        style: TextStyle(
                                            color: ThemeColors.colorD0021B,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal),
                                        children: [
                                          TextSpan(
                                            text: "0",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: ThemeColors.colorD0021B,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "￥100",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                              color: ThemeColors.colorA6A6A6,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      )
                                    : TextSpan(
                                        text: "￥ ",
                                        style: TextStyle(
                                            color: ThemeColors.colorD0021B,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal),
                                        children: [
                                          TextSpan(
                                            text: "100",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: ThemeColors.colorD0021B,
                                            ),
                                          )
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _payResult();
                        },
                        child: Container(
                          width: 145,
                          color: ThemeColors.color404040, // 圆角度
                          alignment: Alignment.center,
                          child: Text(
                            "提交订单",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: ThemeColors.colorF2F2F2,
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          )),
    );
  }
}
