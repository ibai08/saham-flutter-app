import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class RoundedRectangleBorderParser {
  static Map<String, dynamic>? export(RoundedRectangleBorder rectangleBorder) {
    if (rectangleBorder.side == BorderSide.none && rectangleBorder.borderRadius == BorderRadius.zero) {
      return null;
    }
    final BorderRadius borderRadius = rectangleBorder.borderRadius as BorderRadius;
    final Map<String, dynamic> map = {
      "side": exportBorderSide(rectangleBorder.side),
      "borderRadius": "${exportBorderRadius(borderRadius)}"
    };
    return map;
  }
  static RoundedRectangleBorder? parse(Map<String, dynamic>? map) {
    if (map == null) return null;
    return RoundedRectangleBorder(
      side: parseBorderSide(map['side'])!,
      borderRadius: parseBorderRadius(map['borderRadius']),
    );
  }
}