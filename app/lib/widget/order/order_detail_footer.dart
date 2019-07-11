import 'package:app/model/enum_define.dart';
import 'package:app/model/order/order_detail_bean.dart';
import 'package:app/model/order/order_list_bean.dart';
import 'package:app/res/theme_colors.dart';
import 'package:app/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrderDetailFooter extends StatelessWidget {
  final OrderListItem orderInfo;
  const OrderDetailFooter({Key key, @required this.orderInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: ScreenUtil.getScreenW(context),
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _rowItemWidgets(),
      ),
    );
  }

  _cancelOrder() {}

  _payBook() {
    debugPrint('_payBook');
  }

  _bookAgain() {
    debugPrint('_bookAgain');
  }

  _inviteInfo() {
    debugPrint('_inviteInfo');
  }

  _payBill() {
    debugPrint('_payBill');
  }

  _editOrder() {
    debugPrint('_editOrder');
  }

  List<Widget> _rowItemWidgets() {
    switch (orderInfo.orderStatus) {
      case OrderStatus.ORDER_STATUS_PAY_WAITED:
        {
          //未支付
          return _rowChildrenWithExpanded(<Widget>[
            _baseButtonWidget('', '取消订单', _cancelOrder, ThemeColors.color404040,
                Colors.white, true),
            _baseButtonWidget('', '修改订单', _editOrder, ThemeColors.color404040,
                Colors.white, true),
            _baseButtonWidget('', '付订金', _payBook, Colors.white,
                ThemeColors.color404040, false),
          ]);
        }
        break;
      case OrderStatus.ORDER_STATUS_BOOK_FINISH:
        {
          //已支付订金
          switch (orderInfo.confirmStatus) {
            case 0:
              {
                //正常
                return _rowChildrenWithExpanded(<Widget>[
                  _baseButtonWidget('', '取消订单', _cancelOrder,
                      ThemeColors.color404040, Colors.white, true),
                  _baseButtonWidget('', '邀请函', _inviteInfo, Colors.white,
                      ThemeColors.color404040, false),
                ]);
              }
              break;
            case 1:
              {
                //待确认
                return _rowChildrenWithExpanded(<Widget>[
                  _baseButtonWidget('', '取消订单', _cancelOrder,
                      ThemeColors.color404040, Colors.white, true),
                  _baseButtonWidget(null, '客服', null, ThemeColors.colorA6A6A6,
                      ThemeColors.colorDEDEDE, false),
                ]);
              }
              break;
            case 2:
              {
                //确认无房
                return _rowChildrenWithExpanded(<Widget>[
                  _baseButtonWidget('', '还订这家', _bookAgain, Colors.white,
                      ThemeColors.color404040, false),
                ]);
              }
              break;
            case 3:
              {
                //已确认
                return _rowChildrenWithExpanded(<Widget>[
                  _baseButtonWidget('', '取消订单', _cancelOrder,
                      ThemeColors.color404040, Colors.white, true),
                  _baseButtonWidget('', '邀请函', _inviteInfo, Colors.white,
                      ThemeColors.color404040, false),
                ]);
              }
              break;
            default:
          }
          return <Widget>[];
        }
        break;
      case OrderStatus.ORDER_STATUS_CANCEL: //已取消
      case OrderStatus.ORDER_STATUS_BOOK_REFUND: //订金退款中
      case OrderStatus.ORDER_STATUS_BOOK_REFUND_FINISH: //订金退款完成
      case OrderStatus.ORDER_STATUS_FINISH: //已完成
      case OrderStatus.ORDER_STATUS_REFUND: //全额退款中
      case OrderStatus.ORDER_STATUS_REFUND_FINISH: //全额退款完成
        {
          return _rowChildrenWithExpanded(<Widget>[
            _baseButtonWidget('', '还订这家', _bookAgain, Colors.white,
                ThemeColors.color404040, false),
          ]);
        }
        break;
      case OrderStatus.ORDER_STATUS_BE_PRESENTED:
        {
          //已到场
          return _rowChildrenWithExpanded(<Widget>[
            _baseButtonWidget('', '买单', _payBill, Colors.white,
                ThemeColors.color404040, false),
          ]);
        }
        break;
      case OrderStatus.ORDER_STATUS_BOOK_WAITED:
        {
          //待预订
          return _rowChildrenWithExpanded(<Widget>[
            _baseButtonWidget('', '取消订单', _cancelOrder, ThemeColors.color404040,
                Colors.white, true),
            _baseButtonWidget('', '修改订单', _editOrder, ThemeColors.color404040,
                Colors.white, true),
            _baseButtonWidget('', '付订金', _payBook, Colors.white,
                ThemeColors.color404040, false),
          ]);
        }
        break;
      default:
    }
    return <Widget>[];
  }

  List<Widget> _rowChildrenWithExpanded(List<Widget> buttonWidgets) {
    if (buttonWidgets.length == 0) {
      return <Widget>[];
    } else if (buttonWidgets.length == 1) {
      return <Widget>[
        Expanded(
          child: buttonWidgets[0],
        ),
      ];
    } else if (buttonWidgets.length == 2) {
      return <Widget>[
        Expanded(
          flex: 145,
          child: buttonWidgets[0],
        ),
        Expanded(
          flex: 230,
          child: buttonWidgets[1],
        )
      ];
    } else if (buttonWidgets.length == 3) {
      return <Widget>[
        Expanded(
          flex: 112,
          child: buttonWidgets[0],
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: ThemeColors.colorDEDEDE,
            width: 1,
          ),
        ),
        Expanded(
          flex: 112,
          child: buttonWidgets[1],
        ),
        Expanded(
          flex: 150,
          child: buttonWidgets[2],
        )
      ];
    }
    return <Widget>[];
  }

  _baseButtonWidget(
    String icon,
    String title,
    GestureTapCallback onTap,
    Color titleColor,
    Color bgColor,
    bool topLine,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          color: bgColor,
          shape: Border(
            top: topLine ? BorderSide(color: Color(0xFFDEDEDE), style: BorderStyle.solid) : BorderSide.none,
            bottom: topLine ? BorderSide(color: Color(0xFFDEDEDE), style: BorderStyle.solid) : BorderSide.none,
          ),
        ),
        alignment: Alignment.center,
        child: icon != null && icon.length > 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    icon,
                    width: 14,
                    height: 14,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: titleColor,
                    ),
                  ),
                ],
              )
            : Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: titleColor,
                ),
              ),
      ),
    );
  }
}
