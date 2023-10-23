// ignore_for_file: prefer_is_empty, prefer_function_declarations_over_variables, iterable_contains_unrelated_type

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'app_state_controller.dart';
import '../interface/scroll_up_widget.dart';
import '../../models/channel.dart';
import '../../models/entities/ois.dart';
import '../../models/signal.dart';
import '../views/pages/signal_page.dart';

class SignalDashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late RefreshController refreshController;
  late TabController tabController;
  ScrollController scrollController = ScrollController();
  late Level medal;
  late List<Widget> tabBodies;
  final AppStateController appStateController = Get.find();

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
      }
    } on SocketException catch (_) {
      internet = false;
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
    // SignalDashboardController signalDashboardController.
    // Future.delayed(const Duration(microseconds: 0)).then((_) async {
    //   if (appStateController.users.value.id < 1 ||
    //       appStateController.users.value.verify!) {
    //     return;
    //   } else if (appStateController.users.value.id > 0 &&
    //       appStateController.users.value.isProfileComplete()) {
    //     Get.toNamed("/forms/editprofile");
    //   }
    // });
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(onTabChanged);
    scrollController = ScrollController();
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
      const Tab(
        child: Text(
          "Channel",
          style: TextStyle(fontFamily: 'Manrope'),
        ),
      ),
      const Tab(
        child: Text(
          "Signal",
          style: TextStyle(fontFamily: 'Manrope'),
        ),
      )
    ];
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  void onCLose() {
    tabController.removeListener(onTabChanged);
    tabController.dispose();
    super.onClose();
  }
}

class ListSignalWidgetController extends GetxController {
  RxList<SignalCardSlim> dataSignal = RxList<SignalCardSlim>();
  final AppStateController appStateController = Get.find();

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
      }
    } on SocketException catch (_) {
      internet = false;
    }
  }

  Future<void> initializePageSignalAsync({bool clearCache = false}) async {
    try {
      dataSignal.clear();
      List<SignalCardSlim>? recentSignal = await SignalModel.instance.getRecentSignalAsync(filter: filter.value);
      dataSignal.addAll(recentSignal);
      Level result = await getMedal();
      medal.value = result;
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
      /// TODOs: Cek ini nanti
      recentSignal = recentSignal
          .where((test) => !recentSignal!.contains(test.signalid))
          .toList();
      if (recentSignal.length > 0) {
        dataSignal.addAll(recentSignal);
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
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
  void onReady() {
    super.onReady();
    checkInternet();
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
      if (appStateController.users.value.id > 0 &&
        appStateController.users.value.verify!) {
        await initializePageSignalAsync();
      } 
    });
  }
}

// class ListChannelWidgetController extends GetxController {
//   RxList<int?>? dataChannel = <int?>[null].obs;

//   RxInt sort = 0.obs;
//   RxInt page = 0.obs;
//   Rx<Level?> medal = Rx<Level?>(null);
//   RxInt loadingSort = 0.obs;

//   RxBool hasError = false.obs;
//   RxString errorMessage = ''.obs;

//   // bool internet = false;
//   // checkInternet() async {
//   //   try {
//   //     final result = await InternetAddress.lookup('google.com');
//   //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//   //       internet = true;
//   //       print('connected');
//   //     }
//   //   } on SocketException catch (_) {
//   //     internet = false;
//   //     print('not connected');
//   //   }
//   //   print("internet: $internet");
//   // }

//   final RefreshController refreshController =
//       RefreshController(initialRefresh: false);

//   Future<void> initializePageChannelAsync({bool clearCache = false}) async {
//     try {
//       dataChannel?.clear();
//       dataChannel?.value = await ChannelModel.instance
//           .getRecommendedManualChannel(
//               clearCache: clearCache, offset: 0, sort: sort.value);
//       page = 0.obs;
//       var result = await getMedal();
//       medal.value = result;
//       print("berhasi dsdfsl");
//     } catch (xerr) {
//       hasError.value = true;
//       errorMessage.value = xerr.toString();
//       // throw (xerr.toString());
//     }
//   }

