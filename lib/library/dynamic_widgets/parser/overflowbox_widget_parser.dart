import 'package:flutter/material.dart';

import '../dynamic_widget.dart';
import '../utils/utils.dart';

class OverflowBoxWidgetParser extends WidgetParser{
  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    OverflowBox realWidget = widget as OverflowBox;
    return <String, dynamic>{
      "type": widgetName,
      "alignment": exportAlignment(realWidget.alignment as Alignment?),
      "minWidth": realWidget.minWidth,
      "maxWidth": realWidget.maxWidth,
      "minHeight": realWidget.minHeight,
      "maxHeight": realWidget.maxHeight,
      "child": DynamicWidgetBuilder.export(realWidget.child, buildContext)
    };
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    return OverflowBox(
      alignment: map.containsKey("alignment")
          ? parseAlignment(map["alignment"])!
          : Alignment.center,
      minWidth: map.containsKey("minWidth")?map['minWidth']:null,
      maxWidth: map.containsKey("maxWidth")?map['maxWidth']:null,
      minHeight: map.containsKey("minHeight")?map['minHeight']:null,
      maxHeight: map.containsKey("maxHeight")?map['maxHeight']:null,
      child: DynamicWidgetBuilder.buildFromMap(map['child'], buildContext, listener),
    );
  }

  @override
  String get widgetName => "OverflowBox";

  @override
  Type get widgetType => OverflowBox;

}