import 'package:app/pages/pages_index.dart';
import 'package:flutter/material.dart';
import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/widgets_index.dart';

/*
 * 余额明细页 Page
 **/
class BalanceDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BalanceDetailPageState();
  }
}

class BalanceDetailPageState extends State<BalanceDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActionBar.buildActionBar(
        context,
        AppBar(
          title: Text('余额明细', style: const TextStyle(fontSize: 17)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            width: ScreenUtil.getScreenW(context),
            decoration: BoxDecoration(gradient: Gradients.blueLinearGradient),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('账户余额（元）', style: FontStyles.style12FFFFFF),
                        SizedBox(height: 10),
                        Text(
                          '1234.22',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('累计充值（元）',
                                    style: FontStyles.style12FFFFFF),
                                SizedBox(height: 8),
                                Text('1000', style: FontStyles.style14FFFFFF),
                              ],
                            ),
                            SizedBox(width: 25),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('累计赠送（元）',
                                    style: FontStyles.style12FFFFFF),
                                SizedBox(height: 8),
                                Text('234.22', style: FontStyles.style14FFFFFF),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          return RechagrePage(
                            orderId: 0,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    padding: const EdgeInsets.only(top: 22),
                    color: Colors.transparent,
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 100,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: Gradients.goldLightLinearGradient,
                        border: Border.all(
                            width: 1, color: ThemeColors.colorD39857),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/ic_recharge_brown.png',
                            width: 16,
                            height: 16,
                          ),
                          Container(
                            width: 2,
                          ),
                          Text(
                            '立即充值',
                            style: const TextStyle(
                                color: ThemeColors.color89551C, fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 44,
            width: ScreenUtil.getScreenW(context),
            color: Colors.white,
            alignment: Alignment.center,
            child: Text(
              '全部记录',
              style: const TextStyle(
                fontSize: 14,
                color: ThemeColors.color222222,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: ThemeColors.colorF1F1F1,
              padding: const EdgeInsets.only(top: 1),
              width: ScreenUtil.getScreenW(context),
              child: ListView.separated(
                  itemBuilder: (context, i) {
                    return _buildDetailItem(
                      type: 1,
                      title: '充1000元，返赠200元余额',
                      time: '2018.10.15 12:30',
                      price: '+1200',
                      balance: '当前余额：1234.22',
                    );
                  },
                  separatorBuilder: (context, i) {
                    return SizedBox(
                        width: ScreenUtil.getScreenW(context), height: 1);
                  },
                  itemCount: 10),
            ),
          ),
        ],
      ),
    );
  }

  ///创建余额明细item
  Widget _buildDetailItem(
      {int type, String title, String time, String price, String balance}) {
    return Container(
      width: ScreenUtil.getScreenW(context),
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ThemeColors.colorEEBB69,
                      borderRadius: BorderRadius.circular(200)),
                  child: Text('充', style: FontStyles.style18FFFFFF),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 4),
                    Text(title, style: FontStyles.style14222222),
                    SizedBox(height: 6),
                    Text(
                      time,
                      style: FontStyles.style129B9B9B,
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                  color: ThemeColors.colorE44239,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10),
              Text(balance, style: FontStyles.style109B9B9B),
            ],
          )
        ],
      ),
    );
  }
}
