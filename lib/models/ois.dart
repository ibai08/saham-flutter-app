// ignore_for_file: library_prefixes, unnecessary_null_comparison

import 'package:dio/dio.dart';
import 'package:get/get.dart' as Get;
import 'package:get_storage/get_storage.dart';
import '../../controller/appStatesController.dart';
import '../../core/cachefactory.dart';
import '../../core/getStorage.dart';
import '../../core/http.dart';
import '../../models/channel.dart';
import '../../models/entities/ois.dart';
import '../../models/user.dart';

class OisModel {
  OisModel._privateConstructor();
  final AppStateController appStateController =
      Get.Get.find();
  static final OisModel instance = OisModel._privateConstructor();

  Future<OisDashboardPageData> synchronizeDashboard(
      {bool clearCache = true}) async {
    SharedBoxHelper? cache = SharedHelper.instance.getBox(BoxName.cache);
    double now = DateTime.now().millisecondsSinceEpoch / 1000;
    OisDashboardPageData? page = OisDashboardPageData(
        totalChannel: 0,
        totalSignal: 0,
        totalPayment: 0,
        totalSubscriber: 0,
        transactionPayment: []);
    if (clearCache) {
      cache?.delete(CacheKey.oisDashboard);
    } else {
      Map? cachedData = await cache?.getMap(CacheKey.oisDashboard);
      // check if there is valid cached data..
      if (cachedData != null && cachedData.containsKey("lastSync")) {
        page = OisDashboardPageData.fromMap(cachedData);
        if ((now - page.lastSync!) < 43200) {
          //return cached data
          return page;
        }
      }
    }

    Map data = await TF2Request.authorizeRequest(
        method: "POST",
        url: getHostName() + "/ois/api/v1/dashboard/mobile/",
        postParam: {});
    if (!data.containsKey("error") &&
        data.containsKey("message") &&
        data["message"] is Map) {
      data["message"]["lastSync"] = now;
      OisDashboardPageData page = OisDashboardPageData.fromMap(data["message"]);
      if (page != null) {
        cache?.putMap(CacheKey.oisDashboard, page.toMap());
        return page;
      }
    }

    throw Exception("INVALID_RESPONSE_FROM_SERVER");
  }

  Future<OisMyChannelPageData> synchronizeMyChannel(
      {bool clearCache = true}) async {
    // delete first if clear cache
    if (clearCache) {
      CacheFactory.delete(CacheKey.oisMyChannel);
    }
    Map data = await CacheFactory.getCache(CacheKey.oisMyChannel, () async {
      Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/ois/api/v1/my-channel/", postParam: {});
      if (!fetchData.containsKey("error") &&
          fetchData.containsKey("message") &&
          fetchData["message"] is List) {
        List<ChannelCardSlim> listChannelCardSlim = [];
        Map<String, double> listChannelBalance = {};
        if (fetchData["message"].length > 0) {
          for (Map v in fetchData["message"]) {
            listChannelBalance[v["id"].toString()] =
                double.tryParse(v["activeBalance"].toString()) ?? 0.0;
            listChannelCardSlim.add(await ChannelModel.instance
                .getDetail(v["id"], clearCache: clearCache));
          }
        }

        OisMyChannelPageData page = OisMyChannelPageData(
            lastSync: DateTime.now().millisecondsSinceEpoch / 1000,
            listMyChannel: listChannelCardSlim,
            listChannelBalance: listChannelBalance);
        return page.toMap();
      }

      return null;
    }, 3600);

    return OisMyChannelPageData.fromMap(data);
  }

  Future<List<ChannelCardSlim>> getMyChannel({bool clearCache = true}) async {
    // delete first if clear cache
    if (clearCache) {
      CacheFactory.delete(CacheKey.oisMyChannelListOnly);
    }
    List<dynamic> data =
        await CacheFactory.getCache(CacheKey.oisMyChannelListOnly, () async {
      Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/ois/api/v1/my-channel/", postParam: {});
      if (!fetchData.containsKey("error") &&
          fetchData.containsKey("message") &&
          fetchData["message"] is List) {
        return fetchData["message"];
      }

      return null;
    }, 3600);
    return data.map((x) => ChannelCardSlim.fromMap(x)).toList();
  }

