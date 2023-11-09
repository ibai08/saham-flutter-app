// ignore_for_file: unnecessary_null_in_if_null_operators

import 'package:flutter/widgets.dart';

import '../dynamic_widget.dart';
import '../utils/utils.dart';

class ClipRRectWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener) {
    var radius = map['borderRadius'].toString().split(",");
    double? topLeft = double.tryParse(radius[0]) ?? null;
    double? topRight = double.tryParse(radius[1]) ?? null;
    double? bottomLeft = double.tryParse(radius[2]) ?? null;
    double? bottomRight = double.tryParse(radius[3]) ?? null;
    var clipBehaviorString = map['clipBehavior'];
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: topLeft != null ? Radius.circular(topLeft) : Radius.zero,
          topRight: topRight != null ? Radius.circular(topRight) : Radius.zero,
          bottomLeft: bottomLeft != null ? Radius.circular(bottomLeft) : Radius.zero,
          bottomRight: bottomRight != null ? Radius.circular(bottomRight) : Radius.zero),
      clipBehavior: parseClipBehavior(clipBehaviorString),
      child: DynamicWidgetBuilder.buildFromMap(
          map["child"], buildContext, listener),
    );
  }

  @override
  String get widgetName => "ClipRRect";

  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as ClipRRect;
    var borderRadius = realWidget.borderRadius!;
    return <String, dynamic>{
      "type": widgetName,
      "borderRadius":
          "${borderRadius.topLeft.x},${borderRadius.topRight.x},${borderRadius.bottomLeft.x},${borderRadius.bottomRight.x}",
      "clipBehavior": exportClipBehavior(realWidget.clipBehavior),
      "child": DynamicWidgetBuilder.export(realWidget.child, buildContext)
    };
  }

  @override
  Type get widgetType => ClipRRect;
}