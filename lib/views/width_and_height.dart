import 'package:flutter/widgets.dart';

class FrameSize {
  //init method is static so no object creation is required
  static void init({
    required context,
  }) {
    //instantiate variables here
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    sliderHeight = screenHeight / 6;
    addToCartButtonHeight = screenHeight / 14;
  }

  //declare variables here
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double sliderHeight;
  static late double addToCartButtonHeight;
}
