import 'dart:convert';

import 'package:app/Application.dart';
import 'package:app/api/api.dart';
import 'package:app/http.dart';
import 'package:app/model/event.dart';
import 'package:app/model/req_business_list_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:flutter/material.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:app/model/home_buiness_list_bean.dart' as BusinessInfo;

/*
 * 我的收藏页面 Page
 **/
class MyCollectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyCollectPageState();
  }
}

class MyCollectPageState extends State<MyCollectPage> {
  //收藏数据
  List<BusinessInfo.BusinessList> _businessList;

  //收藏ui数据
  List<CollectModel> modelList;

  //商家列表接口请求bean
  ReqBusinessListBean reqBusinessListBean;

  //当前是否全选
  bool isSelectedAll = false;

  //是否为多选模式
  bool isChooseMode = false;

  //已选中的数量
  int selectedNum = 0;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    _businessList = [];
    modelList = [];

    ///商家列表请求数据
    reqBusinessListBean = ReqBusinessListBean();
    _getBusinessList();
  }

  ///获取商家列表
  _getBusinessList() {
    dio
        .get(Api.BUSINESS_LIST, queryParameters: reqBusinessListBean.toJson())
        .then((data) {
      var sources = jsonDecode(data.data);
      BusinessInfo.HomeBusinessInfo businessInfo =
          BusinessInfo.HomeBusinessInfo.fromJson(sources);
      if (businessInfo != null && businessInfo.errorCode == Api.SUCCESS_CODE) {
        setState(() {
          _businessList.addAll(businessInfo.data?.list);

          _businessList.forEach((f) => modelList.add(CollectModel()));
        });
      } else {
        Toast.toast(context, businessInfo.msg);
      }
    });
    print('${reqBusinessListBean.toJson()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActionBar.buildActionBar(
        context,
        AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('我的收藏', style: const TextStyle(fontSize: 17)),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  isChooseMode = !isChooseMode;
                });
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(top: 16, right: 14),
                child: Text(!isChooseMode ? '多选' : '完成',
                    style: FontStyles.style14FFFFFF),
              ),
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: 0 == _businessList.length
          ? _buildEmptyPage()
          : Container(
              width: ScreenUtil.getScreenW(context),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: ScreenUtil.getScreenW(context),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, i) {
                          return _buildCollectItem(modelList[i], i);
                        },
                        separatorBuilder: (context, i) {
                          if (isChooseMode) {
                            return Container(
                              margin: const EdgeInsets.only(left: 178),
                              height: 1,
                              color: ThemeColors.colorDEDEDE,
                            );
                          } else {
                            return Container(
                              margin: const EdgeInsets.only(left: 144),
                              height: 1,
                              color: ThemeColors.colorDEDEDE,
                            );
                          }
                        },
                        itemCount: modelList.length,
                      ),
                    ),
                  ),
                  isChooseMode
                      ? Container(
                          width: ScreenUtil.getScreenW(context),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 113,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(
                                        color: ThemeColors.colorDEDEDE,
                                        width: 1),
                                  ),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: !isSelectedAll
                                          ? Icon(Icons.radio_button_unchecked,
                                              color: ThemeColors.colorA6A6A6)
                                          : Icon(Icons.check_circle,
                                              color: ThemeColors.colorD39857),
                                      onPressed: () {
                                        setState(() {
                                          isSelectedAll = !isSelectedAll;
                                          selectedNum = isSelectedAll
                                              ? modelList.length
                                              : 0;
                                          modelList.forEach((f) =>
                                              f.isSelected = isSelectedAll);
                                        });
                                      },
                                    ),
                                    SizedBox(width: 2),
                                    Text('全选', style: FontStyles.style14404040),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  color: ThemeColors.color404040,
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return SizedBox(
                                                height: 157,
                                                child:
                                                    _buildBottomSureDialog());
                                          });
                                    },
                                    child: Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      child: Text('取消关注（$selectedNum）',
                                          style: FontStyles.style16FFFFFF),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ),
    );
  }

  ///创建收藏夹为空页面
  Widget _buildEmptyPage() {
    return Container(
      width: ScreenUtil.getScreenW(context),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 28),
            color: Colors.grey,
            width: 180,
            height: 180,
          ),
          SizedBox(height: 14),
          Text('“ 暂未收藏餐厅 ”', style: FontStyles.style14A6A6A6),
          SizedBox(height: 40),
          Container(
            width: ScreenUtil.getScreenW(context) - 80,
            height: 44,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: ThemeColors.color979797, width: 1)),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              onPressed: () {
                Application.getEventBus().fire(EventType.goHome);
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(Page.ROOT_PAGE));
              },
              child: Text('去逛逛',
                  textAlign: TextAlign.center, style: FontStyles.style16404040),
            ),
          ),
        ],
      ),
    );
  }

  //创建收藏item
  Widget _buildCollectItem(CollectModel model, int index) {
    return SizedBox(
      width: ScreenUtil.getScreenW(context),
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              isChooseMode
                  ? Container(
                      width: 48,
                      child: IconButton(
                        icon: model.isSelected
                            ? Icon(Icons.check_circle,
                                color: ThemeColors.colorD39857)
                            : Icon(Icons.radio_button_unchecked,
                                color: ThemeColors.colorA6A6A6),
                        onPressed: () {
                          setState(() {
                            model.isSelected = !model.isSelected;
                            model.isSelected ? selectedNum++ : selectedNum--;
                          });
                        },
                      ),
                    )
                  : SizedBox(),
              Expanded(
                child: ItemHall(
                  imgUrl: _businessList[index]?.imgUrl,
                  title: _businessList[index]?.title,
                  price: '¥' + _businessList[index]?.perPerson + "/人",
                  location: _businessList[index]?.dishes +
                      ' | ' +
                      _businessList[index]?.zoneName +
                      " · " +
                      _businessList[index]?.distance,
                  remark: _businessList[index]?.shopName,
                  isShowBook: false,
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
                icon: model.isCollected
                    ? Icon(Icons.favorite, color: ThemeColors.colorD0021B)
                    : Icon(Icons.favorite_border,
                        color: ThemeColors.colorDEDEDE),
                onPressed: () {
                  setState(() {
                    model.isCollected = !model.isCollected;
                  });
                }),
          ),
        ],
      ),
    );
  }

  ///创建确认取消 BottomSheet
  Widget _buildBottomSureDialog() {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {},
          child: Container(
            width: ScreenUtil.getScreenW(context),
            height: 50,
            alignment: Alignment.center,
            color: Colors.white,
            child: Text('确定要取消关注$selectedNum家餐厅吗?',
                style: FontStyles.style12A6A6A6),
          ),
        ),
        Container(height: 1, color: ThemeColors.colorDEDEDE),
        Container(
          width: ScreenUtil.getScreenW(context),
          height: 50,
          child: FlatButton(
            color: Colors.white,
            onPressed: () {
              Toast.toast(context, '你点击了确定');
              Navigator.of(context).pop();
            },
            child: Text(
              '确定',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: ThemeColors.colorD0021B,
              ),
            ),
          ),
        ),
        Container(
          height: 6,
          width: ScreenUtil.getScreenW(context),
          color: ThemeColors.colorF2F2F2,
        ),
        Container(
          width: ScreenUtil.getScreenW(context),
          height: 50,
          child: FlatButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              '取消',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: ThemeColors.color404040,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CollectModel {
  bool isCollected;
  bool isSelected;

  CollectModel({this.isCollected = true, this.isSelected = false});

  CollectModel.fromJson(Map<String, dynamic> json) {
    this.isCollected = json['isCollected'];
    this.isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isCollected'] = this.isCollected;
    data['isSelected'] = this.isSelected;
    return data;
  }
}
