import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../dynamic_widget.dart';
import '../utils/utils.dart';

class TextWidgetParser implements WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener) {
    String? data = map['data'];
    String? textAlignString = map['textAlign'];
    String? overflow = map['overflow'];
    int? maxLines = map['maxLines'];
    String? semanticsLabel = map['semanticsLabel'];
    bool? softWrap = map['softWrap'];
    String? textDirectionString = map['textDirection'];
    double? textScaleFactor = map['textScaleFactor']?.toDouble();
    var textSpan;
    var textSpanParser = TextSpanParser();
    if (map.containsKey("textSpan")) {
      textSpan = textSpanParser.parse(map['textSpan'], listener);
    }

    if (textSpan == null) {
      return Text(
        data!,
        textAlign: parseTextAlign(textAlignString),
        overflow: parseTextOverflow(overflow),
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        softWrap: softWrap,
        textDirection: parseTextDirection(textDirectionString),
        style: map.containsKey('style') ? parseTextStyle(map['style']) : null,
        textScaleFactor: textScaleFactor,
      );
    } else {
      return Text.rich(
        textSpan,
        textAlign: parseTextAlign(textAlignString),
        overflow: parseTextOverflow(overflow),
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        softWrap: softWrap,
        textDirection: parseTextDirection(textDirectionString),
        style: map.containsKey('style') ? parseTextStyle(map['style']) : null,
        textScaleFactor: textScaleFactor,
      );
    }
  }

  @override
  String get widgetName => "Text";

  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as Text;
    if (realWidget.textSpan == null) {
      return <String, dynamic>{
        "type": "Text",
        "data": realWidget.data,
        "textAlign": realWidget.textAlign != null
            ? exportTextAlign(realWidget.textAlign)
            : "start",
        "overflow": exportTextOverflow(realWidget.overflow),
        "maxLines": realWidget.maxLines,
        "semanticsLabel": realWidget.semanticsLabel,
        "softWrap": realWidget.softWrap,
        "textDirection": exportTextDirection(realWidget.textDirection),
        "style": exportTextStyle(realWidget.style),
        "textScaleFactor": realWidget.textScaleFactor
      };
    } else {
      var parser = TextSpanParser();
      return <String, dynamic>{
        "type": "Text",
        "textSpan": parser.export(realWidget.textSpan as TextSpan),
        "textAlign": realWidget.textAlign != null
            ? exportTextAlign(realWidget.textAlign)
            : "start",
        "overflow": exportTextOverflow(realWidget.overflow),
        "maxLines": realWidget.maxLines,
        "semanticsLabel": realWidget.semanticsLabel,
        "softWrap": realWidget.softWrap,
        "textDirection": exportTextDirection(realWidget.textDirection),
        "style": exportTextStyle(realWidget.style),
        "textScaleFactor": realWidget.textScaleFactor
      };
    }
  }

  @override
  Type get widgetType => Text;

  @override
  bool matchWidgetForExport(Widget? widget) => widget is Text;
}

class TextSpanParser {
  TextSpan parse(Map<String, dynamic> map, ClickListener? listener) {
    String? clickEvent = map.containsKey("recognizer") ? map['recognizer'] : "";
    var textSpan = TextSpan(
        text: map['text'],
        style: parseTextStyle(map['style']),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            listener!.onClicked(clickEvent);
          },
        children: []);
    if (map.containsKey('children')) {
      parseChildren(textSpan, map['children'], listener);
    }

    return textSpan;
  }

  Map<String, dynamic> export(TextSpan textSpan) {
    return <String, dynamic>{
      "text": textSpan.text,
      "style": exportTextStyle(textSpan.style),
      "children": exportChildren(textSpan)
    };
  }

  void parseChildren(
      TextSpan textSpan, List<dynamic> childrenSpan, ClickListener? listener) {
    for (var childmap in childrenSpan) {
      textSpan.children!.add(parse(childmap, listener));
    }
  }

  List<Map<String, dynamic>> exportChildren(TextSpan textSpan) {
    List<Map<String, dynamic>> rt = [];
    if (textSpan.children != null && textSpan.children!.isNotEmpty) {
      for (var span in textSpan.children!) {
        rt.add(export(span as TextSpan));
      }
    }
    return rt;
  }
}

class RichTextParser implements WidgetParser {
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    String? textAlignString = map['textAlign'];
    String? overflow = map['overflow'];
    Map<String, dynamic> textMap = map['text'];
    // InlineSpan? text = (textMap == null ? null : DynamicWidgetBuilder.buildFromMap(textMap, buildContext, listener)) as InlineSpan?;
    var textSpan;
    var textSpanParser = TextSpanParser();
    if (textMap['type'] == 'textSpan') {
      textSpan = textSpanParser.parse(map['text'], listener);
    }
    bool? softWrap = map['softWrap'];
    String? textDirectionString = map['textDirection'];

    return RichText(
      text: textSpan,
      textAlign: parseTextAlign(textAlignString),
      overflow: overflow != null ? parseTextOverflow(overflow) : TextOverflow.clip,
      softWrap: softWrap ?? true,
      textDirection: parseTextDirection(textDirectionString),
    );
  }
  @override
  String get widgetName => "RichText";

  @override
  Map<String, dynamic> export(Widget? richTexts, BuildContext? context) {
    RichText? richText = richTexts as RichText;
    return <String, dynamic> {
      "type": "RichText",
      "text": richText.text,
      "textAlign": richText.textAlign != null ? exportTextAlign(richText.textAlign) : "start",
      "overflow": exportTextOverflow(richText.overflow),
      "softWrap": richText.softWrap,
      "textDirection": exportTextDirection(richText.textDirection),
    };
  }

  @override
  Type get widgetType => RichText;

  @override
  bool matchWidgetForExport(Widget? widget) {
    // TODO: implement matchWidgetForExport
    throw UnimplementedError();
  }
}