import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class OrderDetailNaviSheet extends StatelessWidget {
  final Function onBusinessEvent;
  final Function onParkEvent;
  final Function onCancelEvent;

  const OrderDetailNaviSheet({
    Key key,
    @required this.onBusinessEvent,
    @required this.onParkEvent,
    @required this.onCancelEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.colorF2F2F2,
      child: GestureDetector(
        child: SafeArea(
          child: Container(
            height: 266,
            child: Column(
              children: _naviBottomSheetWidgets(),
            ),
          ),
        ),
      ),
    );
  }

  _naviBottomSheetWidgets() {
    List<Widget> widgets = <Widget>[];
    widgets.add(Container(
      color: Colors.white.withAlpha(242),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              '停车场信息',
              style: TextStyle(
                  color: ThemeColors.colorA6A6A6,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 10),
            padding: EdgeInsets.only(left: 14, right: 14),
            child: Text(
              'M+创工场户外停车场，100个车位，用餐时间免费停车2小时（商家提供停车票），开车导航至M+创工场，门口开车进去可看到停车场，停车地址和收费仅供参考，请以实际为准。',
              style: TextStyle(
                  height: 1.2,
                  color: ThemeColors.colorA6A6A6,
                  fontSize: 12,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    ));

    widgets.add(
      Divider(
        height: 1,
      ),
    );

    widgets.add(GestureDetector(
      onTap: () {
        onBusinessEvent();
      },
      child: Container(
        color: Colors.white.withAlpha(242),
        height: 50,
        alignment: Alignment.center,
        child: Text(
          '导航至餐厅',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: ThemeColors.color404040,
              fontSize: 16,
              fontWeight: FontWeight.normal),
        ),
      ),
    ));
    widgets.add(
      Divider(
        height: 1,
      ),
    );
    widgets.add(GestureDetector(
      onTap: () {
        onParkEvent();
      },
      child: Container(
        color: Colors.white.withAlpha(242),
        height: 50,
        alignment: Alignment.center,
        child: Text(
          '导航至停车场',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: ThemeColors.color404040,
              fontSize: 16,
              fontWeight: FontWeight.normal),
        ),
      ),
    ));

    widgets.add(
      Container(
        height: 6,
      ),
    );
    widgets.add(
      GestureDetector(
        onTap: () {
          onCancelEvent();
        },
        child: Container(
          color: Colors.white,
          height: 50,
          alignment: Alignment.center,
          child: Text(
            '取消',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ThemeColors.color404040,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
    return widgets;
  }
}
