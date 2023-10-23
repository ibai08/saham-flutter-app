import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/views/widgets/get_alert.dart';
import '../../../../constants/app_colors.dart';
import '../../../../controller/app_state_controller.dart';
import '../../../../controller/profile_controller.dart';
import '../../../../views/appbar/navtxt.dart';
import '../../../widgets/btn_with_image.dart';
import '../../../widgets/default_image.dart';
import '../../../widgets/image_from_network.dart';
import '../../../widgets/prompt_text.dart';

import '../../../../function/helper.dart';
import '../../../../models/user.dart';

class Profile extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());
  final AppStateController appStateController = Get.find();

  Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: NavTxt(title: "Profile"),
        backgroundColor: AppColors.grey2,
        body: SmartRefresher(
          controller: profileController.refreshController,
          onRefresh: profileController.onRefresh,
          enablePullDown: true,
          enablePullUp: false,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  padding: const EdgeInsets.only(bottom: 20, top: 5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.01, 0.01],
                      colors: [Colors.white, Colors.white]
                    )
                  ),
                  child: ListView(
                    padding:const EdgeInsets.only(top: 20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                profileController.optionsDialogBox();
                              },
                              child: profileController.image.value == null ? ImageFromNetwork(
                                appStateController.users.value.avatar, defaultImage: Image.asset('assets/logo-gray.png', width: 95, height: 95),
                              ) : DefaultImage(
                                option: "1",
                                tex: profileController.image.value,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                profileController.optionsDialogBox();
                              },
                              child: Image.asset(
                                'assets/icon-pencil-green.png',
                                width: 25,
                                height: 25,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      profileController.image.value != null ? UploadBtn(image: profileController.image.value) : const SizedBox(),
                      Text(
                        appStateController.users.value.fullname!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        appStateController.users.value.email!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGrey
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        appStateController.users.value.phone!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGrey
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BtnWithImage(
                  tap: () {
                    Get.toNamed('/more/mrg');
                  },
                  title: "ABC",
                  icon: Image.asset(
                    'assets/logo-black.png',
                    width: 30,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                BtnWithImage(
                  tap: () {
                    Get.toNamed('/more/askap');
                  },
                  title: "DEFGHIJK",
                  icon: Image.asset(
                    'assets/logo-black.png',
                    width: 30,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                PromptText(
                  title: "Personal",
                  desc: "Info dasar, seperti nama dan email yang anda gunakan di layanan XYZ",
                  textBtn: "Edit Profile",
                  url: () {
                    Get.toNamed('/forms/editprofile');
                  },
                ),
                PromptText(
                  title: "Kata Sandi",
                  desc: "Kendalikan akun Anda dengan kata sandi yang Anda inginkan",
                  textBtn: "Ganti Kata Sandi",
                  url: () {
                    Get.toNamed('/forms/editpassword');
                  },
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            )
          ),
        ),
      );
    });
  }
}

class UploadBtn extends StatelessWidget {
  final File? image;
  final DialogController dialogController = Get.find();
  final ProfileController profileController = Get.find();
  UploadBtn({Key? key, this.image}) : super(key: key);

  Future<void> upload() async {
    if (image == null || !image!.existsSync()) {
      // dialoshowToast(Get.context!, "WRONG_FILE_IMAGE", "TUTUP");
      dialogController.showToast("WRONG_FILE_IMAGE", "TUTUP");
      return;
    }

    // DialogLoading dlg = DialogLoading();
    try {
      dialogController.setProgress(LoadingState.progress, "Mohon Tunggu");
      // showDialog(
      //     barrierDismissible: false,
      //     context: Get.context!,
      //     builder: (context) => dlg).catchError((err) => throw err);
      await Future.delayed(const Duration(seconds: 1));
      if (await UserModel.instance.updateProfilePicture(image!)) {
        // Navigator.pop(Get.context!);
        // Navigator.pop(Get.context!);
        Get.back();
        // Navigator.pushNamed(context, "/more/profile");
        // Get.toNamed('/more/profile');
        // showAlert(Get.context!, LoadingState.success, "Profile berhasil diperbarui");
        dialogController.setProgress(LoadingState.success, "Profile berhasil diperbarui");
        profileController.image.value = null;
      }
    } catch (e) {
      // Navigator.pop(context);
      Get.back();
      // showAlert(
      //     Get.context!, LoadingState.error, translateFromPattern(e.toString()));
      dialogController.setProgress(LoadingState.error, translateFromPattern(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: upload,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(5)),
            child: const Text(
              "Upload",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        )
      ],
    );
  }
}