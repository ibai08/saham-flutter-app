import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../core/config.dart';
import '../models/channel.dart';
import '../models/entities/ois.dart';
import '../models/entities/post.dart';
import '../models/post.dart';
import '../models/signal.dart';

class HomeTabController extends GetxController {
  RxString stringcoba = "".obs;
  RxInt loadedPage = 0.obs;
  RxBool noData = false.obs;
  Rx<Level?> medal = Rx<Level?>(null);
  List<SignalInfo> closedSignal = <SignalInfo>[].obs;
  List<SlidePromo> listPromo = <SlidePromo>[].obs;
  List<SignalInfo> signalList = <SignalInfo>[].obs;
  final GetStorage gs = GetStorage();
  List<SignalInfo>? signals;
  List<SignalInfo> signals2 = <SignalInfo>[].obs;
  dynamic gsMedal;

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future<List<ChannelCardSlim>> getMostProfitAllTime(
      {bool clearCache = false}) async {
    return ChannelModel.instance.getProfitChannelAsync(clearCache: clearCache);
  }

  Future<List<ChannelMostProfitEntity>> getMostProfitChannels(
      {bool clearCache = false}) async {
    return ChannelModel.instance
        .getLastMonthProfitChannelAsync(clearCache: clearCache);
  }

  Future<List<ChannelCardSlim>> getMostConsistentChannels(
      {bool clearCache = false}) async {
    return ChannelModel.instance
        .getMostConsistentChannels(clearCache: clearCache, limit: 10);
  }

  Future<Level> getMedal({bool clearCache = false}) async {
    return ChannelModel.instance.getMedalList(clearCache: clearCache);
  }

  Future<List<SignalInfo>>? setSignals(List<SignalInfo> signals) {
    signalList.clear();
    signalList.addAll(signals);
    update();
  }

  Future<void> getEventPage() async {
    try {
      listPromo = await Post.getSlidePromo();
    } catch (e) {
      listPromo = [];
    }
  }

  Future<void> initializePageAsync({bool clearCache = false}) async {
    try {
      print("prosess1");
      List<Future> temp = [
        getMostConsistentChannels(clearCache: clearCache),
      ];

      if (clearCache) {
        await remoteConfig.fetchAndActivate();

        temp.add(SignalModel.instance
            .clearClosedSignalsFeed(page: loadedPage.value));
      }

      print("proses 2");
      await Future.wait(temp);

      loadedPage.value = 0;
      closedSignal.clear();

      // Initialize Infinite Load
      List<SignalInfo>? newSignal = await SignalModel.instance
          .getClosedSignalsFeed(page: loadedPage.value + 1);
      if (newSignal.isNotEmpty) {
        closedSignal.addAll(newSignal);
        loadedPage.value++;
      }
      print("closedSignal: ${closedSignal}");

      var result = await getMedal(clearCache: clearCache);
      medal.value = result;

      refreshController.loadComplete();
      print("berhasil initialize");
    } catch (xerr) {}
  }

  void onRefresh() async {
    // await getEventPage();
    await initializePageAsync(clearCache: true);
    refreshController.refreshCompleted(resetFooterState: true);
    refreshController.resetNoData();
  }

  void onLoad() async {
    try {
      List<SignalInfo> newSignal = await SignalModel.instance
          .getClosedSignalsFeed(page: loadedPage.value + 1);
      if (newSignal.length > 0) {
        var ids = closedSignal.map((sig) => sig.id).toList();
        closedSignal
            .addAll(newSignal.where((newSig) => !ids.contains(newSig.id)));
        print("closedSignal : ${closedSignal}");
        print("-=-=-=-=-=-=-=");
        loadedPage.value++;

        print("loaded page: $loadedPage");

        refreshController.loadComplete();
        print("berhasil");
      } else {
        refreshController.loadNoData();
      }
      update();
    } catch (xerr) {
      refreshController.loadFailed();
    }
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
      await initializePageAsync();
      print("berhasil initpageasync");
      await getEventPage();
      print("berhasil getEVent");
      onLoad();
      update();
    });
    // initializePageAsync();
    // getEventPage();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  //   if (medal.value != null) {
  //     gs.write("medal", medal.value?.toMap());
  //   }
  //   dynamic gsMedal = gs.read("medal");
  //   print("closedsignal.isnotempty: ${closedSignal.isNotEmpty}");
  //   if (closedSignal.isNotEmpty) {
  //     gs.write(
  //         "recentProfitSignalList",
  //         closedSignal
  //             .map((person) => person.toMap())
  //             .toList());
  //             // signals2.addAll(signals);
  //             signals = closedSignal;
  //             print("kena 1");
  //   } else {
  //     print("kena 2");
  //   }
  //   print("signasllllls: $signals");
  // }
}
