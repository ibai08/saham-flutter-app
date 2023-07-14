import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/views/pages/home.dart';
import 'constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isMaintenance = false;
  bool isUpdate = false;

  startTime() async {
    var _duration = const Duration(seconds: 0);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    if (isMaintenance) {
      print("maintenanceeee");
      Get.toNamed("/maintenance");
    } else if (isUpdate) {
      print("updateeeee");
      Get.toNamed("/update");
    } else {
      print("homeeee");
      Get.toNamed("/");
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((x) async {
      try {
        // await cekPermissionNotif();

        // await remoteConfig.fetchAndActivate();
        // var maintenance = remoteConfig.getString("maintenance_until");
        // var until = DateTime.tryParse(maintenance);
        // if (until != null && until.isAfter(DateTime.now())) {
        if (false) {
          print("maintenance");
          Get.toNamed("/maintenance", arguments: "");
        } else {
          // if (await versionCheck()) {
          if (false) {
            Get.toNamed("/update-app");
          } else {
            print("versionCheck()");
            Get.to(() => Home());
          }
        }
      } catch (ex) {
        print(ex);
        Get.toNamed("/remote-config");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.light,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.light,
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons))),
        ),
        backgroundColor: AppColors.light,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Image.asset(
              "assets/logo-gray.png",
              width: 210,
            )),
          ],
        ),
      ),
    );
  }
}
