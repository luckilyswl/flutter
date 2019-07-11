import 'package:app/res/theme_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InvitePicDialog extends Dialog {
  String title = "";
  String imgUrl;
  String negativeText;
  String positiveText;
  Function onCloseEvent;
  Function onPositivePressEvent;

  InvitePicDialog({
    Key key,
    this.title,
    @required this.imgUrl,
    this.negativeText,
    this.positiveText,
    this.onPositivePressEvent,
    @required this.onCloseEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: new Material(
        type: MaterialType.transparency,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                border: Border.all(color: Colors.white, width: 6),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              margin: const EdgeInsets.all(0.0),
              child: new Column(
                children: <Widget>[
                  Image.network(
                    imgUrl,
                    fit: BoxFit.fill,
                    height: 442,
                  ),
                ],
              ),
            ),
            this._buildBottomButtonGroup(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtonGroup() {
    var widgets = <Widget>[];
    if (positiveText != null && positiveText.isNotEmpty)
      widgets.add(_buildBottomPositiveButton());
    return new Flex(
      direction: Axis.horizontal,
      children: widgets,
    );
  }

  Widget _buildBottomPositiveButton() {
    return new Flexible(
        fit: FlexFit.tight,
        child: new Container(
          margin: EdgeInsets.only(top: 20),
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: new LinearGradient(
                colors: [Color(0xffF9D598), Color(0xffD59D56)]),
          ),
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
