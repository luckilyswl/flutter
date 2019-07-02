import 'package:flutter/material.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';

/*
 * 城市选择器 Widget
 **/
class CitySelectorPopupWindow extends StatefulWidget {
  String position;
  double margin;

  List<CityModel> cityList;

  //消失控制
  final VoidCallback dismissAction;

  //回调
  final Function(int index) callback;

  CitySelectorPopupWindow(
      {@required this.position = '正在定位',
      @required this.margin,
      @required this.cityList,
      @required this.callback,
      @required this.dismissAction});

  CitySelectorPopupWindowState state = CitySelectorPopupWindowState();

  set setPosition(String p) {
    this.position = p;
    state.update();
  }

  @override
  State<StatefulWidget> createState() {
    return state;
  }
}

class CitySelectorPopupWindowState extends State<CitySelectorPopupWindow> {
  String position;

  update() {
    setState(() {
      this.position = widget.position;
    });
  }

  @override
  void initState() {
    super.initState();
    this.position = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: ScreenUtil.getScreenW(context),
              height: widget.margin,
              color: Colors.transparent,
            ),
            Expanded(
              child: GestureDetector(
                onTap: widget.dismissAction,
                child: Container(
                  width: ScreenUtil.getScreenW(context),
                  color: ThemeColors.color96000000,
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: widget.margin),
          width: ScreenUtil.getScreenW(context),
          padding: const EdgeInsets.only(left: 20, right: 20),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 56,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        widget.callback(-1);
                      },
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 16,
                            height: 16,
                            child: Center(
                              child: Image.asset('assets/images/ic_message.png',
                                  width: 11, height: 15, fit: BoxFit.fill),
                            ),
                          ),
                          SizedBox(width: 2),
                          Text(
                            widget.position,
                            style: const TextStyle(
                                fontSize: 16,
                                color: ThemeColors.color404040,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        '当前定位',
                        style: const TextStyle(
                            fontSize: 10,
                            color: ThemeColors.colorA6A6A6,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: ThemeColors.color404040),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '切换城市',
                  style: const TextStyle(
                      fontSize: 16,
                      color: ThemeColors.color404040,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 14),
              GridView.count(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.76,
                children: widget.cityList.map((f) {
                  return _buildBtn(widget.cityList.indexOf(f), f.city, f.hasBg);
                }).toList(),
              ),
              SizedBox(height: 40),
              Text(
                '其他城市敬请期待…',
                style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 12,
                    color: ThemeColors.colorA6A6A6),
              ),
              SizedBox(height: 20)
            ],
          ),
        )
      ],
    );
  }

  ///创建城市按钮
  Widget _buildBtn(int index, String title, bool hasBg) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: hasBg ? ThemeColors.color404040 : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(width: 1, color: ThemeColors.colorDEDEDE),
      ),
      child: FlatButton(
        onPressed: () {
          setState(() {
            widget.cityList.forEach((f) => f.hasBg = false);
            widget.cityList[index].hasBg = true;
          });
          widget.callback(index);
        },
        color: Colors.transparent,
        child: Text(
          title,
          style: TextStyle(
              fontSize: 14,
              color: hasBg ? Colors.white : ThemeColors.color404040),
        ),
      ),
    );
  }
}

class CityModel {
  String city;
  bool hasBg;

  CityModel({this.city, this.hasBg});

  CityModel.fromJson(Map<String, dynamic> json) {
    this.city = json['city'];
    this.hasBg = json['hasBg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['hasBg'] = this.hasBg;
    return data;
  }
}
