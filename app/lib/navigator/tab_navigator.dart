import 'package:app/Application.dart';
import 'package:flutter/material.dart';
import 'package:app/model/event.dart';
import 'package:app/res/res_index.dart';
import 'package:app/pages/pages_index.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = ThemeColors.colorA6A6A6;
  final _activeColor = ThemeColors.color1A1A1A;
  int _currentIndex = 0;

  List<BottomNavigationBarItem> _items = [];
  List<Widget> _widgets = [];

  PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = new PageController(initialPage: 0);

    // 根据不同事件处理
    Application.getEventBus().on<String>().listen((event) {
      if (this.mounted) {
        setState(() {
          if (event == EventType.goServer) {
            _currentIndex = 2;
            _controller.jumpToPage(2);
          } else if (event == EventType.goHome) {
            _currentIndex = 0;
            _controller.jumpToPage(0);
          }
        });
      }
    });

    _widgets = [HomePage(), ManagerPage(), CustomerServicePage(), MyPage()];
    _items = [
      BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/tab_unselect_home.png',
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            'assets/images/tab_select_home.png',
            width: 24,
            height: 24,
          ),
          title: Text(
            '首页',
            style: TextStyle(
                color: _currentIndex != 0 ? _defaultColor : _activeColor),
          )),
      BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/tab_unselect_manager.png',
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            'assets/images/tab_unselect_manager.png',
            width: 24,
            height: 24,
          ),
          title: Text(
            '管理',
            style: TextStyle(
                color: _currentIndex != 1 ? _defaultColor : _activeColor),
          )),
      BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/tab_unselect_service.png',
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            'assets/images/tab_select_service.png',
            width: 24,
            height: 24,
          ),
          title: Text(
            '客服',
            style: TextStyle(
                color: _currentIndex != 2 ? _defaultColor : _activeColor),
          )),
      BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/tab_unselect_me.png',
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            'assets/images/tab_select_me.png',
            width: 24,
            height: 24,
          ),
          title: Text(
            '我的',
            style: TextStyle(
                color: _currentIndex != 3 ? _defaultColor : _activeColor),
          )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: _widgets,
        // 禁止滑动
        physics: new NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              debugPrint("currentindex:" + index.toString());
              _currentIndex = index;
            });
            _controller.jumpToPage(index);
          },
          type: BottomNavigationBarType.fixed,
          items: _items),
    );
  }
}
