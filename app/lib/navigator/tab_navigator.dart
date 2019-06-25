import 'package:flutter/material.dart';
import 'package:app/pages/home/home_page.dart';
import 'package:app/pages/me/my_page.dart';
import 'package:app/pages/manager/manager.dart';
import 'package:app/pages/customer_service/customer_service_page.dart';
import 'package:app/res/theme_colors.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = ThemeColors.colorA6A6A6;
  final _activeColor = ThemeColors.color1A1A1A;
  int _currentIndex = 0;
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[
          HomePage(),
          ManagerPage(),
          CustomerServicePage(),
          MyPage(),
        ],
        // 禁止滑动
        physics: new NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _controller.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, color: _defaultColor),
                activeIcon: Icon(Icons.home, color: _activeColor),
                title: Text(
                  '首页',
                  style: TextStyle(
                      color: _currentIndex != 0 ? _defaultColor : _activeColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.apps, color: _defaultColor),
                activeIcon: Icon(Icons.apps, color: _activeColor),
                title: Text(
                  '管理',
                  style: TextStyle(
                      color: _currentIndex != 1 ? _defaultColor : _activeColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.mode_comment, color: _defaultColor),
                activeIcon: Icon(Icons.mode_comment, color: _activeColor),
                title: Text(
                  '客服',
                  style: TextStyle(
                      color: _currentIndex != 2 ? _defaultColor : _activeColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle, color: _defaultColor),
                activeIcon: Icon(Icons.account_circle, color: _activeColor),
                title: Text(
                  '我的',
                  style: TextStyle(
                      color: _currentIndex != 3 ? _defaultColor : _activeColor),
                )),
          ]),
    );
  }
}
