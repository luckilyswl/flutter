import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

/*
 * 精选菜单 Widget 
 **/
class BusinessMenu extends StatefulWidget {
  MenuModel menu;

  VoidCallback callback;

  BusinessMenu({this.menu, this.callback});

  @override
  State<StatefulWidget> createState() {
    return BusinessMenuState();
  }
}

class BusinessMenuState extends State<BusinessMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 169,
      height: !widget.menu.isExpanded
          ? widget.menu.minHeight
          : widget.menu.maxHeight,
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: ThemeColors.colorDEDEDE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 14),
          Text(
            widget.menu?.title,
            style: new TextStyle(
              fontSize: 14,
              color: ThemeColors.color404040,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '(${widget.menu?.numPeople}人)',
            style: FontStyles.style12A6A6A6,
          ),
          SizedBox(height: 6),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              if (0 == widget.menu.menus.length ||
                  (2 > widget.menu.menus.length && 1 == i)) {
                return SizedBox();
              }
              return IntrinsicHeight(
                child: Container(
                  height: 20,
                  alignment: Alignment.center,
                  child: Text(
                    widget.menu?.menus[i],
                    style: FontStyles.style10404040,
                  ),
                ),
              );
            },
            separatorBuilder: (context, i) {
              return SizedBox();
            },
            itemCount: !widget.menu.isExpanded ? 2 : widget.menu.menus.length,
          ),
          widget.menu.isExpanded ? SizedBox(height: 8) : SizedBox(),
          widget.menu.isExpanded
              ? Text(
                  '${widget.menu?.perPrice}',
                  style: FontStyles.style10D39857,
                )
              : SizedBox(),
          SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              setState(() {
                widget.menu.isExpanded = !widget.menu.isExpanded;
              });
              widget.callback();
            },
            child: Container(
              height: 15,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.menu.isExpanded ? '收起' : '展开',
                    style: FontStyles.style10A6A6A6,
                  ),
                  SizedBox(width: 5),
                  Image.asset(
                    widget.menu.isExpanded
                        ? 'assets/images/ic_up_g.png'
                        : 'assets/images/ic_down_g.png',
                    width: 10,
                    height: 12,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 14),
        ],
      ),
    );
  }
}

class MenuModel {
  String title;
  String numPeople;
  String perPrice;
  double minHeight;
  double maxHeight;
  List<String> menus;
  bool isExpanded;

  MenuModel(
      {@required this.title,
      @required this.numPeople,
      @required this.perPrice,
      @required this.menus,
      this.isExpanded = false,
      this.minHeight = 150,
      this.maxHeight});

  MenuModel.fromJson(Map<String, dynamic> json) {
    this.title = json['title'];
    this.numPeople = json['numPeople'];
    this.perPrice = json['perPrice'];
    this.isExpanded = json['isExpanded'];
    this.minHeight = json['minHeight'];
    this.maxHeight = json['maxHeight'];

    List<dynamic> menuList = json['menus'];
    this.menus = new List();
    this.menus.addAll(menuList.map((o) => o.toString()));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['numPeople'] = this.numPeople;
    data['perPrice'] = this.perPrice;
    data['menus'] = this.menus;
    data['isExpanded'] = this.isExpanded;
    data['minHeight'] = this.minHeight;
    data['maxHeight'] = this.maxHeight;
    return data;
  }
}
