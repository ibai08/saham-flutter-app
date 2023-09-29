import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../constants/app_colors.dart';
import '../../controller/appStatesController.dart';
import '../../interface/scrollUpWidget.dart';
import '../../models/channel.dart';
import '../../models/entities/ois.dart';
import '../../models/signal.dart';
import '../../views/pages/signalPage.dart';

class SignalDashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late RefreshController refreshController;
  late TabController tabController;
  ScrollController scrollController = ScrollController();
  late Level medal;
  late List<Widget> tabBodies;
  final AppStateController appStateController = Get.put(AppStateController());

  void onTabChanged() {
    if (tabBodies[tabController.index] is ScrollUpWidget) {
      onResetTabChild =
          (tabBodies[tabController.index] as ScrollUpWidget).onResetTab;
    }
  }

  bool internet = false;
  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internet = true;
        print('connected');
      }
    } on SocketException catch (_) {
      internet = false;
      print('not connected');
    }
  }

  onResetTabs() {
    onResetTabChild();
  }

  Function onResetTabChild = () {};

  @override
  void onInit() {
    super.onInit();
    checkInternet();
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
      if (appStateController.users.value.id < 1 ||
          appStateController.users.value.verify!) {
        return;
      } else if (appStateController.users.value.id > 0 &&
          appStateController.users.value.isProfileComplete()) {
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
      onResetTabChild =
          (tabBodies[tabController.index] as ScrollUpWidget).onResetTab;
    }
  }

  List<Widget> getTabTitle() {
    return <Widget>[
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

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  RxInt filter = 0.obs;
  RxInt page = 0.obs;
  Rx<Level?> medal = Rx<Level?>(null);
  RxInt loadingFilter = 0.obs;

  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  bool internet = false;
  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internet = true;
        print('connected');
      }
    } on SocketException catch (_) {
      internet = false;
      print('not connected');
    }
  }

  Future<void> initializePageSignalAsync({bool clearCache = false}) async {
    try {
      dataSignal.clear();
      print("test 1");
      List<SignalCardSlim>? recentSignal =
          await SignalModel.instance.getRecentSignalAsync(filter: filter.value);
      print(recentSignal);
      print("test 2");
      dataSignal.addAll(recentSignal);
      print("test 3");
      var result = await getMedal();
      medal.value = result;
      print("berhasil fetch medal");
    } catch (err) {
      hasError.value = true;
      errorMessage.value = err.toString();
      throw (err.toString());
    }
  }

  void onRefreshSignal() async {
    await initializePageSignalAsync(clearCache: true);
    refreshController.refreshCompleted();
  }

  void onLoadSignal() async {
    try {
      List<SignalCardSlim>? recentSignal = await SignalModel.instance
          .getRecentSignalAsync(
              offset: dataSignal.length, filter: filter.value);
      recentSignal = recentSignal
          .where((test) => !recentSignal!.contains(test.signalid))
          .toList();
      if (recentSignal.length > 0) {
        dataSignal.addAll(recentSignal);
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
      print("jalan terus");
    } catch (x) {
      hasError.value = true;
      errorMessage.value = x.toString();
      refreshController.loadNoData();
    }

    filter.value = filter.value;
  }

  Future<Level> getMedal({bool clearCache = false}) async {
    return ChannelModel.instance.getMedalList(clearCache: clearCache);
  }

  onResetTab() {
    refreshController.position
        ?.moveTo(0, duration: const Duration(milliseconds: 600));
  }

  @override
  void onInit() {
    super.onInit();
    checkInternet();
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
      initializePageSignalAsync();
    });
  }
}

class ListChannelWidgetController extends GetxController {
  RxList<int?>? dataChannel = <int?>[null].obs;

  RxInt sort = 0.obs;
  RxInt page = 0.obs;
  Rx<Level?> medal = Rx<Level?>(null);
  RxInt loadingSort = 0.obs;

  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  // bool internet = false;
  // checkInternet() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       internet = true;
  //       print('connected');
  //     }
  //   } on SocketException catch (_) {
  //     internet = false;
  //     print('not connected');
  //   }
  //   print("internet: $internet");
  // }

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future<void> initializePageChannelAsync({bool clearCache = false}) async {
    try {
      dataChannel?.clear();
      dataChannel?.addAll(await ChannelModel.instance
          .getRecommendedManualChannel(
              clearCache: clearCache, offset: 0, sort: sort.value));
      page = 0.obs;
      var result = await getMedal();
      medal.value = result;
      print("berhasil");
    } catch (xerr) {
      hasError.value = true;
      errorMessage.value = xerr.toString();
      // print("erororro: ${hasError.value}");
      throw (xerr.toString());
    }
    print("udah initialize");
  }

  void onRefreshChannel() async {
    print("ngerefresh");
    dataChannel?.addAll([]);
    await initializePageChannelAsync(clearCache: true);
    refreshController.refreshCompleted();
    refreshController.resetNoData();
  }

  void onLoadChannel() async {
    // await initializePageChannelAsync(clearCache: false);
    print("lsalalalalalaalal");
    try {
      List<int> temp = await ChannelModel.instance.getRecommendedManualChannel(
          clearCache: true, offset: dataChannel!.length, sort: sort.value);
      print("Jalan jalan");
      print("object: $temp");

      if (temp.isNotEmpty) {
        dataChannel?.addAll(temp);
        dataChannel = dataChannel?.toSet().toList().obs;
        dataChannel = dataChannel;
        print("data channel: $dataChannel");
        page++;
        refreshController.loadComplete();
        print("page: $page");
      } else {
        refreshController.loadNoData();
        print("kennaaa");
      }
    } catch (ex) {
      // print("gak ke load");
      hasError.value = true;
      errorMessage.value = ex.toString();
      // Get.snackbar("Error", ex.toString());
      refreshController.loadFailed();
    }

    sort.value = sort.value;
  }

  Future<Level> getMedal({bool clearCache = false}) async {
    return ChannelModel.instance.getMedalList(clearCache: clearCache);
  }

  @override
  void onInit() {
    super.onInit();
    // checkInternet();
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
      await initializePageChannelAsync();
    });
    print("udah onInit");
  }
}
