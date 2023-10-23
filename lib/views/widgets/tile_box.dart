// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class TileBox extends StatelessWidget {
  const TileBox({
    Key? key,
    this.trailing,
    this.title,
    this.subtitle,
    this.txtColor,
  }) : super(key: key);
  final trailing;
  final title;
  final subtitle;
  final Color? txtColor;

  @override
  Widget build(BuildContext context) {
    var txtCol = txtColor;
    var trail = trailing;
    txtCol ??= Colors.black;
    trail ??= const Text("");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          boxShadow: [BoxShadow(color: AppColors.light, blurRadius: 4)]),
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        child: ListTile(
          dense: false,
          trailing: trailing,
          title: Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
          subtitle: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              subtitle,
              softWrap: false,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: txtColor),
            ),
          ),
        ),
      ),
    );
  }
}
