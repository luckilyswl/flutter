import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class OrderDetailContactSheet extends StatelessWidget {
  final List<String> tel;
  final Function(String telNum) onCallEvent;
  final Function onCancelEvent;

  const OrderDetailContactSheet({
    Key key,
    @required this.tel,
    @required this.onCallEvent,
    @required this.onCancelEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.colorF2F2F2,
      child: GestureDetector(
        child: SafeArea(
          child: Container(
            height: tel.length * 50.0 + (tel.length - 1) * 1.0 + 56,
            child: Column(
              children: _bottomSheetWidgets(),
            ),
          ),
        ),
      ),
    );
  }

  _bottomSheetWidgets() {
    List<Widget> widgets = <Widget>[];
    for (var i = 0; i < tel.length; i++) {
      String telNum = tel[i];
      widgets.add(GestureDetector(
        onTap: () {
          onCallEvent(telNum);
        },
        child: Container(
          color: Colors.white.withAlpha(242),
          height: 50,
          alignment: Alignment.center,
          child: Text(
            telNum,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ThemeColors.color404040,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
        ),
      ));
      if (i != tel.length - 1) {
        widgets.add(
          Divider(
            height: 1,
          ),
        );
      }
    }
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
