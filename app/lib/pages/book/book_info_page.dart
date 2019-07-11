import 'dart:convert';

import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/book/book_info_bean.dart';
import 'package:app/model/business_detail_bean.dart';
import 'package:app/model/custom_scroll_bean.dart';
import 'package:app/model/invoice/invoice_list_bean.dart';
import 'package:app/model/room_info_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/navigator/pop_route.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/dialog/book_application_dialog.dart';
import 'package:app/widget/dialog/book_pay_info_dialog.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:app/widget/toast.dart' as T;
import 'package:app/model/room_info_bean.dart' as Room;

/*
 * 预定成功页面
 **/
class BookInfoPage extends StatefulWidget {
  @override
  _BookInfoPageState createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  bool isMale = true;
  bool _buttonEnabled = false;

  int goodsId; //请求数据用
  String bookTime; //请求数据用

  BookInfo bookInfo; //预定信息索引

  InvoiceModel invoiceModel; //发票对象
  String email; //邮箱
  String showTime; //时间显示
  String showGoodsInfo; //包房显示
  String showNumber; //人数显示

  //包房数据
  List<BookNowModel> modelList = List();
  //日期数据
  List<CustomScrollBean> dateList = List();
  //时间数据
  List<CustomScrollBean> timeList = List();
  //人数数据
  List<CustomScrollBean> numberList = List();

  /// 包房详情
  List<RoomModel> roomModelList = List();
  //时间和人数
  String timeAndNum = '请点击选择';

  int _dateIndex = -1; //日期索引
  int _timeIndex = -1; //时间索引  //选中的时间
  int _numberIndex = -1; //人数索引
  int _roomIndex = -1; //房间索引
  int _businessId = 0; //商家Id

  int _tempDateIndex = -1; //临时索引
  int _tempTimeIndex = -1; //临时索引
  int _tempNumberIndex = -1; //临时索引
  int _tempRoomIndex = -1; //临时索引

  BookNowPopupWindow popupWindow;

  //填写信息
  TextEditingController _nameEditController;
  final FocusNode _nameFocusNode = FocusNode();
  TextEditingController _phoneEditController;
  final FocusNode _phoneFocusNode = FocusNode();
  TextEditingController _remarkEditController;
  final FocusNode _remarkFocusNode = FocusNode();

  //预订信息
  BookInfoData infoData;

  @override
  void initState() {
    _nameEditController = TextEditingController();
    _nameEditController.addListener(() {
      _checkButtonState();
    });

    _phoneEditController = TextEditingController();
    _phoneEditController.addListener(() {
      _checkButtonState();
    });

    _remarkEditController = TextEditingController();
    _remarkEditController.addListener(() {
      if (_remarkEditController.text.length > 200) {
        _remarkEditController.text =
            _remarkEditController.text.substring(0, 199);
      }
    });

    super.initState();
  }

  _checkButtonState() {
    if (_nameEditController.text.length > 0 &&
        _phoneEditController.text.length == 11) {
      setState(() {
        _buttonEnabled = true;
      });
    } else {
      setState(() {
        _buttonEnabled = false;
      });
    }
  }

