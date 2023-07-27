// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class BtnWithIcon extends StatelessWidget {
  const BtnWithIcon({
    Key key, 
    this.title,
    this.icon,
    this.color,
    this.txtColor,
    this.tap,
    this.image,
  }) : super(key: key);
  final title;
  final icon;
  final color;
  final tap;
  final txtColor;
  final Widget image;

  @override
  Widget build(BuildContext context) => Container(
    width: 155,
    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    child: TextButton(
      onPressed: tap,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0)),
        backgroundColor: color,
        padding:const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: image ?? Icon(
                    icon,
                    color: txtColor,
                    size: 30,
                  ),
          ),
          Text(
            title,
            style: TextStyle(color: txtColor, fontSize: 16),
            softWrap: false,
          )
        ],
      ),
    ),
  );
}