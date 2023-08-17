import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/core/analytics.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/ois.dart';
import 'package:saham_01_app/models/signal.dart';
import 'package:saham_01_app/views/widgets/SignalThumb.dart';
import 'package:saham_01_app/views/widgets/channelThumb.dart';

class SearchChannelsPopController extends GetxController {
  final RxString searchText = RxString('');
  final RxList<String> searchList = RxList<String>([]); 

  String getText = "";
  late Map findText;

  Future<void> initSearch() async {
    print("muncul");
    searchList.assignAll(await OisModel.instance.getSearchHistory());
    // print("muncul error");
    // findText = ModalRoute.of(Get.context!)?.settings.arguments as Map<dynamic, dynamic>;
    // print("text:::: ${searchList}");
    // searchText.value = findText["text"];
    // print(searchText.value);
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero).then((value) => initSearch());
    print("search Text: ${searchText}");
  }

  void updateSearchText(String tile) {
    searchText.value = tile;
  }
}

class SearchChannelsTabController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2, initialIndex: 1);
    scrollController = ScrollController();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}

class SearchChannelsResultController extends GetxController {
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  late final RxList<ChannelCardSlim> channelSearchResult = RxList<ChannelCardSlim>();

  var findTxt = ''.obs;

  void setFindTxt(String data) {
    findTxt.value = data;
  }

  RxBool hasError = false.obs;

  Rx<Level?> level = Rx<Level?>(null);
  RxList<ChannelCardSlim> listChannel = <ChannelCardSlim>[].obs;
  List<ChannelThumb> getChannels(List<ChannelCardSlim> cc) {
    List<ChannelThumb> results = [];
    cc.forEach((ccs) {
      results.add(ChannelThumb(
        medals: ccs.medals,
        avatar: ccs.avatar,
        id: ccs.id,
        name: ccs.name,
        pips: ccs.pips,
        post: ccs.postPerWeek,
        profit: ccs.profit,
        subscribed: ccs.subscribed,
        subscriber: ccs.subscriber,
        username: ccs.username,
        level: level.value,
        from: "search",
        search: findTxt.value,
      ));
    });
    return results;
  }

  int sort = 0;

  Future<Level> getMedal({bool clearCache = false}) async {
    return ChannelModel.instance.getMedalList(clearCache: clearCache);
  }

  Future<void> onLoading() async {
    try {
      var result = await getMedal();
      level.value = result;
      int offset = listChannel.length;
      List<ChannelCardSlim> getNewListChannel = await ChannelModel.instance.searchChannel(findtext: findTxt.value, offset: offset, sort: sort);
      print("textvalue: ${findTxt.value}");
      print("Search channelss: ${getNewListChannel[0].name}");
      firebaseAnalytics.logViewSearchResults(searchTerm: findTxt.value);
      if (getNewListChannel.length > 0) {
        listChannel.addAll(getNewListChannel);
        channelSearchResult.addAll(listChannel);
        refreshController.loadComplete();
      } else {
        channelSearchResult.addAll(listChannel);
        refreshController.loadNoData();
      }
    } catch (e) {
      print("error: $e");
      refreshController.loadFailed();
      hasError.value = true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 0)).then((val) async {
      onLoading();
    });
  }
}

class SearchSignalResultController extends GetxController {
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  final RxList<SignalCardSlim>? signalSearchResult = RxList<SignalCardSlim>();

  RxList<SignalCardSlim> listSignal = <SignalCardSlim>[].obs;

  Rx<Level?> level = Rx<Level?>(null);

  var findTxt = ''.obs;

  void setFindTxt(String data) {
    findTxt.value = data;
  }

  List<SignalThumb> getSignals(List<SignalCardSlim> cc) {
    List<SignalThumb> results = [];
    cc.forEach((ccs) {
      results.add(SignalThumb(
        subscriber: ccs.channelSubscriber,
        medals: ccs.medals,
        id: ccs.signalid,
        symbol: ccs.symbol,
        channelId: ccs.channelId,
        createdAt: ccs.createdAt,
        expired: ccs.expired,
        title: ccs.channelName,
        level: level.value,
        avatar: ccs.channelAvatar,
      ));
    });
    return results;
  }

  Future<Level> getMedal({bool clearCache = false}) async {
    return ChannelModel.instance.getMedalList(clearCache: clearCache);
  }

  void onLoading() async {
    try {
      var result = await getMedal();
      level.value = result;
      await Future.delayed(Duration(seconds: 1));
      int offset = listSignal.length;
      List<SignalCardSlim> getNewListSignal = await SignalModel.instance.searchSignal(findTxt.value, offset);
      if (getNewListSignal.isNotEmpty) {
        listSignal.addAll(getNewListSignal);
        signalSearchResult?.addAll(listSignal);
        refreshController.loadComplete();
      } else {
        signalSearchResult?.addAll(listSignal);
        refreshController.loadNoData();
      }
    } catch (e) {
      refreshController.loadNoData();
    }
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 0)).then((val) async {
      onLoading();
    });
  }
}