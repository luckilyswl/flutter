import 'package:flutter/material.dart';

/*
*  保存相册 Toast
**/
class SaveImageToast {
  static OverlayEntry _overlayEntry; // toast靠它加到屏幕上
  static bool _showing = false; // toast是否正在showing
  static DateTime _startedTime; // 开启一个新toast的当前时间，用于对比是否已经展示了足够时间
  static String _msg;
  static bool _isSuccess = true; // 是否成功

  static void toast(BuildContext context, String msg, bool isSuccess) async {
    assert(msg != null);
    _msg = msg;
    _isSuccess = isSuccess;
    _startedTime = DateTime.now();
    // 获取OverlayState
    OverlayState overlayState = Overlay.of(context);
    _showing = true;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Positioned(
                child: new Center(
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 80.0),
                        child: AnimatedOpacity(
                          opacity: _showing ? 1.0 : 0.0, //目标透明度
                          duration: _showing
                              ? Duration(milliseconds: 100)
                              : Duration(milliseconds: 400),
                          child: _buildToastWidget(),
                        ),
                      )),
                ),
              ));
      overlayState.insert(_overlayEntry);
    } else {
      // 重新绘制UI，类似setState
      _overlayEntry.markNeedsBuild();
    }
    await Future.delayed(Duration(milliseconds: 2000)); //等待两秒

    // 2秒后 到底消失不消失
    if (DateTime.now().difference(_startedTime).inMilliseconds >= 2000) {
      _showing = false;
      _overlayEntry.markNeedsBuild();
    }
  }

  // toast绘制
  static _buildToastWidget() {
    return Center(
        child: Container(
            height: 110,
            width: 110,
            child: Card(
              color: Color(0x80000000),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    _isSuccess ? 'assets/images/ic_save_success.png'
                        : 'assets/images/ic_save_failed.png',
                    width: 45,
                    height: 45,
                  ),
                  Text(
                    _msg,
                    style: new TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            )
        )
    );
  }
}