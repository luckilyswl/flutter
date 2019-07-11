import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

/*
 * 餐厅列表item Widget 
 **/
class ItemHall extends StatefulWidget {
  String imgUrl;
  String title;
  String price;
  String location;
  String remark;

  //是否显示预订按钮
  bool isShowBook;

  ItemHall({
    @required this.imgUrl,
    @required this.title,
    @required this.price,
    @required this.location,
    @required this.remark,
    this.isShowBook = true,
  });

  @override
  State<StatefulWidget> createState() {
    return ItemHallState();
  }
}

class ItemHallState extends State<ItemHall> {
  @override
  Widget build(BuildContext context) {
    return _buildHallListItem(
      imgUrl: widget.imgUrl,
      title: widget.title,
      price: widget.price,
      location: widget.location,
      remark: widget.remark,
    );
  }

  ///创建餐厅列表item
  Widget _buildHallListItem(
      {@required String imgUrl,
      @required String title,
      @required String price,
      @required String location,
      @required String remark}) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Container(
                  color: ThemeColors.colorD8D8D8,
                  width: 120,
                  height: 90,
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(right: 32),
                          child: Text(
                            title,
                            softWrap: true,
                            style: const TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 16,
                                color: ThemeColors.color404040,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            price,
                            style: const TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: ThemeColors.colorD0021B),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            location,
                            style: const TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: ThemeColors.colorA6A6A6),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Row(
                            children: <Widget>[
                              Image.asset('assets/images/ic_douhao_left.png',
                                  width: 14, height: 14, fit: BoxFit.fill),
                              SizedBox(width: 2),
                              Container(
                                constraints: BoxConstraints(maxWidth: 200),
                                child: Text(
                                  remark,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: ThemeColors.colorA6A6A6),
                                ),
                              ),
                              SizedBox(width: 2),
                              Image.asset('assets/images/ic_douhao_right.png',
                                  width: 14, height: 14, fit: BoxFit.fill),
                            ],
                          ),
                        ),
                      ],
                    ),
                    widget.isShowBook
                        ? Positioned(
                            right: 14,
                            child: Container(
                              width: 56,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 1, color: ThemeColors.colorA6A6A6),
                              ),
                              child: Text(
                                '预订',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    color: ThemeColors.color404040),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
        ],
      ),
    );
  }
}
