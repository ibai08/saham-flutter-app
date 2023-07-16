import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mutex/mutex.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

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

class StorageHelper {
  static final StorageHelper instance = new StorageHelper._internal();
  bool _init = false;

  StorageHelper._internal();
  Mutex m = Mutex();

  Future<void> init() async {
    if (_init) {
      return;
    }
    try {
      await m.protect(() async {
        final directory = await getApplicationDocumentsDirectory();
        if (directory != null) {
          Hive.init(directory.path);
          await Hive.openBox(BoxName.config,
              compactionStrategy: (a, b) => false);
          await Hive.openBox(BoxName.inbox,
              compactionStrategy: (a, b) => false);
          await Hive.openBox(BoxName.signal,
              compactionStrategy: (a, b) => false);
          await Hive.openBox(BoxName.cache,
              compactionStrategy: (a, b) => false);
          _init = true;
        }
      });
    } catch (xerr) {
      print("StorageHelper.init: $xerr");
    }
  }

  Future<Box> getBox(String boxname) async {
    await init();
    return Hive.openBox(boxname, compactionStrategy: (a, b) => false);
  }

  Future<void> clearBox(String boxname) async {
    Box box = await this.getBox(boxname);
    box.clear();
  }

  Future<void> clearAll() async {
    await this.clearBox(BoxName.config); // remove config
    await this.clearBox(BoxName.cache); // remove cache
    await this.clearBox(BoxName.inbox); // remove inbox
    await this.clearBox(BoxName.signal); // remove signal
  }
}

class SharedBox {
  String? boxName;
  SharedBox({this.boxName});
  StreamingSharedPreferences? prefs;

  Future<void> init() async {
    if (prefs != null) {
      return;
    }
    try {
      prefs = await StreamingSharedPreferences.instance;
    } catch (xerr) {
      print("SharedBox.init: $xerr");
    }
  }

  Future<Map<String, dynamic>> getAll() async {
    Map<String, dynamic> mapData = Map();
    try {
      await init();
      Preference<Set<String>> keys = prefs!.getKeys();
      keys.getValue().forEach((element) {
        if (element.startsWith(boxName! + ".")) {
          mapData[element] =
              prefs!.getString(element, defaultValue: "").getValue();
        }
      });
    } catch (e) {
      print("SharedBox.getAll() Error");
      print(e);
    }
    return mapData;
  }

  Future<Map<String, dynamic>> getAllMap() async {
    Map<String, dynamic> mapData = Map();
    try {
      await init();
      Preference<Set<String>> keys = prefs!.getKeys();
      keys.getValue().forEach((element) {
        if (element.startsWith(boxName! + ".")) {
          String temp = prefs!.getString(element, defaultValue: "").getValue();
          if (temp != "") {
            mapData[element] = jsonDecode(temp);
          }
        }
      });
    } catch (e) {
      print("SharedBox.getAllMap() Error");
      print(e);
    }
    return mapData;
  }

  Future<String?> get(String keyName) async {
    try {
      await init();
      Preference<String> data =
          prefs!.getString(boxName! + "." + keyName, defaultValue: "");
      return data.getValue();
    } catch (e) {
      print("SharedBox.get() Error");
      print(e);
    }
    return null;
  }

  Future<Map?> getMap(String keyName) async {
    Map json = Map();
    try {
      await init();
      Preference<String> data =
          prefs!.getString(boxName! + "." + keyName, defaultValue: "");
      String val = data.getValue();
      if (val == "") {
        return null;
      }
      json = jsonDecode(val);
      return json;
    } catch (e) {
      print("SharedBox.getMap() Error");
      print(e);
    }
    return null;
  }

  StreamSubscription<String> watch(String keyName) {
    Preference<String> prefStr =
        prefs!.getString(boxName! + "." + keyName, defaultValue: "");
    return prefStr.listen(null, cancelOnError: true);
  }

  Future<bool> put(String keyName, String data) async {
    try {
      await init();
      bool result = await prefs!.setString(boxName! + "." + keyName, data);
      return result;
    } catch (e) {
      print("SharedBox.put() Error");
      print(e);
    }
    return false;
  }

  Future<bool> putMap(String keyName, Map<dynamic, dynamic> data) async {
    try {
      await init();
      String json = jsonEncode(data);
      bool result = await prefs!.setString(boxName! + "." + keyName, json);
      return result;
    } catch (e) {
      print("SharedBox.putMap() Error");
      print(e);
    }
    return false;
  }

  Future<bool> delete(String keyName) async {
    try {
      await init();
      bool result = await prefs!.remove(boxName! + "." + keyName);
      return result;
    } catch (e) {}
    return false;
  }

  Future<void> clearBox() async {
    try {
      Preference<Set<String>> prefsKeys = prefs!.getKeys();
      Set<String> x = prefsKeys.getValue();
      x.forEach((element) async {
        if (element.startsWith(boxName! + ".")) {
          await prefs!.remove(element);
        }
      });
    } catch (e) {}
  }
}

class SharedHelper {
  static final SharedHelper instance = new SharedHelper._internal();

  SharedHelper._internal();
  Map<String, SharedBox> _boxes = Map();

  SharedBox? getBox(String boxName) {
    if (!_boxes.containsKey(boxName)) {
      _boxes[boxName] = SharedBox(boxName: boxName);
    }
    return _boxes[boxName];
  }

  Future<void> clearBox(String boxName) async {
    try {
      SharedBox? box = this.getBox(boxName);
      await box!.clearBox();
    } catch (e) {}
  }

  Future<void> clearAll() async {
    await this.clearBox(BoxName.config); // remove config
    await this.clearBox(BoxName.cache); // remove cache
    await this.clearBox(BoxName.inbox); // remove inbox
    await this.clearBox(BoxName.signal); // remove signal
  }
}
