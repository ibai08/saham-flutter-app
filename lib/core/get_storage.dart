// ignore_for_file: avoid_print, empty_catches, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ConfigKey {
  static String installReferrer = "installReferrer";
  static String installAff = "installAff";
  static String deepLink = "deepLink";
}

class CacheKey {
  static String signalFrontPage = "signalfrontpage";
  static String channelFrontPage = "channelfrontpage";
  static String oisDashboard = "oisDashboard";
  static String oisMyChannelListOnly = "oisMyChannelListOnly";
  static String oisMyChannel = "oismychannel";
  static String signalTradeByIDnUserID = "TradeSignal-%d-%d";
  static String channelByIDforUserID = "channel-%d-%d";
  static String channelInfo = "channelInfo-%d";
  static String channelMostProfit = "channelMostProfit";
  static String channelMostProfitLastMonth = "channelMostProfitLastMonth";
  static String channelMostConsistent = "channelMostConsistent";
  static String channelConfig = "channelConfig";
  static String channelMostPopular = "channelMostPopular";
  static String channelRecommended = "channelRecommended";
  static String channelRecommendedFeed = "channelRecommended-%d-%d";
  static String closedSignalFeed = "closedSignalFeed-%d";
  static String slidePromo = "slidePromo";
  static String tfAddress = "tfAddress";
  static String userMRGByID = "MRG-%d";
  static String realAccMRGByID = "RealAccMRG-%d";
  static String demoAccMRGByID = "DemoAccMRG-%d";
  static String contestAccMRGByID = "ContestAccMRG-%d";
  static String bankBrokerMRG = "bankBrokerMRG";
  static String userBankMRGByID = "userBankMRG-%d";
  static String userImgMRGID = "userImgMRGID-%d";
  static String accountTypeMRG = "accountTypeMRG";
  static String transactionMRGByID = "transactionMRGByID-%d";
  static String uploadIDMRGByID = "uploadIDMRG-%d";
  static String userAskapByID = "Askap-%d";
  static String realAccAskapByID = "RealAccAskap-%d";
  static String demoAccAskapByID = "DemoAccAskap-%d";
  static String accountTypeAskap = "accountTypeAskap";
  static String transactionAskapByID = "transactionAskapByID-%d";
  static String bankBrokerAksap = "bankBrokerAskap";
  static String channelsMySubscriptionsByUserId = "channelSubscriptions-%d";
  static String channelsMySubscribersByUserId = "channelSubscribers-%d";
  static String channelsMedal = "channelMedal-%d";
  static String channelHistoryList = "channelHistoryList-%d";
  static String channelRedeemHistory = "channelRedeemHistory-%d";
  static String channelMyHistoryPointById = "channelPoint-%d";
  static String oisSearchHistory = "searchHistory";
  static String tooltipPanduanClosed = "tooltipPanduanClosed";
  static String initOnboardScreen = "initOnboardScreen3";
  static String initOnboardScreenSec = "initOnboardScreen2";
  static String oisBanks = "oisBanks";
  static String inboxRead = "inboxRead";
  static String listGroupedCity = "listGroupedCity";
  static String listUserInfo = "listUserInfo";
  static String openLivechat = "openLivechat";
  static String domisiliGrouped = "domisiliGrouped";

  static String checkTFPoint = "checkTFPoint";
  static String versionNumber = "VersionNumber";
}

class BoxName {
  static String config = "cfg";
  static String inbox = "inbox";
  static String signal = "signal";
  static String cache = "cache";
}

class StorageController {
  static final StorageController instance = StorageController._internal();
  bool _init = false;

  StorageController._internal();

  Future<void> init() async {
    if (_init) {
      return;
    }
    try {
      await GetStorage.init();
      GetStorage(BoxName.cache);
      GetStorage(BoxName.config);
      GetStorage(BoxName.inbox);
      GetStorage(BoxName.signal);
      _init = true;
      print("berhasil ssswwewqe");
    } catch (xerr) {
      print("StorageController.init: $xerr");
    }
  }

  GetStorage getBox(String boxname) {
    init();
    return GetStorage(boxname);
  }

  Future<void> clearBox(String boxname) async {
    await GetStorage(boxname).erase();
  }

  Future<void> clearAll() async {
    await GetStorage(BoxName.cache).erase();
    await GetStorage(BoxName.config).erase();
    await GetStorage(BoxName.inbox).erase();
    await GetStorage(BoxName.signal).erase();
  }
}

class SharedBoxHelper {
  String? boxName;

  SharedBoxHelper({this.boxName});

  Future<void> init() async {
    await GetStorage.init();
  }

  Future<Map<String, dynamic>> getAll() async {
    await init();
    Map<String, dynamic> mapData = {};
    List<String> allKeys = GetStorage().getKeys().toList();
    for (String key in allKeys) {
      if (key.startsWith(boxName! + '.')) {
        dynamic value = GetStorage().read(key);
        if (value == null) {
          mapData[key] = value;
        }
      }
    }
    return mapData;
  }

  Future<Map<String, dynamic>> getAllMap() async {
    Map<String, dynamic> mapData = {};
    try {
      await init();
      List<String> allKeys = GetStorage().getKeys().toList();
      for (String key in allKeys) {
        if (key.startsWith(boxName! + '.')) {
          String? temp = GetStorage().read<String>(key);
          if (temp != "") {
            mapData[key] = jsonDecode(temp!);
          }
        }
      }
    } catch (e) {
      print("SharedBox.getAllMap() Error");
      print(e);
    }
    return mapData;
  }

  Future<String> get(String keyName) async {
    await init();
    String data = GetStorage().read(boxName! + '.' + keyName).toString();
    return data;
  }

  Future<Map?> getMap(String keyName) async {
    await init();
    String? val = GetStorage().read(boxName! + '.' + keyName).toString();
    if (val == null || val.isEmpty) {
      return null;
    }
    return jsonDecode(val);
  }

  Rx<String?> watch(String keyName) {
    return GetStorage().read<String>(boxName! + '.' + keyName).obs;
  }

  Future<bool> put(String keyName, String data) async {
    await init();
    await GetStorage().write(boxName! + '.' + keyName, data);
    return true;
  }

  Future<bool> putMap(String keyName, Map<dynamic, dynamic> data) async {
    await init();
    String json = jsonEncode(data);
    await GetStorage().write(boxName! + '.' + keyName, json);
    return true;
  }

  Future<bool> delete(String keyName) async {
    await init();
    await GetStorage().remove(boxName! + '.' + keyName);
    return true;
  }

  Future<void> clearBox() async {
    await init();
    List<String> allKeys = GetStorage().getKeys().toList();
    for (String key in allKeys) {
      if (key.startsWith(boxName! + '.')) {
        GetStorage().remove(key);
      }
    }
  }
}

class SharedHelper {
  static final SharedHelper instance = SharedHelper._internal();

  SharedHelper._internal();
  // ignore: prefer_final_fields
  Map<String, SharedBoxHelper> _boxes = {};

  SharedBoxHelper? getBox(String boxName) {
    if (!_boxes.containsKey(boxName)) {
      _boxes[boxName] = SharedBoxHelper(boxName: boxName);
    }
    return _boxes[boxName];
  }

  Future<void> clearBox(String boxName) async {
    try {
      SharedBoxHelper box = getBox(boxName)!;
      await box.clearBox();
    } catch (e) {}
  }

  Future<void> clearAll() async {
    await clearBox(BoxName.config);
    await clearBox(BoxName.cache);
    await clearBox(BoxName.inbox);
    await clearBox(BoxName.signal);
  }
}