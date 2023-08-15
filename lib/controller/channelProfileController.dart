import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/core/string.dart';
import 'package:saham_01_app/function/helper.dart';
import 'package:saham_01_app/function/removeFocus.dart';
import 'package:saham_01_app/function/showAlert.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/views/widgets/dialogLoading.dart';

class ChannelProfileController extends GetxController {
  final Rx<ChannelCardSlim?> channel = Rx<ChannelCardSlim?>(null);
  
  void setChannel(ChannelCardSlim channels) {
    channel.value = channels;
  }

  String price = "FREE";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> submitToken() async {
    removeFocus(Get.context);
    var valid = false;
    if (formKey.currentState!.validate()) {
      valid = true;
    }

    if (valid) {
      formKey.currentState?.save();
      DialogLoading dlg = DialogLoading();
      try {
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) {
            return dlg;
          }
        ).catchError((err) {
          throw err;
        });
        await Future.delayed(Duration(seconds: 2));
        Navigator.pop(Get.context!);
        showAlert(
          Get.context!, LoadingState.success, "TOKEN berhasil dikonfirmasi", thens: (x) {
            Navigator.pop(Get.context!, true);
          }
        );

      } catch (e) {
        Navigator.pop(Get.context!);
        showAlert(Get.context!, LoadingState.error, translateFromPattern(e.toString()));
      }
    }
  }

  Rx<Level?> medal = Rx<Level?>(null);
  Future<Level> getMedal({bool clearCache = false}) async {
    return ChannelModel.instance.getMedalList(clearCache: clearCache);
  }

  @override
  void onInit() {
    super.onInit();
    if (channel.value!.price! > 0) {
      price = numberShortener(channel.value!.price!.floor());
    }
    Future.delayed(Duration(microseconds: 0)).then((_) async {
      var result = await getMedal();
      medal.value = result;
    });
  }
}