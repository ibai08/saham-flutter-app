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
  File? image;
  final picker = ImagePicker();

  Future openCamera() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      Get.back();
    }
  }

  Future openFile() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      Get.back();
    }
  }

  Future<void> optionsDialogBox() async {
    bool cek = await cekPermission();
    if (cek == false) {
      showAlert(Get.context!, LoadingState.warning, "Izinkan untuk mulai mengupload foto");
    }
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          titlePadding: EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Text('Take a picture'),
                  ),
                  onTap: openCamera,
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Text('Select from gallery'),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void onRefresh() async {
    await UserModel.instance.refreshUserData();
    refreshController.refreshCompleted();
  }
}