import 'package:dio/dio.dart';
import 'package:get/get.dart' as Get;
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/core/cachefactory.dart';
import 'package:saham_01_app/core/getStorage.dart';
import 'package:saham_01_app/core/http.dart';
import 'package:saham_01_app/models/entities/askap.dart';
import 'package:saham_01_app/models/user.dart';
import 'package:sprintf/sprintf.dart';

class AskapModel {
  static const realAcc = "real";
  static const demoAcc = "demo";


  static Future<void> fetchUserData({bool clearCache = false}) async {
    try {
      UserAskap user = UserAskap(
        askapid: await getBrokerAccount(clearCache: clearCache),
        realAccounts: await getRealAccAskap(clearCache: clearCache),
        demoAccounts: await getDemoAccAskap(clearCache: clearCache),
        transactions: await getLatestTransactions(clearCache: clearCache),
        lastSync: DateTime.now().millisecondsSinceEpoch / 1000,
        accountTypes: await getAccountTypes(clearCache: clearCache),
        hasDeposit: await hasDeposit(),
      );
      appStateController?.setAppState(Operation.setUserAskap, user.toMap());
    } catch (xerr) {
      print(xerr);
    }
  }

  static Future<List<AccountTypeAskap>> getAccountTypes(
      {bool clearCache = false}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      int refreshSecond = 3600 * 5;
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data =
          await CacheFactory.getCache(CacheKey.accountTypeAskap, () async {
        Map fetchData = await TF2Request.authorizeRequest(
            method: "GET", url: getHostName() + "/askap/api/v1/account/types/");
        return fetchData["message"];
      }, refreshSecond);

      if (data is List) {
        return data.map((type) => AccountTypeAskap.fromMap(type)).toList();
      }
    } catch (xerr) {}

    return [];
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
          sprintf(CacheKey.userAskapByID, [appStateController?.users.value.id]), () async {
        Map fetchData = await TF2Request.authorizeRequest(
            method: "GET", url: getHostName() + "/askap/api/v1/account/check/");
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
      url: getHostName() + "/askap/api/v1/account/symbol/",
      method: 'POST',
      postParam: {"account": account, "symbol": symbol}
    );
    listTradeSymbol = fetchData["message"];

    return listTradeSymbol;
  }

  static Future<bool> hasDeposit() async {
    bool hasDeposit = false;
    Map fetchData = await TF2Request.authorizeRequest(
      url: getHostName() + "/askap/api/v1/deposit/check/",
      method: 'GET',
    );
    hasDeposit = fetchData["message"];
    return hasDeposit;
  }

  static Future<List<RealAccAskap>> getRealAccAskap(
      {bool clearCache = false}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      int refreshSecond = 3600 * 5;
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data = await CacheFactory.getCache(
        sprintf(CacheKey.realAccAskapByID, [appStateController?.users.value.id]), () async {
        Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/askap/api/v1/account/",
          method: 'GET',
        );

        return fetchData["message"];
      }, refreshSecond);

      if (data is List) {
        return data.map((map) => RealAccAskap.fromMap(map)).toList();
      }
    } catch (xerr) {}

    return [];
  }

  static Future<List<DemoAccAskap>?> getDemoAccAskap(
      {bool clearCache = false}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      int refreshSecond = 3600 * 5;
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data = await CacheFactory.getCache(
          sprintf(CacheKey.demoAccAskapByID, [appStateController?.users.value.id]), () async {
        Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/askap/api/v1/account/demo/",
          method: 'GET',
        );

        return fetchData["message"];
      }, refreshSecond);

      if (data is List) {
        return data.map((map) => DemoAccAskap.fromMap(map)).toList();
      }
    } catch (xerr) {}

    return null;
  }

  static Future<List<BankBrokerAskap>> getBankData(
      {bool clearCache = false}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      int refreshSecond = 3600 * 5;
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data =
          await CacheFactory.getCache(CacheKey.bankBrokerAksap, () async {
        Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/askap/api/v1/bank/",
          method: 'GET',
        );

        return fetchData["message"];
      }, refreshSecond);

      if (data is List) {
        return data.map((map) => BankBrokerAskap.fromMap(map)).toList();
      }
    } catch (xerr) {}

    return [];
  }

  static Future<List<BankBrokerAskap>> getBankUserData() async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/askap/api/v1/bank/user/",
        method: 'GET',
      );

      List data = fetchData["message"];

      if (data is List) {
        return data.map((map) => BankBrokerAskap.fromMap(map)).toList();
      }
    } catch (xerr) {}

    return [];
  }

  static Future<List<UserTransactionsAskap>?> getLatestTransactions(
      {bool clearCache = false}) async {
    try {
      if (!UserModel.instance.hasLogin()) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      int refreshSecond = 3600 * 5;
      if (clearCache) {
        refreshSecond = 0;
      }
      dynamic data = await CacheFactory.getCache(
          sprintf(CacheKey.transactionAskapByID, [appStateController?.users.value.id]),
          () async {
        Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/askap/api/v1/transaction/latest/",
          method: 'GET',
        );

        return fetchData["message"];
      }, refreshSecond);

      if (data is List) {
        return data.map((map) => UserTransactionsAskap.fromMap(map)).toList();
      }
    } catch (xerr) {}

    return null;
  }

  static Future<bool> register(Map data) async {
    bool isLogin = UserModel.instance.hasLogin();
    if (!isLogin) {
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
      res =
          await dio.post(getHostName() + "/askap/api/v1/register/", data: data);

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

  static Future<bool> submitDeposit(Map data) async {
    bool isLogin = UserModel.instance.hasLogin();
    if (!isLogin) {
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
      res =
          await dio.post(getHostName() + "/askap/api/v1/deposit/", data: data);

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

  static Future<bool> submitWithdrawal(Map data) async {
    bool isLogin = UserModel.instance.hasLogin();
    if (!isLogin) {
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
      res =
          await dio.post(getHostName() + "/askap/api/v1/withdraw/", data: data);

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

  static Future<Map> getPendingRequest() async {
    Map fetchData = await TF2Request.authorizeRequest(
      url: getHostName() + "/askap/api/v1/account/request/check/",
      method: 'GET',
    );
    return fetchData["message"];
  }

  static Future<String> requestRealAccountUploads(
      {Map<String, Future<XFile>>? documents}) async {
    if (documents != null) {
      Map<String, dynamic> files = {};
      for (var key in documents.keys) {
        XFile? doc = await documents[key];

        files[key] = MultipartFile.fromBytes(
            encodeJpg(
                copyResize(decodeImage(await doc!.readAsBytes())!, width: 500),
                quality: 70),
            contentType: MediaType("image", "jpeg"),
            filename: key + ".jpeg");
      }
      FormData formData = FormData.fromMap(files);
      Map fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/askap/api/v1/account/request/uploads/",
          method: 'POST',
          formData: formData);
      return fetchData["message"];
    } else {
      return "NOTHING_TO_UPLOAD";
    }
  }

  static Future<String> requestRealAccount({Map? data}) async {
    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/askap/api/v1/account/request/",
        method: 'POST',
        postParam: data);
    return fetchData["message"];
  }

  static Future<bool> requestDemoAccount() async {
    Map fetchData = await TF2Request.authorizeRequest(
        url: getHostName() + "/askap/api/v1/account/demo/request/",
        method: 'GET');
    return fetchData["message"];
  }
}