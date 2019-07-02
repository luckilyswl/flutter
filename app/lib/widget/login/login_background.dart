import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({Key key}) : super(key: key);

  _buildBgWidge() {
    return Container(
        color: Color(0xFFF3F3F3),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
                height: 230,
                decoration: BoxDecoration(
                  gradient: Gradients.loginBgLinearGradient,
                )),
            Expanded(
              child: Container(color: Color(0xFFF3F3F3)),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildBgWidge(),
    );
  }
}
