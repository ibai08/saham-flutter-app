import 'package:flutter/material.dart';

class SizeConfig {
  static const int _cNUMOFHORIZONTALGRID = 100;
  static const int _cNUMOFVERTICALGRID = 100;

  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  static double? _safeAreaHorizontal;
  static double? _safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    blockSizeHorizontal = screenWidth! / _cNUMOFHORIZONTALGRID;
    blockSizeVertical = screenHeight! / _cNUMOFVERTICALGRID;

    _safeAreaHorizontal = _mediaQueryData!.padding.left + _mediaQueryData!.padding.right;
    _safeAreaVertical = _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;
    safeBlockHorizontal = (screenWidth! + _safeAreaHorizontal!) / _cNUMOFHORIZONTALGRID;
    safeBlockVertical = (screenHeight! + _safeAreaVertical!) / _cNUMOFVERTICALGRID;
  }
}