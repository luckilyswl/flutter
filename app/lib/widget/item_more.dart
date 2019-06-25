import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';

//定义回调接口
typedef Callback = void Function();

/*
 * 更多子目录item Widget
 **/
class ItemMore {
  ///我的页面更多item
  static Widget buildItemMore(
      String icon, String title, String moreIcon, Callback callback,
      {String moreText = ""}) {
    bool isShowMoreText = moreText.isEmpty;

    ///这里用Material可以解决InkWell因为填色而水波纹无效问题
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: callback,
        child: Container(
          height: 44,
          padding: const EdgeInsets.only(left: 14, right: 14),
          child: Row(
            children: <Widget>[
              Image.asset(
                icon,
                width: 16,
                height: 16,
                fit: BoxFit.fill,
              ),
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: Text(
                  title,
                  style:
                      TextStyle(color: ThemeColors.color404040, fontSize: 14),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Offstage(
                      offstage: isShowMoreText,
                      child: Text(
                        moreText,
                        style: TextStyle(
                            color: ThemeColors.color404040, fontSize: 14),
                      ),
                    ),
                    Image.asset(
                      moreIcon,
                      width: 16,
                      height: 16,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
