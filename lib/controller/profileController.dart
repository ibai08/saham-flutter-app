import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../function/checkPermission.dart';
import '../function/showAlert.dart';
import '../views/widgets/dialogLoading.dart';

import '../models/user.dart';

class ProfileController extends GetxController {
  RefreshController refreshController = RefreshController();
  Rx<File?> image = Rx<File?>(null);
  final picker = ImagePicker();

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
        print("imageee: ${image.value}");
      } catch(ex) {
        print("error: ${ex.toString()}");
      }
      print("pickfile: ${pickedFile.path}");
      print("fileee: ${File(pickedFile.path)}");
      Get.back();
    }
  }

  Future<void> optionsDialogBox() async {
    bool cek = await cekPermission();
    print("ceksss");
    print(" ---------n: ${await cekPermission()}");
    if (cek == false) {
      showAlert(Get.context!, LoadingState.warning, "Izinkan untuk mulai mengupload foto");
    }
    if (cek == true) {
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