import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InvoiceInputWidget extends StatelessWidget {
  final bool isMutil;
  final String title;
  final String hint;
  final TextEditingController controller;
  final FocusNode node;

  const InvoiceInputWidget(
      {Key key,
      this.title,
      this.hint,
      this.controller,
      this.node,
      this.isMutil})
      : super(key: key);

  _normalWidget() {
    return Container(
      height: 50,
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 14),
        decoration: ShapeDecoration(
          shape: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 70,
              child: Text(
                title,
                style: TextStyle(
                  color: ThemeColors.color404040,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: node,
                obscureText: false,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF404040),
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFA6A6A6),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 14, right: 14),
              alignment: Alignment.center,
              width: 14,
              child: controller.text.length > 0
                  ? GestureDetector(
                      onTap: () {
                        controller.clear();
                      },
                      child: Container(
                        color: Colors.black,
                        height: 14,
                      ),
                    )
                  : SizedBox(
                      height: 14,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _mutilWidget() {
    return Container(
      constraints: BoxConstraints(maxHeight: 68, minHeight: 50),
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 14),
        padding: EdgeInsets.only(top: 14, bottom: 14),
        decoration: ShapeDecoration(
          shape: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 70,
              child: Text(
                title,
                style: TextStyle(
                  color: ThemeColors.color404040,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: node,
                obscureText: false,
                keyboardType: TextInputType.text,
                maxLines: isMutil ? null : 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF404040),
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 0),
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFA6A6A6),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 14, right: 14),
              alignment: Alignment.center,
              width: 14,
              child: controller.text.length > 0
                  ? GestureDetector(
                      onTap: () {
                        controller.clear();
                      },
                      child: Container(
                        color: Colors.black,
                        height: 14,
                      ),
                    )
                  : SizedBox(
                      height: 14,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isMutil ? _mutilWidget() : _normalWidget();
  }
}
