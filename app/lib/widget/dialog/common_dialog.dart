import 'package:app/res/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/utils_index.dart';

/*
 * 通用文字弹窗 Dialog 
 **/
class CommonDialog extends Dialog {
  String title = "";
  String message;
  String negativeText;
  String positiveText;
  Function onCloseEvent;
  Function onPositivePressEvent;

  //message是否居中
  bool isMessageCenter;

  CommonDialog(
      {Key key,
      this.title,
      @required this.message,
      this.negativeText,
      this.positiveText,
      this.onPositivePressEvent,
      @required this.onCloseEvent,
      this.isMessageCenter = false})
      : super(key: key);

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
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              margin: const EdgeInsets.all(0.0),
              child: new Column(
                children: <Widget>[
                  new Container(
                    decoration: BoxDecoration(
                      color: ThemeColors.colorF7F7F7,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: !ObjectUtil.isEmptyString(title)
                        ? new Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: new Stack(
                              alignment: AlignmentDirectional.centerEnd,
                              children: <Widget>[
                                new Center(
                                  child: new Text(
                                    title,
                                    style: new TextStyle(
                                        fontSize: 20.0,
                                        color: ThemeColors.color404040,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : new Container(),
                  ),
                  new Container(
                    decoration: BoxDecoration(
                      color: ThemeColors.colorF7F7F7,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                            !ObjectUtil.isEmptyString(title) ? 0 : 8),
                        topRight: Radius.circular(
                            !ObjectUtil.isEmptyString(title) ? 0 : 8),
                      ),
                    ),
                    width: double.maxFinite,
                    constraints: BoxConstraints(minHeight: 68.0),
                    child: new Padding(
                      padding: EdgeInsets.only(
                          top: !ObjectUtil.isEmptyString(title) ? 14 : 24,
                          left: 20,
                          right: 20,
                          bottom: 24),
                      child: new IntrinsicHeight(
                        child: new Text(
                          message,
                          textAlign: isMessageCenter
                              ? TextAlign.center
                              : TextAlign.start,
                          style: const TextStyle(
                            height: 1.4,
                            fontSize: 14.0,
                            color: ThemeColors.color404040,
                          ),
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
    if (!ObjectUtil.isEmptyString(negativeText))
      widgets.add(_buildBottomCancelButton());
    if (!ObjectUtil.isEmptyString(positiveText))
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
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: ThemeColors.colorDEDEDE, width: 1),
                right: BorderSide(color: ThemeColors.colorDEDEDE, width: 1)),
          ),
          child: new FlatButton(
            onPressed: onCloseEvent,
            child: new Text(
              negativeText,
              style: TextStyle(fontSize: 16.0, color: ThemeColors.colorA6A6A6),
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
