import 'package:app/pages/business/imageviewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/model/business_detail_bean.dart';
import 'package:app/pages/business/banner.dart' as Banner;

class Pagination extends StatelessWidget {
  final List<Photos> _photos;
  final String _title, _subTitle;
  final BuildContext context;
  Pagination(this.context, this._photos, this._title, this._subTitle);

  final List<Photos> bannerStories = [];

  @override
  Widget build(BuildContext context) {
    _photos.forEach((item) {
      item.title = _title;
      item.subTitle = _subTitle;
      bannerStories.add(item);
    });
    return Column(children: _pageSelector(context));
  }

  List<Widget> _pageSelector(BuildContext context) {
    List<Widget> list = [];
    if (_photos.length > 0) {
      list.add(Banner.Banner(bannerStories, (story) {
        Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
          return ImageViewer(bannerStories.indexOf(story), bannerStories);
        }));
      }));
    }
    return list;
  }
}
