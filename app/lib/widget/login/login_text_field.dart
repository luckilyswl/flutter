import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {
  final String hintText;
  final FocusNode focusNode;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String imageName;
  final Widget rightWidget;

  LoginTextField(
      {Key key,
      this.hintText,
      this.focusNode,
      this.controller,
      this.obscureText,
      this.keyboardType,
      this.imageName,
      this.rightWidget})
      : super(key: key);

  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              obscureText: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: Padding(
                  padding: const EdgeInsetsDirectional.only(
                      start: 5, top: 12, end: 12, bottom: 12),
                  child: Image.asset(
                    widget.imageName,
                    width: 20,
                    height: 24,
                  ),
                ),
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFA6A6A6),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          widget.rightWidget
        ],
      ),
    );
  }
}

class RegisterTextField extends StatefulWidget {
  final String hintText;
  final String title;
  final FocusNode focusNode;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;

  RegisterTextField(
      {Key key,
      this.title,
      this.hintText,
      this.focusNode,
      this.controller,
      this.obscureText,
      this.keyboardType})
      : super(key: key);

  _RegisterTextFieldState createState() => _RegisterTextFieldState();
}

class _RegisterTextFieldState extends State<RegisterTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: ShapeDecoration(
        shape: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color(0xFFDEDEDE), style: BorderStyle.solid)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: 98,
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ThemeColors.color404040,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              obscureText: widget.obscureText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1A1A1A),
              ),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFA6A6A6),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
