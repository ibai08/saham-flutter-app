// ignore_for_file: prefer_if_null_operators, body_might_complete_normally_nullable, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'parser/align_widget_parser.dart';
import 'parser/appbar_widget_parser.dart';
import 'parser/aspectratio_widget_parser.dart';
import 'parser/baseline_widget_parser.dart';
import 'parser/button_widget_parser.dart';
import 'parser/card_widget_parser.dart';
import 'parser/center_widget_parser.dart';
import 'parser/cliprrect_widget_parser.dart';
import 'parser/container_widget_parser.dart';
import 'parser/divider_widget_parser.dart';
import 'parser/dropcaptext_widget_parser.dart';
import 'parser/expanded_widget_parser.dart';
import 'parser/fittedbox_widget_parser.dart';
import 'parser/gridview_widget_parser.dart';
import 'parser/icon_widget_parser.dart';
import 'parser/image_widget_parser.dart';
import 'parser/indexedstack_widget_parser.dart';
import 'parser/limitedbox_widget_parser.dart';
import 'parser/listtile_widget_parser.dart';
import 'parser/listview_widget_parser.dart';
import 'parser/offstage_widget_parser.dart';
import 'parser/opacity_widget_parser.dart';
import 'parser/overflowbox_widget_parser.dart';
import 'parser/padding_widget_parser.dart';
import 'parser/pageview_widget_parser.dart';
import 'parser/placeholder_widget_parser.dart';
import 'parser/rotatedbox_widget_parser.dart';
import 'parser/row_column_widget_parser.dart';
import 'parser/safearea_widget_parser.dart';
import 'parser/scaffold_widget_parser.dart';
import 'parser/selectable_text_widget_parser.dart';
import 'parser/single_child_scroll_view_widget_parser.dart';
import 'parser/sizedbox_widget_parser.dart';
import 'parser/stack_positioned_widget_parsers.dart';
import 'parser/text_widget_parser.dart';
import 'parser/wrap_widget_parser.dart';

class DynamicWidgetBuilder {
  static final Logger log = Logger('DynamicWidget');

  static final _parsers = [
    ContainerWidgetParser(),
    TextWidgetParser(),
    SelectableTextWidgetParser(),
    RowWidgetParser(),
    ColumnWidgetParser(),
    AssetImageWidgetParser(),
    NetworkImageWidgetParser(),
    PlaceholderWidgetParser(),
    GridViewWidgetParser(),
    ListViewWidgetParser(),
    PageViewWidgetParser(),
    ExpandedWidgetParser(),
    PaddingWidgetParser(),
    CenterWidgetParser(),
    AlignWidgetParser(),
    AspectRatioWidgetParser(),
    FittedBoxWidgetParser(),
    BaselineWidgetParser(),
    StackWidgetParser(),
    PositionedWidgetParser(),
    IndexedStackWidgetParser(),
    ExpandedSizedBoxWidgetParser(),
    SizedBoxWidgetParser(),
    OpacityWidgetParser(),
    WrapWidgetParser(),
    DropCapTextParser(),
    IconWidgetParser(),
    ClipRRectWidgetParser(),
    SafeAreaWidgetParser(),
    ListTileWidgetParser(),
    ScaffoldWidgetParser(),
    AppBarWidgetParser(),
    LimitedBoxWidgetParser(),
    OffstageWidgetParser(),
    OverflowBoxWidgetParser(),
    ElevatedButtonParser(),
    DividerWidgetParser(),
    TextButtonParser(),
    RotatedBoxWidgetParser(),
    CardParser(),
    SingleChildScrollViewParser(),
    RichTextParser()
  ];

  static final _widgetNameParserMap = <String, WidgetParser>{};

  static bool _defaultParserInited = false;

  // use this method for adding your custom widget parser
  static void addParser(WidgetParser parser) {
    log.info(
        "add custom widget parser, make sure you don't overwrite the widget type.");
    _parsers.add(parser);
    _widgetNameParserMap[parser.widgetName] = parser;
  }

  static void initDefaultParsersIfNess() {
    if (!_defaultParserInited) {
      for (var parser in _parsers) {
        _widgetNameParserMap[parser.widgetName] = parser;
      }
      _defaultParserInited = true;
    }
  }

  static Widget? build(
      String json, BuildContext buildContext, ClickListener? listener) {
    
    try {
    initDefaultParsersIfNess();
    var map = jsonDecode(json);
    ClickListener _listener =
        listener == null ? NonResponseWidgetClickListener() : listener;
    var widget = buildFromMap(map, buildContext, _listener);
    return widget;
    }catch(eror, stack) {
      print("errorr: $eror");
      print(stack);
    }
  }

  static Widget? buildFromMap(Map<String, dynamic>? map,
      BuildContext buildContext, ClickListener? listener) {
    initDefaultParsersIfNess();
    if (map == null) {
      return null;
    }
    String? widgetName = map['type'];
    if (widgetName == null) {
      return null;
    }
    var parser = _widgetNameParserMap[widgetName];
    if (parser != null) {
      return parser.parse(map, buildContext, listener);
    }
    log.warning("Not support parser type: $widgetName");
    return null;
  }

  static List<Widget> buildWidgets(List<dynamic> values,
      BuildContext buildContext, ClickListener? listener) {
    initDefaultParsersIfNess();
    List<Widget> rt = [];
    for (var value in values) {
      var buildFromMap2 = buildFromMap(value, buildContext, listener);
      if (buildFromMap2 != null) {
        rt.add(buildFromMap2);
      }
    }
    return rt;
  }

  static Map<String, dynamic>? export(
      Widget? widget, BuildContext? buildContext) {
    initDefaultParsersIfNess();
    var parser = _findMatchedWidgetParserForExport(widget);
    if (parser != null) {
      return parser.export(widget, buildContext);
    }
    log.warning(
        "Can't find WidgetParser for Type ${widget.runtimeType} to export.");
    return null;
  }

  static List<Map<String, dynamic>?> exportWidgets(
      List<Widget?> widgets, BuildContext? buildContext) {
    initDefaultParsersIfNess();
    List<Map<String, dynamic>?> rt = [];
    for (var widget in widgets) {
      rt.add(export(widget, buildContext));
    }
    return rt;
  }

  static WidgetParser? _findMatchedWidgetParserForExport(Widget? widget) {
    for (var parser in _parsers) {
      if (parser.matchWidgetForExport(widget)) {
        return parser;
      }
    }
    return null;
  }
}

/// extends this class to make a Flutter widget parser.
abstract class WidgetParser {
  /// parse the json map into a flutter widget.
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener);

  /// the widget type name for example:
  /// {"type" : "Text", "data" : "Denny"}
  /// if you want to make a flutter Text widget, you should implement this
  /// method return "Text", for more details, please see
  /// @TextWidgetParser
  String get widgetName;

  /// export the runtime widget to json
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext);

  /// match current widget
  Type get widgetType;

  bool matchWidgetForExport(Widget? widget) => widget.runtimeType == widgetType;
}

abstract class ClickListener {
  void onClicked(dynamic event);
}

class NonResponseWidgetClickListener implements ClickListener {
  static final Logger log = Logger('NonResponseWidgetClickListener');

  @override
  void onClicked(dynamic event) {
    log.info("receiver click event: " + event!);
  }
}