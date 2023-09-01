import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/function/removeFocus.dart';

import '../function/helper.dart';
import '../function/showAlert.dart';
import '../models/user.dart';
import '../views/widgets/dialogLoading.dart';
import '../views/widgets/toast.dart';

class EditPasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map data = Map();

  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  final oldPassFocus = FocusNode();
  final newPassFocus = FocusNode();
  final confirmPassFocus = FocusNode();

  RxBool seePass = true.obs;
  RxBool seePassCon = true.obs;
  RxBool seePassOld = true.obs;

  void toggleOldPassVisibility() {
    seePassOld.value = !seePassOld.value;
  }

  void togglePassVisibility() {
    seePass.value = !seePass.value;
  }

  void toggleConfirmPassVisibility() {
    seePassCon.value = !seePassCon.value;
  }

  Future<void> ChangePassword(BuildContext context) async {
    removeFocus(context);
    var valid = false;
    if (formKey.currentState!.validate()) {
      valid = true;
    }
    if (valid) {
      formKey.currentState?.save();
      String oldpass = oldPassController.text;
      String newpass = newPassController.text;
      String confirm = confirmPassController.text;
      if (oldpass == "" || newpass == "" || confirm == "") {
        showToast(context, "SEMUA_FIELD_TIDAK_BOLEH_KOSONG", "CLOSE_TOAST");
        return;
      } else if (confirm != newpass) {
        showToast(context, "KONFIRMASI_KATA_SANDI_HARUS_SAMA", "CLOSE_TOAST");
        return;
      }

      showDialog(
          barrierDismissible: false,
          context: Get.context!,
          builder: (context) {
            return DialogLoading();
          });

      // gunakan do while untuk jaga" apakah token sudah expired...
      try {
        bool result = await UserModel.instance.changePassword(oldpass, newpass);
        if (result) {
          Get.back(canPop: true);
          showAlert(context, LoadingState.success, "SUKSES_MERUBAH_PASSWORD",
              thens: (x) {
            Get.back(canPop: true);
          });
          // showToast(context, "SUKSES_MERUBAH_PASSWORD", "CLOSE_TOAST");
          // await Future.delayed(Duration(seconds: 2));
          // Navigator.pop(context);
        }
      } catch (xerr) {
        Get.back(canPop: true);
        showAlert(
            context, LoadingState.error, translateFromPattern(xerr.toString()));
      }
    }

  }
}