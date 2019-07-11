import 'package:app/res/res_index.dart';
import 'package:app/utils/utils_index.dart';
import 'package:app/widget/toast.dart';
import 'package:flutter/material.dart';

import 'package:amap_base/amap_base.dart' as Map;

class MapPage extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String title;
  final String address;

  Map.AMapController _controller;
  Map.MyLocationStyle _myLocationStyle = Map.MyLocationStyle();
  Map.UiSettings _uiSettings = Map.UiSettings();

  MapPage(
      {@required this.latitude,
      @required this.longitude,
      @required this.title,
      @required this.address});

  @override
  Widget build(BuildContext context) {
    _clickMap() {
      Map.AMapNavi().startNavi(
        lat: latitude,
        lon: longitude,
        naviType: Map.AMapNavi.drive,
      );
    }

    Map.LatLng latLng = new Map.LatLng(latitude, longitude);

    return Scaffold(
        body: new Stack(
      children: <Widget>[
        Positioned(
          top: 70,
          bottom: 80,
          child: Container(
            width: ScreenUtil.getScreenW(context),
            height: ScreenUtil.getScreenH(context),
            child: Map.AMapView(
              onAMapViewCreated: (c) {
                _controller = c;
                _updateMyLocationStyle(
                  context,
                  showMyLocation: true,
                  interval: 3000,
                  radiusFillColor: Colors.blue.withOpacity(0.6),
                  myLocationType: Map.LOCATION_TYPE_LOCATION_ROTATE_NO_CENTER,
                  latitude: latitude,
                  longitude: longitude,
                );
              },
              amapOptions: Map.AMapOptions(
                scaleControlsEnabled: true,
                zoomControlsEnabled: true,
                camera: Map.CameraPosition(target: latLng, zoom: 15),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: new Container(
            width: ScreenUtil.getScreenW(context),
            height: 70,
            decoration: BoxDecoration(
              image: new DecorationImage(
                  image: AssetImage('assets/images/bg_bar.png'),
                  fit: BoxFit.fill),
            ),
            child: new Padding(
              padding: EdgeInsets.only(top: 25),
              child: new Stack(
                children: <Widget>[
                  Positioned(
                      left: 14,
                      top: 10,
                      child: new GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/images/ic_back_w.png',
                          width: 20,
                          height: 20,
                        ),
                      )),
                  new Center(
                    child: new Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              new TextStyle(fontSize: 16, color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: new Container(
            width: ScreenUtil.getScreenH(context),
            height: 80,
            color: Colors.white,
            child: new Stack(
              children: <Widget>[
                new Container(
                  constraints: BoxConstraints(maxWidth: 276),
                  margin: EdgeInsets.only(left: 14),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            fontSize: 20,
                            color: ThemeColors.color404040,
                            fontWeight: FontWeight.w500),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                              fontSize: 12, color: ThemeColors.colorA6A6A6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: new GestureDetector(
              onTap: () {
                _clickMap();
              },
              child: new Padding(
                padding: EdgeInsets.only(right: 20, bottom: 18),
                child: Image.asset(
                  'assets/images/ic_map_gps.png',
                  width: 45,
                  height: 45,
                ),
              ),
            ))
      ],
    ));
  }

  void _updateMyLocationStyle(BuildContext context,
      {String myLocationIcon,
      double anchorU,
      double anchorV,
      Color radiusFillColor,
      Color strokeColor,
      double strokeWidth,
      int myLocationType,
      int interval,
      bool showMyLocation,
      bool showsAccuracyRing,
      bool showsHeadingIndicator,
      Color locationDotBgColor,
      Color locationDotFillColor,
      bool enablePulseAnnimation,
      String image,
      double latitude,
      double longitude}) async {
    if (await Map.Permissions().requestPermission()) {
      _myLocationStyle = _myLocationStyle.copyWith(
        myLocationIcon: myLocationIcon,
        anchorU: anchorU,
        anchorV: anchorV,
        radiusFillColor: radiusFillColor,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        myLocationType: myLocationType,
        interval: interval,
        showMyLocation: showMyLocation,
        showsAccuracyRing: showsAccuracyRing,
        showsHeadingIndicator: showsHeadingIndicator,
        locationDotBgColor: locationDotBgColor,
        locationDotFillColor: locationDotFillColor,
        enablePulseAnnimation: enablePulseAnnimation,
        image: image,
      );
      _controller.setMyLocationStyle(_myLocationStyle);
      _controller.addMarkers(<Map.MarkerOptions>[
        Map.MarkerOptions(
          position: Map.LatLng(latitude, longitude),
          icon: 'assets/images/ic_map_location.png',
        )
      ]);
      _controller.setZoomLevel(15);
      _controller
          .setUiSettings(_uiSettings.copyWith(isMyLocationButtonEnabled: true));
    } else {
      Toast.toast(context, '权限不足');
    }
  }
}
