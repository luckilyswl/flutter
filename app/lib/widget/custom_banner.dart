import 'dart:async';

import 'package:flutter/material.dart';

typedef void OnTapBannerItem(int id);
typedef void OnPageChange(int id);

/*
 * 自定义无限滚动Banner Widget
 **/
class CustomBanner extends StatefulWidget {
  final List<ImgModel> bannerStories;
  final OnTapBannerItem onTap;
  final OnPageChange onPageChange;
  final bool autoScroll;

  CustomBanner(
      {Key key,
      this.bannerStories,
      this.onTap,
      this.onPageChange,
      this.autoScroll = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomBannerState();
  }
}

class _CustomBannerState extends State<CustomBanner> {
  int virtualIndex = 0;
  int realIndex = 1;
  PageController controller;
  Timer timer;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: realIndex);
    if (widget.autoScroll) {
      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        // 自动滚动
        controller.animateToPage(realIndex + 1,
            duration: Duration(milliseconds: 300), curve: Curves.linear);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      onPageChanged: _onPageChanged,
      children: _buildItems(),
    );
  }

  List<Widget> _buildItems() {
    // 排列轮播数组
    List<Widget> items = [];
    if (widget.bannerStories.length > 0) {
      // 头部添加一个尾部Item，模拟循环
      items.add(
          _buildItem(widget.bannerStories[widget.bannerStories.length - 1]));
      // 正常添加Item
      items.addAll(widget.bannerStories
          .map((model) => _buildItem(model))
          .toList(growable: false));
      // 尾部
      items.add(_buildItem(widget.bannerStories[0]));
    }
    return items;
  }

  Widget _buildItem(ImgModel model) {
    return GestureDetector(
      onTap: () => widget?.onTap(model.id),
//      child: Image.network(widget.bannerStories[index], fit: BoxFit.cover),
      child: Image.asset(model.imgUrl, fit: BoxFit.cover),
    );
  }

  _onPageChanged(int index) {
    realIndex = index;
    int count = widget.bannerStories.length;
    if (index == 0) {
      virtualIndex = count - 1;
      controller.jumpToPage(count);
    } else if (index == count + 1) {
      virtualIndex = 0;
      controller.jumpToPage(1);
    } else {
      virtualIndex = index - 1;
    }
    widget.onPageChange(widget.bannerStories[virtualIndex].id);
  }
}

class ImgModel {
  String imgUrl;
  int id;

  ImgModel({this.imgUrl, this.id});

  ImgModel.fromJson(Map<String, dynamic> json) {
    this.imgUrl = json['imgUrl'];
    this.id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imgUrl'] = this.imgUrl;
    data['id'] = this.id;
    return data;
  }
}
