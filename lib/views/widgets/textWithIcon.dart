import 'package:flutter/material.dart';

class TextWithIcon extends StatelessWidget {
  const TextWithIcon({
    Key? key,
    required this.title,
    required this.icon,
    this.isBold,
    this.fontSize,
  }) : super(key: key);

  final String title;
  final Widget icon;
  final bool? isBold;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    bool bold = false;
    double size = 16;
    if (isBold != null) bold = isBold!;
    if (fontSize != null) size = fontSize!;
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: icon,
        ),
        Expanded(
          flex: 9,
          child: Text(
            title,
            style: TextStyle(
                fontSize: size,
                fontWeight: bold == true ? FontWeight.w600 : FontWeight.normal),
          ),
        ),
      ],
    );
  }
}