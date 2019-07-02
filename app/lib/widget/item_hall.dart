import 'package:flutter/material.dart';
import 'package:app/res/res_index.dart';

/*
 * 餐厅列表item Widget 
 **/
class ItemHall extends StatefulWidget {
  String imgUrl;
  String title;
  String price;
  String location;
  String remark;

  ItemHall(
      {@required this.imgUrl,
      @required this.title,
      @required this.price,
      @required this.location,
      @required this.remark});

  @override
  State<StatefulWidget> createState() {
    return ItemHallState(imgUrl, title, price, location, remark);
  }
}

class ItemHallState extends State<ItemHall> {
  String imgUrl;
  String title;
  String price;
  String location;
  String remark;

  ItemHallState(
      this.imgUrl, this.title, this.price, this.location, this.remark);

  @override
  Widget build(BuildContext context) {
    return _buildHallListItem(
      imgUrl: imgUrl,
      title: title,
      price: price,
      location: location,
      remark: remark,
    );
  }

  ///创建餐厅列表item
  Widget _buildHallListItem(
      {@required String imgUrl,
      @required String title,
      @required String price,
      @required String location,
      @required String remark}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child:
              Container(color: ThemeColors.colorD8D8D8, width: 120, height: 90, child: Image.network(imgUrl, fit: BoxFit.fill,),),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16,
                        color: ThemeColors.color404040,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 6),
                  Text(
                    price,
                    style: const TextStyle(
                        fontSize: 14, color: ThemeColors.colorD0021B),
                  ),
                  SizedBox(height: 4),
                  Text(
                    location,
                    style: const TextStyle(
                        fontSize: 12, color: ThemeColors.colorA6A6A6),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      Image.asset('assets/images/ic_message.png',
                          width: 16, height: 16),
                      SizedBox(width: 2),
                      Text(
                        remark,
                        softWrap: true,
                        style: const TextStyle(
                            fontSize: 12, color: ThemeColors.colorA6A6A6),
                      ),
                      SizedBox(width: 2),
                      Image.asset('assets/images/ic_message.png',
                          width: 16, height: 16),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(
                    height: 1,
                    color: ThemeColors.colorDEDEDE,
                  ),
                ],
              ),
              Positioned(
                right: 14,
                child: Container(
                  width: 56,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(width: 1, color: ThemeColors.colorA6A6A6),
                  ),
                  child: Text(
                    '预订',
                    style:
                        TextStyle(fontSize: 12, color: ThemeColors.color404040),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
