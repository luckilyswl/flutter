import 'package:app/model/app_init_bean.dart';
import 'package:app/model/custom_scroll_bean.dart';
import 'package:app/model/home_link_picker_bean.dart';
import 'package:app/model/search_condition_bean.dart';
import 'package:app/res/res_index.dart';
import 'package:app/widget/widgets_index.dart';
import 'package:flutter/material.dart';

class HomeFilterUtils {
  static List<HomeLinkPickerBean> changeAreaDataToPickerData(
      List<Areas> areas) {
    List<HomeLinkPickerBean> homeLinkPickerBeans = <HomeLinkPickerBean>[];

    for (Areas area in areas) {
      List<HomeLinkPickerBean> subHomeLinkPickerBeans = <HomeLinkPickerBean>[];
      for (Circles circle in area.circles) {
        subHomeLinkPickerBeans.add(HomeLinkPickerBean(
            id: circle.circleId,
            name: circle.name,
            aliasName: circle.name,
            subItems: <HomeLinkPickerBean>[]));
      }
      subHomeLinkPickerBeans.insert(
          0,
          HomeLinkPickerBean(
              id: area.areaId,
              name: '全部',
              aliasName: '全部',
              subItems: <HomeLinkPickerBean>[]));
      HomeLinkPickerBean bean = HomeLinkPickerBean(
          id: area.areaId,
          name: area.name,
          aliasName: area.name,
          subItems: subHomeLinkPickerBeans);
      homeLinkPickerBeans.add(bean);
    }

    homeLinkPickerBeans.insert(
        0,
        HomeLinkPickerBean(
            id: -1,
            name: '全部区域',
            aliasName: '区域',
            subItems: <HomeLinkPickerBean>[]));

    return homeLinkPickerBeans;
  }

  static changeDishDataToPickerData(List<Dishes> dishes) {
    List<HomeLinkPickerBean> homeLinkPickerBeans = <HomeLinkPickerBean>[];
    for (Dishes dish in dishes) {
      List<HomeLinkPickerBean> subHomeLinkPickerBeans = <HomeLinkPickerBean>[];
      for (Dishes subDish in dish.subItems) {
        subHomeLinkPickerBeans.add(HomeLinkPickerBean(
            id: subDish.id,
            name: subDish.name,
            aliasName: subDish.name,
            subItems: <HomeLinkPickerBean>[]));
      }
      subHomeLinkPickerBeans.insert(
          0,
          HomeLinkPickerBean(
              id: dish.id,
              name: '全部',
              aliasName: '全部',
              subItems: <HomeLinkPickerBean>[]));
      HomeLinkPickerBean bean = HomeLinkPickerBean(
          id: dish.id,
          name: dish.name,
          aliasName: dish.name,
          subItems: subHomeLinkPickerBeans);
      homeLinkPickerBeans.add(bean);
    }

    homeLinkPickerBeans.insert(
        0,
        HomeLinkPickerBean(
            id: -1,
            name: '全部菜系',
            aliasName: '菜系',
            subItems: <HomeLinkPickerBean>[]));

    return homeLinkPickerBeans;
  }

//CustomScrollBean(title: '今天', subTitle: '周一', hasBg: true)
  static changeDateDataToScrollData(List<Date> date) {
    List<CustomScrollBean> scrollBean = <CustomScrollBean>[];
    for (var i = 0; i < date.length; i++) {
      scrollBean.add(CustomScrollBean(
          title: date[i].title, subTitle: date[i].week, hasBg: i == 0));
    }
    return scrollBean;
  }

  static changeTimeDataToScrollData(List<String> time) {
    List<CustomScrollBean> scrollBean = <CustomScrollBean>[];
    for (var i = 0; i < time.length; i++) {
      scrollBean.add(CustomScrollBean(title: time[i], hasBg: i == 0));
    }
    return scrollBean;
  }

  static changeNumberDataToScrollData(List<int> numbers) {
    List<CustomScrollBean> scrollBean = <CustomScrollBean>[];
    for (var i = 0; i < numbers.length; i++) {
      scrollBean.add(CustomScrollBean(
          title: numbers[i] == 0 ? '未确定' : '${numbers[i]}位', hasBg: i == 0));
    }
    return scrollBean;
  }

  static changePriceOptionDataToScrollData(PriceOption priceOption) {
    List<CustomScrollBean> scrollBean = <CustomScrollBean>[];
    for (var i = 0; i < priceOption.items.length; i++) {
      scrollBean.add(CustomScrollBean(
          title: priceOption.items[i].text, hasBg: i == 0));
    }
    return scrollBean;
  }

  static changeOpenCityDataToCityModelData(List<OpenCitys> openCitys) {
    List<CityModel> scrollBean = <CityModel>[];
    for (var i = 0; i < openCitys.length; i++) {
      scrollBean.add(CityModel(
          city: openCitys[i].regionName, hasBg: i == 0));
    }
    return scrollBean;
  }

  static double maxWidthWithPickerData(
      List<HomeLinkPickerBean> homeLinkPickerBeans) {
    double maxWidth = 0.0;
    for (HomeLinkPickerBean bean in homeLinkPickerBeans) {
      TextSpan span = new TextSpan(
          style: TextStyle(
            decoration: TextDecoration.none,
            color: ThemeColors.color404040,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          text: bean.name);
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      if (tp.width > maxWidth) {
        maxWidth = tp.width;
      }
    }
    return maxWidth;
  }
}