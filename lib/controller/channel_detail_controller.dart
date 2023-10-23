import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/controller/statistic_controller.dart';
import 'package:saham_01_app/controller/summary_channels_controller.dart';

import '../models/channel.dart';
import '../models/entities/ois.dart';
import 'app_state_controller.dart';
import 'list_active_controller.dart';
import 'list_history_controller.dart';

class ChannelDetailController extends GetxController with GetTickerProviderStateMixin {
  RxInt channel = 0.obs;
  RxInt btn = 0.obs;
  final Rx<ChannelCardSlim?>? channelObs = Rx<ChannelCardSlim?>(null);
  final RxString titleObs = ''.obs; 
  ChannelCardSlim channelDetail = ChannelCardSlim();
  RxBool hasError = false.obs;
  RxBool isInit = false.obs;
  RxBool getChannelComplete = false.obs;
  RxInt tabIndex = 0.obs;
  RxString price = "0".obs;
  RxDouble channelProfit = 0.0.obs;
  RxString errorMessage = "".obs;
  RxBool isTab = false.obs;
  RxDouble paddingBtn = 0.0.obs;
  Rx<Level?> medal = Rx<Level?>(null);
  Future<Level> getMedal({bool clearCache = false}) async {
    return ChannelModel.instance.getMedalList(clearCache: clearCache);
  }

  final AppStateController appStateController = Get.find();
  late TabController tabController;
  late ScrollController scrollController;
  late RefreshController refreshController = RefreshController(initialRefresh: false);

  Future<void> getChannel({bool forceRequest = false}) async {
    try {
      channelDetail = await ChannelModel.instance.getDetail(channel.value, clearCache: forceRequest);
      if (channelDetail.name != null) {
        titleObs.value = channelDetail.name!;
        channelObs?.value = channelDetail;
      }
      SummaryChannelsController summaryChannelsController = Get.put(SummaryChannelsController());
      summaryChannelsController.channel.value = channel.value;
      ListActiveController listActiveController = Get.put(ListActiveController());
      listActiveController.channels.value = channel.value;
      listActiveController.subscribed.value = channelObs!.value!.subscribed! || channelObs?.value?.username == appStateController.users.value.username;
      ListHistoryController listHistoryController = Get.put(ListHistoryController());
      listHistoryController.channels.value = channel.value;
      listHistoryController.subscribed.value = channelObs!.value!.subscribed!  || channelObs?.value?.username == appStateController.users.value.username;
      StatisticsController statisticsController = Get.put(StatisticsController());
      statisticsController.channel.value = channel.value;
      getChannelComplete.value = true;
      hasError.value = false;
      errorMessage.value = "";
    } catch (xerr) {
      getChannelComplete.value = false;
      hasError.value = true;
      errorMessage.value = xerr.toString();
    }
  }

  Future<void> refreshChannel() async {
    getChannelComplete.value = false;
    await getChannel(forceRequest: true);
    refreshController.refreshCompleted();
  }

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    refreshController = RefreshController(initialRefresh: false);
    Future.delayed(const Duration(milliseconds: 0)).then((_) async {
      var result = await getMedal();
      medal.value = result;
    });
    isInit.value = true;
  }
}