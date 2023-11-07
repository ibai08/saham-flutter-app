import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/function/helper.dart';
import 'package:saham_01_app/function/remove_focus.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/views/widgets/get_alert.dart';

import '../models/ois.dart';

class WithdrawController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxMap data = {}.obs;
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final Rx<OisMyChannelPageData> myChannelController = Rx<OisMyChannelPageData>(OisMyChannelPageData.init());
  RxBool trySumbit = false.obs;
  final TextEditingController nominalCon = TextEditingController();
  final TextEditingController bankCon = TextEditingController();
  final TextEditingController bankNoCon = TextEditingController();
  final TextEditingController bankUserNameCon = TextEditingController();
  RxInt ddChannel = 0.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = "".obs;

  Future<void> synchronize({bool clearCache = true}) async {
    try {
      // _oisStreamController.add(null);
      OisDashboardPageData data =
          await OisModel.instance.synchronizeDashboard(clearCache: clearCache);
      // _oisStreamController.add(data);
      if (data.bankName != "null") {
        bankCon.text = data.bankName!;
        bankUserNameCon.text = data.bankUsername!;
        bankNoCon.text = data.bankAccount!;
      }
      hasError.value = false;
      errorMessage.value = "";
    } catch (xerr) {
      // _oisStreamController.addError(xerr);
      hasError.value = true;
      errorMessage.value = xerr.toString();
    }

    try {
      OisMyChannelPageData myChannel =
          await OisModel.instance.synchronizeMyChannel(clearCache: clearCache);
      myChannelController.value = myChannel;
      hasError.value = false;
      errorMessage.value = "";
    } catch (xerr, stack) {
      print(stack);
      hasError.value = true;
      errorMessage.value = xerr.toString();
    }
  }

  void onRefresh() async {
    await synchronize(clearCache: true);
    refreshController.refreshCompleted();
  }

  Future<void> performWithdrawal(BuildContext context) async {
    removeFocus(context);
    trySumbit.value = true;

    bool valid = false;
    if (formKey.currentState!.validate() && data["channel"] != null) {
      valid = true;
    }

    if (valid) {
      formKey.currentState?.save();
      Get.find<DialogController>().setProgress(LoadingState.progress, "Mohon Tunggu", null, null, null);
      try {
        await OisModel.instance.submitRequestWithdrawal(data: data);
        await OisModel.instance.synchronizeMyChannel(clearCache: true);
        Get.back();
        await Get.find<DialogController>().setProgress(LoadingState.success, "Request Cash Out Berhasil", null, null, null);
        Get.back();
      } catch (e) {
        Get.back();
        Get.find<DialogController>().setProgress(LoadingState.error, translateFromPattern(e.toString()), null, null, null);
      }
    }
  }

  @override
  void onInit() {
    Future.delayed(const Duration(milliseconds: 0)).then((_) async {
      await synchronize(clearCache: true);
    });
    super.onInit();
  }
}