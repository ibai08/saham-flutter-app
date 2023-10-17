import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/function/helper.dart';
import 'package:saham_01_app/function/removeFocus.dart';
import 'package:saham_01_app/models/user.dart';
import 'package:saham_01_app/views/widgets/getAlert.dart';

class ForgotPassController extends GetxController {
  final DialogController dialogController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map data = {}.obs;
  RxBool valid = false.obs;

  final TextEditingController emailCon = TextEditingController();

  Future<void> performReset(BuildContext ctx) async {
    removeFocus(ctx);
    valid.value = formKey.currentState!.validate();
    if (valid.value) {
      formKey.currentState!.save();
      dialogController.setProgress(LoadingState.progress, "Mohon Tunggu");
      try {
        if (await UserModel.instance.resetPassword(data["email"])) {
          Get.back();
          dialogController.setProgress(LoadingState.success, "Password berhasil direset. Silahkan untuk memeriksa email Anda");
        } else {
          throw Exception("CONNECTION_FAILED");
        }
      } catch (x) {
        Get.back();
        dialogController.setProgress(LoadingState.error, translateFromPattern(x.toString()));
      }
    }
  }
}