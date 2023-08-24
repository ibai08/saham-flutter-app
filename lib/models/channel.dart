// ignore_for_file: avoid_print, empty_catches

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as Get;
import '../../constants/channel_sort.dart';
import '../../controller/appStatesController.dart';
import '../../core/cachefactory.dart';
import '../../core/getStorage.dart';
import '../../core/http.dart';
import '../../models/entities/ois.dart';
import '../../models/user.dart';
import 'package:sprintf/sprintf.dart';
import 'package:image/image.dart';
import 'package:http_parser/http_parser.dart';

import '../core/config.dart';

class ChannelModel {
  ChannelModel._privateConstructor();
  static final ChannelModel instance = ChannelModel._privateConstructor();

  final AppStateController appStateController =
      Get.Get.put(AppStateController());

  Future<void> createChannel(
      {String? name,
      double? harga,
      String? caption,
      String? bankName,
      String? bankRekening,
      String? bankOwner,
      int? real,
      String? account,
      List<ChannelPricing>? pricing}) async {
    Map fetchData = await TF2Request.authorizeRequest(
        method: 'POST',
        url: getHostName() + "/ois/api/v1/channel/create/",
        postParam: {
          "nama": name,
          "harga": harga,
          "caption": caption,
          "bank": bankName,
          "rekening": bankRekening,
          "namarekening": bankOwner,
          "mt4server": real,
          "mt4acc": account,
          "pricing": pricing?.map((price) => price.toMap()).toList()
        });

    if (fetchData["message"] is int) {
      await ChannelModel.instance.getDetail(fetchData["message"]);
    }

    await UserModel.instance.refreshUserData();
    //delete ois dashboard & channel cache
    SharedBoxHelper? cache = SharedHelper.instance.getBox(BoxName.cache);
    await cache?.delete(CacheKey.oisDashboard);
    await cache?.delete(CacheKey.oisMyChannel);
  }

  Future<void> updateChannel(
      {int? id,
      String? name,
      double? harga,
      int? real,
      String? account,
      String? bankName,
      String? bankRekening,
      String? bankOwner,
      List<ChannelPricing>? pricing}) async {
    await TF2Request.authorizeRequest(
        method: 'POST',
        url: getHostName() + "/ois/api/v1/channel/update/",
        postParam: {
          "id": id,
          "nama": name,
          "harga": harga,
          "mt4server": real,
          "mt4acc": account,
          "bank": bankName,
          "rekening": bankRekening,
          "namarekening": bankOwner,
          "pricing": pricing?.map((price) => price.toMap()).toList()
        });
    await ChannelModel.instance.getDetail(id, clearCache: true);
    await UserModel.instance.refreshUserData();
    //delete ois dashboard & channel cache
    SharedBoxHelper? cache = SharedHelper.instance.getBox(BoxName.cache);
    await cache?.delete(CacheKey.oisDashboard);
    await cache?.delete(CacheKey.oisMyChannel);
  }