  Future<bool> subscribe(ChannelCardSlim? channel, {String? token}) async {
    Map postParam = {"CHANNELID": channel?.id};
    if (token != null) {
      postParam["TOKEN"] = token;
    }

    Map data = await TF2Request.authorizeRequest(
        method: "POST",
        url: getHostName() + "/ois/api/v1/subscribe/",
        postParam: postParam);

    if (!data.containsKey("error") && data.containsKey("message")) {
      // update cache data...
      if (appStateController.users.value.id > 0) {
        if (data != null) {
          await ChannelModel.instance.getDetail(channel!.id!, clearCache: true);
          await ChannelModel.instance.getMySubscriptions(clearCache: true);
          OisModel.instance.logActions(
              channelId: channel.id,
              actionName: 'subscribe',
              stateName: 'channel_detail');
        }
      }

      return true;
    }

    throw Exception("INVALID_RESPONSE_FROM_SERVER");
  }

  Future<bool> unSubscribe(ChannelCardSlim channel) async {
    Map data = await TF2Request.authorizeRequest(
        method: "POST",
        url: getHostName() + "/ois/api/v1/unsubscribe/",
        postParam: {"CHANNELID": channel.id});

    if (!data.containsKey("error") && data.containsKey("message")) {
      // update cache data...
      if (appStateController.users.value.id > 0) {
        if (data != null) {
          await ChannelModel.instance.getDetail(channel.id!, clearCache: true);
          await ChannelModel.instance.getMySubscriptions(clearCache: true);
          OisModel.instance.logActions(
              channelId: channel.id,
              actionName: 'unsubscribe',
              stateName: 'channel_detail');
        }
      }

      return true;
    }

    throw Exception("INVALID_RESPONSE_FROM_SERVER");
  }

  Future<PaymentActions> getPaymentActions() async {
    Response res;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = const Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    Map data;
    int reqNo = 0;
    do {
      reqNo++;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      res = await dio
          .get(getHostName() + "/ois/api/v1/subscribe/payment/channels/");
      data = res.data;
      if (data.containsKey("error")) {
        if (data["error"] == "UnauthorizedError" && reqNo == 1) {
          await UserModel.instance.refreshLogin();
          continue;
        } else {
          throw Exception("${data["error"]}: ${data["message"]}");
        }
      }
      break;
    } while (reqNo < 2);
    if (!data.containsKey("error") && data.containsKey("message")) {
      return PaymentActions(
          paymentChannels: data["message"]["channels"]
              .map<PaymentChannels>((map) => PaymentChannels.fromMap(map))
              .toList(),
          paymentDurations: data["message"]["durations"]
              .map<PaymentDurationInMonths>(
                  (map) => PaymentDurationInMonths.fromMap(map))
              .toList());
    }

    throw Exception("INVALID_RESPONSE_FROM_SERVER");
  }

  Future<Map> confirmPayment(
      ChannelCardSlim channel, int duration, int paymentMethod) async {
    Response res;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = const Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    Map data;
    int reqNo = 0;
    do {
      reqNo++;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      Map postParam = {
        "CHANNELID": channel.id,
        "DURATION": duration,
        "PAYMENT_METHOD": paymentMethod
      };
      res = await dio.post(
          getHostName() + "/ois/api/v1/subscribe/payment/confirm/",
          data: postParam);
      data = res.data;
      if (data.containsKey("error")) {
        if (data["error"] == "UnauthorizedError" && reqNo == 1) {
          await UserModel.instance.refreshLogin();
          continue;
        } else if (data["error"] == "PendingPaymentError") {
          throw Exception({"bill_no": data["message"]});
        } else {
          throw Exception("${data["error"]}: ${data["message"]}");
        }
      }
      break;
    } while (reqNo < 2);

    if (!data.containsKey("error") &&
        data.containsKey("message") &&
        data["message"] is Map) {
      return data["message"];
    }

    throw Exception("INVALID_RESPONSE_FROM_SERVER");
  }

  Future<PaymentDetails> getPaymetDetail(int billNo) async {
    Response res;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = const Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    Map data;
    int reqNo = 0;
    do {
      reqNo++;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      Map postParam = {"BILL_NO": billNo};
      res = await dio.post(
          getHostName() + "/ois/api/v1/subscribe/payment/detail/",
          data: postParam);
      data = res.data;
      if (data.containsKey("error")) {
        if (data["error"] == "UnauthorizedError" && reqNo == 1) {
          await UserModel.instance.refreshLogin();
          continue;
        } else {
          throw Exception("${data["error"]}: ${data["message"]}");
        }
      }
      break;
    } while (reqNo < 2);

    if (!data.containsKey("error") &&
        data.containsKey("message") &&
        data["message"] is Map) {
      return PaymentDetails.fromMap(data["message"]);
    }

    throw Exception("INVALID_RESPONSE_FROM_SERVER");
  }

