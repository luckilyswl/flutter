import 'package:app/model/enum_define.dart';
import 'package:app/model/order/order_list_bean.dart';
import 'package:app/navigator/page_route.dart';
import 'package:app/pages/me/order/order_list_page_widget.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/theme_colors.dart';
import 'package:flutter/painting.dart';

/*
 * 订单列表页面
 **/
class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex; //0：全部订单，1：待预订，2：待就餐，3：待买单
  List<Tab> _tabs = <Tab>[];
  List<int> _types = <int>[
    OrderListType.ORDER_TYPE_ALL,
    OrderListType.ORDER_TYPE_BOOK_WAITED,
    OrderListType.ORDER_TYPE_PRESENT_WAITED,
    OrderListType.ORDER_TYPE_PAY_WAITED
  ];
  TabController _tabController;
  PageController _pageController;
  PageView pageView;
  TabBar tabBar;

  @override
  void initState() {
    _currentIndex = 0;
    _tabs = <Tab>[
      Tab(text: '全部'),
      Tab(text: '待预订'),
      Tab(text: '待就餐'),
      Tab(text: '待买单'),
    ];
    _tabController = TabController(
        vsync: this, length: _tabs.length, initialIndex: _currentIndex);
    _tabController.addListener(_onTabChanged);
    tabBar = TabBar(
      controller: _tabController,
      tabs: _tabs,
      isScrollable: false,
      labelPadding: EdgeInsets.only(top: 0),
      indicatorColor: ThemeColors.color1A1A1A,
      indicatorWeight: 2,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: ThemeColors.color1A1A1A,
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelColor: ThemeColors.colorA6A6A6,
      unselectedLabelStyle:
          TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
      onTap: (int index) {
        this.setState(() {
          debugPrint(index.toString());
          _currentIndex = index;
          _pageController.animateToPage(_currentIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear);
        });
      },
    );

    _pageController =
        PageController(keepPage: true, initialPage: _currentIndex);
    pageView = PageView.builder(
      itemCount: _tabs.length,
      itemBuilder: ((context, index) {
        return OrderListPageWidget(type: _types[index], onTapEvent: (OrderListItem item) {
          Navigator.of(context).pushNamed(Page.ORDER_DETAIL_PAGE, arguments: {"orderListItem" : item});
        },);
      }),
      scrollDirection: Axis.horizontal,
      reverse: false,
      controller: _pageController,
      physics: PageScrollPhysics(parent: BouncingScrollPhysics()),
      onPageChanged: (index) {
        debugPrint(index.toString());
        _currentIndex = index;
        _tabController.animateTo(index);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _onTabChanged() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          child: AppBar(
            title: Text('我的订单'),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          decoration: BoxDecoration(
            gradient: Gradients.loginBgLinearGradient,
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 45),
      ),
      body: Container(
        color: ThemeColors.colorF2F2F2,
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 40,
                color: Colors.white,
                width: ScreenUtil.getScreenW(context),
                alignment: Alignment.center,
                child: tabBar,
              ),
              Expanded(
                child: pageView,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
