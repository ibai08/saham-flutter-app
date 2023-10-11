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
  RxBool isLoading = true.obs;
  RxString stringcoba = "".obs;
  RxInt loadedPage = 0.obs;
  RxBool noData = false.obs;
  Rx<Level?> medal = Rx<Level?>(null);
  List<SignalInfo> closedSignal = <SignalInfo>[].obs;
  List<SlidePromo> listPromo = <SlidePromo>[].obs;
  List<SignalInfo> signalList = <SignalInfo>[].obs;
  List<SignalInfo>? signals;

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
      List<Future> temp = [
        getMostConsistentChannels(clearCache: clearCache),
      ];

      if (clearCache) {
        await remoteConfig.fetchAndActivate();

        temp.add(SignalModel.instance
            .clearClosedSignalsFeed(page: loadedPage.value));
      }

      await Future.wait(temp);

      loadedPage.value = 0;
      closedSignal.clear();

      // Initialize Infinite Load
      List<SignalInfo>? newSignal = await SignalModel.instance
          .getClosedSignalsFeed(page: loadedPage.value + 1);
      if (newSignal.isNotEmpty) {
        closedSignal.addAll(newSignal);
        loadedPage.value++;
        isLoading.value = false;
      }

      var result = await getMedal(clearCache: clearCache);
      medal.value = result;

      refreshController.loadComplete();
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
      if (newSignal.isNotEmpty) {
        var ids = closedSignal.map((sig) => sig.id).toList();
        closedSignal
            .addAll(newSignal.where((newSig) => !ids.contains(newSig.id)));
        loadedPage.value++;

        refreshController.loadComplete();
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
    print("cek init");
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
      await initializePageAsync();
      await getEventPage();
    });
  }
}
