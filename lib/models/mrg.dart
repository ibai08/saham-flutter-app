import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as Get;
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/core/cachefactory.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/core/getStorage.dart';
import 'package:saham_01_app/core/http.dart';
import 'package:saham_01_app/models/entities/mrg.dart';
import 'package:saham_01_app/models/user.dart';
import 'package:sprintf/sprintf.dart';

class MrgModel {
  final realAcc = "real";
  final demoAcc = "demo";
  final contestAcc = "contest";

  Future<Map> getUserData() async {
    String? mData = await getCfgAsync("mrgdat");
    return jsonDecode(mData!);
  }

  Future<bool> setUserData(UserMRG user) async {
    String params = jsonEncode(user.toMap());
    return updateCfgAsync("mrgdat", params);
  }

  static Future<void> fetchUserData({bool clearCache = false}) async {
    try {
      UserMRG user = UserMRG(
        mrgid: await getBrokerAccount(clearCache: clearCache),
        imgID: await getId(clearCache: clearCache),
        bankInfo: await getUserBankData(clearCache: clearCache),
        realAccounts: await getRealAccMrg(clearCache: clearCache),
        demoAccounts: await getDemoAccMrg(clearCache: clearCache),
        contestAccounts: await getContestAccMrg(clearCache: clearCache),
        canWd: await checkWithdrawal(),
        transactions: await getLatestTransactions(clearCache: clearCache),
        lastSync: DateTime.now().millisecondsSinceEpoch / 1000,
        accountTypes: await getAccountTypes(clearCache: clearCache),
        hasDeposit: await hasDeposit(),
      );

      appStateController?.setAppState(Operation.setUserMRG, user.toMap());
    } catch (x) {
      print(x);
    }
  }

  static Future<int> getBrokerAccount({bool clearCache = false}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      int refreshSecond = 3600 * 5;
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data = await CacheFactory.getCache(
          sprintf(CacheKey.userMRGByID, [appStateController?.users.value.id]), () async {
        Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/mrg/api/v1/account/check/",
          method: 'GET',
        );

        return fetchData["message"];
      }, refreshSecond);

