// ignore_for_file: unnecessary_null_in_if_null_operators

import 'package:flutter/material.dart';

import '../dynamic_widget.dart';
import '../utils/utils.dart';
import 'child_parser/container_decoration_parser.dart';

class ContainerWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener) {
    Alignment? alignment = parseAlignment(map['alignment']);
    Color? color = parseHexColor(map['color']);
    BoxConstraints constraints = parseBoxConstraints(map['constraints']);
    //TODOs: dekorasi nya perlu di koreksi
    EdgeInsetsGeometry? margin = parseEdgeInsetsGeometry(map['margin']);
    EdgeInsetsGeometry? padding = parseEdgeInsetsGeometry(map['padding']);
    Map<String, dynamic>? childMap = map['child'];
    Widget? child = childMap == null
        ? null
        : DynamicWidgetBuilder.buildFromMap(childMap, buildContext, listener);
    final BoxDecoration? decoration = ContainerDecorationParser.parse(map['decoration']);
    String? clickEvent =
        map.containsKey("click_event") ? map['click_event'] : null;
    bool? inkWellOn = map['inkWellOn'];
    double? width = map['width'] != null && map['width'] is String || map['width'] is int ? double.parse(map['width'].toString()) : map['width'] ?? null;

    var containerWidget = Container(
      alignment: alignment,
      padding: padding,
      color: color,
      margin: margin,
      width: width ?? null,
      height: map['height'],
      constraints: constraints,
      decoration: decoration ?? null,
      child: child,
    );

    if (listener != null && clickEvent != null) {
      if (inkWellOn == true) {
        return InkWell(
          onTap: () {
            listener.onClicked(clickEvent);
          },
          child: containerWidget,
        );
      } else {
        return GestureDetector(
          onTap: () {
            listener.onClicked(clickEvent);
          },
          child: containerWidget,
        );
      }
    } else {
      return containerWidget;
    }
  }

  @override
  String get widgetName => "Container";

  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as Container;
    var padding = realWidget.padding as EdgeInsets?;
    var margin = realWidget.margin as EdgeInsets?;
    var constraints = realWidget.constraints;
    var decoration = realWidget.decoration;
    return <String, dynamic>{
      "type": widgetName,
      "alignment": realWidget.alignment != null
          ? exportAlignment(realWidget.alignment as Alignment?)
          : null,
      "padding": padding != null
          ? "${padding.left},${padding.top},${padding.right},${padding.bottom}"
          : null,
      "color": realWidget.color != null && realWidget.decoration == null
          ? realWidget.color!.value.toRadixString(16)
          : null,
      "margin": margin != null
          ? "${margin.left},${margin.top},${margin.right},${margin.bottom}"
          : null,
      "constraints":
          constraints != null ? exportConstraints(constraints) : null,
      "decoration": decoration != null ? ContainerDecorationParser.export(realWidget.decoration as BoxDecoration) : null,
      "child": DynamicWidgetBuilder.export(realWidget.child, buildContext)
    };
  }

  @override
  Type get widgetType => Container;
}