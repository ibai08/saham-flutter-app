import 'package:flutter/material.dart';

import '../dynamic_widget.dart';
import '../utils/utils.dart';

class DividerWidgetParser extends WidgetParser{
  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    Divider realWidget = widget as Divider;
    return <String, dynamic>{
      "type": widgetName,
      "height": realWidget.height,
      "thickness": realWidget.thickness,
      "indent": realWidget.indent,
      "endIndent": realWidget.endIndent,
      "color": realWidget.color != null
          ? realWidget.color!.value.toRadixString(16): null,
    };

  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {

    return Divider(
      height: double.tryParse(map['height'].toString()),
      thickness: double.tryParse(map['thickness'].toString()),
      indent: double.tryParse(map['indent'].toString()),
      endIndent: double.tryParse(map['endIndent'].toString()),
      color: parseHexColor(map['color']),
    );
  }

  @override
  String get widgetName => "Divider";

  @override
  Type get widgetType => Divider;

}