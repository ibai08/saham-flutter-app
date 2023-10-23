// ignore_for_file: avoid_print, unused_local_variable

import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/function/check_permission.dart';
import 'package:saham_01_app/function/force_update.dart';

import '../core/get_storage.dart';

class SplashScreenController extends GetxController {
  RxBool isMaintenance = false.obs;
  RxBool isUpdate = false.obs;

  startTime() async {
    Duration duration = const Duration(seconds: 0);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    if (isMaintenance.value) {
      Get.offNamed("/maintenance");
    } else if (isUpdate.value) {
      Get.offNamed("/update");
    } else {
      Get.offNamed("/home");
    }
  }

  @override
  void onReady() {
    super.onReady();
    print("ini kena");
    Future.delayed(Duration.zero).then((x) async {
      try {
        bool cek = await cekPermissionNotif();
        await remoteConfig.fetchAndActivate();
        var maintenance = remoteConfig.getString("maintenance_until");
        var until = DateTime.tryParse(maintenance);
        if (until != null && until.isAfter(DateTime.now())) {
          Get.offNamed("/maintenance", arguments: until);
        } else {
          if (await versionCheck()) {
            Get.offNamed("/update-app");
          } else {
            await GetStorage.init();
            var result = await GetStorage().read(CacheKey.initOnboardScreen);
            if (result == null || !result) {
              Get.offNamed("/home");
            } else {
              Get.offNamed("/home");
            }
          }
        }
      } catch (ex, stack) {
        print(ex);
        print(stack);
        Get.offNamed("/remote-config");
      }
    });
  }
}