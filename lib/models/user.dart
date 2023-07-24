import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:saham_01_app/controller/appStateController.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/core/analytics.dart';
import 'package:saham_01_app/core/cachefactory.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/core/firebasecm.dart';
import 'package:saham_01_app/core/getStorage.dart';
import 'package:saham_01_app/core/http.dart';
import 'package:saham_01_app/models/askap.dart';
import 'package:saham_01_app/models/mrg.dart';

class UserModel {
  UserModel._privateConstructor();
  static UserModel instance = UserModel._privateConstructor();

  Future<void> refreshController() async {
    Map? user = await getUserData();
    appStateController?.setAppState(Operation.setUser, {"user": user});
  }

  bool hasLogin() {
    return appStateController!.users.value.id! > 0;
  }

  Future<Map?> getUserData() async {
    String? mData = await getCfgAsync("usrdat");
    if (mData != null && mData != "") {
      return jsonDecode(mData);
    }
    return null;
  }

  Future<String?> getCredentials() async {
    return getCfgAsync("crd");
  }

  Future<String?> getUserToken() async {
    return getCfgAsync("token");
  }

  Future<Map> loginWithGoogle(String token, {dynamic arguments}) async {
    Map ret = {"result": false};
    Map data = await TF2Request.request(
      method: 'POST',
      url: getHostName() + "/traders/api/v1/login/social/",
      postParam: {"idToken": token}
    );

    if (!data.containsKey("error") && data.containsKey("message")) {
      Map result = data["message"];
      if (result.containsKey("result") && result.containsKey("enc") && result.containsKey("user")) {
        Map user = result["user"];
        bool ul = await setUserLogin(
          result["result"], result["enc"], jsonEncode(user),
          arguments: arguments
        );
        if (ul) {
          firebaseAnalytics.logLogin(loginMethod: "Google").then((x) {}, onError: (err) => print(err));
          ret["result"] = true;
          return ret;
        }
      } else if (result.containsKey("users")) {
        List<dynamic> users = result["users"];
        if (users.isNotEmpty) {
          ret["result"] = true;
          ret["users"] = result["users"];
          return ret;
        }
      }
    } else {
      if (data.containsKey("error")) {
        throw Exception(data["error"]);
      }
    }
    throw Exception("LOGIN_RESULT_NOT_COMPLETE");
  }

  Future<Map> login(String email, String password, {dynamic arguments}) async {
    Map ret = {"result": false};
    Map data = await TF2Request.request(
      method: 'POST',
      url: getHostName() + "/traders/api/v1/login/",
      postParam: {"email": email, "password": password}
    );

    if(!data.containsKey("error") && data.containsKey("message")) {
      Map result = data["message"];
      if (result.containsKey("result") && result.containsKey("enc") && result.containsKey("user")) {
        Map user = result["user"];

        bool ul = await setUserLogin(result["result"], result["enc"], jsonEncode(user), arguments: arguments);

        if (ul) {
          firebaseAnalytics.logLogin(loginMethod: "Email").then((x) {}, onError: (err) => print(err));
          ret["result"] = true;
          return ret;
        }
      } else if (result.containsKey("users")) {
        List<dynamic> users = result["users"];
        if (users.isNotEmpty) {
          ret["result"] = true;
          ret["users"] = result["users"];
          return ret;
        }
      }
    } else {
      if (data.containsKey("error")) {
        throw Exception(data["error"]);
      }
    }
    throw Exception("LOGIN_RESULT_NOT_COMPLETE");
  }

  Future<Map> loginWithMT4(String broker, String mt4id, String password, {dynamic arguments}) async {
    Map ret = {"result": false};

    Response res;
    Map data = {};
    Dio dio = Dio();
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
    res = await dio.post(getHostName() + "/traders/api/v1/login-with-mt4/", data: {"broker": broker, "mt4id": mt4id, "password": password});
    data = res.data;

    if (!data.containsKey("error") && data.containsKey("message")) {
      Map result = data["message"];
      if (result.containsKey("result") && result.containsKey("enc") && result.containsKey("user")) {
        Map user = result["user"];

        bool ul = await this.setUserLogin(result["result"], result["enc"], jsonEncode(user),arguments: arguments);
        if (ul) {
          firebaseAnalytics.logLogin(loginMethod: "MT4").then((x) {}, onError: (err) => print(err));
          ret["result"] = true;
          return ret;
        }
      }
    } else {
      if (data.containsKey("error")) {
        throw Exception(data["error"]);
      }
    }
    throw Exception("LOGIN_RESULT_NOT_COMPLETE");
  }

  Future<void> afterLogin() async {
    await TF2Request.authorizeRequest(
      url: getHostName() + "/traders/api/v1/login/after/",
      postParam: {"platform": Platform.isIOS ? "ios" : "android"} 
    );
  }

