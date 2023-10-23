// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/widgets.dart';

import '../dynamic_widget.dart';
import '../utils/utils.dart';

class PlaceholderWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener) {
    return Placeholder(
      color: map.containsKey('color')
          ? parseHexColor(map['color'])!
          : const Color(0xFF455A64),
      strokeWidth:
          map.containsKey('strokeWidth') ? map['strokeWidth']?.toDouble() : 2.0,
      fallbackWidth: map.containsKey('fallbackWidth')
          ? map['fallbackWidth']?.toDouble()
          : 400.0,
      fallbackHeight: map.containsKey('fallbackHeight')
          ? map['fallbackHeight']?.toDouble()
          : 400.0,
    );
  }

  @override
  String get widgetName => "Placeholder";

  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as Placeholder;
    return <String, dynamic>{
      "type": widgetName,
      "color": realWidget.color != null
          ? realWidget.color.value.toRadixString(16)
          : "0xFF455A64",
      "strokeWidth": realWidget.strokeWidth,
      "fallbackWidth": realWidget.fallbackWidth,
      "fallbackHeight": realWidget.fallbackHeight
    };
  }

  @override
  Type get widgetType => Placeholder;
}