import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/views/pages/channels/details/summary.dart';
import 'package:saham_01_app/views/pages/channels/listActive.dart';

class ChannelDetailController extends GetxController with GetTickerProviderStateMixin {
  int channel = 0;
  bool _init = false;
  late ChannelCardSlim channelDetail;
  late RefreshController refreshController;
  final RxString titleObs = ''.obs;
  final Rx<ChannelCardSlim?>? channelObs = Rx<ChannelCardSlim?>(null);
  final RxBool hasError = RxBool(false);


  void setTitle(String newTitle) {
    titleObs.value = newTitle;
  }

  void setChannel(ChannelCardSlim newChannel) {
    channelObs?.value = newChannel;
  }

  final AppStateController appStateController = Get.put(AppStateController());

  late TabController tabController;
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 4);
    List<Widget> tabs = [
      const Tab(
        text: "SUMMARY",
      ),
      const Tab(
        text: "ACTIVE SIGNAL"
      ),
      const Tab(
        text: "HISTORY SIGNAL",
      ),
      const Tab(
        text: "STATISTICS",
      )
    ];

    if (channelDetail.username != appStateController.users.value.username && channelDetail.isPrivate! && !channelDetail.subscribed!) {
      tabController = TabController(length: 1, vsync: this);
      tabs = [
        Tab(
          text: "CONTACT",
        )
      ];
    }
    List<Widget> tabsView = [
      SummaryChannels(channel, channelDetail.createdTime!),
      ListActiveSignal(
        channel, channelObs?.value?.subscribed != null || channelObs?.value?.username == appStateController.users.value.username
        
      )
    ];
    scrollController = ScrollController();
    refreshController = RefreshController(initialRefresh: false);
    Future.delayed(const Duration(milliseconds: 0)).then((_) {
      if (appStateController.users.value.id < 1 || !appStateController.users.value.verify!) {
        Get.offAndToNamed("/forms/login", arguments: {
          "route": "/dsc/channels",
          "arguments": ModalRoute.of(Get.context!)?.settings.arguments
        });
      } else if (appStateController.users.value.id > 0 && appStateController.users.value.isProfileComplete()) {
        Get.offAndToNamed("/forms/editprofile", arguments: {
          "route": "/dsc/channels/",
          "arguments": ModalRoute.of(Get.context!)?.settings.arguments
        });
      }
    });
  }

  Future<void> getChannel({bool forceRequest = false}) async {
    try {
      if (!_init) {
        _init = true;
      } else {
        if (!forceRequest) {
          return;
        }
      }
      channelDetail = await ChannelModel.instance.getDetail(channel, clearCache: forceRequest);
      setTitle(channelDetail.name!);
      setChannel(channelDetail);
    } catch (xerr) {
      hasError.value = true;
      print(xerr);
      titleObs.addError(xerr);
      channelObs?.addError(xerr);
    }
  }

  Future<void> refreshChannel() async {
    await getChannel(forceRequest: true);
    refreshController.refreshCompleted();
  }
  
  
}