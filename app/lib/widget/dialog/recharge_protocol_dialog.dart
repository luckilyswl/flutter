import 'package:app/res/gradients.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';

// ignore: must_be_immutable
class RechargeProtocolDialog extends Dialog {
  String title = "";
  String message;
  String negativeText;
  String positiveText;
  VoidCallback onCloseEvent;
  VoidCallback onPositivePressEvent;

  RechargeProtocolDialog({
    Key key,
    this.title,
    @required this.message,
    this.negativeText,
    this.positiveText,
    this.onPositivePressEvent,
    @required this.onCloseEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(40.0),
      child: new Material(
        type: MaterialType.transparency,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                ),
              ),
              margin: const EdgeInsets.all(0.0),
              child: new Column(
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(top: 20),
                    child: new Text(
                      '请上座充值协议',
                      style: new TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.color1A1A1A),
                    ),
                  ),
                  new Container(
                    height: 200,
                    child: new SingleChildScrollView(
                      primary: false,
                      child: new Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: new Text(
                          message,
                          style: new TextStyle(
                              fontSize: 12, color: ThemeColors.color404040),
                        ),
                      ),
                    ),
                  ),
                  this._buildBottomButtonGroup(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtonGroup() {
    var widgets = <Widget>[];
    if (negativeText != null && negativeText.isNotEmpty)
      widgets.add(_buildBottomCancelButton());
    if (positiveText != null && positiveText.isNotEmpty)
      widgets.add(_buildBottomPositiveButton());
    return new Flex(
      direction: Axis.horizontal,
      children: widgets,
    );
  }

  Widget _buildBottomCancelButton() {
    return new Flexible(
        fit: FlexFit.tight,
        child: new Container(
          alignment: Alignment.center,
          height: 44,
          margin: EdgeInsets.only(left: 0, right: 0, bottom: 20, top: 20),
          child: new FlatButton(
            onPressed: onCloseEvent,
            child: new Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 44,
              decoration: BoxDecoration(
                gradient: Gradients.blueLinearGradient,
                borderRadius: BorderRadius.circular(5),
              ),
              child: new Text(
                negativeText,
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            ),
          ),
        ));
  }

  Widget _buildBottomPositiveButton() {
    return new Flexible(
        fit: FlexFit.tight,
        child: new Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: ThemeColors.colorDEDEDE, width: 1))),
          child: new FlatButton(
            onPressed: onPositivePressEvent,
            child: new Text(
              positiveText,
              style: TextStyle(
                color: ThemeColors.color404040,
                fontSize: 16.0,
              ),
            ),
          ),
        ));
  }
}
