
import 'package:app/res/res_index.dart';
import 'package:flutter/material.dart';

class RegisterStepper extends StatefulWidget {
  final int registerStepIndex;
  RegisterStepper({Key key, @required this.registerStepIndex}) : super(key: key);

  _RegisterStepperState createState() => _RegisterStepperState();
}

class _RegisterStepperState extends State<RegisterStepper> {

  _buildStepItemWidget(int index, bool isActive) {
    return Container(
      padding: EdgeInsets.only(left: 4, right: 4),
      width: 48,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          gradient: _getStepItemLinearGradient(isActive),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        alignment: Alignment.center,
        child: Text(
          index.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? ThemeColors.color404040 : ThemeColors.colorA6A6A6,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  _buildStepTitleWidget(String title) {
    return Container(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  _getStepItemLinearGradient(bool isActive) {
    return isActive
        ? LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ThemeColors.colorFFEFD4,
              ThemeColors.colorFFE3B1,
            ],
          )
        : LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
                ThemeColors.colorDEDEDE,
                ThemeColors.colorDEDEDE,
              ]);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 347,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 47, right: 47),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildStepItemWidget(1, 0 <= widget.registerStepIndex),
              Expanded(
                child: Center(
                  child: Container(
                    color: ThemeColors.colorDEDEDE,
                    height: 1,
                  ),
                ),
              ),
              _buildStepItemWidget(2, 1 <= widget.registerStepIndex),
              Expanded(
                child: Container(
                  color: ThemeColors.colorDEDEDE,
                  height: 1,
                ),
              ),
              _buildStepItemWidget(3, 2 <= widget.registerStepIndex),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildStepTitleWidget('填写信息'),
                _buildStepTitleWidget('验证负责人'),
                _buildStepTitleWidget('成功提交'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}