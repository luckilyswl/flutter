import 'package:app/res/theme_colors.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InviteDialog extends StatefulWidget {
  String title = "";
  String message;
  String inviteName;
  String negativeText;
  String positiveText;

  Function onCloseEvent;
  Function(String name, String welcome) onPositivePressEvent;

  InviteDialog({
    Key key,
    this.title,
    @required this.inviteName,
    @required this.message,
    this.negativeText,
    this.positiveText,
    this.onPositivePressEvent,
    @required this.onCloseEvent,
  }) : super(key: key);
  @override
  _InviteDialogState createState() => _InviteDialogState();
}

class _InviteDialogState extends State<InviteDialog>
    with TickerProviderStateMixin {
  String name;
  String welcome;

  void _textFieldChanged(String str) {
    name = str;
  }

  void _textFieldChange2(String str) {
    welcome = str;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xa6000000),
      body: new Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: new Material(
          type: MaterialType.transparency,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                height: 240,
                decoration: ShapeDecoration(
                  color: Color(0xffffffff),
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
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      height: 190,
                      decoration: BoxDecoration(
                        color: Color(0xffF7F7F7),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                      ),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: new Text(
                              '邀请人昵称',
                              style: new TextStyle(
                                fontSize: 16,
                                color: ThemeColors.color404040,
                              ),
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: new TextField(
                              //controller: _controller,
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              onChanged: _textFieldChanged,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(top: 14, bottom: 14),
                                  hintText: widget.inviteName,
                                  border: InputBorder.none,
                                  hintStyle: new TextStyle(
                                      fontSize: 16,
                                      color: ThemeColors.colorA6A6A6)),
                            ),
                          ),
                          new Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            height: 1,
                            color: Color(0xffDEDEDE),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: new Text(
                              '欢迎语',
                              style: new TextStyle(
                                fontSize: 16,
                                color: ThemeColors.color404040,
                              ),
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: new TextField(
                              onChanged: _textFieldChange2,
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(top: 14, bottom: 14),
                                  hintText: widget.message,
                                  border: InputBorder.none,
                                  hintStyle: new TextStyle(
                                      fontSize: 16,
                                      color: ThemeColors.colorA6A6A6)),
                            ),
                          ),
                          new Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            height: 1,
                            color: Color(0xffDEDEDE),
                          ),
                        ],
                      ),
                    ),
                    this._buildBottomButtonGroup(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtonGroup() {
    var widgets = <Widget>[];
    if (widget.negativeText != null && widget.negativeText.isNotEmpty)
      widgets.add(_buildBottomCancelButton());
    if (widget.positiveText != null && widget.positiveText.isNotEmpty)
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
            onPressed: widget.onCloseEvent,
            child: new Text(
              widget.negativeText,
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
            onPressed: () {
              widget.onPositivePressEvent(name, welcome);
            },
            child: new Text(
              widget.positiveText,
              style: TextStyle(
                color: Color(0xff54548C),
                fontSize: 16.0,
              ),
            ),
          ),
        ));
  }
}
