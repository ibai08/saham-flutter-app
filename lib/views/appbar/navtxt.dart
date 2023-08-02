import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saham_01_app/constants/app_colors.dart';

class NavTxt extends AppBar {
  NavTxt({Key? key, String? title, tap})
      : super(
            key: key,
            title: Text(
              title!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            shadowColor: AppColors.white,
            elevation: 2,
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: AppColors.white),
            iconTheme: const IconThemeData(color: Colors.black));

  // NavTxt.stream({Key? key, StreamBuilder<String>? title, tap})
  //     : super(
  //           key: key,
  //           title: title,
  //           centerTitle: true,
  //           backgroundColor: Colors.white,
  //           shadowColor: ConstColor.white,
  //           elevation: 2,
  //           systemOverlayStyle:
  //               SystemUiOverlayStyle(statusBarColor: ConstColor.white),
            // iconTheme: IconThemeData(color: Colors.black));
}