      if (data is int) {
        return data;
      }
    } catch (xerr) {
      throw xerr;
    }

    throw Exception("UNKNOWN_ERROR");
  }

  static Future<List> checkSymbolAccount(int account, String symbol) async {
    List listTradeSymbol = [];
    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/mrg/api/v1/account/symbol/",
        method: 'POST',
        postParam: {"account": account, "symbol": symbol});
    listTradeSymbol = fetchData["message"];

    return listTradeSymbol;
  }

  static Future<bool> hasDeposit() async {
    bool hasDeposit = false;
    Map fetchData = await TF2Request.authorizeRequest(
      url: getHostName() + "/mrg/api/v1/deposit/check/",
      method: 'GET',
    );
    hasDeposit = fetchData["message"];
    return hasDeposit;
  }

  static Future<List<UserTransactionsMrg>> getLatestTransactions(
      {bool clearCache = false}) async {
    if (!UserModel.instance.hasLogin()) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    int refreshSecond = 3600 * 5;
    if (clearCache) {
      refreshSecond = 0;
    }
    dynamic data = await CacheFactory.getCache(
        sprintf(CacheKey.transactionMRGByID, [appStateController?.users.value.id]), () async {
      Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/mrg/api/v1/transaction/latest/",
        method: 'GET',
      );

      return fetchData["message"];
    }, refreshSecond);

    List<UserTransactionsMrg> results = [];
    if (data is List) {
      results = data
          .map<UserTransactionsMrg>((json) => UserTransactionsMrg.fromMap(json))
          .toList();
    }

    return results;
  }

  static Future<List<RealAccMrg>> getRealAccMrg({clearCache = false}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      int refreshSecond = 3600 * 5;
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data = await CacheFactory.getCache(
          sprintf(CacheKey.realAccMRGByID, [appStateController?.users.value.id]), () async {
        Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/mrg/api/v1/account/",
          method: 'GET',
        );

        return fetchData["message"];
      }, refreshSecond);

      if (data is List) {
        return data
            .map<RealAccMrg>((json) => RealAccMrg.fromMap(json))
            .toList();
      }
    } catch (xerr) {}

    return [];
  }

  static Future<List<DemoAccMrg>> getDemoAccMrg({clearCache: false}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      int refreshSecond = 3600 * 5;
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data = await CacheFactory.getCache(
          sprintf(CacheKey.demoAccMRGByID, [appStateController?.users.value.id]), () async {
        Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/mrg/api/v1/account/demo/",
          method: 'GET',
        );

        return fetchData["message"];
      }, refreshSecond);

      if (data is List) {
        return data
            .map<DemoAccMrg>((json) => DemoAccMrg.fromMap(json))
            .toList();
      }
    } catch (xerr) {}

    return [];
  }

  static Future<List<ContestAccMrg>> getContestAccMrg(
      {clearCache = false}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      int refreshSecond = 3600 * 5;
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data = await CacheFactory.getCache(
          sprintf(CacheKey.contestAccMRGByID, [appStateController?.users.value.id]), () async {
        Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/mrg/api/v1/account/contest/",
          method: 'GET',
        );

        return fetchData["message"];
      }, refreshSecond);

      if (data is List) {
        return data
            .map<ContestAccMrg>((json) => ContestAccMrg.fromMap(json))
            .toList();
      }
    } catch (xerr) {}

    return [];
  }

  static Future<List<BankBrokerMrg>> getBankData(
      {bool clearCache = false}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      int refreshSecond = 3600 * 24 * 7; // seminggu
      if (clearCache) {
        // refreshSecond = 0;
        CacheFactory.delete(CacheKey.bankBrokerMRG);
      }
      dynamic data =
          await CacheFactory.getCache(CacheKey.bankBrokerMRG, () async {
        Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/mrg/api/v1/bank/",
          method: 'GET',
        );

        return fetchData["message"];
      }, refreshSecond);

      if (data is List) {
        return data
            .map<BankBrokerMrg>((json) => BankBrokerMrg.fromMap(json))
            .toList();
      }
    } catch (xerr) {}

    return [];
  }

  static Future<List<BankBrokerMrg>> getBankUserData() async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/mrg/api/v1/bank/user/",
        method: 'GET',
      );

      var data = fetchData["message"];

      if (data is List) {
        return data
            .map<BankBrokerMrg>((json) => BankBrokerMrg.fromMap(json))
            .toList();
      }
    } catch (xerr) {}

    return [];
  }

  static Future<UserBankMrg> getUserBankData({bool clearCache = false}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      int refreshSecond = 3600 * 24 * 7; // seminggu
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data = await CacheFactory.getCache(
          sprintf(CacheKey.userBankMRGByID, [appStateController?.users.value.id]), () async {
        Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/mrg/api/v1/user/bank/",
          method: 'GET',
        );

        return fetchData["message"];
      }, refreshSecond);

      if (data is Map) {
        return UserBankMrg.fromMap(data);
      }
    } catch (xerr) {}

    return UserBankMrg();
  }

  static Future<bool> submitDeposit(Map<String, dynamic> tempData) async {
    if (!UserModel.instance.hasLogin()) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }
    try {
      Map<String, dynamic> data = {};
      data.addAll(tempData);
      var file;
      if (data["proof"] != null) {
        Image resized = copyResize(
            decodeImage(await data["proof"].readAsBytes())!,
            width: 500);
        File resizedFile = File(data["proof"].path + "temp.jpeg")
          ..writeAsBytesSync(encodeJpg(resized));
        file = MultipartFile.fromFileSync(resizedFile.path);
        data["proof"] = file;
      }

      FormData formData = FormData.fromMap(data);
      Map res = await TF2Request.authorizeRequest(
          url: getHostName() + "/mrg/api/v2/deposit/",
          method: 'POST',
          formData: formData);
      if (res.containsKey("error")) {
        throw Exception(res);
      } else {
        return true;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      throw Exception(e);
    }
  }

  static Future<bool> checkWithdrawal({bool clearCache = false}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      int refreshSecond = 3600 * 24 * 7; //seminggu
      if (clearCache) {
        refreshSecond = 0;
      }
      await CacheFactory.getCache(
          sprintf(CacheKey.uploadIDMRGByID, [appStateController?.users.value.id]), () async {
        Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/mrg/api/v1/withdraw/check/",
          method: 'GET',
        );

        return fetchData["message"];
      }, refreshSecond);

