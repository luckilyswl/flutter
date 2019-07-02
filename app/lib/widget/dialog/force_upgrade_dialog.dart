import 'package:app/res/theme_colors.dart';
import 'package:flutter/material.dart';

class ForceUpgradeDialog extends Dialog {
  final Function onUpgradeEvent;
  final String version;
  final double apkSize;
  final List upgradeContents;

  ForceUpgradeDialog(
      {Key key,
      @required this.version,
      @required this.apkSize,
      @required this.upgradeContents,
      @required this.onUpgradeEvent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String upgradeContent = '';
    for (var i = 0; i < this.upgradeContents.length; i++) {
      String item = this.upgradeContents[i];
      upgradeContent += "${i + 1}. $item\n";
    }
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: SizedBox(
          width: 295,
          height: 375,
          child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))), //设置圆角
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 150,
                  color: ThemeColors.colorA6A6A6,
                  child: Text(
                    '发现新版本',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ThemeColors.color404040,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (BuildContext context,
                        BoxConstraints viewportConstraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 15),
                                alignment: Alignment.centerLeft,
                                // A fixed-height child.
                                child: RichText(
                                  text: TextSpan(
                                    text: '最新版本：',
                                    style: TextStyle(
                                        color: ThemeColors.color404040,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'V$version',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 5),
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    text: '版本大小：',
                                    style: TextStyle(
                                        color: ThemeColors.color404040,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${apkSize}M',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '更新内容：',
                                  style: TextStyle(
                                      color: ThemeColors.color404040,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  upgradeContent,
                                  style: TextStyle(
                                      color: ThemeColors.color404040,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(
                  height: 1,
                  color: Color(0xFFDEDEDE),
                ),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: GestureDetector(
                      child: Text(
                        '立即更新',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ThemeColors.color404040,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: this.onUpgradeEvent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
