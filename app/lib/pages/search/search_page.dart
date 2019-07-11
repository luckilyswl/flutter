import 'package:app/api/net_index.dart';
import 'package:app/model/req_business_list_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:flutter/material.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/api/api.dart';
import 'package:app/widget/widgets_index.dart';
import 'dart:convert';
import 'package:app/http.dart';
import 'package:app/model/search_page_bean.dart';
import 'package:app/pages/pages_index.dart';
import 'package:flutter_lifecycle_state/flutter_lifecycle_state.dart';
import 'package:app/constant.dart';

/*
 * 搜索页 Page
 **/
class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends StateWithLifecycle<SearchPage> {
  //商家列表接口请求bean
  ReqBusinessListBean reqBusinessListBean;

  //最近搜索
  List<String> recentList = [];

  //热门搜索
  List<HotSearchListBean> hotList = [];

  //文本控制器
  TextEditingController _textEditingController;

  //输入框焦点控制
  FocusNode _focusNode;

  //是否已经初始化页面
  bool isInit = false;

  //输入框hint值
  String hintText;

  //广告图
  String imgUrl = '';

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();

    //从sp中获取推荐内容
    hintText =
        SpUtil.getString(Constant.sp_search_motion, defValue: '附近热门推荐：') +
            SpUtil.getString(Constant.sp_search_tip, defValue: '至正小菜');

    _textEditingController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((time) {
      initData();
      if (!isInit) {
        Future.delayed(Duration(milliseconds: 200), () {
          if (!_focusNode.hasFocus) {
            FocusScope.of(context).requestFocus(_focusNode);
            isInit = true;
          }
        });
      }
    });

    reqBusinessListBean = ReqBusinessListBean();
  }

  void onResume() {
    super.onResume();
    Future.delayed(Duration(milliseconds: 200), () {
      if (!_focusNode.hasFocus && isInit) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
      initData();
    });
  }

  void onPause() {
    super.onPause();
    if (null != _focusNode) {
      _focusNode.unfocus();
    }
  }

  ///网络请求
  initData() {
    ///搜索页接口
    dio.get(Api.SEARCH_PAGE_DATA).then((data) {
      var body = jsonDecode(data.toString());
      SearchPageBean bean = SearchPageBean.fromJson(body);
      if (Api.SUCCESS_CODE == bean.error_code) {
        setState(() {
          recentList = bean.data.history;
          recentList ??= [];
          hotList = bean.data.hotSearch;
          hotList ??= [];
          imgUrl = ObjectUtil.isEmptyList(bean.data?.banner)
              ? ''
              : bean.data?.banner[0]?.imgUrl;
        });
      } else {
        Toast.toast(context, bean?.msg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: ScreenUtil.getScreenW(context),
              height: 75,
              decoration: BoxDecoration(gradient: Gradients.blueLinearGradient),
            ),
            Expanded(
              child: Container(color: Colors.white),
            ),
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                width: ScreenUtil.getScreenW(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                          color: ThemeColors.colorF2F2F2,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 10),
                            SizedBox(
                              child: Center(
                                child: Icon(Icons.search),
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Container(
                                height: 28,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(right: 12),
                                child: Material(
                                  color: Colors.transparent,
                                  child: TextFormField(
                                    focusNode: _focusNode,
                                    controller: _textEditingController,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: ThemeColors.color404040),
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.search,
                                    onFieldSubmitted: (text) {
                                      reqBusinessListBean.keywords = text;
                                      Navigator.of(context).pushNamed(
                                          Page.SEARCH_RESULT_PAGE,
                                          arguments: reqBusinessListBean);
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(top: 2),
                                      hintText: hintText,
                                      border: InputBorder.none,
                                      hintStyle: const TextStyle(
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                          color: ThemeColors.colorA6A6A6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            0 == _textEditingController.text.length
                                ? SizedBox()
                                : GestureDetector(
                                    onTap: () => _textEditingController.clear(),
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Icon(Icons.clear),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 50,
                        color: Colors.transparent,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          '取消',
                          style: const TextStyle(
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1),
              Container(
                width: ScreenUtil.getScreenW(context),
                height: ScreenUtil.getScreenH(context) -
                    50 -
                    MediaQuery.of(context).padding.top,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                          height: 20, width: ScreenUtil.getScreenW(context)),
                      Container(
                        width: ScreenUtil.getScreenW(context),
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '最近搜索',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: ThemeColors.color404040,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: _clickDelete,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 46, top: 10),
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: 10,
                                alignment: WrapAlignment.start,
                                children: recentList
                                    .map((f) => _buildKeyBtn(f, false))
                                    .toList(),
                              ),
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: () => Toast.toast(context, '跳转充值页'),
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: ThemeColors.colorD8D8D8,
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                        image: NetworkImage(imgUrl),
                                        fit: BoxFit.fitWidth)),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              '热门搜索',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 16,
                                color: ThemeColors.color404040,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 46, top: 10),
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: 10,
                                alignment: WrapAlignment.start,
                                children: hotList
                                    .map((f) => _buildKeyBtn(f.shopName, true,
                                        id: f.id))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///创建文字按钮
  Widget _buildKeyBtn(String value, bool isHot, {int id = 0}) {
    return FlatButton(
      color: ThemeColors.colorF2F2F2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      onPressed: () {
        if (isHot) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => BusinessDetailPage(id)));
        } else {
          reqBusinessListBean.keywords = value;
          Navigator.of(context).pushNamed(Page.SEARCH_RESULT_PAGE,
              arguments: reqBusinessListBean);
        }
      },
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          color: ThemeColors.color404040,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  ///删除最近搜索点击事件
  _clickDelete() {
    dio.get(Api.SEARCH_DELETE).then((data) {
      var body = jsonDecode(data.toString());
      CommonBean bean = CommonBean.fromJson(body);
      if (Api.SUCCESS_CODE == bean?.errorCode) {
        if (!ObjectUtil.isEmptyList(hotList)) {
          hotList.clear();
        }
        Toast.toast(context, '清除成功');
      } else {
        Toast.toast(context, bean?.msg);
      }
    });
  }
}
