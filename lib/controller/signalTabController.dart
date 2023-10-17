// ignore_for_file: prefer_is_empty

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

class SignalDashboardController extends SuperController
    with GetSingleTickerProviderStateMixin, FullLifeCycleMixin {
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("state beruabah: $state");
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.paused:
        onPaused();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    checkInternet();
    // SignalDashboardController signalDashboardController.
    print("APpLifecycle: ${AppLifecycleState}");
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

  @override
  void onReady() {
    print("READYDYDYDYDYDDYDYDYDY");
    super.onReady();
  }

  void onCLose() {
    tabController.removeListener(onTabChanged);
    tabController.dispose();
    super.onClose();
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
    print("DETACTSGDGGSSGGS");
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
    print("ACKTIFISFFHSHFHSGHFGHSGH");
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
    print("PAUSESSSSSSSSSS");
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
    print("RESUMESSSSSSSSSS");
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
  }

  @override
  void onReady() {
    super.onReady();
    checkInternet();
    Future.delayed(Duration(microseconds: 0)).then((_) async {
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
  Rx<Level?> medal = Rx<Level?>(null);
  Rx<List<int>?> channelStream = Rx<List<int>?>(null);
  RefreshController refreshController = RefreshController(initialRefresh: false);
  final AppStateController appStateController = Get.find();

  Future<void> initializePageChannelAsync({bool clearCache = false}) async {
    print("INIT GUYSSS");
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
      print("error------: $e");
      hasLoad.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  void onRefreshChannel() async {
    dataChannel.value.clear();
    channelStream.value = [];
    hasLoad.value = false;
    await initializePageChannelAsync(clearCache: true);
    refreshController.refreshCompleted();
    refreshController.resetNoData();
  }                                         

  void onLoadChannel() async {
    try {
      List<int> temp = await ChannelModel.instance.getRecommendedManualChannel(clearCache: true, offset: dataChannel.value.length, sort: sort.value);
      print("datachannellength: ${dataChannel.value.length}");
      print("temosss: $temp");

      if (temp.length > 0) {
        dataChannel.value.addAll(temp);
        print("data channel sebelum: ${dataChannel.value}");
        print("dataChannelLengths: ${dataChannel.value.length}");
        var newData = dataChannel.value.toSet().toList();
        print("data channel sesudah: ${dataChannel.value}");
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
      print("error: $e");
    }
  }

  Future<Level> getMedal({bool clearCache = false}) async {
    return ChannelModel.instance.getMedalList(clearCache: clearCache);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    print("readyyyyyyyyyyyyy");
    Future.delayed(Duration(microseconds: 0)).then((_) async {
        if (appStateController.users.value.id > 0) {
          await initializePageChannelAsync();
        }
    });
  }

  @override
  void dispose() {
    print("disposessssssssssss");
    super.dispose();
  }
}
