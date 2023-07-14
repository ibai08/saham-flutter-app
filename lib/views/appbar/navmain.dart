import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saham_01_app/constants/app_colors.dart';

class NavMain extends AppBar {
  NavMain({Key? key, Widget? title})
      : super(
            key: key,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'assets/icon/brands/tf-teks.png',
                  width: 180,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            elevation: 2,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppColors.white,
                statusBarIconBrightness: Brightness.dark),
            iconTheme: IconThemeData(color: AppColors.black),
            centerTitle: true,
            backgroundColor: AppColors.white,
            shadowColor: AppColors.white);
}
