import 'package:flutter/widgets.dart';

import '../dynamic_widget.dart';
import '../utils/utils.dart';

class WrapWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener) {
    return Wrap(
      direction: map.containsKey("direction")
          ? parseAxis(map["direction"])
          : Axis.horizontal,
      alignment: map.containsKey("alignment")
          ? parseWrapAlignment(map["alignment"])
          : WrapAlignment.start,
      spacing: map.containsKey("spacing") ? double.tryParse(map["spacing"].toString())! : 0.0,
      runAlignment: map.containsKey("runAlignment")
          ? parseWrapAlignment(map["runAlignment"])
          : WrapAlignment.start,
      runSpacing:
          map.containsKey("runSpacing") ? double.tryParse(map["runSpacing"].toString())! : 0.0,
      crossAxisAlignment: map.containsKey("crossAxisAlignment")
          ? parseWrapCrossAlignment(map["crossAxisAlignment"])
          : WrapCrossAlignment.start,
      textDirection: map.containsKey("textDirection")
          ? parseTextDirection(map["textDirection"])
          : null,
      verticalDirection: map.containsKey("verticalDirection")
          ? parseVerticalDirection(map["verticalDirection"])
          : VerticalDirection.down,
      children: DynamicWidgetBuilder.buildWidgets(
          map['children'], buildContext, listener),
    );
  }

  @override
  String get widgetName => "Wrap";

  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as Wrap;
    return <String, dynamic>{
      "type": "Wrap",
      "direction":
          realWidget.direction == Axis.horizontal ? "horizontal" : "vertical",
      "alignment": exportWrapAlignment(realWidget.alignment),
      "spacing": realWidget.spacing,
      "runAlignment": exportWrapAlignment(realWidget.runAlignment),
      "runSpacing": realWidget.runSpacing,
      "crossAxisAlignment":
          exportWrapCrossAlignment(realWidget.crossAxisAlignment),
      "textDirection": realWidget.textDirection != null
          ? exportTextDirection(realWidget.textDirection)
          : null,
      "verticalDirection":
          realWidget.verticalDirection == VerticalDirection.up ? "up" : "down",
      "children":
          DynamicWidgetBuilder.exportWidgets(realWidget.children, buildContext)
    };
  }

  @override
  Type get widgetType => Wrap;
}