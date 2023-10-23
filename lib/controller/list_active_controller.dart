// ignore_for_file: prefer_is_empty

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/signal.dart';

class ListActiveController extends GetxController {
  RefreshController refreshController = RefreshController(initialRefresh: false);
  Rx<List<SignalInfo>> signalInfo = Rx<List<SignalInfo>>([]);
  List<SignalInfo> listSignal = [];
  RxInt channels = 0.obs;
  RxBool hasError = false.obs;
  RxBool hasLoad = false.obs;
  RxBool subscribed = false.obs;
  RxBool isInit = false.obs;
  RxBool noActiveSignal = false.obs;
  RxString errorMessage = "".obs;

  void setInfo(List<SignalInfo> cc) {
    signalInfo.value = cc;
  }

  void onLoading() async {
    int offset = 0;
    try {
      offset = signalInfo.value.length;
      List<SignalInfo> activeSignal = await SignalModel.instance.getChannelSignals(channels.value, 1, offset);
      if (activeSignal.length > 0) {
        signalInfo.value = activeSignal;
        refreshController.loadComplete();
      } else {
        signalInfo.value = activeSignal;
        noActiveSignal.value = true;
        refreshController.loadNoData();
      }
      hasError.value = false;
      hasLoad.value = true;
      errorMessage.value = "";
    } catch (e) {
      hasError.value = true;
      hasLoad.value = false;
      errorMessage.value = e.toString();
      refreshController.loadFailed();
    }
  }

  void onRefresh() async {
    signalInfo.value.clear();
    onLoading();
  }

  @override
  void onInit() {
    super.onInit();
    isInit.value = true;
  }

  @override
  void onReady() {
    super.onReady();
    onLoading();
  }
}