import 'package:app/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

/// 文章页 page
class ArticlePage extends StatefulWidget {
  final int articleId;

  ArticlePage({@required this.articleId});

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String _article = "";
  String _title = "文章标题";

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff262626),
        centerTitle: true,
        title: Text(
          _title,
          style: new TextStyle(fontSize: 16, color: Colors.white),
        ),
        actions: <Widget>[
          new GestureDetector(
            onTap: () {
              Toast.toast(context, '分享');
            },
            child: new Container(
              margin: EdgeInsets.only(right: 16),
              alignment: Alignment.centerRight,
              child: new Text(
                '分享',
                style: new TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    return SingleChildScrollView(
      physics: new NeverScrollableScrollPhysics(),
      child: new Html(
        padding: EdgeInsets.all(0),
        data: _article,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
