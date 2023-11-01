// ignore_for_file: prefer_conditional_assignment, avoid_print, avoid_function_literals_in_foreach_calls, unnecessary_null_comparison

import 'dart:convert';

import 'package:get/get.dart';
import '../controller/app_state_controller.dart';
import '../core/cache_factory.dart';
import '../core/get_storage.dart';
import '../../core/http.dart';
import '../../models/channel.dart';
import '../../models/entities/ois.dart';
import '../../models/entities/symbols.dart';
import '../../models/user.dart';
import 'package:sprintf/sprintf.dart';

class SignalModel {
  static final SignalModel instance = SignalModel._privateConstructor();
  SignalModel._privateConstructor();
  SharedBoxHelper? _signalBox;
  final AppStateController appStateController = Get.find();

  RxMap<int, SignalInfo> signalCache = <int, SignalInfo>{}.obs;

  Future<Rx<String?>?> subsribeSignalAsync({int? signalid, bool? clearCache}) async {
    SignalInfo? tmpSignal;
    if (_signalBox == null) {
      _signalBox = SharedHelper.instance.getBox(BoxName.signal);
    }
    if (clearCache == true) {
      _signalBox?.delete(signalid.toString());
    }

    int tryCount = 0;

    do {
      tryCount++;
      Map<dynamic, dynamic>? tmpSignalMap =
          await _signalBox?.getMap(signalid.toString());
      if (tmpSignalMap != null) {
        tmpSignal = SignalInfo.fromMap(tmpSignalMap);
      } else {
        tmpSignal = await getSignalDetailAsync(signalid!);
      }
      
      if (tmpSignal != null) {
        break;
      }
    } while (tryCount > 1);

    if (tmpSignal != null) {
      ChannelCardSlim? channel =
          await ChannelModel.instance.getDetail(tmpSignal.channel?.id);
      if (channel == null) {
        throw "CHANNEL_NOT_FOUND";
      } else if (channel.subscribed! &&
          channel.username != appStateController.users.value.username) {
        throw "CHANNEL_NOT_SUBSCRIBED";
      } else {
        signalCache[signalid!] = tmpSignal;
        return _signalBox?.watch(signalid.toString());
      }
    }
    return null;
  }

  void removeSignalCache(String identifier) {
    signalCache.remove(identifier);
  }

  Future<List> getSymbols() async {
    List<TradeSymbol> listTradeSymbol = [];
    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/ois/api/v1/symbols/", method: 'GET');
    List symbolList = fetchData["message"];
    print("symbollist: $symbolList");

    symbolList.forEach((v1) {
      listTradeSymbol.add(TradeSymbol.fromTF2v1API(v1));
    });

    return listTradeSymbol;
  }

  Future<List<SignalCardSlim>> searchSignal(String findtext, int offset) async {
    List<SignalCardSlim> listSignalBadgeSlim = [];
    try {
      Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/ois/api/v1/signal/search/",
          postParam: {"title": findtext, "offset": offset});
          print("map fecthdata: $fetchData");
      List signalList = fetchData["message"];
      print("signallist:: $signalList");

      signalList.forEach((v1) {
        listSignalBadgeSlim.add(SignalCardSlim.fromMap({
          "channelId": v1["channel_id"],
          "channelName": v1["title"],
          "channelSubscriber": v1["subscount"],
          "signalid": v1["id"],
          "symbol": v1["symbol"],
          "createdAt": v1["created_at"],
          "expired": v1["expired"],
          "medals": v1["medals"]
        }));
      });
    } catch (xerr) {
      print("error mengambil search signal: $xerr");
    }

