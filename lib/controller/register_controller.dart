import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/app_state_controller.dart';
import 'package:saham_01_app/controller/home_tab_controller.dart';
import 'package:saham_01_app/views/widgets/get_alert.dart';

import '../function/helper.dart';
import '../function/remove_focus.dart';
import '../models/user.dart';


class RegisterController extends GetxController {
  final AppStateController appStateController = Get.find();
  final DialogController dialogController = Get.find();
  final NewHomeTabController newHomeTabController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final fullnameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final phoneController = TextEditingController();
  final domisiliController = TextEditingController();

  RxBool isNewsLetter = true.obs;

  final FocusNode emailFocus = FocusNode();
  final FocusNode fullnameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode passwordConfirmFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode domisiliFocus = FocusNode();

  late Map? domMap;

  RxBool trySubmit = false.obs;
  final Map data = {};

  RxBool seePass = true.obs;
  RxBool seePassCon = true.obs;

  RxBool isEmailDisabled = false.obs;
  String token = '';

  void togglePass() {
    seePass.value = !seePass.value;
  }

  void togglePassCon() {
    seePassCon.value = !seePassCon.value;
  }

  Future<void> performRegister() async {
    removeFocus(Get.context);
    trySubmit.value = true;

    var valid = false;
    if (formKey.currentState!.validate()) {
      valid = true;
    }
    if (valid) {
      formKey.currentState?.save();
      try {
        // showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     builder: (context) {
        //       return dlg;
        //     });
        dialogController.setProgress(LoadingState.progress, "Mohon Tunggu", null, null, null);

        bool result = await UserModel.instance.registerWithCity(
            token: token,
            email: emailController.text,
            name: fullnameController.text,
            password: passwordController.text,
            passconfirm: passwordConfirmController.text,
            phone: phoneController.text,
            city: domMap?["code"],
            subscribe: isNewsLetter.value ? 1 : 0);
        if (result && token == '') {
          // Navigator.pop(context);
          // Get.back(canPop: true);
          Get.back();
          Get.toNamed('/forms/login');
          // Get.toNamed('/forms/login');
          // Navigator.pushNamed(context, "/forms/login"); // nyangkut disini
          // showAlert(
          //   context,
          //   LoadingState.success,
          //   "Pendaftaran berhasil, silahkan cek email Anda untuk meverifikasi email Anda",
          // );
          dialogController.setProgress(LoadingState.success, "Pendaftaran berhasil, silahkan cek email Anda untuk memverifikasi email Anda", null, null, null);
        } else if (token != '') {
          // Navigator.popUntil(context, ModalRoute.withName("/home"));
          Get.until((route) => route.settings.name == '/home');
          // showAlert(
          //   context,
          //   LoadingState.success,
          //   "Pendaftaran berhasil",
          // );
          dialogController.setProgress(LoadingState.success, "Pendaftaran berhasil", null, null, null);
          newHomeTabController.tab.value = HomeTab.home;
          newHomeTabController.tabController.animateTo(0,duration: const Duration(milliseconds: 200),curve:Curves.easeIn);
          // return true;
        }
      } catch (e) {
        // print("error register: $e");
        // print(stack);
        // // Navigator.pop(context);
        // // showAlert(context, LoadingState.error, translateFromPattern(e.toString()));
        Get.back();
        dialogController.setProgress(LoadingState.error, translateFromPattern(e.toString()), null, null, null);
      }
      // return false;
    }
    // return null;
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 0)).then((_) {
      Map? arg = ModalRoute.of(Get.context!)?.settings.arguments as Map?;
      if (arg != null) {
        Map userInfo = arg["userInfo"] is Map ? arg["userInfo"] : null;
        token = arg["token"] is String ? arg["token"] : '';
        // ignore: unnecessary_null_comparison
        if (userInfo != null) {
          emailController.text = userInfo['email'];
          fullnameController.text = userInfo['displayName'];
          isEmailDisabled.value = true;
        }
      }
      if (appStateController.users.value.id > 0 && !appStateController.users.value.isProfileComplete()) {
        Get.offAndToNamed('/forms/editprofile');
      }
    });
  }
}