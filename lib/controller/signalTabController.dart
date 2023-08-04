import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/interface/scrollUpWidget.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/signal.dart';
import 'package:saham_01_app/views/pages/signalPage.dart';

class SignalDashboardController extends GetxController with GetSingleTickerProviderStateMixin {
  late RefreshController refreshController ;
  late TabController tabController;
  ScrollController scrollController = ScrollController();
  late Level medal;
  late List<Widget> tabBodies;
  final AppStateController appStateController = Get.put(AppStateController());

  void onTabChanged() {
    if (tabBodies[tabController.index] is ScrollUpWidget) {
      onResetTabChild = (tabBodies[tabController.index] as ScrollUpWidget).onResetTab;
    }
  }

  onResetTabs() {
    onResetTabChild();
  }

  Function onResetTabChild = () {};


  void onInit() {
    super.onInit();
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
      if (appStateController.users.value.id < 1 || appStateController.users.value.verify!) {
        return;
      } else if (appStateController.users.value.id > 0 && appStateController.users.value.isProfileComplete()) {
        Get.toNamed("/forms/editprofile");
      }
    });
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(onTabChanged);
    scrollController = ScrollController();

    print("hello: ${onResetTabChild}");

    tabBodies = <Widget>[
      ListChannelWidget(),
      ListSignalWidget(),
    ];

    if (tabBodies[tabController.index] is ScrollUpWidget) {
      onResetTabChild = (tabBodies[tabController.index] as ScrollUpWidget).onResetTab;
    }

  }

  List<Widget> getTabTitle() {
    return const <Widget>[
      Tab(
        child: Text(
          "Channel",
          style: TextStyle(fontFamily: 'Manrope'),
        ),
      ),
      Tab(
        child: Text(
          "Signal",
          style: TextStyle(fontFamily: 'Manrope'),
        ),
      )
    ];
  }

  void onCLose() {
    tabController.removeListener(onTabChanged);
    tabController.dispose();
    super.onClose();
  }
}

class ListSignalWidgetController extends GetxController {
  RxList<SignalCardSlim> dataSignal = RxList<SignalCardSlim>();

  final RefreshController refreshController = RefreshController(initialRefresh: false);

  RxInt filter = 0.obs;
  RxInt page = 0.obs;
  Rx<Level?> medal = Rx<Level?>(null);
  RxInt loadingFilter = 0.obs;

  Future<void> initializePageSignalAsync({bool clearCache = false}) async {
    try {
      dataSignal.clear();
      List<SignalCardSlim>? recentSignal = await SignalModel.instance.getRecentSignalAsync(filter: filter.value);
      dataSignal.addAll(recentSignal!);
      var result = await getMedal();
      medal.value = result;
    } catch (err) {
      throw(err.toString());
    }
  }

  void onRefreshSignal() async {
    await initializePageSignalAsync(clearCache: true);
    refreshController.refreshCompleted();
  }

  void onLoadSignal() async {
    try {
      List<SignalCardSlim>? recentSignal = await SignalModel.instance.getRecentSignalAsync(offset: dataSignal.length, filter: filter.value);
      recentSignal = recentSignal!.where((test) => !recentSignal!.contains(test.signalid)).toList();
      if (recentSignal.length > 0) {
        dataSignal.addAll(recentSignal);
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    } catch (x) {
      refreshController.loadNoData();
    }

    filter.value = filter.value;
  }

  Future<Level> getMedal({bool clearCache = false}) async {
    return ChannelModel.instance.getMedalList(clearCache: clearCache);
  }

  onResetTab() {
    refreshController.position?.moveTo(0, duration: const Duration(milliseconds: 600));
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
      initializePageSignalAsync();
    });
  }
}

class ListChannelWidgetController extends GetxController {
  RxList<int> dataChannel = RxList<int>();

  RxInt sort = 0.obs;
  RxInt page = 0.obs;
  Rx<Level?> medal = Rx<Level?>(null);
  RxInt loadingSort = 0.obs;

  final RefreshController refreshController = RefreshController(initialRefresh: false);

  Future<void> initializePageChannelAsync({bool clearCache = false}) async {
    try {
      dataChannel.clear();
      dataChannel.addAll(await ChannelModel.instance.getRecommendedManualChannel(clearCache: clearCache, offset: 0, sort: sort.value));
      page = 0.obs;
      var result = await getMedal();
      medal.value = result;
      print("berhasil");
    } catch (xerr) {
      throw (xerr.toString());
    }
  }

  void onRefreshChannel() async {
    await initializePageChannelAsync(clearCache: true);
    refreshController.refreshCompleted();
    refreshController.resetNoData();
  }

  void onLoadChannel() async {
    try {
      List<int> temp = await ChannelModel.instance.getRecommendedManualChannel(clearCache: true, offset: dataChannel.length, sort: sort.value);

      if (temp.isNotEmpty) {
        dataChannel.addAll(temp);
        RxList<int>dataChannelList = dataChannel.toSet().toList().obs;
        dataChannel = dataChannelList;
        page++;
        refreshController.loadComplete();
      }
    } catch (ex) {
      Get.snackbar("Error", ex.toString());
      refreshController.loadFailed();
    }

    sort = loadingSort;
  }

  Future<Level> getMedal({bool clearCache = false}) async {
    return ChannelModel.instance.getMedalList(clearCache: clearCache);
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
      await initializePageChannelAsync();
    });
  }
}

