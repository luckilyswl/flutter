import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:flutter/material.dart';

/*
 * 通用加载中弹窗 Dialog
 * 可以通过Overlay或者PopRoute或者showDialog方法弹出
 */
class LoadingDialog extends StatelessWidget {
  ///dialog四周点击事件
  VoidCallback outsideAction;

  LoadingDialog({this.outsideAction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (null != outsideAction) {
          outsideAction();
        }
      },
      child: Container(
        color: Colors.transparent,
        width: ScreenUtil.getScreenW(context),
        height: ScreenUtil.getScreenH(context),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: ScreenUtil.getAdapterSizeCtx(context, 110),
            height: ScreenUtil.getAdapterSizeCtx(context, 110),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0x80000000),
              borderRadius: BorderRadius.circular(
                  ScreenUtil.getAdapterSizeCtx(context, 5)),
            ),
            child: SizedBox(
              width: ScreenUtil.getAdapterSizeCtx(context, 45),
              height: ScreenUtil.getAdapterSizeCtx(context, 45),
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: ScreenUtil.getAdapterSizeCtx(context, 4),
                valueColor: AlwaysStoppedAnimation<Color>(
                  ThemeColors.color96000000,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
