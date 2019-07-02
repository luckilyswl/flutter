
import 'package:app/res/res_index.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginIntroduction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 15),
            child: Align(
              alignment: Alignment.center,
              child: GradientText(
                '请上座企业版',
                textAlign: TextAlign.center,
                gradient: LinearGradient(
                    begin: Alignment(-1.0, 0.0),
                    end: Alignment(1.0, 0.0),
                    colors: [
                      ThemeColors.colorFFEFD4,
                      ThemeColors.colorFFE3B1,
                    ]),
                style: TextStyle(
                  color: Color(0xFFD7B67F),
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )),
        Container(
            margin: EdgeInsets.only(top: 5),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '值得信赖的商务接待管家',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ))
      ],
    );
  }
  
}