import 'package:app/navigator/page_route.dart';
import 'package:app/res/res_index.dart';
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
  List<String> enterpriseInvoiceList = <String>[];
  List<String> invoiceList = <String>[];
  bool isOpen = false;
  int currentIndex = -1;

  @override
  void initState() {
    enterpriseInvoiceList = <String>[
      '广州请上座信息科技有限公司',
      '广州请上座信息科技有限公司',
      '广州请上座信息科技有限公司',
      '广州请上座信息科技有限公司',
      '广州请上座信息科技有限公司',
      '广州请上座信息科技有限公司',
    ];
    invoiceList = <String>[
      '李维斯',
      '李维斯',
      '李维斯',
    ];

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _addInvoice() {
    Navigator.of(context).pushNamed(Page.INVOICE_CREATE_PAGE);
    debugPrint('添加抬头');
  }

  _toDetail() {
    Navigator.of(context).pushNamed(Page.INVOICE_DETAIL_PAGE);
    debugPrint('详情');
  }

  _selectInvoice() {
    debugPrint('跳转回开票页面');
    Navigator.of(context).pop();
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

  _normalWidget(String title, bool isLastOne) {
    return Container(
      height: 78,
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 14),
        decoration: ShapeDecoration(
          shape: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: isLastOne ? Colors.transparent : Color(0xFFDEDEDE),
                  style: BorderStyle.solid)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 20,
              height: 20,
              color: ThemeColors.color404040,
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
                      title,
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
                  Container(
                    child: Text(
                      '邮箱 tony@youshangzuo.com',
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
                  onPressed: () {
                    _toDetail();
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
                invoiceList[index - 1], index == invoiceList.length);
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
                  index == enterpriseInvoiceList.length);
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
                    index == enterpriseInvoiceList.length);
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
                    index == enterpriseMaxNumber);
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
                  index == enterpriseInvoiceList.length);
            } else if (index == enterpriseInvoiceList.length + 1) {
              return _normalHeader();
            } else {
              return _normalWidget(
                  invoiceList[index - enterpriseInvoiceList.length - 2],
                  index ==
                      enterpriseInvoiceList.length + 1 + invoiceList.length);
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
                    index == enterpriseInvoiceList.length);
              } else if (index == enterpriseInvoiceList.length + 1) {
                return _openWidget();
              } else if (index == enterpriseInvoiceList.length + 2) {
                return _normalHeader();
              } else {
                return _normalWidget(
                    invoiceList[index - enterpriseInvoiceList.length - 3],
                    index ==
                        enterpriseInvoiceList.length + 2 + invoiceList.length);
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
                    index == enterpriseMaxNumber);
              } else if (index == enterpriseMaxNumber + 1) {
                return _openWidget();
              } else if (index == enterpriseMaxNumber + 2) {
                return _normalHeader();
              } else {
                return _normalWidget(
                    invoiceList[index - enterpriseMaxNumber - 3],
                    index == invoiceList.length + enterpriseMaxNumber + 2 + 1);
              }
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
