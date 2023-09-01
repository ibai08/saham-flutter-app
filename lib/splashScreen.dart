// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'constants/app_colors.dart';
import 'core/config.dart';
import 'core/getStorage.dart';
import 'function/checkPermission.dart';
import 'function/forceUpdate.dart';

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
      Get.offNamed("/home");
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((x) async {
     try {
        print("proses 1");
        await cekPermissionNotif();
        print("proses 2");
        await remoteConfig.fetchAndActivate();
        print("proses 3");
        var maintenance = remoteConfig.getString("maintenance_until");
        print("proses 4");
        var until = DateTime.tryParse(maintenance);
        print("proses 5");
        if (until != null && until.isAfter(DateTime.now())) {
          print("proses 6");
          // Navigator.of(context)
          //     .pushReplacementNamed('/maintenance', arguments: until);
        Get.offNamed('/maintenance', arguments:  until);
        print("proses 7");

        } else {
          print("proses 8");
          if (await versionCheck()) {
            print("proses sebelum 9");
            // Get.offNamed('/update-app');
            // Note ketika sudah ready unkomen baris diatas dan jangan pakai Get yang mengarah ke home
            Get.offNamed('/home');
            print("proses 9");
            // Navigator.of(context).pushReplacementNamed('/update-app');
          } else {
            print("proses 10");
            await GetStorage.init();
            print("proses 11");
            if (GetStorage(CacheKey.initOnboardScreen) == null ||
                GetStorage(CacheKey.initOnboardScreen) == false) {
              // Navigator.of(context).pushReplacementNamed('/board/slider');
              // Navigator.of(context).pushReplacementNamed('/home');
              print("proses 12");
              Get.offNamed('/home');
            } else {
              // Navigator.of(context).pushReplacementNamed('/home');
              print("proses 13");
              Get.offNamed('/home');
              print("proses 14");
              // Navigator.of(context).pushReplacementNamed('/board/slider');
            }
          }
          print("proses unknown");
        }
      } catch (ex) {
        print("Error splash screen: ${ex.toString()}");
        Get.offNamed('/remote-config');
        // Navigator.of(context).pushReplacementNamed('/remote-config');
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
