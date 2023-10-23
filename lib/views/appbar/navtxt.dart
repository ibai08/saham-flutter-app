import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';

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
            title: Obx(
              () => Text(
                title?.value ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            shadowColor: AppColors.white,
            elevation: 2,
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: AppColors.white),
            iconTheme: const IconThemeData(color: Colors.black),
            leading: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.arrow_back),
              onPressed: tap,
            ));
}
