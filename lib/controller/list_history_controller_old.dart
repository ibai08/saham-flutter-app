// ignore_for_file: prefer_is_empty

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/entities/ois.dart';
import '../../models/signal.dart';

class ListHistoryController extends GetxController {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final RxList<SignalInfo>? signalInfo = RxList<SignalInfo>([]);
  List<SignalInfo> listSignal = [];
  RxInt channels = 0.obs;
  RxBool subscribed = false.obs;
  RxBool hasError = false.obs;
  RxBool isInit = false.obs;

  void setChannels(int channel) {
    channels.value = channel;
  }

  void setSubscribed(bool subs) {
    subscribed.value = subs;
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
    } catch (xerr) {
      if (offset == 0) {
        hasError.value = true;
      }
      refreshController.loadFailed();
    }
  }

  void onRefresh() async {
    listSignal.clear();
    try {
      List<SignalInfo> activeSignal =
          await SignalModel.instance.getChannelSignals(channels.value, 1, 0);
      if (activeSignal.length > 0) {
        listSignal.addAll(activeSignal);
        signalInfo?.addAll(listSignal);
      } else {
        signalInfo?.addAll(listSignal);
      }
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
    onLoading;
  }
}
