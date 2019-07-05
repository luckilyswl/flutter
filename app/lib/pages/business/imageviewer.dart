import 'dart:ui';

import 'package:app/model/business_detail_bean.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:extended_image/extended_image.dart';
import 'package:app/pages/business/ImageGestureDetector.dart';

class ImageViewer extends StatefulWidget {
  final int index;
  final List<Photos> pics;
  final bool needsClear;

  ImageViewer(this.index, this.pics, {this.needsClear});

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer>
    with TickerProviderStateMixin {
  int currentIndex;
  AnimationController _doubleTapAnimationController;
  Animation _doubleTapCurveAnimation;
  Animation<double> _doubleTapAnimation;
  Function _doubleTapListener;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    _doubleTapAnimationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _doubleTapCurveAnimation = CurvedAnimation(
        parent: _doubleTapAnimationController, curve: Curves.linear);
  }

  @override
  void dispose() {
    super.dispose();
    _doubleTapAnimationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ExtendedImageGesturePageView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    String item = widget.pics[index].src;
                    Widget image = Container(
                      child: ExtendedImage.network(
                        item,
                        fit: BoxFit.contain,
                        cache: true,
                        mode: ExtendedImageMode.Gesture,
                        onDoubleTap: updateAnimation,
                        initGestureConfigHandler: (ExtendedImageState state) =>
                            GestureConfig(
                              initialScale: 1.0,
                              minScale: 1.0,
                              maxScale: 3.0,
                              animationMinScale: 0.5,
                              animationMaxScale: 4.0,
                              cacheGesture: false,
                              inPageView: true,
                            ),
                      ),
                      padding: EdgeInsets.all(5.0),
                    );
                    return ImageGestureDetector(
                      child: image,
                      context: context,
                      enableTapPop: true,
                      enablePullDownPop: false,
                    );
                  },
                  itemCount: widget.pics.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  controller: PageController(initialPage: currentIndex),
                  scrollDirection: Axis.horizontal,
                ),
                widget.pics.length > 1 ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                      margin: EdgeInsets.only(left: 20, bottom: 20),
                      child: RichText(
                        text: TextSpan(
                            text: (currentIndex + 1).toString(),
                            style: new TextStyle(
                                fontSize: 28, color: Colors.white),
                            children: [
                              TextSpan(
                                text: '/ ${widget.pics.length}',
                                style: new TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ]),
                      )),
                ) : Stack(),
              ],
            ),
          )
        ],
      ),
    );
  }

  void updateAnimation(ExtendedImageGestureState state) {
    double begin = state.gestureDetails.totalScale, end;
    Offset pointerDownPosition = state.pointerDownPosition;
    end = state.gestureDetails.totalScale == 1.0 ? 3.0 : 1.0;

    _doubleTapAnimation?.removeListener(_doubleTapListener);
    _doubleTapAnimationController
      ..stop()
      ..reset();

    _doubleTapListener = () {
      state.handleDoubleTap(
        scale: _doubleTapAnimation.value,
        doubleTapPosition: pointerDownPosition,
      );
    };

    _doubleTapAnimation = Tween(begin: begin, end: end)
        .animate(_doubleTapCurveAnimation)
          ..addListener(_doubleTapListener);
    _doubleTapAnimationController.forward();
  }
}
