import 'dart:convert';

import 'package:app/Application.dart';
import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/event.dart';
import 'package:app/model/invoice/invoice_list_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';
import 'package:app/widget/save_image_toast.dart' as Toast;
import 'package:app/widget/toast.dart' as T;

/*
 * 发票详情页面
 **/
class InvoiceDetailPage extends StatefulWidget {
  @override
  _InvoiceDetailPageState createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage>
    with SingleTickerProviderStateMixin {
  bool _canEdit;
  List<Widget> _titleWidgets;
  InvoiceModel invoiceModel;

  @override
  void initState() {
    _canEdit = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _editInvoice() {
    Navigator.of(context)
        .pushNamed(Page.INVOICE_EDIT_PAGE, arguments: invoiceModel);
  }

  _deleteInvoice() {
     dio.post(Api.INVOICE_DELETE, data: {"invoice_id": invoiceModel.id.toString(),"is_delete": "1"}).then((data) {
      var sources = jsonDecode(data.data);
      if (sources['error_code'] == Api.SUCCESS_CODE) {
        Toast.SaveImageToast.toast(context, "删除成功", true);
        Future.delayed(
          new Duration(milliseconds: 1000),
          () {
            Application.getEventBus().fire(EventType.changeInvoiceList);
            Navigator.of(context).popUntil(ModalRoute.withName(Page.INVOICE_LIST_PAGE));
          },
        );
      } else {
        T.Toast.toast(context, sources['msg']);
      }
    });
  }

  _normalWidget(String title, String subTitle) {
    return Container(
      constraints: BoxConstraints(minHeight: 50),
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 14),
        padding: EdgeInsets.only(top: 14, bottom: 14),
        decoration: ShapeDecoration(
          shape: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }

  _buttonGroupWidget() {
    return _canEdit
        ? Container(
            margin: EdgeInsets.only(top: 35, left: 14, right: 14),
            height: 50,
            child: FlatButton(
              padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Container(
                alignment: Alignment.center,
                child: Text('编辑',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    )),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [Color(0xFF404040), Color(0xFF404040)],
                  ),
                ),
              ),
              onPressed: () {
                _editInvoice();
              },
              textTheme: ButtonTextTheme.normal,
              disabledTextColor: ThemeColors.color404040,
              textColor: Colors.white,
              // 按下的背景��
              splashColor: Colors.transparent,
              // ��波纹颜色
              colorBrightness: Brightness.dark,
              // 主题
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
          )
        : Container();
  }

  _getListContent() {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: _titleWidgets.length,
      itemBuilder: (BuildContext context, int index) {
        return _titleWidgets[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /*获取传递过来的参数*/
    Map<String, dynamic> invoiceInfo =
        ModalRoute.of(context).settings.arguments;
    debugPrint(invoiceInfo.toString());
    if (invoiceModel == null && invoiceInfo != null) {
      _canEdit = !invoiceInfo["isEnterprise"];
      invoiceModel = invoiceInfo["invoiceModel"];

      _titleWidgets = <Widget>[];
      if (invoiceModel.taxNumber.length > 0) {
        _titleWidgets.addAll([
          _normalWidget('抬头类型', '单位'),
          _normalWidget('名称', invoiceModel.taxTitle),
          _normalWidget('税号', invoiceModel.taxNumber),
          _normalWidget('单位地址', invoiceModel.companyAddress),
          _normalWidget('电话号码', invoiceModel.telphone),
          _normalWidget('开户银行', invoiceModel.bankName),
          _normalWidget('银行账户', invoiceModel.bankAccount),
          _normalWidget('邮箱', invoiceModel.email),
        ]);
      } else {
        _titleWidgets.addAll([
          _normalWidget('抬头类型', '个人'),
          _normalWidget('名称', invoiceModel.taxTitle),
          _normalWidget('邮箱', invoiceModel.email),
        ]);
      }
      if (_canEdit) {
        _titleWidgets.add(_buttonGroupWidget());
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          child: AppBar(
            title: Text('发票详情'),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              _canEdit
                  ? GestureDetector(
                      onTap: () {
                        _deleteInvoice();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 14),
                        alignment: Alignment.centerRight,
                        child: Text(
                          '删除抬头',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                  : Container(),
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
        child: _getListContent(),
      ),
    );
  }
}
