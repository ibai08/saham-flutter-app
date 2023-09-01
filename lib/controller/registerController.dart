import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/appStatesController.dart';

import '../function/helper.dart';
import '../function/removeFocus.dart';
import '../function/showAlert.dart';
import '../models/user.dart';
import '../views/widgets/dialogLoading.dart';

class RegisterController extends GetxController {
  final AppStateController appStateController = Get.find();
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
  final Map data = Map();

  RxBool seePass = true.obs;
  RxBool seePassCon = true.obs;

  bool isEmailDisabled = false;
  String token = '';

  void togglePass() {
    seePass.value = !seePass.value;
  }

  void togglePassCon() {
    seePassCon.value = !seePassCon.value;
  }

  

  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 0)).then((_) {
      Map? arg = ModalRoute.of(Get.context!)?.settings.arguments as Map?;
      if (arg != null) {
        Map userInfo = arg["userInfo"] is Map ? arg["userInfo"] : null;
        token = arg["token"] is String ? arg["token"] : '';
        if (userInfo != null) {
          emailController.text = userInfo['email'];
          fullnameController.text = userInfo['displayName'];
          isEmailDisabled = true;
        }
      }
      if (appStateController.users.value.id > 0 && !appStateController.users.value.isProfileComplete()) {
        Get.offAndToNamed('/forms/editprofile');
      }
    });
  }
}