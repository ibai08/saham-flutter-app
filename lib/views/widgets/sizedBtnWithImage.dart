// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class BtnWithIcon extends StatelessWidget {
  const BtnWithIcon(
      {Key? key, this.title, this.icon, this.color, this.txtColor, this.url}): super(key: key);
  final title;
  final icon;
  final color;
  final url;
  final txtColor;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, url);
          },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: color,
            padding: const EdgeInsets.all(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Icon(icon, color: txtColor, size: 32)],
          ),
        ),
      );
}