import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/controller/app_state_controller.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/ois.dart';
import 'package:saham_01_app/views/widgets/get_alert.dart';

class OisDashboardController extends GetxController {
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final Rx<OisDashboardPageData?> oisStream = Rx<OisDashboardPageData?>(null);

  TextEditingController bankNameCon = TextEditingController();
  TextEditingController bankUsernameCon = TextEditingController();
  TextEditingController bankNoCon = TextEditingController();

  RxBool hasError = false.obs;
  RxString errorMessage = "".obs;

  RxMap getRoute = {}.obs;

  AppStateController appStateController = Get.find();

  Future<void> synchronize({bool clearCache = true}) async {
    try {
      oisStream.value == null;
      OisDashboardPageData data = (await Future.wait([
        OisModel.instance.synchronizeDashboard(clearCache: clearCache),
        OisModel.instance.synchronizeMyChannel(clearCache: clearCache)
      ]))[0] as OisDashboardPageData;

      oisStream.value = data;
      if (data.bankName == null || data.bankName == "") {
        bankNameCon.text = "-";
        bankUsernameCon.text = "-";
        bankNoCon.text = "-";
      } else {
        bankNameCon.text = data.bankName!;
        bankUsernameCon.text = data.bankUsername!;
        bankNoCon.text = data.bankAccount!;
      }
      hasError.value = false;
      errorMessage.value = "";
    } catch (err, stack) {
      hasError.value = true;
      errorMessage.value = err.toString();
      print("errr: $err");
      print(stack);
    }
  }

  void onRefresh() async {
    await synchronize(clearCache: true);
    refreshController.refreshCompleted();
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 0)).then((_) async {
      await synchronize(clearCache: true);

      // getRoute = Get.arguments;
      // if (getRoute != null || getRoute != {}) {
      //   Get.find<DialogController>().setProgress(getRoute["state"], getRoute["dialog"], null, null, null);
      // }
    });
  }
}