  Future<bool> setUserLogin(String token, String credential, String userJson, {dynamic arguments}) async {
    try {
      bool result = await updateCfgAsync("token", token);
      bool crd = await updateCfgAsync("crd", credential);
      bool upduser = await updateCfgAsync("usrdat", userJson);
      if (!result || !crd || !upduser) {
        throw Exception("UNABLE_SAVE_TO_DATA");
      }

      FCM.instance.getToken().then((fcmToken) => FCM.instance.userSetFCMToken(fcmToken!).then((x) => null), onError: (error) async {
        await updateCfgAsync("fcm_token_saved", "0");
      });

      await refreshController();
      afterLogin().then((value) => null);
      appStateController?.setAppState(Operation.bringToHome, HomeTab.home);

      if (arguments != null) {
        if (arguments is Map && arguments.containsKey("route") && arguments.containsKey("arguments")) {
          appStateController?.setAppState(Operation.pushNamed, arguments);
        } else if (arguments is String) {
          appStateController?.setAppState(Operation.pushNamed, {"route": "/forms/login", "arguments": arguments});
        }
      } else if (!appStateController!.users.value.verify!) {
        appStateController?.setAppState(Operation.pushNamed, {"route": "/forms/login"});
      }

      await SharedHelper.instance.clearBox(BoxName.cache);

      MrgModel.fetchUserData(clearCache: true).then((mrg) {
        print("Fetch ABC Success");
      }).catchError((err) {
        print(err);
      });

      AskapModel.fetchUserData(clearCache: true).then((askap) {
        print("Fetch DEFGHIJK Success");
      }).catchError((err) {
        print(err);
      });


      FirebaseCrashlytics.instance.setUserIdentifier('${appStateController!.users.value.id}');
      FirebaseCrashlytics.instance.setCustomKey("email", '${appStateController!.users.value.email}');
      FirebaseCrashlytics.instance.setCustomKey("username", '${appStateController!.users.value.username}');
      firebaseAnalytics.setUserId('${appStateController!.users.value.id}');
      
    }
  }

  Future<bool> refreshLogin() async {
    String? enc = await getCredentials();
    if (enc != null) {
      Response res;
      Map data = {};
      Dio dio = Dio();
      dio.options.connectTimeout = 5000;
      dio.options.receiveTimeout = 3000;
      res = await dio.post(getHostName() + "/traders/api/v1/refreshlogin/", data: {"enc": enc});
      data = res.data;

      if (data.containsKey("message") && !data.containsKey("error")) {
        bool result = await updateCfgAsync("token", data["message"]["result"]);
        bool crd = await updateCfgAsync("crd", data["message"]["enc"]);
        if (result && crd) {
          return true;
        }
      }
    }

    await this.logout();
    throw Exception("CREDENTIALS_IS_EMPTY_PLEASE_MANUAL_LOGIN");
  }

  Future<bool> changePassword(String oldpassword, String newpassword) async {
    bool isLogin = hasLogin();
    Response res;
    Map data = {};

    int i = 0;
    do {
      i++;
      if (!isLogin) {
        throw Exception("PLEASE_LOGIN_FIRST");
      }

      Dio dio = Dio(); // with default Options
      dio.options.connectTimeout = 5000; //5s
      dio.options.receiveTimeout = 3000;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      res = await dio.post(getHostName() + "/traders/api/v1/user/changepass/",
          data: {"oldpassword": oldpassword, "newpassword": newpassword});
      if (res.data is Map) {
        data = res.data;
        if (!data.containsKey("error") &&
            data.containsKey("message") &&
            data["message"] == true) {
          return true;
        } else if (data.containsKey("error") &&
            data["error"] == "UnauthorizedError" &&
            i == 1) {
          await this.refreshLogin();
          continue;
        }
      }
      break;
    } while (i < 2);

    if (data.containsKey("error")) {
      throw Exception("${data["error"]}: ${data["message"]}");
    }

    throw Exception("CHANGE_PASSWORD_UNKNOWN_RESULT");
  }

  Future<void> logout({bool destroyToken = true}) async {
    try {
      if (destroyToken) {
        await FCM.instance.userSetFCMToken(null);
      }
      firebaseAnalytics.logEvent(
          name: "logout",
          parameters: {"userid": appStateController!.users.value.id}).then((x) {});
      await SharedHelper.instance.clearAll();
      appStateController?.setAppState(Operation.clearState, null);
      await FCM.instance.deleteInstanceID();
      CacheFactory.releaseAllMutex();
    } catch (xerr) {
      print("UserModel.logout: $xerr");
    }
  }
}