  Future<List<PaymentDetails>> getPaymetHistory() async {
    Response res;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = const Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    Map data;
    int reqNo = 0;
    do {
      reqNo++;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      res = await dio
          .get(getHostName() + "/ois/api/v1/subscribe/payment/history/");
      data = res.data;
      if (data.containsKey("error")) {
        if (data["error"] == "UnauthorizedError" && reqNo == 1) {
          await UserModel.instance.refreshLogin();
          continue;
        } else {
          throw Exception("${data["error"]}: ${data["message"]}");
        }
      }
      break;
    } while (reqNo < 2);

    if (!data.containsKey("error") &&
        data.containsKey("message") &&
        data["message"] is List) {
      return data["message"]
          .map<PaymentDetails>((map) => PaymentDetails.fromMap(map))
          .toList();
    }

    throw Exception("INVALID_RESPONSE_FROM_SERVER");
  }

  Future<bool> cancelPayment(int billNo) async {
    Response res;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = const Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    Map data;
    int reqNo = 0;
    do {
      reqNo++;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      Map postParam = {"BILL_NO": billNo};
      res = await dio.post(
          getHostName() + "/ois/api/v1/subscribe/payment/cancel/",
          data: postParam);
      data = res.data;
      if (data.containsKey("error")) {
        if (data["error"] == "UnauthorizedError" && reqNo == 1) {
          await UserModel.instance.refreshLogin();
          continue;
        } else {
          throw Exception("${data["error"]}: ${data["message"]}");
        }
      }
      break;
    } while (reqNo < 2);

    if (!data.containsKey("error") &&
        data.containsKey("message") &&
        data["message"] is bool) {
      return data["message"];
    }

    throw Exception("INVALID_RESPONSE_FROM_SERVER");
  }

  Future<int> isPending() async {
    Response res;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = const Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    Map data;
    int reqNo = 0;
    do {
      reqNo++;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      res = await dio
          .get(getHostName() + "/ois/api/v1/subscribe/payment/pending/");
      data = res.data;
      if (data.containsKey("error")) {
        if (data["error"] == "UnauthorizedError" && reqNo == 1) {
          await UserModel.instance.refreshLogin();
          continue;
        } else {
          throw Exception("${data["error"]}: ${data["message"]}");
        }
      }
      break;
    } while (reqNo < 2);

    if (!data.containsKey("error") && data.containsKey("message")) {
      return data["message"];
    }

    throw Exception("INVALID_RESPONSE_FROM_SERVER");
  }

  Future<int> submitRequestWithdrawal({Map? data}) async {
    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/ois/api/v1/channel/withdraw/", postParam: data);
    return fetchData["message"];
  }

  Future<void> logActions(
      {int? channelId, String? actionName, String? stateName}) async {
    if (UserModel.instance.hasLogin()) {
      assert(stateName != null);
      assert(actionName != null);
      assert(channelId != null);
      await TF2Request.authorizeRequest(
          url: getHostName() + "/ois/api/v1/log/",
          postParam: {
            "channel_id": channelId,
            "action_name": actionName,
            "state_name": stateName
          });
    }
  }

  Future<List<String>> getSearchHistory() async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      GetStorage sp = GetStorage();
      if (!sp.hasData(CacheKey.oisSearchHistory)) {
        Map fetchData = await TF2Request.authorizeRequest(
            method: "GET",
            url: getHostName() + "/ois/api/v1/my/search/history/");
        if (!fetchData.containsKey("error") &&
            fetchData.containsKey("message") &&
            fetchData["message"] is List) {
          sp.write(
              CacheKey.oisSearchHistory,
              fetchData["message"]
                  .map<String>((map) => map["term"].toString())
                  .toList());
        }
      }

      return Future.value(
          List<String>.from(sp.read(CacheKey.oisSearchHistory)));
    } catch (error) {
      print("Error while fetching search history: $error");
      return []; // Return an empty list or handle the error accordingly.
    }
  }

  Future<void> updateLocalSearchHistory(String term) async {
    try {
      GetStorage sp = GetStorage();
      if (sp.hasData(CacheKey.oisSearchHistory)) {
        List<dynamic> cacheHistory = sp.read(CacheKey.oisSearchHistory);
        List<String> historyList = cacheHistory.cast<String>();

        List<String> temp = [term];
        temp.addAll(historyList);
        sp.write(CacheKey.oisSearchHistory, temp.toSet().toList());
      } else {
        sp.write(CacheKey.oisSearchHistory, [term]);
      }
    } catch (error) {
      print("Error updating local search history: $error");
      // Handle the error here as needed
    }
  }

  Future<List<dynamic>> getBanks() async {
    dynamic v = await CacheFactory.getCache(CacheKey.oisBanks, () async {
      Map fetchData = await TF2Request.authorizeRequest(
          method: "GET", url: getHostName() + "/ois/api/v1/banks/");

      return fetchData["message"];
    }, 10 * 60); // cache 10 menit
    return v;
  }
}
