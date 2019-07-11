import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';
import 'package:app/api/net_index.dart';

/*
 * 意见反馈页面 Page
 **/
class FeedbackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FeedbackPageState();
  }
}

class FeedbackPageState extends State<FeedbackPage> {
  //输入框控制器
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActionBar.buildActionBar(
          context,
          AppBar(
            elevation: 0,
            title: Text('意见反馈', style: TextStyle(fontSize: 17)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          )),
      body: Container(
        width: ScreenUtil.getScreenW(context),
        height: ScreenUtil.getScreenH(context) -
            44 -
            MediaQuery.of(context).padding.top,
        color: ThemeColors.colorF1F1F1,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(minHeight: 175),
                margin: const EdgeInsets.only(left: 14, right: 14, top: 20),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  style: FontStyles.style141A1A1A,
                  maxLines: null,
                  maxLength: 300,
                  decoration: InputDecoration(
                    hintText: '请填写反馈信息…',
                    border: InputBorder.none,
                    counterText: '',
                    hintStyle: FontStyles.style14A6A6A6,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 44,
                width: ScreenUtil.getScreenW(context) - 28,
                margin: const EdgeInsets.only(left: 14, right: 14),
                decoration:
                    ObjectUtil.isEmptyString(_textEditingController.text)
                        ? BoxDecoration(
                            color: ThemeColors.colorA6A6A6,
                            borderRadius: BorderRadius.circular(5),
                          )
                        : BoxDecoration(
                            gradient: Gradients.blueLinearGradient,
                            borderRadius: BorderRadius.circular(5),
                          ),
                child: FlatButton(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: _submit,
                  child: Text('提交', style: FontStyles.style16FFFFFF),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///提交请求
  _submit() {
    dio.get(Api.SUBMIT,
        queryParameters: {'mess': _textEditingController.text}).then((data) {
      var body = jsonDecode(data.toString());
      CommonBean bean = CommonBean.fromJson(body);
      if (Api.SUBMIT == bean.errorCode) {
        SaveImageToast.toast(context, '提交成功', true);
      } else {
        Toast.toast(context, bean?.msg);
      }
    });
  }
}
