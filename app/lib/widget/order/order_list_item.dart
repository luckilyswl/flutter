import 'package:app/model/enum_define.dart';
import 'package:app/model/order/order_list_bean.dart';
import 'package:app/res/res_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class OrderListItemWidget extends StatelessWidget {
  final Function onTapEvent;
  final OrderListItem orderListItem;
  const OrderListItemWidget({Key key, @required this.orderListItem, @required this.onTapEvent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14),
      height: 181,
      child: GestureDetector(
        onTap: onTapEvent,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))), //设置圆角
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              Container(
                height: 42,
                padding: EdgeInsets.only(left: 14, right: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    orderListItem.enterprisePay == true
                        ? Container(
                            width: 48,
                            height: 20,
                            margin: EdgeInsets.only(right: 10),
                            color: ThemeColors.colorA6A6A6,
                            alignment: Alignment.center,
                            child: Text(
                              '企业招待',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          )
                        : SizedBox(width: 0),
                    Expanded(
                      child: Text(
                        orderListItem.businessName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: ThemeColors.color404040,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        orderListItem.orderStatusText,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: ThemeColors.colorD0021B,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: ThemeColors.colorDEDEDE,
              ),
              Container(
                margin: EdgeInsets.only(top: 14),
                padding: EdgeInsets.only(left: 14, right: 14),
                height: 72,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 14),
                      width: 110,
                      height: 72,
                      color: ThemeColors.color404040,
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _roomInfoWidget('时间', '${orderListItem.bookTime}'),
                        _roomInfoWidget('人数', '${orderListItem.peopleNum}位'),
                        _roomInfoWidget('包房', '${orderListItem.roomInfo}'),
                        _roomInfoWidget('已付', '￥${orderListItem.paidAmount}'),
                      ],
                    ))
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 14, right: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _orderButtonList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _roomInfoWidget(String title, String subTitle) {
    return Row(
      children: <Widget>[
        Container(
          height: 12,
          constraints: BoxConstraints(minWidth: 26),
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            color: ThemeColors.colorF2F2F2,
            borderRadius: new BorderRadius.circular((6.0)), // 圆角度
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ThemeColors.colorA6A6A6,
              fontSize: 8,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 6),
            child: Text(
              subTitle,
              style: TextStyle(
                color: ThemeColors.color404040,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        )
      ],
    );
  }

  _seeDetail() {}

  _cancelOrder() {}

  _payBook() {}

  _bookAgain() {}

  _inviteInfo() {}

  _payBill() {}

  List<Widget> _orderButtonList() {
    switch (orderListItem.orderStatus) {
      case OrderStatus.ORDER_STATUS_PAY_WAITED:
        {
          //未支付
          return <Widget>[
            _lightButton('查看详情', _seeDetail, true),
            _lightButton('取消订单', _cancelOrder, true),
            _darkButton('付订金', _payBook, false),
          ];
        }
        break;
      case OrderStatus.ORDER_STATUS_BOOK_FINISH:
        {
          //已支付订金
          switch (orderListItem.confirmStatus) {
            case 0:
              {
                //正常
                return <Widget>[
                  _lightButton('查看详情', _seeDetail, true),
                  _lightButton('取消订单', _cancelOrder, true),
                  _darkButton('邀请函', _inviteInfo, false),
                ];
              }
              break;
            case 1:
              {
                //待确认
                return <Widget>[
                  _lightButton('查看详情', _seeDetail, true),
                  _lightButton('取消订单', _cancelOrder, false),
                ];
              }
              break;
            case 2:
              {
                //确认无房
                return <Widget>[
                  _lightButton('查看详情', _seeDetail, true),
                  _normalButton('还订这家', _bookAgain, false),
                ];
              }
              break;
            case 3:
              {
                //已确认
                return <Widget>[
                  _lightButton('查看详情', _seeDetail, true),
                  _lightButton('取消订单', _cancelOrder, true),
                  _darkButton('邀请函', _inviteInfo, false),
                ];
              }
              break;
            default:
          }
          return <Widget>[];
        }
        break;
      case OrderStatus.ORDER_STATUS_CANCEL: //已取消
      case OrderStatus.ORDER_STATUS_BOOK_REFUND: //订金退款中
      case OrderStatus.ORDER_STATUS_BOOK_REFUND_FINISH: //订���退款完成
      case OrderStatus.ORDER_STATUS_FINISH: //已完成
      case OrderStatus.ORDER_STATUS_REFUND: //全额退款中
      case OrderStatus.ORDER_STATUS_REFUND_FINISH:
        {
          //全额退款完成
          return <Widget>[
            _lightButton('查看详情', _seeDetail, true),
            _normalButton('还订这家', _bookAgain, false),
          ];
        }
        break;
      case OrderStatus.ORDER_STATUS_BE_PRESENTED:
        {
          //已到场
          return <Widget>[
            _lightButton('查看详情', _seeDetail, true),
            _darkButton('买单', _payBill, false),
          ];
        }
        break;
      case OrderStatus.ORDER_STATUS_BOOK_WAITED:
        {
          //待预订
          return <Widget>[
            _lightButton('查看详情', _seeDetail, true),
            _lightButton('取消订单', _cancelOrder, true),
            _darkButton('付订金', _payBook, false),
          ];
        }
        break;
      default:
    }
    return <Widget>[];
  }

  Widget _lightButton(String title, VoidCallback onPressed, bool needMargin) {
    return _baseButton(title, onPressed, needMargin, ThemeColors.colorDEDEDE,
        ThemeColors.color404040, Colors.white);
  }

  Widget _normalButton(String title, VoidCallback onPressed, bool needMargin) {
    return _baseButton(title, onPressed, needMargin, ThemeColors.color404040,
        ThemeColors.color404040, Colors.white);
  }

  Widget _darkButton(String title, VoidCallback onPressed, bool needMargin) {
    return Container(
      width: 68,
      height: 24,
      margin: needMargin ? EdgeInsets.only(right: 10) : EdgeInsets.all(0),
      child: FlatButton(
        padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            )),
        onPressed: onPressed,
        textTheme: ButtonTextTheme.normal,
        textColor: Colors.white,
        color: ThemeColors.color4A4A4A,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        colorBrightness: Brightness.light,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            side: BorderSide(
                color: ThemeColors.color4A4A4A,
                style: BorderStyle.solid,
                width: 1)),
        clipBehavior: Clip.antiAlias,
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }

  Widget _baseButton(String title, VoidCallback onPressed, bool needMargin,
      Color borderColor, Color textColor, Color bgColor) {
    return Container(
      width: 68,
      height: 24,
      margin: needMargin ? EdgeInsets.only(right: 10) : EdgeInsets.all(0),
      child: OutlineButton(
        padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            )),
        onPressed: onPressed,
        textColor: textColor,
        highlightedBorderColor: borderColor,
        color: bgColor,
        borderSide: new BorderSide(color: borderColor),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
