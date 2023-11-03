// ignore_for_file: prefer_conditional_assignment

import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';

class TileBoxCopySignal extends StatelessWidget {
  const TileBoxCopySignal({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.txtColor,
    this.totalBalance,
  }) : super(key: key);
  final leading;
  final title;
  final subtitle;
  final Color? txtColor;
  final double? totalBalance;

  @override
  Widget build(BuildContext context) {
    var txtCol = txtColor;
    var trail = leading;
    var totBalLength = totalBalance;
    var subtitleFontSize = 0;
    if (txtCol == null) {
      txtCol = Colors.black;
    }
    if (trail == null) {
      trail = Text("");
    }
    if (totalBalance != null) {
      if (totBalLength! >= 7) {
        subtitleFontSize = 12;
      } else if (totBalLength >= 5) {
        subtitleFontSize = 14;
      } else {
        subtitleFontSize = 16;
      }
    } else {
      subtitleFontSize = 16;
    }
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 5),
        dense: false,
        leading: leading,
        title: Text(
          title,
          style: TextStyle(fontSize: 11, color: AppColors.darkGrey2),
        ),
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            subtitle,
            softWrap: false,
            style: TextStyle(
                fontSize: subtitleFontSize.toDouble(),
                fontWeight: FontWeight.w400,
                color: txtCol),
          ),
        ),
      ),
    );
  }
}