import 'package:app/pages/pages_index.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';

/*
 * 账号与安全页面 Page
 **/
class AccountAndSafePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AccountAndSafePageState();
  }
}

class AccountAndSafePageState extends State<AccountAndSafePage> {
  String _phone = '';
  String _wechat = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActionBar.buildActionBar(
        context,
        AppBar(
          elevation: 0,
          title: Text('账号与安全', style: TextStyle(fontSize: 17)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
      ),
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return Container(
      color: ThemeColors.colorF1F1F1,
      width: ScreenUtil.getScreenW(context),
      child: Column(
        children: <Widget>[
          SizedBox(height: ScreenUtil.getAdapterSizeCtx(context, 20)),
          buildItemMore(
            title: '绑定手机',
            moreText: _phone,
            callback: () =>
                Navigator.of(context).pushNamed(Page.BINDED_PHONE_PAGE),
          ),
          SizedBox(height: ScreenUtil.getAdapterSizeCtx(context, 10)),
          buildItemMore(
            title: '修改密码',
            callback: () =>
                Navigator.of(context).pushNamed(Page.CHANGE_PWD_PAGE),
          ),
          SizedBox(height: ScreenUtil.getAdapterSizeCtx(context, 10)),
          buildItemMore(
              title: '关联微信',
              moreText: ObjectUtil.isEmptyString(_wechat) ? '未绑定' : _wechat,
              callback: () {
                if (ObjectUtil.isEmptyString(_wechat)) {
                  _bindWechat();
                } else {
                  _untiedWechat();
                }
              }),
        ],
      ),
    );
  }

  Widget buildItemMore({
    String title,
    String moreText = '',
    Callback callback,
  }) {
    bool isShowMoreText = moreText.isEmpty;
    return Container(
      height: ScreenUtil.getAdapterSizeCtx(context, 44),
      margin: EdgeInsets.only(
          left: ScreenUtil.getAdapterSizeCtx(context, 13),
          right: ScreenUtil.getAdapterSizeCtx(context, 13)),
      child: FlatButton(
        onPressed: callback,
        color: Colors.white,
        padding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                ScreenUtil.getAdapterSizeCtx(context, 5))),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  left: ScreenUtil.getAdapterSizeCtx(context, 20)),
              child: Text(
                title,
                style: FontStyles.style14404040,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Offstage(
                    offstage: isShowMoreText,
                    child: Container(
                      margin: EdgeInsets.only(
                          right: ScreenUtil.getAdapterSizeCtx(context, 9)),
                      child: Text(
                        moreText,
                        style: FontStyles.style14404040,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      right: ScreenUtil.getAdapterSizeCtx(context, 17),
                    ),
                    child: Image.asset(
                      'assets/images/ic_more.png',
                      width: ScreenUtil.getAdapterSizeCtx(context, 16),
                      height: ScreenUtil.getAdapterSizeCtx(context, 16),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///绑定微信
  _bindWechat() {}

  ///解绑微信
  _untiedWechat() {
    showDialog(
      context: context,
      builder: (context) => CommonDialog(
            title: '解绑微信账号',
            message: '解除微信账号后你将无法继续使用它登录该请上座账号',
            isMessageCenter: true,
            negativeText: '考虑一下',
            positiveText: '确认解绑',
            onCloseEvent: () => Navigator.of(context).pop(),
            onPositivePressEvent: () => Navigator.of(context).pop(),
          ),
    );
  }
}
