// ignore_for_file: must_call_super

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/controller/home_tab_controller.dart';
import 'package:saham_01_app/controller/new_signal_controller.dart';
import 'package:saham_01_app/views/widgets/get_alert.dart' as alert;
import '../../../controller/app_state_controller.dart';
import '../../../controller/signal_tab_controller.dart';
import '../../../function/helper.dart';
import '../../../function/remove_focus.dart';
import '../../../models/user.dart';
import '../../widgets/btn_block.dart';
import '../../widgets/dialog_loading.dart';

class VerifyEmailController extends GetxController {
  RxInt? time = 0.obs;
  Timer? timer;

  final AppStateController appStateController = Get.find();
  final NewHomeTabController newHomeTabController = Get.find();
  final alert.DialogController dialogController = Get.find();
  ListChannelWidgetController listChannelWidgetController = Get.find();
  ListSignalWidgetController listSignalWidgetController = Get.find();
  NewSignalController newSignalController = Get.find();
  HomeTabController homeTabController = Get.find();

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

    // DialogLoading dlg = DialogLoading();
    // showDialog(
    //     context: ctx,
    //     barrierDismissible: false,
    //     builder: (ctx) {
    //       return dlg;
    //     });
    dialogController.setProgress(alert.LoadingState.progress, "Mohon Tunggu", null, null, null);
    try {
      if (await UserModel.instance.resendVerifyEmailAuthorized()) {
        // Navigator.pop(ctx);
        Get.back();
        // showAlert(ctx, LoadingState.success,
        //     translateFromPattern("RESEND_VERIFY_EMAIL_SUCCESS"));
        dialogController.setProgress(alert.LoadingState.success, translateFromPattern("RESEND_VERIFY_EMAIL_SUCCESS"), null, null, null);
      } else {
        throw Exception("RESEND_VERIFY_EMAIL_FAILED");
      }
      performTime();
    } catch (ex) {
      // Navigator.pop(ctx);
      Get.back();
      // TODOs: Ganti getalert
      // showAlert(ctx, LoadingState.error, translateFromPattern(ex.toString()));
      dialogController.setProgress(alert.LoadingState.error, translateFromPattern(ex.toString()), null, null, null);
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
      time?.value--;
      if (time!.value < 1) {
        timer.cancel();
      }
    });
  }

  onRefresh() async {
    await UserModel.instance.refreshUserData();
    refreshController.refreshCompleted();
    if (appStateController.users.value.verify!) {
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
        // Get.delete<HomeTabController>().then((value) => Get.put(HomeTabController()));
        // Get.delete<SignalDashboardController>().then((value) => Get.put(SignalDashboardController()));
        // Get.delete<ListChannelWidgetController>().then((value) => Get.put(ListChannelWidgetController()));
        // Get.delete<ListSignalWidgetController>().then((value) => Get.put(ListSignalWidgetController()));
        // Get.delete<NewSignalController>().then((value) => Get.put(NewSignalController()));
        appStateController.setAppState(Operation.bringToHome, HomeTab.home);
        // Get.back();
        listChannelWidgetController.initializePageChannelAsync();
        listSignalWidgetController.initializePageSignalAsync();
        newSignalController.initializePageChannelAsync();
        homeTabController.onRefresh();
        newHomeTabController.tab.value = HomeTab.home;
        newHomeTabController.tabController.animateTo(0,duration: const Duration(milliseconds: 200),curve:Curves.easeIn);
        dialogController.setProgress(alert.LoadingState.success, "Login Berhasil", null, null, null);
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
            Get.back();
            // TODOs: ganti GetALert
            await dialogController.setProgress(alert.LoadingState.success, translateFromPattern("VERIFY_EMAIL_SUCCESS"), null, null, null);
            Get.toNamed("/forms/afterverify");
            // showAlert(Get.context!, LoadingState.success,
            //     translateFromPattern("VERIFY_EMAIL_SUCCESS"), thens: (x) {
            //   Get.toNamed("/forms/afterverify");
            // });
          } else {
            Get.back();
          }
        } catch (ex) {
          Get.back();
          dialogController.setProgress(alert.LoadingState.error, translateFromPattern(ex.toString()), null, null, null);
          // showAlert(Get.context!, LoadingState.error,
          //     translateFromPattern(ex.toString()));
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