//   void onRefreshChannel() async {
//     print("ngerefresh");
//     dataChannel?.value = [];
//     await initializePageChannelAsync(clearCache: true);
//     refreshController.refreshCompleted();
//     refreshController.resetNoData();
//   }

//   void onLoadChannel() async {
//     // await initializePageChannelAsync(clearCache: false);
//     print("lsalalalalalaalal");
//     try {
//       List<int> temp = await ChannelModel.instance.getRecommendedManualChannel(
//           clearCache: true, offset: dataChannel!.length, sort: sort.value);
//       print("Jalan jalan");
//       print("object: $temp");

//       if (temp.isNotEmpty) {
//         dataChannel?.addAll(temp);
//         dataChannel = dataChannel?.toSet().toList().obs;
//         dataChannel = dataChannel;
//         print("data channel: $dataChannel");
//         page++;
//         refreshController.loadComplete();
//         print("page: $page");
//       } else {
//         refreshController.loadNoData();
//         print("kennaaa");
//       }
//     } catch (ex) {
//       // print("gak ke load");
//       hasError.value = true;
//       errorMessage.value = ex.toString();
//       // Get.snackbar("Error", ex.toString());
//       refreshController.loadFailed();
//     }

//     sort.value = sort.value;
//   }

//   Future<Level> getMedal({bool clearCache = false}) async {
//     return ChannelModel.instance.getMedalList(clearCache: clearCache);
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     // checkInternet();
//     Future.delayed(const Duration(microseconds: 0)).then((_) async {
//       await initializePageChannelAsync();
//     });
//     print("udah onInit");
//   }
// }

class ListChannelWidgetController extends GetxController {
  Rx<List<int>> dataChannel = Rx<List<int>>([]);
  RxInt sort = 0.obs;
  RxInt page = 0.obs;
  RxInt loadingSort = 0.obs;
  RxBool hasLoad = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = "".obs;
  RxBool channelBuild = false.obs;
  Rx<Level?> medal = Rx<Level?>(null);
  Rx<List<int>?> channelStream = Rx<List<int>?>(null);
  RefreshController refreshController = RefreshController(initialRefresh: false);
  final AppStateController appStateController = Get.find();

  Future<void> initializePageChannelAsync({bool clearCache = false}) async {
    try {
      dataChannel.value.clear();
      dataChannel.value.addAll(await ChannelModel.instance.getRecommendedManualChannel(clearCache: clearCache, offset: 0, sort: sort.value));
      channelStream.value = dataChannel.value.toSet().toList();
      page.value = 0;

      Level result = await getMedal();
      medal.value = result;
      hasError.value = false;
      errorMessage.value = "";
      hasLoad.value = true;
    } catch(e) {
      hasLoad.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  void onRefreshChannel() async {
    dataChannel.value.clear();
    channelStream.value = [];
    hasLoad.value = false;
    channelBuild.value = false;
    await initializePageChannelAsync(clearCache: true);
    refreshController.refreshCompleted();
    refreshController.resetNoData();
  }                                         

  void onLoadChannel() async {
    try {
      List<int> temp = await ChannelModel.instance.getRecommendedManualChannel(clearCache: true, offset: dataChannel.value.length, sort: sort.value);

      if (temp.length > 0) {
        dataChannel.value.addAll(temp);
        var newData = dataChannel.value.toSet().toList();
        channelStream.value = newData;
        page.value++;
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
      hasError.value = false;
      errorMessage.value = "";
    } catch(e) {
      hasError.value = true;
      Get.snackbar("Terjadi Error", e.toString());
      refreshController.loadFailed();
    }
  }

  Future<Level> getMedal({bool clearCache = false}) async {
    return ChannelModel.instance.getMedalList(clearCache: clearCache);
  }


  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
        if (appStateController.users.value.id > 0) {
          await initializePageChannelAsync();
        }
    });
  }
}
