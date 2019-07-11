import 'package:app/model/pay/pay_info_list_bean.dart';
import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class PayBillPersonalWidget extends StatelessWidget {
  final PayInfoListOptions options;
  final RechargeRecommend rechargeRecommend;
  final Function onTap;
  final bool selected;
  final Function onListEvent;
  final Function onRechargeEvent;

  const PayBillPersonalWidget(
      {Key key,
      this.options,
      this.rechargeRecommend,
      this.selected,
      this.onTap,
      this.onListEvent,
      this.onRechargeEvent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 60),
      color: Colors.white,
      child: Container(
          margin: EdgeInsets.only(left: 14),
          decoration: ShapeDecoration(
            shape: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
          ),
          child: Column(
            children: <Widget>[
              _baseInfoWidget(),
              _extraInfoWidget(),
            ],
          )),
    );
  }

  _baseInfoWidget() {
    return Container(
      margin: EdgeInsets.only(top: 14, left: 7),
      height: 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            child: Image.network(options.icon, fit: BoxFit.fill),
          ),
          Container(
            margin: EdgeInsets.only(left: 21),
            child: Text(
              options.name,
              style: TextStyle(
                color: ThemeColors.color404040,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            child:
                (options.subBtn.name != null && options.subBtn.name.length > 0)
                    ? Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 20),
                        child: Text(
                          options.subBtn.name,
                          style: TextStyle(
                            color: ThemeColors.colorA6A6A6,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )
                    : SizedBox(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                onTap();
              },
              child: Container(
                color: selected ? Colors.green : ThemeColors.colorA6A6A6,
                width: 20,
                height: 20,
                margin: EdgeInsets.only(right: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _extraInfoSubWidgets() {
    List<Widget> extraInfoSubWidgets = <Widget>[];
    for (String item in rechargeRecommend.title) {
      extraInfoSubWidgets.add(Text(
        item,
        style: TextStyle(
            color: ThemeColors.colorD0021B,
            fontSize: 14,
            fontWeight: FontWeight.w300),
      ));
    }
    for (String item in rechargeRecommend.desc) {
      extraInfoSubWidgets.add(Text(
        item,
        style: TextStyle(
            color: ThemeColors.colorA6A6A6,
            fontSize: 12,
            fontWeight: FontWeight.normal),
      ));
    }
    return extraInfoSubWidgets;
  }

  _rechargeButtonWidget() {
    return GestureDetector(
      onTap: onRechargeEvent,
      child: Container(
        decoration: new BoxDecoration(
          border: new Border.all(
              color: ThemeColors.colorD0021B, width: 1.0), // 边色与边宽度
          borderRadius: new BorderRadius.circular((10.0)), // 圆角度
        ),
        width: 64,
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '去充值',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: ThemeColors.colorD0021B,
              ),
            ),
            Container(
              color: ThemeColors.color404040,
              width: 14,
              height: 14,
            )
          ],
        ),
      ),
    );
  }

  _seeListButtonWidget() {
    return GestureDetector(
      onTap: onListEvent,
      child: Container(
        decoration: new BoxDecoration(
          border: new Border.all(
              color: ThemeColors.colorD0021B, width: 1.0), // 边色与边宽度
          borderRadius: new BorderRadius.circular((10.0)), // 圆角度
        ),
        width: 64,
        height: 20,
        margin: EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        child: Text(
          '适用餐厅',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            color: ThemeColors.colorD0021B,
          ),
        ),
      ),
    );
  }

  _extraInfoWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 59),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _extraInfoSubWidgets(),
              ),
            ),
          ),
          Container(
            width: 64,
            margin: EdgeInsets.only(right: 20),
            child: Column(
              children: <Widget>[
                options.subBtn.btnName != null &&
                        options.subBtn.btnName.length > 0
                    ? _rechargeButtonWidget()
                    : Container(
                        width: 64,
                        height: 20,
                      ),
                rechargeRecommend.btn != null &&
                        rechargeRecommend.btn.title != null &&
                        rechargeRecommend.btn.title.length > 0
                    ? _seeListButtonWidget()
                    : Container(
                        width: 64,
                        height: 20,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
