// ignore_for_file: must_call_super

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/controller/homeTabController.dart';
import 'package:saham_01_app/controller/newSignalController.dart';
import '../../../controller/appStatesController.dart';
import '../../../controller/signalTabController.dart';
import '../../../function/helper.dart';
import '../../../function/removeFocus.dart';
import '../../../function/showAlert.dart';
import '../../../models/user.dart';
import '../../../views/widgets/btnBlock.dart';
import '../../../views/widgets/dialogLoading.dart';

class VerifyEmailController extends GetxController {
  RxInt? time = 0.obs;
  Timer? timer;

  final AppStateController appStateController = Get.put(AppStateController());

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  // void startTimer() {
  //   time.value = 90;
  //   timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     time.value;
  //     if (time.value <= 0) {
  //       timer.cancel();
  //     }
  //   });
  // }

  Future<void> peformResend(BuildContext ctx) async {
    removeFocus(ctx);

    DialogLoading dlg = DialogLoading();
    showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (ctx) {
          return dlg;
        });
    try {
      print("satusssssssss5");
      if (await UserModel.instance.resendVerifyEmailAuthorized()) {
        Navigator.pop(ctx);
        print("satusssssssss6");
        showAlert(ctx, LoadingState.success,
            translateFromPattern("RESEND_VERIFY_EMAIL_SUCCESS"));
      } else {
        print("satusssssssss7");
        throw Exception("RESEND_VERIFY_EMAIL_FAILED");
      }
      performTime();
    } catch (ex) {
      Navigator.pop(ctx);
      print("satusssssssss8");
      showAlert(ctx, LoadingState.error, translateFromPattern(ex.toString()));
    }
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  performTime() {
    time?.value = 90;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      time?.value;
      if (time!.value <= 0) {
        timer.cancel();
      }
    });
  }

  onRefresh() async {
    await UserModel.instance.refreshUserData();
    refreshController.refreshCompleted();
    if (appStateController.users.value.verify!) {
      print("satusssssssss10");
      appStateController.setAppState(Operation.bringToHome, HomeTab.home);
      return;
    } else if (appStateController.users.value.verify == null) {
      return const SizedBox();
    }
  }

  @override
  void onInit() {
    performTime();
    Future.delayed(const Duration(seconds: 0)).then((value) async {
      if (appStateController.users.value.verify!) {
        appStateController.setAppState(Operation.bringToHome, HomeTab.home);
        
        return;
      }

      if (ModalRoute.of(Get.context!)!.settings.arguments is String) {
        String? token =
            ModalRoute.of(Get.context!)?.settings.arguments as String?;
        DialogLoading dlg = DialogLoading();
        showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (ctx) {
              return dlg;
            });
        try {
          if (await UserModel.instance.verifyEmail(token: token!)) {
            print("satusssssssss");
            Get.back();
            print("satusssssssss2");
            showAlert(Get.context!, LoadingState.success,
                translateFromPattern("VERIFY_EMAIL_SUCCESS"), thens: (x) {
              Get.toNamed("/forms/afterverify");
            });
          } else {
            print("satusssssssss3");
            Get.back();
          }
        } catch (ex) {
          print("satusssssssss4");
          Get.back();
          showAlert(Get.context!, LoadingState.error,
              translateFromPattern(ex.toString()));
        }
      }
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}

class VerifyEmail extends StatelessWidget {
  VerifyEmail({Key? key}) : super(key: key);

  final VerifyEmailController verifyController =
      Get.put(VerifyEmailController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          controller: verifyController.refreshController,
          onRefresh: verifyController.onRefresh,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                    child: Image.asset(
                  "assets/logo-gray.png",
                  width: 60,
                )),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Email Verifikasi",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 21),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Kami perlu mengetahui email Anda valid atau tidak,",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.grey[900]),
                    children: [
                      const TextSpan(
                        text:
                            "Kami telah mengirim kode verifikasi ke email Anda di ",
                      ),
                      TextSpan(
                          text: verifyController
                              .appStateController.users.value.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          )),
                      const TextSpan(
                        text:
                            ". Silahkan periksa email Anda untuk melakukan verifikasi",
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Tidak menerima email? ",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Obx(() {
                  if (verifyController.time?.value == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return verifyController.time!.value <= 0
                      ? BtnBlock(
                          onTap: () {
                            verifyController.peformResend(context);
                          },
                        )
                      : Text(
                          verifyController._printDuration(
                              Duration(seconds: verifyController.time!.value)),
                          style: const TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w600),
                        );
                }),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
