import 'dart:convert';

import 'package:app/Application.dart';
import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/event.dart';
import 'package:app/model/invoice/invoice_list_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
import 'package:app/widget/invoice/invoice_list_item_widget.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

/*
 * 选择发票抬头页面
 **/
class InvoiceListPage extends StatefulWidget {
  @override
  _InvoiceListPageState createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage>
    with SingleTickerProviderStateMixin {
  static int enterpriseMaxNumber = 2;
  List<InvoiceModel> enterpriseInvoiceList = <InvoiceModel>[];
  List<InvoiceModel> invoiceList = <InvoiceModel>[];
  bool isOpen = false;
  int currentId = 0;

  @override
  void initState() {
    // 根据不同事件处理
    Application.getEventBus().on<String>().listen((event) {
      if (this.mounted) {
        if (event == EventType.changeInvoiceList) {
          initData();
        }
      }
    });
    initData();
    super.initState();
  }

  /*
   * 获取列表
   **/
  initData() {
    dio
        .get(
      Api.INVOICE_LIST,
    )
        .then((data) {
      var sources = jsonDecode(data.data);
      InvoiceListBean bean = InvoiceListBean.fromJson(sources);
      if (bean.errorCode == Api.SUCCESS_CODE) {
        InvoiceListDataBean dataBean = bean.data;
        setState(() {
          enterpriseInvoiceList = dataBean.appEnterpriseInvoice;
          if (invoiceList.length > 0) {
            invoiceList.removeRange(0, invoiceList.length);
          }
          if (dataBean.appUserInvoice.companyInvoice != null) {
            invoiceList.addAll(dataBean.appUserInvoice.companyInvoice);
          }
          if (dataBean.appUserInvoice.userInvoice != null) {
            invoiceList.addAll(dataBean.appUserInvoice.userInvoice);
          }
        });
      } else {
        Toast.toast(context, bean.msg);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _addInvoice() {
    Navigator.of(context).pushNamed(Page.INVOICE_CREATE_PAGE);
    debugPrint('添加抬头');
  }

  _toDetail(InvoiceModel invoiceModel, bool isEnterprise) {
    debugPrint('详情' + invoiceModel.id.toString());
    Navigator.of(context).pushNamed(Page.INVOICE_DETAIL_PAGE, arguments: {
      "invoiceModel": invoiceModel,
      "isEnterprise": isEnterprise
    });
  }

  _selectInvoice(InvoiceModel invoiceModel) {
    debugPrint('跳转回开票页面'+invoiceModel.toJson().toString());
    Navigator.of(context).pop(invoiceModel);
  }

  _openWidget() {
    if (isOpen) {
      return GestureDetector(
        onTap: () {
          setState(() {
            isOpen = false;
          });
        },
        child: Container(
          height: 42,
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('收起'),
              Container(
                width: 14,
                height: 14,
                color: ThemeColors.color404040,
                margin: EdgeInsets.only(left: 2),
              )
            ],
          ),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: Border(
              top: BorderSide(
                  color: Color(0xFFDEDEDE), style: BorderStyle.solid),
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            isOpen = true;
          });
        },
        child: Container(
          height: 42,
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('查看全部'),
              Container(
                width: 14,
                height: 14,
                color: ThemeColors.color404040,
                margin: EdgeInsets.only(left: 2),
              )
            ],
          ),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: Border(
              top: BorderSide(
                  color: Color(0xFFDEDEDE), style: BorderStyle.solid),
            ),
          ),
        ),
      );
    }
  }

  _normalWidget(InvoiceModel invoiceModel, bool isLastOne, bool isEnterprise) {
    return InvoiceListItemWidget(
      invoiceModel: invoiceModel,
      isLastOne: isLastOne,
      isChoosed: invoiceModel.id == currentId,
      onPressed: () {
        _toDetail(invoiceModel, isEnterprise);
      },
      onChooseEvent: () {
        setState(() {
          currentId = invoiceModel.id;
        });
        _selectInvoice(invoiceModel);
      },
    );
  }

  _enterpriseHeader() {
    return Container(
      height: 42,
      padding: EdgeInsets.only(left: 14),
      alignment: Alignment.centerLeft,
      color: ThemeColors.colorF2F2F2,
      child: Row(
        children: <Widget>[
          Text(
            '企业账号发票',
            style: TextStyle(
              color: ThemeColors.color404040,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 6),
            width: 28,
            height: 14,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              border: new Border.all(
                  color: ThemeColors.colorD0021B, width: 1.0), // 边色与边宽度
              borderRadius: new BorderRadius.circular((2.0)), // 圆角度
            ),
            child: Text(
              '推荐',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ThemeColors.colorD0021B,
                fontSize: 8,
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        ],
      ),
    );
  }

  _normalHeader() {
    return Container(
      height: 42,
      padding: EdgeInsets.only(left: 14),
      alignment: Alignment.centerLeft,
      color: ThemeColors.colorF2F2F2,
      child: Text(
        '个人常用发票',
        style: TextStyle(
          color: ThemeColors.color404040,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  _getListContent() {
    if (enterpriseInvoiceList.length == 0 && invoiceList.length == 0) {
      return Center(
        child: Text(
          '暂无发票抬头数据',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ThemeColors.colorA6A6A6,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
    } else if (enterpriseInvoiceList.length == 0) {
      //只显示个人常用发票
      return ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: invoiceList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _normalHeader();
          } else {
            return _normalWidget(
                invoiceList[index - 1], index == invoiceList.length, false);
          }
        },
      );
    } else if (invoiceList.length == 0) {
      if (enterpriseInvoiceList.length <= enterpriseMaxNumber) {
        //显示企业账号发票，不显示展开/收起按钮
        return ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: enterpriseInvoiceList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _enterpriseHeader();
            } else {
              return _normalWidget(enterpriseInvoiceList[index - 1],
                  index == enterpriseInvoiceList.length, true);
            }
          },
        );
      } else {
        //显示企业账号发票，显示展开/收起按钮
        if (isOpen) {
          return ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: enterpriseInvoiceList.length + 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _enterpriseHeader();
              } else if (index == enterpriseInvoiceList.length + 1) {
                return _openWidget();
              } else {
                return _normalWidget(enterpriseInvoiceList[index - 1],
                    index == enterpriseInvoiceList.length, true);
              }
            },
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: enterpriseMaxNumber + 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _enterpriseHeader();
              } else if (index == enterpriseMaxNumber + 1) {
                return _openWidget();
              } else {
                return _normalWidget(enterpriseInvoiceList[index - 1],
                    index == enterpriseMaxNumber, true);
              }
            },
          );
        }
      }
    } else {
      if (enterpriseInvoiceList.length <= enterpriseMaxNumber) {
        //显示企业账号发票、个人常用发票，不显示展开/收起按钮
        return ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: enterpriseInvoiceList.length + 1 + invoiceList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _enterpriseHeader();
            } else if (index < enterpriseInvoiceList.length + 1) {
              return _normalWidget(enterpriseInvoiceList[index - 1],
                  index == enterpriseInvoiceList.length, true);
            } else if (index == enterpriseInvoiceList.length + 1) {
              return _normalHeader();
            } else {
              return _normalWidget(
                  invoiceList[index - enterpriseInvoiceList.length - 2],
                  index ==
                      enterpriseInvoiceList.length + 1 + invoiceList.length,
                  false);
            }
          },
        );
      } else {
        //显示企业账号发票、个人常用发票，显示展开/收起按钮
        if (isOpen) {
          return ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount:
                enterpriseInvoiceList.length + 2 + invoiceList.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _enterpriseHeader();
              } else if (index < enterpriseInvoiceList.length + 1) {
                return _normalWidget(enterpriseInvoiceList[index - 1],
                    index == enterpriseInvoiceList.length, true);
              } else if (index == enterpriseInvoiceList.length + 1) {
                return _openWidget();
              } else if (index == enterpriseInvoiceList.length + 2) {
                return _normalHeader();
              } else {
                return _normalWidget(
                    invoiceList[index - enterpriseInvoiceList.length - 3],
                    index ==
                        enterpriseInvoiceList.length + 2 + invoiceList.length,
                    false);
              }
            },
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: enterpriseMaxNumber + 2 + invoiceList.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _enterpriseHeader();
              } else if (index < enterpriseMaxNumber + 1) {
                return _normalWidget(enterpriseInvoiceList[index - 1],
                    index == enterpriseMaxNumber, true);
              } else if (index == enterpriseMaxNumber + 1) {
                return _openWidget();
              } else if (index == enterpriseMaxNumber + 2) {
                return _normalHeader();
              } else {
                return _normalWidget(
                    invoiceList[index - enterpriseMaxNumber - 3],
                    index == invoiceList.length + enterpriseMaxNumber + 2 + 1,
                    false);
              }
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    /*获取传递过来的参数*/
    Map<String, dynamic> invoiceInfo =
        ModalRoute.of(context).settings.arguments;
    if (invoiceInfo != null) {
      currentId = invoiceInfo["id"];
    }
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          child: AppBar(
            title: Text('选择发票抬头'),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  _addInvoice();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 14),
                  alignment: Alignment.centerRight,
                  child: Text(
                    '添加抬头',
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
        child: _getListContent(),
      ),
    );
  }
}
