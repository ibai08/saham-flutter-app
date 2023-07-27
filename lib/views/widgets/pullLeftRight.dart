import 'dart:ui';

import 'package:flutter/material.dart';

class PullLeftRight extends StatelessWidget {
  const PullLeftRight({
    Key key, 
    this.title, 
    this.desc, 
    this.isBoldTitle, 
    this.height, 
    this.bordered
  }) :super(key: key);

  final String title;
  final String desc;
  final bool isBoldTitle;
  final double height;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    bool boldTitile = false;
    bool borderedBottom = false;
    double heightTxt = height;
    heightTxt ??= 2.3;
    if (isBoldTitle == true) boldTitile = true;
    if (bordered == true) {
      borderedBottom = true;
      if (height == null) {
        heightTxt = 1;
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    height: heightTxt,
                    fontWeight: boldTitile ? FontWeight.w600 : FontWeight.normal
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  desc,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14, height: 1.4
                  ),
                ),
              ),
            ],
          ),
          borderedBottom ? const Divider() : const SizedBox(height: 0)
        ],
      ),
    );
  }
}