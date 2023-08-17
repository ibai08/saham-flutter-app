import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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

  NavTxt.getx({Key? key, RxString? title, tap})
      : super(
            key: key,
            title: Text(title?.value ?? ""),
            centerTitle: true,
            backgroundColor: Colors.white,
            shadowColor: AppColors.white,
            elevation: 2,
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: AppColors.white),
            iconTheme: IconThemeData(color: Colors.black));
}
