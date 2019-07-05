import 'dart:async';

import 'package:app/model/business_detail_bean.dart';
import 'package:app/utils/screen_util.dart';
import 'package:flutter/material.dart';

typedef void OnTapBannerItem(Photos story);

class Banner extends StatefulWidget {
  final List<Photos> bannerStories;
  final OnTapBannerItem onTap;
  final bool autoScroll;

  Banner(this.bannerStories, this.onTap, {Key key, this.autoScroll = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BannerState();
  }
}

class _BannerState extends State<Banner> {
  int virtualIndex = 0;
  int realIndex = 1;
  PageController controller;
  Timer timer;
  String _title;
  String _subTitle;
  List<Photos> _bannerStories;

  @override
  void initState() {
    super.initState();
    _bannerStories = widget.bannerStories;
    _title = _bannerStories[0].title;
    _subTitle = _bannerStories[0].subTitle;
    controller = PageController(initialPage: realIndex);
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      // 自动滚动
      /// print(realIndex);
      controller.animateToPage(realIndex + 1,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.getScreenW(context),
      height: 250.0,
      child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
        PageView(
          controller: controller,
          onPageChanged: _onPageChanged,
          children: _buildItems(),
        ),
        Positioned(
          bottom: 0,
          child: new Container(
            height: 56,
            width: ScreenUtil.getScreenW(context),
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                image: new DecorationImage(
                    image: AssetImage('assets/images/banner_bottom.png'),
                    fit: BoxFit.fill)),
          ),
        ),
        Positioned(
          left: 14,
          bottom: 0.0,
          right: 80,
          child: new Container(
              alignment: Alignment.centerLeft,
              height: 56,
              width: ScreenUtil.getScreenW(context),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    _title != null ? _title : "",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  new Text(
                    _subTitle != null ? _subTitle : "",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: _numberIndicator(
              context, virtualIndex, widget.bannerStories.length),
        ),
      ]),
    );
  }

  /// pagination 的计数器
  Widget _numberIndicator(BuildContext context, int index, int itemCount) {
    return Container(
      margin: EdgeInsets.only(right: 10.0, bottom: 12),
      child: RichText(
          textAlign: TextAlign.right,
          text: TextSpan(
              text: "${++index}\n",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: "/ $itemCount",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white))
              ])),
    );
  }

  List<Widget> _buildItems() {
    // 排列轮播数组
    List<Widget> items = [];
    if (_bannerStories.length > 0) {
      // 头部添加一个尾部Item，模拟循环
      items.add(_buildItem(_bannerStories[_bannerStories.length - 1]));
      // 正常添加Item
      items.addAll(_bannerStories
          .map((story) => _buildItem(story))
          .toList(growable: false));
      // 尾部
      items.add(_buildItem(_bannerStories[0]));
    }
    return items;
  }

  Widget _buildItem(Photos story) {
    return GestureDetector(
      onTap: () {
        // 按下
        if (widget.onTap != null) {
          widget.onTap(story);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(story.src, fit: BoxFit.cover),
        ],
      ),
    );
  }

  _onPageChanged(int index) {
    realIndex = index;
    int count = _bannerStories.length;
    if (index == 0) {
      virtualIndex = count - 1;
      controller.jumpToPage(count);
    } else if (index == count + 1) {
      virtualIndex = 0;
      controller.jumpToPage(1);
    } else {
      virtualIndex = index - 1;
    }
    setState(() {
      _title = _bannerStories[virtualIndex].title;
      _subTitle = _bannerStories[virtualIndex].subTitle;
    });
  }
}
