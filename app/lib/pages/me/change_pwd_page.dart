import 'package:flutter/material.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/res/res_index.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:app/api/net_index.dart';

/*
 * 修改密码页 Page
 **/
class ChangePwdPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChangePwdPageState();
  }
}

class ChangePwdPageState extends State<ChangePwdPage> {
  TextEditingController _currentPwdController;
  TextEditingController _changePwdController;
  TextEditingController _newPwdController;

  FocusNode _currentFocusNode;
  FocusNode _changePwdFocusNode;
  FocusNode _newPwdFocusNode;

  //加载框
  OverlayEntry loadingDialog;

  //密码正则表达式
  String _pwdRegex = '[0-9a-zA-z]{6,20}';

  @override
  void initState() {
    super.initState();
    _currentPwdController = TextEditingController();
    _changePwdController = TextEditingController();
    _newPwdController = TextEditingController();

    _currentFocusNode = FocusNode();
    _changePwdFocusNode = FocusNode();
    _newPwdFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: ActionBar.buildActionBar(
            context,
            AppBar(
              elevation: 0,
              title: Text('密码修改', style: TextStyle(fontSize: 17)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
          ),
          body: _bodyWidget(),
        ),
        onWillPop: () {
          //加载框不消失不允许用户退出当前页面
          if (null != loadingDialog) {
            return Future.value(false);
          }
          return Future.value(true);
        });
  }

  _bodyWidget() {
    return Container(
      color: ThemeColors.colorF1F1F1,
      width: ScreenUtil.getScreenW(context),
      height: ScreenUtil.getScreenH(context) -
          44 -
          MediaQuery.of(context).padding.top,
      child: Column(
        children: <Widget>[
          SizedBox(height: ScreenUtil.getAdapterSizeCtx(context, 20)),
          _buildItem(
            title: '当前密码',
            hint: '请输入当前密码',
            textController: _currentPwdController,
            focusNode: _currentFocusNode,
            callback: (focusNode) {
              if (_currentFocusNode == focusNode) {
                FocusScope.of(context).requestFocus(_changePwdFocusNode);
              }
            },
          ),
          SizedBox(height: ScreenUtil.getAdapterSizeCtx(context, 10)),
          _buildItem(
            title: '修改密码',
            hint: '必须为6-20位字母和数字',
            textController: _changePwdController,
            focusNode: _changePwdFocusNode,
            callback: (focusNode) {
              if (_changePwdFocusNode == focusNode) {
                FocusScope.of(context).requestFocus(_newPwdFocusNode);
              }
            },
          ),
          SizedBox(height: ScreenUtil.getAdapterSizeCtx(context, 10)),
          _buildItem(
            title: '确认新密码',
            hint: '请再次输入新密码',
            textController: _newPwdController,
            focusNode: _newPwdFocusNode,
            callback: (focusNode) {
              if (_newPwdFocusNode == focusNode) {
                _newPwdFocusNode.unfocus();
              }
            },
          ),
          SizedBox(height: ScreenUtil.getAdapterSizeCtx(context, 40)),
          Container(
            width: ScreenUtil.getScreenW(context) -
                ScreenUtil.getAdapterSizeCtx(context, 28),
            height: ScreenUtil.getAdapterSizeCtx(context, 44),
            decoration: BoxDecoration(
              border: Border.all(color: ThemeColors.color555C9E, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: FlatButton(
              color: Colors.transparent,
              onPressed: _resetPwd,
              child: Text(
                '重置密码',
                style: FontStyles.style163F4688,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem({
    String title,
    String hint,
    TextEditingController textController,
    FocusNode focusNode,
    Function(FocusNode focusNode) callback,
  }) {
    return Container(
      height: ScreenUtil.getAdapterSizeCtx(context, 44),
      margin: EdgeInsets.only(
          left: ScreenUtil.getAdapterSizeCtx(context, 13),
          right: ScreenUtil.getAdapterSizeCtx(context, 13)),
      padding: EdgeInsets.only(
        left: ScreenUtil.getAdapterSizeCtx(context, 20),
        right: ScreenUtil.getAdapterSizeCtx(context, 20),
      ),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(ScreenUtil.getAdapterSizeCtx(context, 5)),
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: ThemeColors.color404040,
                fontSize: ScreenUtil.getAdapterSizeCtx(context, 14)),
          ),
          Expanded(
            child: TextFormField(
              textAlign: TextAlign.end,
              textInputAction: _newPwdFocusNode == focusNode
                  ? TextInputAction.done
                  : TextInputAction.next,
              maxLines: 1,
              style: FontStyles.style141A1A1A,
              obscureText: true,
              keyboardType: TextInputType.text,
              controller: textController,
              focusNode: focusNode,
              onFieldSubmitted: (text) => callback(focusNode),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                counterText: '',
                hintStyle: FontStyles.style14A6A6A6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///重置密码
  _resetPwd() {
    if (ObjectUtil.isEmptyString(_currentPwdController.text)) {
      Toast.toast(context, '请输入当前密码');
    } else if (!RegexUtil.matches(_pwdRegex, _changePwdController.text)) {
      Toast.toast(context, '密码格式错误');
    } else if (_changePwdController.text != _newPwdController.text) {
      Toast.toast(context, '修改新密码需要一致');
    } else {
      _showLoadingDialog();

      //模拟网络请求
      Future.delayed(Duration(seconds: 2), () {
        loadingDialog.remove();
        loadingDialog = null;
        SaveImageToast.toast(context, '重置成功', true);
      });
    }
  }

  ///显示加载框
  _showLoadingDialog() {
    loadingDialog = OverlayEntry(
        builder: (context) => LoadingDialog(
              outsideAction: () {},
            ));
    Overlay.of(context).insert(loadingDialog);
  }
}
