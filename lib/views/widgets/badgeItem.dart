// ignore_for_file: prefer_typing_uninitialized_variables, sized_box_for_whitespace

import 'package:flutter/material.dart';

class BadgeItem extends StatelessWidget {
  const BadgeItem({
    Key? key,
    this.images,
    this.title,
    this.tap,
    this.colors,
    this.status,
  }) : super(key: key);
  final String? images;
  final String? title;
  final tap;
  final colors;
  final status;

  @override
  Widget build(BuildContext context) {
    var warna;
    if (status == '0') {
      warna = const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.elliptical(65.0, 22.0),
        ),
        color: Colors.grey,
        backgroundBlendMode: BlendMode.saturation,
      );
    }
    double margin = 5;
    double minWidth = 15;
    double height = 20;
    if (MediaQuery.of(context).size.width < 380) {
      margin = 5;
      height = 15;
      minWidth = 15;
    }
    return GestureDetector(
      onTap: tap,
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - minWidth,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 20,
              margin: EdgeInsets.only(top: height, left: margin, right: margin),
              foregroundDecoration: warna,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: TextButton.icon(
                onPressed: tap,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: Colors.white,
                ),
                icon: Image.asset(
                  images!,
                  width: 25,
                  height: 25,
                ),
                label: Text(
                  title!,
                  style: TextStyle(fontSize: 12),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}