    return listSignalBadgeSlim;
  }

  Future<void> clearClosedSignalsFeed({int page = 1}) async {
    for (int i = 1; i <= page; i++) {
      await CacheFactory.delete(sprintf(CacheKey.closedSignalFeed, [i]));
    }
  }

  Future<List<SignalInfo>> getClosedSignalsFeed(
      {bool clearCache = false, int page = 1}) async {
    try {
      int refreshSecond = 3600 * 5;
      if (clearCache) {
        refreshSecond = 0;
      }
      // print(clearCache);
      dynamic data = await CacheFactory.getCache(
          sprintf(CacheKey.closedSignalFeed, [page]), () async {
        Map? fetchData = {"message": List};
        print("fetchdata: $fetchData");
        String url = getHostName() + "/ois/api/v2/channel/signal/feed/";
        print("url: $url");
        Map? postParam = {"page": page};
        // print("postparam: ${UserModel.instance.hasLogin()}");
        if (UserModel.instance.hasLogin() == true) {
          print("kena ini");
          fetchData = await TF2Request.authorizeRequest(
              url: url, method: 'POST', postParam: postParam);
        } else {
          print("kena ini 2");
          fetchData = await TF2Request.request(
              url: url, method: 'POST', postParam: postParam);
        }
        print("------------------------");
        print("fetchdata: ${fetchData["message"]}");
        return fetchData["message"];
      }, refreshSecond);
      // log(data.toString(), name: "myLog");
      if (data is List) {
        return data
            .map((signalMap) { 
              return SignalInfo?.createObject(
                  active: int?.tryParse(signalMap["active"].toString()) ?? 0,
                  caption: signalMap?["caption"],
                  channelId:
                      int?.tryParse(signalMap["channel_id"].toString()) ?? 0,
                  channelPrice:
                      double?.tryParse(signalMap["channelPrice"].toString()) ??
                          0.00,
                  channelStatus:
                      int?.tryParse(signalMap["status"].toString()) ?? 0,
                  channelCreatedTimeStamp:
                      int?.tryParse(signalMap["created_time"].toString()) ?? 0,
                  closePrice:
                      double?.tryParse(signalMap["close_price"].toString()) ??
                          0.00,
                  closeTime: signalMap?["close_time"],
                  createdAt: signalMap?["created_at"],
                  expired: int?.tryParse(signalMap["expired"].toString()) ?? 0,
                  id: int?.tryParse(signalMap["id"].toString()) ?? 0,
                  notified:
                      int?.tryParse(signalMap["notified"].toString()) ?? 0,
                  op: int?.tryParse(signalMap["op"].toString()) ?? 0,
                   pips: int.tryParse(signalMap["pips"].toString()) ?? 0,
                  price:
                      double?.tryParse(signalMap["price"].toString()) ?? 0.00,
                  profit:
                      double?.tryParse(signalMap["pips"].toString()) ?? 0.00,
                  sl: double?.tryParse(signalMap["sl"].toString()) ?? 0.00,
                  tp: double?.tryParse(signalMap["tp"].toString()) ?? 0.00,
                  subs: int?.tryParse(signalMap["subscount"].toString()) ?? 0,
                  symbol: signalMap?["symbol"],
                  title: signalMap?["title"],
                  userid: int?.tryParse(signalMap["userid"].toString()) ?? 0,
                  username: signalMap?["username"],
                  channelAvatar: signalMap?["avatar"],
                  medals: int?.tryParse(signalMap["medals"].toString()) ?? 0,
                  point:
                      double?.tryParse(signalMap["point"].toString()) ?? 0.00,
                );})
            .toList();
      }
    } catch (xerr) {
      print("error xerr: $xerr");
    }
    return [];
  }

  Future<List<SignalInfo>> getChannelSignals(
      int? channelid, int? active, int? offset) async {
    List<SignalInfo> listSignalInfo = [];
    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/ois/api/v2/channel/signal/",
        postParam: {
          "CHANNELID": channelid,
          "active": active,
          "offset": offset
        });
    List signalList = fetchData["message"];

    for (Map signalMap in signalList) {
      listSignalInfo.add(SignalInfo.createObject(
        active: int.tryParse(signalMap["active"].toString()) ?? 0,
        caption: signalMap["caption"],
        channelId: int.tryParse(signalMap["channel_id"].toString()) ?? 0,
        channelPrice:
            double.tryParse(signalMap["channelPrice"].toString()) ?? 0.00,
        channelStatus: int.tryParse(signalMap["status"].toString()) ?? 0,
        channelCreatedTimeStamp:
            int.tryParse(signalMap["created_time"].toString()) ?? 0,
        closePrice:
            double.tryParse(signalMap["close_price"].toString()) ?? 0.00,
        closeTime: signalMap["close_time"],
        openTime: signalMap["open_time"],
        createdAt: signalMap["created_at"],
        expired: int.tryParse(signalMap["expired"].toString()) ?? 0,
        id: int.tryParse(signalMap["id"].toString()) ?? 0,
        notified: int.tryParse(signalMap["notified"].toString()) ?? 0,
        op: int.tryParse(signalMap["op"].toString()) ?? 0,
        pips: int.tryParse(signalMap["pips"].toString()) ?? 0,
        price: double.tryParse(signalMap["price"].toString()) ?? 0.00,
        profit: double.tryParse(signalMap["pips"].toString()) ?? 0.00,
        sl: double.tryParse(signalMap["sl"].toString()) ?? 0.00,
        tp: double.tryParse(signalMap["tp"].toString()) ?? 0.00,
        subs: int.tryParse(signalMap["subs"].toString()) ?? 0,
        symbol: signalMap["symbol"],
        title: signalMap["title"],
        userid: int.tryParse(signalMap["userid"].toString()) ?? 0,
        username: signalMap["username"],
        // channelAvatar: signalMap["avatar"],
        // medals: int.tryParse(signalMap["medals"].toString()) ?? 0,
        // point: double.tryParse(signalMap["point"].toString()) ?? 0.00,
      ));
    }

    return listSignalInfo;
  }

  Future<List<SignalCardSlim>> getRecentSignalAsync(
      {int limit = 10, int offset = 0, int filter = 0}) async {
    List<SignalCardSlim> listSignalBadgeSlim = [];
    try {
      Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/ois/api/v3/signal/recent/",
          postParam: {"limit": limit, "offset": offset, "filter": filter});
      List signalList = fetchData["message"];

      signalList.forEach((v1) {
        // ignore: prefer_is_empty
        if (listSignalBadgeSlim
                .where((test) => test.signalid == v1["id"])
                .length ==
            0) {
          listSignalBadgeSlim.add(SignalCardSlim.fromMap({
            "channelId": v1["channel_id"],
            "channelName": v1["title"],
            "channelSubscriber": v1["subscount"],
            "channelAvatar": v1["avatar"],
            "signalid": v1["id"],
            "symbol": v1["symbol"],
            "createdAt": v1["created_at"],
            "expired": v1["expired"],
            "subs": v1["subscount"],
            "medals": v1["medals"],
            "op": v1["op"],
          }));
        }
      });

      listSignalBadgeSlim.sort((a, b) {
        return DateTime.parse(b.createdAt!)
            .compareTo(DateTime.parse(a.createdAt!));
      });
      return listSignalBadgeSlim;
    } catch (xerr) {
      print("error fetch recent signal: ${xerr.toString()}");
    }

    return [];
  }

  Future<SignalInfo?> getSignalDetailAsync(int signalid,
      {bool clearCache = false}) async {
    try {
      dynamic data = await _signalBox?.get(signalid.toString());
      print("=======signalid: $signalid");
      print("=====data :$data");
      SignalInfo _signalData;
      if (data == null || data == "" || clearCache == false) {
        print("=====progress111");
        Map fetchData = await TF2Request.authorizeRequest(
            url: getHostName() + "/ois/api/v2/signal/detail/",
            postParam: {"signalid": signalid});
            print("=====progress2324");
        print("=====fetchData: $fetchData");
        Map signalMap = fetchData["message"];
        print("=====progress1123231");
        _signalData = SignalInfo.createObject(
          active: int.tryParse(signalMap["active"].toString()) ?? 0,
          caption: signalMap["caption"],
          channelId: int.tryParse(signalMap["channel_id"].toString()) ?? 0,
          channelPrice:
              double.tryParse(signalMap["channelPrice"].toString()) ?? 0.00,
          channelStatus: int.tryParse(signalMap["status"].toString()) ?? 0,
          channelCreatedTimeStamp:
              int.tryParse(signalMap["created_time"].toString()) ?? 0,
          closePrice:
              double.tryParse(signalMap["close_price"].toString()) ?? 0.00,
          closeTime: signalMap["close_time"],
          createdAt: signalMap["created_at"],
          expired: int.tryParse(signalMap["expired"].toString()) ?? 0,
          id: int.tryParse(signalMap["id"].toString()) ?? 0,
          notified: int.tryParse(signalMap["notified"].toString()) ?? 0,
          op: int.tryParse(signalMap["op"].toString()) ?? 0,
          price: double.tryParse(signalMap["price"].toString()) ?? 0.00,
          profit: double.tryParse(signalMap["pips"].toString()) ?? 0.00,
          sl: double.tryParse(signalMap["sl"].toString()) ?? 0.00,
          tp: double.tryParse(signalMap["tp"].toString()) ?? 0.00,
          subs: int.tryParse(signalMap["subs"].toString()) ?? 0,
          symbol: signalMap["symbol"],
          title: signalMap["title"],
          userid: int.tryParse(signalMap["userid"].toString()) ?? 0,
          username: signalMap["username"],
          channelAvatar: signalMap["avatar"],
          medals: int.tryParse(signalMap["medals"].toString()) ?? 0,
          point: double.tryParse(signalMap["point"].toString()) ?? 0.00,
        );
        print("=====progress11wewef1");
        await _signalBox?.putMap(
            _signalData.id.toString(), _signalData.toMap()!);
            print("=====progressqweqwe");
      } else {
        print("=====progressfjsdjfj");
        Map mapData = jsonDecode(data);
        _signalData = SignalInfo.fromMap(mapData);
      }
      return _signalData;
    } catch (xerr, stack) {
      print(xerr);
      print("----------------------");
      print("stackk: $stack");
    }

    return null;
  }

  Future<int> createSignal(
      {int? channelid,
      String? cmd,
      String? symbol,
      double? price,
      double? sl,
      double? tp,
      int? hour}) async {
    Map<String, dynamic> postParam = {
      "CHANNELID": channelid,
      "SYMBOL": symbol,
      "CMD": cmd,
      "PRICE": price,
      "EXPIRED": hour! * 3600,
      "SL": sl,
      "TP": tp
    };

    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/ois/api/v1/signal/create/",
        postParam: postParam);

    SharedBoxHelper? cache = SharedHelper.instance.getBox(BoxName.cache);
    await cache?.delete(CacheKey.oisDashboard);
    await cache?.delete(CacheKey.oisMyChannel);
    return fetchData["message"];
  }

  Future<List> getAccountSymbols({String? mt4, String? symbol}) async {
    Map postParam = {"account": mt4, "symbol": symbol};

    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/mrg/api/v1/account/symbol/",
        postParam: postParam);

    return fetchData["message"];
  }

  Future<dynamic> copySignal(
      {int? signalid,
      String? mt4id,
      String? symbol,
      double? volume,
      String? broker}) async {
    Map postParam = {
      "SIGNALID": signalid,
      "MT4ID": mt4id,
      "VOLUME": volume,
      "SYMBOL": symbol,
      "BROKER": broker,
    };

    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/ois/api/v1/signal/copy/", postParam: postParam);
    return fetchData["message"];
  }

  Future<dynamic> cancelSignal({int? signalId}) async {
    Map postParam = {"SIGNALID": signalId};

    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/ois/api/v1/signal/cancel/",
        postParam: postParam);
    return fetchData["message"];
  }

  Future<List<SignalTradeCopyLogSlim>> getSignalTradeByMe(int signalid,
      {int refreshSeconds = 18000}) async {
    List data = await CacheFactory.getCache(
        sprintf(CacheKey.signalTradeByIDnUserID,
            [signalid, appStateController.users.value.id]), () async {
      Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/ois/api/v1/signal/trade/byme/",
          postParam: {"SIGNALID": signalid});
      return fetchData["message"];
    }, refreshSeconds);

    return data
        .map<SignalTradeCopyLogSlim>(
            (json) => SignalTradeCopyLogSlim.fromTF2v1API(json))
        .toList();
  }

  Future<void> deleteSignalCache(int signalId) async {
    SharedBoxHelper? cache = SharedHelper.instance.getBox(BoxName.signal);
    cache?.delete(signalId.toString());
  }

  Future<bool> updateSignal(
      {int? signalId,
      double price = 0,
      double? tp,
      double? sl,
      int? expired}) async {
    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/ois/api/v1/signal/update/",
        postParam: {
          "signal_id": signalId,
          "price": price,
          "tp": tp,
          "sl": sl,
          "expired": expired
        });

    return fetchData["message"];
  }
}
