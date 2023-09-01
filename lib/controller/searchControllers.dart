import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/views/pages/channels/searchChannels.dart';
import '../../core/analytics.dart';
import '../../models/channel.dart';
import '../../models/entities/ois.dart';
import '../../models/ois.dart';
import '../../models/signal.dart';
import '../../views/widgets/SignalThumb.dart';
import '../../views/widgets/channelThumb.dart';
import '../interface/scrollUpWidget.dart';
import '../views/pages/signalPage.dart';

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

class SearchChannelsTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  late List<Widget> tabBodies;
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2);
    scrollController = ScrollController();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}

class SearchChannelsResultController extends GetxController {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  late final RxList<ChannelCardSlim> channelSearchResult =
      RxList<ChannelCardSlim>();

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
      List<ChannelCardSlim> getNewListChannel = await ChannelModel.instance
          .searchChannel(findtext: findTxt.value, offset: offset, sort: sort);
      print("offset channels: $offset");
      print("textvalue: ${findTxt.value}");
      // print("Search channelss: ${getNewListChannel[0].name}");
      print("Get news boys: ${getNewListChannel}");
      firebaseAnalytics.logViewSearchResults(searchTerm: findTxt.value);
      if (getNewListChannel.length > 0) {
        listChannel.addAll(getNewListChannel);
        channelSearchResult.addAll(listChannel);
        refreshController.loadComplete();
        print("kena iffff channels");
      } else {
        channelSearchResult.addAll(listChannel);
        refreshController.loadNoData();
        print("kena elsssee channels");
        hasError.value = true;
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
    print("udah init channels");
  }
}

class SearchSignalResultController extends GetxController {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  final RxList<SignalCardSlim>? signalSearchResult = RxList<SignalCardSlim>();

  RxList<SignalCardSlim> listSignal = <SignalCardSlim>[].obs;

  Rx<Level?> level = Rx<Level?>(null);

  final RxBool hasError = false.obs;

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
      // await Future.delayed(Duration(seconds: 1));
      int offset = listSignal.length;
      print("ini offset: $offset");
      print("searcg signalll: ${findTxt.value}");
      List<SignalCardSlim> getNewListSignal =
          await SignalModel.instance.searchSignal(findTxt.value, offset);
          print("get newss signal: ${getNewListSignal}");
      if (getNewListSignal.length > 0) {
        listSignal.addAll(getNewListSignal);
        signalSearchResult?.addAll(listSignal);
        refreshController.loadComplete();
      } else {
        signalSearchResult?.addAll(listSignal);
        refreshController.loadNoData();
        hasError.value = true;
      }
    } catch (e) {
      refreshController.loadNoData();
      hasError.value = true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 0)).then((val) async {
      onLoading();
    });
    print("udah init signalss");
  }
}
