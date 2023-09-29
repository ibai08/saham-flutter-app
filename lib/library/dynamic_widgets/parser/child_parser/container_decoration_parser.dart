import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class ContainerDecorationParser {
  static Map<String, dynamic>? export(BoxDecoration boxDecoration) {
    if (
      boxDecoration.borderRadius == BorderRadius.zero &&
      boxDecoration.color == null &&
      boxDecoration.border == null && 
      boxDecoration.gradient == null &&
      boxDecoration.backgroundBlendMode == null &&
      boxDecoration.shape == BoxShape.rectangle &&
      boxDecoration.image == null &&
      boxDecoration.boxShadow == null) {
        print("lena kena takol");
        return null;
    }
    BorderRadius borderRadius = (boxDecoration.borderRadius != null) ? boxDecoration.borderRadius as BorderRadius : BorderRadius.zero;
    final Color color = boxDecoration.color as Color;
    final Map<String, dynamic> map = {
      "borderRadius": "${exportBorderRadius(borderRadius)}",
      "color": color.value.toRadixString(16),
      "gradient": exportLinearGradient(boxDecoration.gradient as LinearGradient),
      "shape": exportShapeInDecoration(boxDecoration.shape),
      "border": exportBoxBorder(boxDecoration.border)
    };
    print("parsing parsing parsing");
    return map;
  }

  static BoxDecoration? parse(Map<String, dynamic>? map) {
    // print("ini lagi parsing");
    // print("mapnya null?: $map");
    if (map == null) return null;
    // print("jalan jalan: ${map['border']['type']}");
    // print("panjangg: ${BoxDecoration(
    //   color: parseHexColor(map['color']) ?? null,
    //   shape: parseShapeInDecoration(map['shape']),
    //   borderRadius: map['shape'] != 'circle' ? parseBorderRadius(map['borderRadius']) : null,
    //   // border: parseBoxBorder(map['border']) ?? null
    //   // gradient: parseLinearGradient(map['gradient']) ?? null,
    // )}");
    return BoxDecoration(
      borderRadius:  map['borderRadius'] != null ? map['shape'] != 'circle' ? parseBorderRadius(map['borderRadius']) : null : null,
      color: parseHexColor(map['color']) ?? null,
      gradient: parseLinearGradient(map['gradient']) ?? null,
      shape: parseShapeInDecoration(map['shape']) ?? BoxShape.rectangle,
      border: map['border'] != null ? map['border']['type'] == 'Border.all' ? parseBoxBorderAll(map['border']) : map['border']['type'] == 'Border' ? parseBoxBorder(map['border']) : null : null
    );

  }
}