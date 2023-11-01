import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/function/remove_focus.dart';
import 'package:saham_01_app/views/widgets/get_alert.dart';

import '../function/helper.dart';
import '../models/user.dart';

class EditPasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DialogController dialogController = Get.find();
  final Map data = {};

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

  Future<void> changePassword(BuildContext context) async {
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
        // showToast(context, "SEMUA_FIELD_TIDAK_BOLEH_KOSONG", "CLOSE_TOAST");
        dialogController.showToast("SEMUA FIELD TIDAK BOLEH KOSONG", "TUTUP");
        return;
      } else if (confirm != newpass) {
        dialogController.showToast("KONFIRMASI KATA SANDI HARUS SAMA", "TUTUP");
        return;
      }

      // showDialog(
      //     barrierDismissible: false,
      //     context: Get.context!,
      //     builder: (context) {
      //       return DialogLoading();
      //     });
      dialogController.setProgress(LoadingState.progress, "Mohon Tunggu", null, null, null);

      // gunakan do while untuk jaga" apakah token sudah expired...
      try {
        bool result = await UserModel.instance.changePassword(oldpass, newpass);
        if (result) {
          Get.back();
          // showAlert(context, LoadingState.success, "SUKSES_MERUBAH_PASSWORD",
          //     thens: (x) {
          //   Get.back(canPop: true);
          // });
          await dialogController.setProgress(LoadingState.success, "SUKSES MERUBAH PASSWORD", null, null, null);
          // showToast(context, "SUKSES_MERUBAH_PASSWORD", "CLOSE_TOAST");
          // await Future.delayed(const Duration(seconds: 2));
          Get.back();
          // Navigator.pop(context);
        }
      } catch (xerr) {
        Get.back();
        dialogController.setProgress(LoadingState.error, translateFromPattern(xerr.toString()), null, null, null);
        // showAlert(
        //     context, LoadingState.error, translateFromPattern(xerr.toString()));
      }
    }

  }
}