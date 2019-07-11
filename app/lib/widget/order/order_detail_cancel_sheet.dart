import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderDetailCancelSheet extends StatefulWidget {
  final List<String> reasons;
  final Function onCloseEvent;
  final Function(int index, String reason) onCancelEvent;

  const OrderDetailCancelSheet({
    Key key,
    @required this.reasons,
    @required this.onCloseEvent,
    @required this.onCancelEvent,
  }) : super(key: key);

  _OrderDetailCancelSheetState createState() => _OrderDetailCancelSheetState();
}

class _OrderDetailCancelSheetState extends State<OrderDetailCancelSheet> {
  int _currentIndex = -1;
  TextEditingController _reasonController;
  final FocusNode node = FocusNode();

  @override
  void initState() {
    _reasonController = TextEditingController();
    super.initState();
  }

  _bottomButtonWidget() {
    return Container(
      height: 78,
      color: Colors.white,
      width: ScreenUtil.getScreenW(context),
      padding: EdgeInsets.only(left: 14, right: 14, bottom: 14, top: 14),
      child: FlatButton(
        padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Text('确认取消',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            )),
        onPressed: () {
          if (_currentIndex == -1 && _reasonController.text.length == 0) {
            Toast.toast(context, '请选择取消原因');
            return;
          }
          widget.onCancelEvent(_currentIndex, _reasonController.text);
        },
        textTheme: ButtonTextTheme.normal,
        textColor: Colors.white,
        color: ThemeColors.color404040,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        colorBrightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        clipBehavior: Clip.antiAlias,
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }

  _headerWidget() {
    return Container(
      height: 70,
      padding: EdgeInsets.only(left: 14, right: 14, top: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              child: RichText(
                text: TextSpan(
                  text: "Hi",
                  style: TextStyle(
                      color: ThemeColors.color404040,
                      fontSize: 28,
                      fontWeight: FontWeight.normal),
                  children: [
                    TextSpan(
                        text: "，遇到什么问题了吗？",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: ThemeColors.color404040)),
                  ],
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  widget.onCloseEvent();
                },
                child: Container(
                  width: 20,
                  height: 20,
                  color: ThemeColors.colorA6A6A6,
                ),
              ))
        ],
      ),
    );
  }

  _textFieldWidget() {
    return Container(
      constraints: BoxConstraints(minHeight: 74, maxHeight: 74),
      margin: const EdgeInsets.only(left: 14, right: 14, top: 6),
      padding: const EdgeInsets.only(left: 14, right: 14),
      decoration: BoxDecoration(
          color: ThemeColors.colorF2F2F2,
          borderRadius: BorderRadius.circular(5)),
      child: TextField(
        controller: _reasonController,
        focusNode: node,
        keyboardType: TextInputType.multiline,
        style: FontStyles.style141A1A1A,
        textInputAction: TextInputAction.done,
        maxLines: null,
        decoration: InputDecoration(
          hintText: '没有合适的？那就写下来吧…',
          border: InputBorder.none,
          counterText: '',
          hintStyle: FontStyles.style14A6A6A6,
        ),
        onEditingComplete: () {
          node.unfocus();
        },
      ),
    );
  }

  _reasonItemWidget(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 14),
        padding: EdgeInsets.only(right: 14),
        decoration: ShapeDecoration(
          shape: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: index == widget.reasons.length - 1
                      ? Colors.transparent
                      : Color(0xFFDEDEDE),
                  style: BorderStyle.solid)),
        ),
        height: 44,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                widget.reasons[index],
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: ThemeColors.color404040,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              color: index == _currentIndex
                  ? Colors.green
                  : ThemeColors.colorA6A6A6,
            ),
          ],
        ),
      ),
    );
  }

  _contentWidget() {
    return Expanded(
      child: Container(
          color: Colors.white,
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: widget.reasons.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == widget.reasons.length) {
                return _textFieldWidget();
              }
              return _reasonItemWidget(index);
            },
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: new LayoutBuilder(
        builder: (BuildContext cotext, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: new ConstrainedBox(
              constraints:
                  new BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: new IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          widget.onCloseEvent();
                        },
                        child: Container(
                          color: Colors.black.withAlpha(153),
                        ),
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Container(
                        height: 474,
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            _headerWidget(),
                            _contentWidget(),
                            _bottomButtonWidget(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
