// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';

class BtnWithImage extends StatelessWidget {
  const BtnWithImage({
    Key key,
    this.title,
    this.icon,
    this.tap,
  }) : super(key: key);

  final title;
  final icon;
  final tap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TextButton.icon(
        onPressed: tap,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0)),
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.white,
        ),
        icon: icon,
        label: Text(
          title,
          style: const TextStyle(fontSize: 17),
        )
      ),
    );
  }
}
