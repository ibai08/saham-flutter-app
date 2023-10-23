// ignore_for_file: prefer_is_empty

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/entities/ois.dart';
import '../../models/signal.dart';

class ListActiveController extends GetxController {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final RxList<SignalInfo>? signalInfo = RxList<SignalInfo>([]);
  List<SignalInfo> listSignal = [];
  RxInt channels = 0.obs;
  RxBool isInit = false.obs;

  RxBool hasError = false.obs;

  void setChannels(int channel) {
    channels.value = channel;
  }

  

  void onLoading() async {
    int offset = 0;
    try {
      offset = listSignal.length;
      List<SignalInfo> activeSignal = await SignalModel.instance
          .getChannelSignals(channels.value, 1, offset);
      if (activeSignal.length > 0) {
        listSignal.addAll(activeSignal);
        signalInfo?.addAll(listSignal);
        refreshController.loadComplete();
      } else {
        signalInfo?.addAll(listSignal);
        refreshController.loadNoData();
      }
      hasError.value = false;
    } catch (xerr, stack) {
      // ignore: avoid_print
      print(stack);
      if (offset == 0) {
        hasError.value = true;
      }
      refreshController.loadFailed();
    }
  }

  void onRefresh() async {
    listSignal.clear();
    onLoading();
    try {
      List<SignalInfo> activeSignal =
          await SignalModel.instance.getChannelSignals(channels.value, 1, 0);
      if (activeSignal.length > 0) {
        listSignal.addAll(activeSignal);
        signalInfo?.addAll(listSignal);
      } else {
        signalInfo?.addAll(listSignal);
      }
      hasError.value = false;
      refreshController.refreshCompleted();
    } catch (xerr) {
      refreshController.refreshCompleted();
    }
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