// Will throw on error
      return true;
    } catch (xerr) {}

    return false;
  }

  static Future<bool> submitWithdrawal(Map data) async {
    if (!UserModel.instance.hasLogin()) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    Response res;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = Duration(milliseconds: 3000);

    var i = 0;
    do {
      i++;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      res = await dio.post(getHostName() + "/mrg/api/v1/withdraw/", data: data);

      if (res.data is Map) {
        if (res.data.containsKey("error")) {
          if (res.data["error"] == "UnauthorizedError" && i == 1) {
            await UserModel.instance.refreshLogin();
            continue;
          } else {
            throw Exception(res.data["message"]);
          }
        } else {
          return true;
        }
      }
      break;
    } while (i < 2);
    return false;
  }

  static Future<String> getId({bool clearCache = false}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      int refreshSecond = 3600 * 24 * 7; // seminggu
      if (clearCache) {
        refreshSecond = 0;
      }

      dynamic data = await CacheFactory.getCache(
          sprintf(CacheKey.userImgMRGID, [appStateController?.users.value.id]), () async {
        Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/mrg/api/v1/id/",
          method: 'GET',
        );

        return fetchData["message"];
      }, refreshSecond);

      if (data is String) {
        return data;
      }
    } catch (xerr) {}

    return "";
  }

  static Future<bool> uploadId(XFile image) async {
    Response res;

    Dio dio = Dio(); // with default Options

    Image resized =
        copyResize(decodeImage(await image.readAsBytes())!, width: 500);
    File resizedFile = File(image.path + "temp.jpeg")
      ..writeAsBytesSync(encodeJpg(resized));

    var file = MultipartFile.fromFileSync(resizedFile.path);

    FormData formData = FormData.fromMap({"file": file});

    dio.options.connectTimeout = Duration(milliseconds: 50000); //10s
    dio.options.receiveTimeout = Duration(milliseconds: 3000);

    int i = 0;
    do {
      i++;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      res = await dio.post(getHostName() + "/mrg/api/v1/id/upload/",
          data: formData);

      if (res.data is Map) {
        if (res.data.containsKey("error") &&
            res.data["error"] == "UnauthorizedError" &&
            i == 1) {
          await UserModel.instance.refreshLogin();
          continue;
        }
        if (res.data.containsKey("error") ||
            !res.data.containsKey("message") ||
            res.data["message"] == null) {
          resizedFile.deleteSync();
          return false;
        }
        break;
      }
    } while (i < 2);
    resizedFile.deleteSync();
    return true;
  }

  static Future<bool> register(Map data) async {
    if (!UserModel.instance.hasLogin()) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    Response res;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = Duration(milliseconds: 15000); //5s
    dio.options.receiveTimeout = Duration(milliseconds: 3000);

    var i = 0;
    do {
      i++;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      res = await dio.post(getHostName() + "/mrg/api/v1/register/", data: data);

      if (res.data is Map) {
        if (res.data.containsKey("error")) {
          if (res.data["error"] == "UnauthorizedError" && i == 1) {
            await UserModel.instance.refreshLogin();
            continue;
          } else {
            throw Exception(res.data["message"]);
          }
        } else {
          return res.data["message"];
        }
      }
      break;
    } while (i < 2);
    return false;
  }

  static Future<List<AccountTypeMrg>> getAccountTypes(
      {bool clearCache = false}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      int refreshSecond = 3600 * 24 * 7; // seminggu
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data =
          await CacheFactory.getCache(CacheKey.accountTypeMRG, () async {
        Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/mrg/api/v1/account/types/",
          method: 'GET',
        );

        return fetchData["message"];
      }, refreshSecond);

      if (data is List) {
        return data
            .map<AccountTypeMrg>((json) => AccountTypeMrg.fromMap(json))
            .toList();
      }
    } catch (xerr) {}

    return [];
  }

  static Future<bool> submitRequestDemo(int account) async {
    if (!UserModel.instance.hasLogin()) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    Response res;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = Duration(milliseconds: 3000);

    var i = 0;
    do {
      i++;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      res = await dio.post(getHostName() + "/mrg/api/v1/account/demo/request/",
          data: {"account": account});

      if (res.data is Map) {
        if (res.data.containsKey("error")) {
          if (res.data["error"] == "UnauthorizedError" && i == 1) {
            await UserModel.instance.refreshLogin();
            continue;
          } else {
            throw Exception(res.data["message"]);
          }
        } else {
          return res.data["message"];
        }
      }
      break;
    } while (i < 2);
    return false;
  }

  static Future<bool> submitRequestReal(int account) async {
    if (!UserModel.instance.hasLogin()) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    Response res;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = Duration(milliseconds: 3000);

    var i = 0;
    do {
      i++;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      res = await dio.post(getHostName() + "/mrg/api/v1/account/request/",
          data: {"account": account});

      if (res.data is Map) {
        if (res.data.containsKey("error")) {
          if (res.data["error"] == "UnauthorizedError" && i == 1) {
            await UserModel.instance.refreshLogin();
            continue;
          } else {
            throw Exception(res.data["message"]);
          }
        } else {
          return res.data["message"];
        }
      }
      break;
    } while (i < 2);
    return false;
  }

  static Future<List<ContestScheduleMrg>> getContestSchedule() async {
    if (!UserModel.instance.hasLogin()) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/mrg/api/v1/contest/schedule/", method: 'GET');

    return fetchData["message"]
        .map<ContestScheduleMrg>((map) => ContestScheduleMrg.fromMap(map))
        .toList();
  }

  static Future<bool> submitRequestContest() async {
    if (!UserModel.instance.hasLogin()) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    Response res;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = Duration(milliseconds: 3000);

    var i = 0;
    do {
      i++;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      res = await dio.post(
          getHostName() + "/mrg/api/v1/account/contest/request/",
          data: {});

      if (res.data is Map) {
        if (res.data.containsKey("error")) {
          if (res.data["error"] == "UnauthorizedError" && i == 1) {
            await UserModel.instance.refreshLogin();
            continue;
          } else {
            throw Exception(res.data["message"]);
          }
        } else {
          return res.data["message"];
        }
      }
      break;
    } while (i < 2);
    return false;
  }

  static Future<MarginInfo?> getMarginInfo(String account) async {
    if (!UserModel.instance.hasLogin()) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    Response res;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = Duration(milliseconds: 3000);

    var i = 0;
    do {
      i++;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      res = await dio.post(getHostName() + "/mrg/api/v1/account/info/",
          data: {"account": account});

      if (res.data is Map) {
        if (res.data.containsKey("error")) {
          if (res.data["error"] == "UnauthorizedError" && i == 1) {
            await UserModel.instance.refreshLogin();
            continue;
          } else {
            throw Exception(res.data["message"]);
          }
        } else {
          return MarginInfo.fromMap(res.data["message"]);
        }
      }
      break;
    } while (i < 2);
    return null;
  }

  static Future<MarginInOut?> getMarginInOut(String account) async {
    if (!UserModel.instance.hasLogin()) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    Response res;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = Duration(milliseconds: 3000);

    var i = 0;
    do {
      i++;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      res = await dio.post(
          getHostName() + "/mrg/api/v1/account/info/margininout/",
          data: {"account": account});

      if (res.data is Map) {
        if (res.data.containsKey("error")) {
          if (res.data["error"] == "UnauthorizedError" && i == 1) {
            await UserModel.instance.refreshLogin();
            continue;
          } else {
            throw Exception(res.data["message"]);
          }
        } else {
          return MarginInOut.fromMap(res.data["message"]);
        }
      }
      break;
    } while (i < 2);
    return null;
  }
}