  initData() {
    //预定信息
    dio.get(Api.BOOK_INFO, queryParameters: {
      "goods_id": goodsId.toString(),
      "book_time": bookTime,
      "num": bookInfo.numbers[_numberIndex].toString()
    }).then((data) {
      var sources = jsonDecode(data.toString());
      BookInfoBean bean = BookInfoBean.fromJson(sources);
      BookInfoData dataBean = bean.data;
      if (bean.errorCode == Api.SUCCESS_CODE) {
        setState(() {
          infoData = dataBean;
          if (infoData.enterprisePay == 1) {
            _isOpen = true;
          }
          goodsId = infoData.goodsInfo.goodsId;
          bookTime = infoData.goodsInfo.bookTime;
          for (Room.Rooms room in bookInfo.rooms) {
            if (room.goodsInfo.goodsId == goodsId) {
              showGoodsInfo = '${room.roomName}（${room.numberDesc}）';
            }
          }
          for (Date dateItem in bookInfo.date) {
            if (dateItem.timestamp == bookInfo.date[_dateIndex].timestamp) {
              // 今天 周三(6.12) 18:00
              showTime =
                  '${dateItem.title} ${dateItem.week} ${bookInfo.time[_timeIndex]}';
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _payResult() {
    Map<String, dynamic> queryParameters = {};
    queryParameters["goods_id"] = infoData.goodsInfo.goodsId.toString();
    queryParameters["reserve_mobile"] = _phoneEditController.text;
    queryParameters["reserve_name"] = _nameEditController.text;
    queryParameters["book_time"] = infoData.goodsInfo.bookTime;
    queryParameters["enterprise_pay"] = _isOpen ? "1" : "0";
    queryParameters["gender"] = isMale ? "1" : "2";
    queryParameters["num"] = infoData.goodsInfo.num.toString();

    if (invoiceModel != null) {
      queryParameters["use_invoice"] = "1";
      queryParameters["tax_number"] = invoiceModel.taxNumber;
      queryParameters["tax_title"] = invoiceModel.taxTitle;
      queryParameters["tax_type"] = invoiceModel.invoiceType.toString();
      queryParameters["tax_stuff_type"] = "1";
      queryParameters["tax_email"] = email;
    } else {
      queryParameters["use_invoice"] = "0";
    }
    dio.get(Api.BOOK_ROOM, queryParameters: queryParameters).then((data) {
      var sources = jsonDecode(data.data);
      if (sources['error_code'] == Api.SUCCESS_CODE) {
        if (sources['data']['pay_code'] != null &&
            sources['data']['pay_code'] == '5100') {
          Navigator.of(context).popAndPushNamed(Page.BOOK_RESULT_PAGE,
              arguments: {"orderId": sources['data']['order_id']});
        } else {
          Navigator.of(context).popAndPushNamed(Page.BOOK_PAY_PAGE,
              arguments: {"orderId": sources['data']['order_id']});
        }
      } else {
        T.Toast.toast(context, sources['msg']);
      }
    });
  }

  _issueInvoice() async {
    if (invoiceModel != null) {
      Map<String, dynamic> arguments = {"invoiceModel": invoiceModel};
      if (email != null && email.length > 0) {
        arguments["email"] = email;
      }
      final result = await Navigator.of(context)
          .pushNamed(Page.ISSUE_PAGE, arguments: arguments);
      if (result != null) {
        Map<String, dynamic> returnArguments = result;
        InvoiceModel returnInvoiceModel = returnArguments["invoiceModel"];
        String returnEmail = returnArguments["email"];
        setState(() {
          invoiceModel = returnInvoiceModel;
          email = returnEmail;
        });
      }
    } else {
      final result = await Navigator.of(context).pushNamed(Page.ISSUE_PAGE);
      if (result != null) {
        Map<String, dynamic> returnArguments = result;
        InvoiceModel returnInvoiceModel = returnArguments["invoiceModel"];
        String returnEmail = returnArguments["email"];
        setState(() {
          invoiceModel = returnInvoiceModel;
          email = returnEmail;
        });
      }
    }
  }

  /// 获取包房信息
  _getAvailableRoomList(int dateIndex, int timeIndex, int numberIndex) {
    if (dateIndex != -1 && dateIndex != -1 && dateIndex != -1) {
      dio.get(Api.ROOM_URL, queryParameters: {
        "business_id": _businessId.toString(),
        "book_date": bookInfo.date[dateIndex].date +
            " " +
            bookInfo.time[timeIndex] +
            ":00",
        "num": bookInfo.numbers[numberIndex].toString()
      }).then((data) {
        setState(() {
          var sources = jsonDecode(data.data);
          RoomInfo info = RoomInfo.fromJson(sources);
          bookInfo.rooms = info.data.rooms;
          modelList.clear();
          if (_roomIndex != -1 && bookInfo.rooms[_roomIndex].goodsInfo.available == 0) {
            _roomIndex = -1;
          }
          bookInfo.rooms.forEach((f) {
            BookNowModel model = new BookNowModel(
                imgUrl: f.defaultImg,
                title: f.roomName,
                subtitle: f.numberDesc,
                clickable: f.goodsInfo.available == 1,
                tips: f.goodsInfo.tips,
                desc: f.goodsInfo.desc,
                hasBg: bookInfo.rooms.indexOf(f) == _roomIndex);
            modelList.add(model);
          });
          popupWindow.state.updateAll();
          _setRoomInfo();
        });
      });
    }
  }

  _editInfo() {
    if (popupWindow == null) {
      popupWindow = BookNowPopupWindow(
          modelList: modelList,
          dateData: dateList,
          timeData: timeList,
          bitData: numberList,
          roomModel: roomModelList,
          timeAndNum: timeAndNum,
          isBook: false,
          timeSelectorCallback: (results) {
            _tempDateIndex = results[0];
            _tempTimeIndex = results[1];
            _tempNumberIndex = results[2];
            timeAndNum = '${dateList[_tempDateIndex].title} '
                '${dateList[_tempDateIndex].subTitle} '
                '${timeList[_tempTimeIndex].title}, '
                '${numberList[_tempNumberIndex].title}';

            /// 获取包房信息
            _getAvailableRoomList(
                _tempDateIndex, _tempTimeIndex, _tempNumberIndex);
          },
          roomIndexCallback: (index) {
            print('$index');
            setState(() {
              _tempRoomIndex = index;
              modelList.forEach((f) => f.hasBg = false);
              if (-1 != index) {
                modelList[index].hasBg = true;
              }
            });
          },
          dimissCallBack: () {},
          sureCallBack: () {
            if (_tempDateIndex != -1 &&
                _tempTimeIndex != -1 &&
                _tempNumberIndex != -1 &&
                _tempRoomIndex != -1) {
              _dateIndex = _tempDateIndex;
              _timeIndex = _tempTimeIndex;
              _numberIndex = _tempNumberIndex;
            }
            if (_tempRoomIndex != -1) {
              _roomIndex = _tempRoomIndex;
            }
            debugPrint(
                  '${_dateIndex.toString()}${_timeIndex.toString()}${_numberIndex.toString()}${_roomIndex.toString()}');
              goodsId = _roomIndex != -1
                  ? bookInfo.rooms[_roomIndex].goodsInfo.goodsId
                  : -1;
              bookTime = bookInfo.date[_dateIndex].date +
                  " " +
                  bookInfo.time[_timeIndex] +
                  ":00";
              initData();
          },
        );
    }
    Navigator.of(context).push(
      PopRoute(
        child: popupWindow,
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
                infoData.goodsInfo.shopName,
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
                            _bookInfoItemWidget('时间', showTime),
                            _bookInfoItemWidget(
                                '人数', '${infoData.goodsInfo.num}位'),
                            _bookInfoItemWidget('包房', '$showGoodsInfo'),
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
    if (invoiceModel != null) {
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
                          invoiceModel.taxTitle,
                          style: TextStyle(
                            color: ThemeColors.color404040,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          invoiceModel.invoiceType == 0
                              ? '个人'
                              : '税号 ${invoiceModel.taxNumber}',
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
                  width: 51,
                  height: 28,
                  child: CupertinoSwitch(
                    activeColor: ThemeColors.colorF2C785,
                    value: false,
                    onChanged: (bool value) {
                      setState(() {
                        _issueInvoice();
                      });
                    },
                  ),
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
              child: Container(
                width: 51,
                height: 28,
                child: CupertinoSwitch(
                  activeColor: ThemeColors.colorF2C785,
                  value: _isOpen,
                  onChanged: (bool value) {
                    setState(() {
                      if (infoData.enterprisePay == 3) {
                        _showApplicationDialog();
                      } else if (infoData.enterprisePay == 1) {
                        setState(() {
                          _isOpen = value;
                        });
                      }
                    });
                  },
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
              T.Toast.toast(context, '敬请期待');
            },
          );
        });
  }

  _service() {
    Navigator.of(context).pushNamed(Page.CUSTOMER_SERVICE_PAGE);
  }

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
                            text: infoData.goodsInfo.price.toString(),
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
                        infoData.refundTips,
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
                    String content = '';
                    for (var i = 0; i < infoData.bookNotice.length; i++) {
                      String subString = infoData.bookNotice[i];
                      if (i == infoData.bookNotice.length - 1) {
                        content = '$content${i + 1}. $subString';
                      } else {
                        content = '$content${i + 1}. $subString\n';
                      }
                    }
                    showDialog<Null>(
                        context: context, //BuildContext对象
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return BookPayInfoDialog(
                            onCloseEvent: () {
                              Navigator.pop(context);
                            },
                            content: content,
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
    List<Widget> listWidgets = <Widget>[
      _bookInfoWidget(),
      _subscriptionWidget(),
      _dividerWidget(),
      _nameWidget('预订人', '请填写到场用餐人姓氏', _nameEditController, _nameFocusNode),
      _inputWidget('联系手机', '用于商家沟通联系', _phoneEditController, _phoneFocusNode),
      _mutileInputWidget(
          '备注', '如有其它要求，可在此留言', _remarkEditController, _remarkFocusNode),
      _dividerWidget(),
      _getInvoiceWidget(),
      _dividerWidget(),
    ];
    if (infoData.enterprisePay == 1 || infoData.enterprisePay == 3) {
      listWidgets.add(_enterpriseWidget());
    }
    return listWidgets;
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

  /// 设置包房详情信息
  _setRoomInfo() {
    roomModelList.clear();
    bookInfo.rooms.forEach((f) {
      RoomModel bean = RoomModel();
      bean.devices = f.devices;
      bean.roomName = f.roomName;
      bean.price = f.price.toString();
      bean.numPeople = f.numberDesc;
      bean.recommendPrice = f.shopMoney.toString();
      bean.roomInfo = f.detail;
      bean.isClickable = f.goodsInfo.available == 1;

      /// 图片
      List<ImgModel> list = new List();
      if (f.imgList.length == 0) {
        ImgModel imgModel = new ImgModel();
        imgModel.imgUrl = f.defaultImg;
        imgModel.id = 0;
        list.add(imgModel);
      } else {
        for (int i = 0; i < f.imgList.length; i++) {
          ImgModel imgModel = new ImgModel();
          imgModel.imgUrl = f.imgList[i].src;
          imgModel.id = i;
          list.add(imgModel);
        }
      }
      bean.imgUrls = list;
      roomModelList.add(bean);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    /*获取传递过来的参数*/
    Map<String, dynamic> bookFliterInfo =
        ModalRoute.of(context).settings.arguments;
    if (infoData == null && bookFliterInfo != null) {
      _dateIndex = bookFliterInfo["dateIndex"];
      _timeIndex = bookFliterInfo["timeIndex"];
      _numberIndex = bookFliterInfo["numberIndex"];
      _roomIndex = bookFliterInfo["roomIndex"];
      bookInfo = bookFliterInfo["bookInfo"];
      _businessId = bookFliterInfo["businessId"];

      goodsId = bookInfo.rooms[_roomIndex].goodsInfo.goodsId;
      debugPrint(goodsId.toString());
      bookTime = bookInfo.date[_dateIndex].date +
          " " +
          bookInfo.time[_timeIndex] +
          ":00";

      dateList.clear();
      bookInfo.date.forEach((f) {
        CustomScrollBean bean = new CustomScrollBean();
        bean.title = f.title;
        bean.subTitle = f.week;
        if (bookInfo.date.indexOf(f) == _dateIndex) {
          bean.hasBg = true;
        } else {
          bean.hasBg = false;
        }
        dateList.add(bean);
      });

      timeList.clear();
      bookInfo.time.forEach((f) {
        CustomScrollBean bean = new CustomScrollBean();
        bean.title = f;
        if (bookInfo.time.indexOf(f) == _timeIndex) {
          bean.hasBg = true;
        } else {
          bean.hasBg = false;
        }
        timeList.add(bean);
      });

      List<CustomScrollBean> scrollBean = <CustomScrollBean>[];
      for (var i = 0; i < bookInfo.numbers.length; i++) {
        scrollBean.add(CustomScrollBean(
            title: bookInfo.numbers[i] == 0 ? '未确定' : '${bookInfo.numbers[i]}位',
            hasBg: i == _numberIndex));
      }
      numberList = scrollBean;

      modelList.clear();
      bookInfo.rooms.forEach((f) {
        BookNowModel model = new BookNowModel(
            imgUrl: f.defaultImg,
            title: f.roomName,
            subtitle: f.numberDesc,
            clickable: f.goodsInfo.available == 1,
            tips: f.goodsInfo.tips,
            desc: f.goodsInfo.desc,
            hasBg: bookInfo.rooms.indexOf(f) == _roomIndex);
        modelList.add(model);
      });
      _setRoomInfo();

      timeAndNum = '${dateList[_dateIndex].title} '
          '${dateList[_dateIndex].subTitle} '
          '${timeList[_timeIndex].title}, '
          '${numberList[_numberIndex].title}';

      initData();
    }
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
                  child: infoData != null ? _getListContent() : Container(),
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
                                            text: infoData != null
                                                ? "￥${infoData.goodsInfo.price}"
                                                : "￥0",
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
                                            text: infoData != null
                                                ? "${infoData.goodsInfo.price}"
                                                : "0",
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
                          if (_buttonEnabled) {
                            _payResult();
                          }
                        },
                        child: Container(
                          width: 145,
                          color: _buttonEnabled
                              ? ThemeColors.color404040
                              : ThemeColors.colorDEDEDE,
                          alignment: Alignment.center,
                          child: Text(
                            "提交订单",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _buttonEnabled
                                  ? Colors.white
                                  : ThemeColors.colorA6A6A6,
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
