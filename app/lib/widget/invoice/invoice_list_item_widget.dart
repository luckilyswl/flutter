import 'package:app/model/invoice/invoice_list_bean.dart';
import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InvoiceListItemWidget extends StatelessWidget {
  final InvoiceModel invoiceModel;
  final bool isLastOne;
  final bool isChoosed;
  final Function onPressed;
  final Function onChooseEvent;

  const InvoiceListItemWidget({
    Key key,
    @required this.invoiceModel,
    @required this.isLastOne,
    @required this.isChoosed,
    @required this.onPressed,
    @required this.onChooseEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      color: Colors.white,
      child: GestureDetector(
        onTap: onChooseEvent,
        child: Container(
          margin: EdgeInsets.only(left: 14),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: isLastOne ? Colors.transparent : Color(0xFFDEDEDE),
                    style: BorderStyle.solid)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              isChoosed
                  ? Container(
                      width: 20,
                      height: 20,
                      color: ThemeColors.color404040,
                      margin: EdgeInsets.only(right: 14),
                    )
                  : Container(
                      width: 20,
                      height: 20,
                      color: Colors.transparent,
                      margin: EdgeInsets.only(right: 14),
                    ),
              Expanded(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        invoiceModel.invoiceType == 1
                            ? '税号 ${invoiceModel.taxNumber}'
                            : '个人',
                        style: TextStyle(
                          color: ThemeColors.colorA6A6A6,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '邮箱 ${invoiceModel.email}',
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
                  width: 48,
                  height: 24,
                  margin: EdgeInsets.only(right: 14),
                  child: FlatButton(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Text("详情",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ThemeColors.color404040,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        )),
                    onPressed: onPressed,
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
                    // 主题
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        side: BorderSide(
                            color: ThemeColors.colorA6A6A6,
                            style: BorderStyle.solid,
                            width: 1)),
                    clipBehavior: Clip.antiAlias,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