  Future<int> muteChannel({int? channelid, bool? mute}) async {
    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/ois/api/v1/channel/mute/",
        postParam: {"CHANNELID": channelid, "MUTE": mute, 0: 1});
    return fetchData["message"];
  }

  Future<ChannelCardSlim> getDetail(int? channelid,
      {bool clearCache = false}) async {
    int refreshSecond = remoteConfig
        .getInt("channel_detail_expire"); //3600 * 24 * 7; // seminggu
    if (clearCache) {
      refreshSecond = 0;
    }
    dynamic v = await CacheFactory.getCache(
        sprintf(CacheKey.channelByIDforUserID,
            [channelid, appStateController.users.value.id]), () async {
      Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/ois/api/v1/channel/detail/",
          postParam: {"CHANNELID": channelid});
      return fetchData["message"];
    }, refreshSecond);
    ChannelCardSlim ccs = ChannelCardSlim.fromMap(v);

    return ccs;
  }

  Future<ChannelSummary> getSummary(int channelid) async {
    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/ois/api/v1/channel/summary/",
        postParam: {"CHANNELID": channelid});
    Map v = fetchData["message"];

    return ChannelSummary.fromTF2v1API(v);
  }

  Future<ChannelSummaryDetail> getSummary2(int channelid,
      {bool isAlltime = false}) async {
    String start = remoteConfig.getString("tf_point_start_date");
    if (isAlltime) {
      start = "1970-01-01 17:00:00 UTC";
    }
    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/ois/api/v2/channel/summary/",
        postParam: {"CHANNELID": channelid, "start": start});
    Map v = fetchData["message"];
    return ChannelSummaryDetail.fromMapApi2(v["summary"]);
  }

  Future<List<ChannelSummaryGrowth>> getChart(int channelid) async {
    Map param = {"CHANNELID": channelid};
    int isNext = 0;
    List<ChannelSummaryGrowth> result = [];
    do {
      Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/ois/api/v1/channel/chart/", postParam: param);
      List tempData = fetchData["message"]["data"];

      result = [
        ...result,
        ...tempData.map((e) => ChannelSummaryGrowth.fromMapApiv2(e)).toList(),
      ];
      if (fetchData["message"]["hasNext"] > 0) {
        param["NEXT_ID"] = fetchData["message"]["hasNext"];
      } else {
        isNext = -1;
      }
    } while (isNext >= 0);

    result.sort((a, b) {
      DateTime aClose = DateTime.parse(a.closeTime!);
      DateTime bClose = DateTime.parse(b.closeTime!);
      return aClose.compareTo(bClose);
    });

    return result;
  }

  Future<ChannelStat> getStatistic(int channelid) async {
    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/ois/api/v1/channel/stat/",
        postParam: {"CHANNELID": channelid});
    Map v = fetchData["message"];
    return ChannelStat.fromTF2v1API(v);
  }

  Future<List<ChannelCardSlim>> searchChannel(
      {String? findtext, int? offset, int? sort}) async {
    List<ChannelCardSlim> listChannelCardSlim = [];
    try {
      Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/ois/api/v1/channel/search/",
          postParam: {
            "title": findtext,
            "offset": offset,
            "sort": sortMap[sort!]["name"]
          });
      List signalList = fetchData["message"];
      // List<String> keyRequired = [
      //   "id",
      //   "title",
      //   "username",
      //   "price",
      //   "subs",
      //   "pips",
      //   "total_profit",
      //   "signals",
      //   "diff_week",
      //   "subscribed"
      // ];

      // define outerloop, jadi klo ada key yang missing dari result tgl skip
      // outerloop:
      for (Map v in signalList) {
        //cek apakah semua key tersedia...
        // for (String key in keyRequired) {
        //   if (v.containsKey(key)) {
        //     continue outerloop;
        //   }
        // }

        ChannelCardSlim ccs = await ChannelModel.instance.getDetail(v["id"]);

        listChannelCardSlim.add(ccs);
      }
    } catch (xerr) {
      print(xerr);
    }

    return listChannelCardSlim;
  }

  Future<List<ChannelCardSlim>> getProfitChannelAsync(
      {bool clearCache = false}) async {
    try {
      int refreshSecond = 3600 * 5;
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data =
          await CacheFactory.getCache(CacheKey.channelMostProfit, () async {
        Map fetchData = await TF2Request.request(
          url: getHostName() + "/ois/api/v1/channel/profit/",
          method: 'POST',
        );
        print("fecth data: $fetchData");
        return fetchData["message"];
      }, refreshSecond);
      if (data is List) {
        if (UserModel.instance.hasLogin()) {
          List<ChannelCardSlim> temp = [];
          for (Map dat in data) {
            if (dat.containsKey("id")) {
              temp.add(await ChannelModel.instance
                  .getDetail(dat["id"], clearCache: clearCache));
            }
          }

          return temp;
        } else {
          return data.map((map) => ChannelCardSlim.fromMap(map)).toList();
        }
      }
    } catch (xerr) {}

    return [];
  }

  Future<List<ChannelMostProfitEntity>> getLastMonthProfitChannelAsync(
      {int limit = 5, bool clearCache = false}) async {
    try {
      int refreshSecond = 3600 * 24;
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data = await CacheFactory.getCache(
          CacheKey.channelMostProfitLastMonth, () async {
        Map fetchData = await TF2Request.request(
            url: getHostName() + "/ois/api/v1/channel/profit/lastmonth/",
            method: 'POST',
            postParam: {"limit": limit});
        return fetchData["message"];
      }, refreshSecond);

      if (data is List) {
        return data.map((map) => ChannelMostProfitEntity.fromMap(map)).toList();
      }
    } catch (xerr) {
      print(xerr);
    }

    return [];
  }

  Future<List<ChannelCardSlim>> getMostConsistentChannels(
      {int limit = 5, bool clearCache = false}) async {
    try {
      int refreshSecond = 3600 * 24;
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data =
          await CacheFactory.getCache(CacheKey.channelMostConsistent, () async {
        Map fetchData = await TF2Request.request(
            url: getHostName() + "/ois/api/v1/channel/consistent/",
            method: 'POST',
            postParam: {"limit": limit});
        return fetchData["message"];
      }, refreshSecond);
      if (data is List) {
        return data.map((map) => ChannelCardSlim.fromMap(map)).toList();
      }
    } catch (xerr) {
      print(xerr);
    }

    return [];
  }

  Future<List<ChannelCardSlim>> getPopularChannelAsync(
      {bool clearCache = false}) async {
    try {
      int refreshSecond = 3600 * 5;
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data =
          await CacheFactory.getCache(CacheKey.channelMostPopular, () async {
        Map fetchData = await TF2Request.request(
          url: getHostName() + "/ois/api/v1/channel/popular/",
        );
        return fetchData["message"];
      }, refreshSecond);

      if (data is List) {
        if (UserModel.instance.hasLogin()) {
          List<ChannelCardSlim> temp = [];
          for (Map dat in data) {
            if (dat.containsKey("id")) {
              temp.add(await ChannelModel.instance
                  .getDetail(dat["id"], clearCache: clearCache));
            }
          }

          return temp;
        } else {
          return data.map((map) => ChannelCardSlim.fromMap(map)).toList();
        }
      }
    } catch (xerr) {}

    return [];
  }

  Future<List<int>> getRecommendedChannel(
      {bool clearCache = false, List? exceptions}) async {
    try {
      exceptions ??= [];

      int refreshSecond = 3600 * 5;
      if (clearCache || exceptions.isNotEmpty) {
        refreshSecond = 0;
      }
      dynamic data =
          await CacheFactory.getCache(CacheKey.channelRecommended, () async {
        Map fetchData = await TF2Request.authorizeRequest(
            url: getHostName() + "/ois/api/v1/channel/recommend/",
            method: "POST",
            postParam: {"exceptions": exceptions});
        return fetchData["message"];
      }, refreshSecond);

      if (data is List) {
        List<int> temp = [];
        for (String i in data) {
          temp.add(int.parse(i));
        }
        return temp;
      }
    } catch (xerr) {
      print(xerr);
    }

    return [];
  }

  Future<List<int>> getRecommendedManualChannel(
      {bool clearCache = false, int offset = 0, int? sort}) async {
    try {
      int refreshSecond = 3600 * 5;
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data = await CacheFactory.getCache(
          sprintf(CacheKey.channelRecommendedFeed, [sort, offset]), () async {
        Map fetchData = await TF2Request.authorizeRequest(
            url: getHostName() + "/ois/api/v1/channel/recommend/manual/",
            method: "POST",
            postParam: {"sort": sortMap[sort!]["name"], "offset": offset});

        var temp = [];
        for (Map v in fetchData["message"]) {
          temp.add(v["id"]);
        }
        return temp;
      }, refreshSecond);

      return List<int>.from(data);
    } catch (xerr, stack) {
      print("harusnya error");
      print(xerr);
      print(stack);
    }

    return [];
  }

  Future<List<ChannelCardSlim>> getDashboardChannels(
      {bool clearCache = false}) async {
    try {
      return await ChannelModel.instance
          .getPopularChannelAsync(clearCache: clearCache);
    } catch (xerr) {}

    return [];
  }

  Future<List<ChannelCardSlim>> getMySubscriptions(
      {bool clearCache = true}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      // int refreshSecond = 3600 * 24 * 7; // seminggu
      int refreshSecond = 0; // seminggu
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data = await CacheFactory.getCache(
          sprintf(CacheKey.channelsMySubscriptionsByUserId,
              [appStateController.users.value.id]), () async {
        Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/ois/api/v1/my/subscriptions/",
          method: 'GET',
        );

        return fetchData["message"];
      }, refreshSecond);

      if (data is List) {
        return Future.wait(
            data.map((dat) => getDetail(dat["channel_id"], clearCache: false)));
        // List<ChannelCardSlim> temp = [];
        // for (Map dat in data) {
        //   if (dat.containsKey("channel_id")) {
        //     temp.add(
        //         await this.getDetail(dat["channel_id"], clearCache: false));
        //   }
        // }

        // return temp;
      }
    } catch (xerr) {}

    return [];
  }

  Future<List<ChannelSubscriber>> getMySubscribers(
      {bool clearCache = false}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      // int refreshSecond = 3600 * 24 * 7; // seminggu
      int refreshSecond = 0; // seminggu
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data = await CacheFactory.getCache(
          sprintf(CacheKey.channelsMySubscribersByUserId,
              [appStateController.users.value.id]), () async {
        Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/ois/api/v1/my/subscribers/",
          method: 'GET',
        );

        return fetchData["message"];
      }, refreshSecond);

      if (data is List) {
        return data.map((map) => ChannelSubscriber.fromMap(map)).toList();
      }
    } catch (xerr) {
      print(xerr);
    }

    return [];
  }

  Future<bool> uploadAvatarChannel({File? image, int? channelid}) async {
    if (!UserModel.instance.hasLogin()) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    var file = MultipartFile.fromBytes(
        encodeJpg(
            copyResize(decodeImage(await image!.readAsBytes())!, width: 500),
            quality: 70),
        contentType: MediaType("image", "jpeg"),
        filename: "avatar.jpeg");
    FormData formData =
        FormData.fromMap({"file": file, "channel_id": channelid});

    Map result = await TF2Request.authorizeRequest(
        url: getHostName() + "/ois/api/v1/channel/upload/avatar/",
        formData: formData);
    if (result.containsKey("error") && result["error"] != false) {
      throw Exception(result["message"]);
    }
    return true;
  }

  Future<List<HistoryPoint>> getHistoryPoint(
      {int? channelId, bool clearCache = false}) async {
    if (appStateController.users.value.id < 1) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    int refreshSecond = 3600 * 24 * 7; // seminggu
    if (clearCache) {
      refreshSecond = 0;
    }

    dynamic data = await CacheFactory.getCache(
        sprintf(
            CacheKey.channelHistoryList, [appStateController.users.value.id]),
        () async {
      Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/ois/api/v1/channel/history/point/",
          method: 'POST',
          postParam: {"channel_id": channelId});
      return fetchData["message"];
    }, refreshSecond);
    if (data is List) {
      return data.map((map) => HistoryPoint.fromMap(map)).toList();
    }
    return [];
  }

  Future<List<RedeemHistory>> getRedeemHistory(
      {int? channelId, bool clearCache = false}) async {
    if (appStateController.users.value.id < 1) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    int refreshSecond = 3600 * 24 * 7; // seminggu
    if (clearCache) {
      refreshSecond = 0;
    }

    dynamic data = await CacheFactory.getCache(
        sprintf(
            CacheKey.channelRedeemHistory, [appStateController.users.value.id]),
        () async {
      Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/ois/api/v1/channel/history/point/redeem/",
          method: 'POST',
          postParam: {"channel_id": channelId});
      return fetchData["message"];
    }, refreshSecond);
    if (data is List) {
      return data.map((map) => RedeemHistory.fromMap(map)).toList();
    }
    return [];
  }

  Future<Level> getMedalList({bool clearCache = false}) async {
    int refreshSecond = 3600 * 24 * 7; // seminggu
    if (clearCache) {
      refreshSecond = 0;
    }
    dynamic data =
        await CacheFactory.getCache(CacheKey.channelsMedal, () async {
      Map fetchData = await TF2Request.request(
        url: getHostName() + "/ois/api/v1/channel/point/config/",
        method: 'GET',
      );

      return fetchData["message"];
    }, refreshSecond);
    Level medals = Level.fromMap(data);
    return medals;
  }

  Future<RulesPoint> getDetailRulesPoint(int channelid,
      {bool clearCache = false}) async {
    if (appStateController.users.value.id < 1) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    int refreshSecond = 3600 * 24 * 7; // seminggu
    if (clearCache) {
      refreshSecond = 0;
    }
    dynamic qualification = await CacheFactory.getCache(
        sprintf(CacheKey.channelMyHistoryPointById,
            [channelid, appStateController.users.value.id]), () async {
      Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/ois/api/v1/channel/medal/qualification/",
          method: "POST",
          postParam: {"channel_id": channelid});
      return fetchData["message"];
    }, refreshSecond);
    RulesPoint rulesPoint = RulesPoint.fromMap(qualification);
    return rulesPoint;
  }

  Future<bool> postExchangePoint(int channelId, int point) async {
    Map data = await TF2Request.authorizeRequest(
        url: getHostName() + "/ois/api/v1/channel/exchange/point/",
        method: 'POST',
        postParam: {"channel_id": channelId, "point": point});
    if (!data.containsKey("error") && data.containsKey("message")) {
      await ChannelModel.instance.getDetail(channelId, clearCache: true);
      return true;
    }

    throw Exception("INVALID_RESPONSE_FROM_SERVER");
  }
}
