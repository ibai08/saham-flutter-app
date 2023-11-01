import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/views/widgets/get_alert.dart';
import '../function/check_permission.dart';
// import '../function/show_alert.dart';
// import '../views/widgets/dialog_loading.dart';

import '../models/user.dart';

class ProfileController extends GetxController {
  RefreshController refreshController = RefreshController();
  Rx<File?> image = Rx<File?>(null);
  final picker = ImagePicker();
  DialogController dialogController = Get.find();
  RxBool cek = false.obs;

  Future openCamera() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      Get.back();
    }
  }

  Future openFile() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (pickedFile != null) {
      try {
        image.value = File(pickedFile.path);
      } catch(ex) {
        throw Exception(ex.toString());
      }
      Get.back();
    }
  }

  Future<void> optionsDialogBox() async {
    cek.value = await cekPermission();
    if (cek.value == false) {
      // showAlert(Get.context!, LoadingState.warning, "Izinkan untuk mulai mengupload foto");
      await dialogController.setProgress(LoadingState.warning, "Izinkan untuk mulai mengupload foto", "Izinkan akses", true, null);
      Get.back();
    }
    if (cek.value == true) {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            titlePadding: const EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: const Text('Take a picture'),
                    ),
                    onTap: openCamera,
                  ),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: const Text('Select from gallery'),
                    ),
                    onTap: openFile,
                  ),
                ],
              ),
            ),
          );
        }
      );
    }
    
  }

  void onRefresh() async {
    await UserModel.instance.refreshUserData();
    refreshController.refreshCompleted();
  }
}