import 'package:app/navigator/page_route.dart';
import 'package:flutter/material.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';

/*
 * 搜索页 Page
 **/
class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  //最近搜索
  List<String> recentList;

  //热门搜索
  List<String> hotList;

  //文本控制器
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    recentList = [
      '花园酒店',
      '花悦庭',
      '雅韵',
      '蜀九香',
      '朝花熹食 · 餐饮艺术空间',
      '梵高艺术餐厅',
      '花园酒店',
      '花悦庭',
      '雅韵'
    ];
    hotList = [
      '21楼私厨',
      '101江景私厨',
      '至正小菜',
      '陶然轩',
      '陶然轩',
      '珍姐龙虾',
      '至正小菜',
      '陶然轩',
      '陶然轩',
      '珍姐龙虾'
    ];
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
                              width: 14,
                              height: 14,
                              child: Center(
                                child: Image.asset(
                                  'assets/images/ic_message.png',
                                  width: 9,
                                  height: 9,
                                  fit: BoxFit.fill,
                                ),
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
                                  child: TextField(
                                    controller: _textEditingController,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: ThemeColors.color404040),
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.search,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(top: 2),
                                      hintText: '附近热门推荐：至正小菜',
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
                            GestureDetector(
                              onTap: () => _textEditingController.clear(),
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(right: 10),
                                child: Image.asset(
                                  'assets/images/ic_message.png',
                                  width: 14,
                                  height: 14,
                                  fit: BoxFit.fill,
                                ),
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
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        alignment: Alignment.centerRight,
                                        child: Center(
                                          child: Image.asset(
                                              'assets/images/ic_message.png',
                                              width: 16,
                                              height: 14,
                                              fit: BoxFit.fill),
                                        ),
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
                            Container(
                              height: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: ThemeColors.colorD8D8D8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  '广告位',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w700,
                                      color: ThemeColors.color404040),
                                ),
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
                                    .map((f) => _buildKeyBtn(f, true))
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
  Widget _buildKeyBtn(String value, bool isHot) {
    return FlatButton(
      color: ThemeColors.colorF2F2F2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      onPressed: () {
        if (isHot) {
          Navigator.of(context).pushNamed(Page.BUSINESS_DETAIL_PAGE);
        } else {
          Navigator.of(context)
              .pushNamed(Page.SEARCH_RESULT_PAGE, arguments: value);
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
}
