import 'package:app/constant.dart';
import 'package:app/pages/pages_index.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:flutter/material.dart';

/*
 * 引导页 Page
 */
class GuidePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GuidePageState();
  }
}

class GuidePageState extends State<GuidePage> {
  PageController _pageController;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: ScreenUtil.getScreenW(context),
        height: ScreenUtil.getScreenH(context),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                  top: ScreenUtil.getAdapterSizeCtx(context, 45),
                  left: ScreenUtil.getAdapterSizeCtx(context, 30)),
              child: Text(
                '轻松搞定',
                style: TextStyle(
                  fontSize: ScreenUtil.getAdapterSizeCtx(context, 40),
                  color: ThemeColors.color404040,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            SizedBox(height: ScreenUtil.getAdapterSizeCtx(context, 6)),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                  top: ScreenUtil.getAdapterSizeCtx(context, 6),
                  left: ScreenUtil.getAdapterSizeCtx(context, 30)),
              child: Text(
                '预订结账 / 审批管理',
                style: FontStyles.style20A6A6A6,
              ),
            ),
            SizedBox(height: ScreenUtil.getAdapterSizeCtx(context, 45)),
            SizedBox(
              width: ScreenUtil.getScreenW(context),
              height: ScreenUtil.getAdapterSizeCtx(context, 289),
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _buildGuideItem(),
                  _buildGuideItem(),
                  _buildGuideItem(),
                ],
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            SizedBox(height: ScreenUtil.getAdapterSizeCtx(context, 57)),
            _buildIndicators(),
            SizedBox(height: ScreenUtil.getAdapterSizeCtx(context, 40)),
            Container(
              width: ScreenUtil.getScreenW(context) -
                  ScreenUtil.getAdapterSizeCtx(context, 80),
              height: ScreenUtil.getAdapterSizeCtx(context, 44),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    ScreenUtil.getAdapterSizeCtx(context, 22)),
                border: Border.all(color: ThemeColors.color979797, width: 1),
              ),
              child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        ScreenUtil.getAdapterSizeCtx(context, 22)),
                  ),
                  onPressed: () {
                    //标志已经启动过引导页
                    SpUtil.putInt(Constant.flag_guide, 1);
                    Future.delayed(
                        Duration(milliseconds: 120),
                        () => Navigator.of(context)
                            .pushReplacementNamed(Page.ROOT_PAGE));
                  },
                  child: Text('马上体验', style: FontStyles.style16A6A6A6)),
            ),
          ],
        ),
      ),
    );
  }

  ///创建引导页item
  Widget _buildGuideItem() {
    return Container(
      width: ScreenUtil.getAdapterSizeCtx(context, 289),
      height: ScreenUtil.getAdapterSizeCtx(context, 289),
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: ThemeColors.colorD8D8D8),
    );
  }

  ///创建引导页指示器
  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: ScreenUtil.getAdapterSizeCtx(context, 8),
          height: ScreenUtil.getAdapterSizeCtx(context, 8),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: 0 == _currentIndex
                  ? ThemeColors.color1A1A1A
                  : Color.fromARGB(26, 26, 26, 1)),
        ),
        SizedBox(width: ScreenUtil.getAdapterSizeCtx(context, 8)),
        Container(
          width: ScreenUtil.getAdapterSizeCtx(context, 8),
          height: ScreenUtil.getAdapterSizeCtx(context, 8),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: 1 == _currentIndex
                  ? ThemeColors.color1A1A1A
                  : Color.fromARGB(26, 26, 26, 1)),
        ),
        SizedBox(width: ScreenUtil.getAdapterSizeCtx(context, 8)),
        Container(
          width: ScreenUtil.getAdapterSizeCtx(context, 8),
          height: ScreenUtil.getAdapterSizeCtx(context, 8),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: 2 == _currentIndex
                  ? ThemeColors.color1A1A1A
                  : Color.fromARGB(26, 26, 26, 1)),
        ),
      ],
    );
  }
}
