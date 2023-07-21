import 'dart:io';

import 'package:flutter/material.dart';

class DefaultImage extends StatelessWidget {
  const DefaultImage(
      {Key? key, this.option, this.image, this.width, this.tex, this.paddingTop})
      : super(key: key);

  final AssetImage? image;
  final String? option;
  final File? tex;
  final double? width;
  final double? paddingTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 120,
      height: width ?? 120,
      margin: EdgeInsets.only(top: paddingTop ?? 0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: option == null
                  ? const AssetImage(
                      'assets/icon/brands/tf-square-pad-bg-darkgreen.png',
                    ) as ImageProvider
                  : FileImage(
                      tex!,
                    )
    )));
  }
}