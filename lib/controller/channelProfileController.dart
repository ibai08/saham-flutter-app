// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../function/helper.dart';
import '../../function/removeFocus.dart';
import '../../function/showAlert.dart';
import '../../models/channel.dart';
import '../../models/entities/ois.dart';
import '../../views/widgets/dialogLoading.dart';

class ChannelProfileController extends GetxController {
  final Rx<ChannelCardSlim?>? channel = Rx<ChannelCardSlim?>(null);

  void setChannel(ChannelCardSlim channels) {
    channel?.value = channels;
  }

  RxBool isInit = false.obs;

  RxString price = "0".obs;

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
            }).catchError((err) {
          throw err;
        });
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(Get.context!);
        showAlert(
            Get.context!, LoadingState.success, "TOKEN berhasil dikonfirmasi",
            thens: (x) {
          Navigator.pop(Get.context!, true);
        });
      } catch (e) {
        Navigator.pop(Get.context!);
        showAlert(Get.context!, LoadingState.error,
            translateFromPattern(e.toString()));
      }
    }
  }

  Rx<Level?> medal = Rx<Level?>(null);
  Future<Level> getMedal({bool clearCache = false}) async {
    return ChannelModel.instance.getMedalList(clearCache: clearCache);
  }

  // @override
  // void onReady() {
  //   super.onReady();
  //   // if (channel!.value?.price != null) {
  //   //   if (channel!.value!.price! > 0) {
  //   //     price.value = numberShortener(channel!.value!.price!.floor());
  //   //   }
  //   // } else {
  //   //   print("null kenanya");
  //   // }
  //   // if (channel!.value!.price! > 0) {
  //   //   price.value = numberShortener(channel!.value!.price!.floor());
  //   // }
  //   print("channel: ${channel?.value?.price}");
  //   if (double.parse(price.value) > 0) {
  //     price.value = numberShortener(channel!.value!.price!.floor());
  //   } else {
  //     price.value = "FREE";
  //   }

  // }

  // @override
  // void onUpdate() {
  //   super.on
  // }
  var penyimpanan;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
      var result = await getMedal();
      medal.value = result;
    });
    
    print(channel?.value?.medals);
    print("udah init");
  }

  @override
  void onReady() {
    isInit.value = true;
    print("---232 ${channel?.value?.medals}");
    print("udah ready kuy");
  }

}
