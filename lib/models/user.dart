import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:saham_01_app/controller/appStateController.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/core/analytics.dart';
import 'package:saham_01_app/core/cachefactory.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/core/firebasecm.dart';
import 'package:saham_01_app/core/getStorage.dart';
import 'package:saham_01_app/core/http.dart';
import 'package:saham_01_app/core/string.dart';
import 'package:saham_01_app/core/zendesk.dart';
import 'package:saham_01_app/models/askap.dart';
import 'package:saham_01_app/models/entities/user.dart';
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

  Future<void> refreshUserData() async {
    Map data = await TF2Request.authorizeRequest(
      method: "GET",
      url: getHostName() + "/traders/api/v1/user/mydata/",
    );

    if (!data.containsKey("error") && data.containsKey("message")) {
      await updateCfgAsync("usrdat", jsonEncode(data["message"]));
      await refreshController();
    }
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

        bool ul = await setUserLogin(result["result"], result["enc"], jsonEncode(user),arguments: arguments);
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


      FirebaseCrashlytics.instance.setUserIdentifier('${appStateController?.users.value.id}');
      FirebaseCrashlytics.instance.setCustomKey("email", '${appStateController?.users.value.email}');
      FirebaseCrashlytics.instance.setCustomKey("username", '${appStateController?.users.value.username}');
      firebaseAnalytics.setUserId('${appStateController?.users.value.id}');
      MainZendesk().setVisitorInfo(
        email: '${appStateController?.users.value.email}',
        name: '${appStateController?.users.value.fullname}',
        phone: '${appStateController?.users.value.phone}'
      );
      MainZendesk().removeTag(ZendeskTag.logout).then((value) => null).catchError((e) => print(e));
      MainZendesk().removeTag(ZendeskTag.newVisitor).then((value) => null).catchError((e) => print(e));
      MainZendesk().removeTag(ZendeskTag.login).then((value) => null).catchError((e) => print(e));
      return true;
    } catch (xerr) {
      await SharedHelper.instance.clearAll();
      rethrow;
    }
  }

  Future<bool> editProfile(UserInfo user) async {
    bool isLogin = hasLogin();
    Response res;
    Map data = {};
    if (!user.isProfileComplete()) {
      throw Exception("PROFILE_IS_NOT_COMPLETE");
    }

    if (!isLogin) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    int i = 0;
    do {
      i++;
      Dio dio = Dio(); // with default Options
      dio.options.connectTimeout = 5000; //5s
      dio.options.receiveTimeout = 3000;
      String? token = await getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      res = await dio.post(getHostName() + "/traders/api/v1/user/edit/profile/",
          data: user.toMap());
      data = res.data;
      if (data.containsKey("error") &&
          data["error"] == "UnauthorizedError" &&
          i == 1) {
        await refreshLogin();
        continue;
      }
      break;
    } while (i < 2);

    if (data.containsKey("error")) {
      throw Exception("${data["error"]}: ${data["message"]}");
    }

    if (data["message"] is Map) {
      UserInfo tmpuser = UserInfo.fromMap(data["message"]);
      if (tmpuser.id! > 0) {
        await updateCfgAsync("usrdat", jsonEncode(data["message"]));
        await refreshController();
        //refresh
        return true;
      }
    }

    throw Exception("PLEASE_TRY_AGAIN");
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

    await logout();
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
          await refreshLogin();
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
          parameters: {"userid": appStateController?.users.value.id}).then((x) {});
      await SharedHelper.instance.clearAll();
      appStateController?.setAppState(Operation.clearState, null);
      await FCM.instance.deleteInstanceID();
      CacheFactory.releaseAllMutex();
    } catch (xerr) {
      print("UserModel.logout: $xerr");
    }
  }

  Future<void> refreshFCMToken() async {
    bool isLogin = hasLogin();
    if (isLogin) {
      String? fcmToken = await FCM.instance.getToken();
      await FCM.instance.userSetFCMToken(fcmToken);
    }
  }

  Future<bool> register(
      {String? email,
      String? name,
      String? password,
      String? passconfirm,
      String? phone,
      String? branch,
      int subscribe = 1,
      dynamic arguments}) async {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email!);
    if (!emailValid) {
      throw Exception("EMAIL_IS_NOT_VALID");
    } else if (name!.length < 4 || name.length > 50) {
      throw Exception("NAME_MUST_BETWEEN_4_AND_50_CHARACTERS");
    } else if (password!.length < 6 || password.length > 12) {
      throw Exception("PASSWORD_MUST_BETWEEN_6_AND_12_CHARACTERS");
    } else if (password.compareTo(passconfirm!) != 0) {
      throw Exception("PASSWORD_AND_CONFIRM_DOESNT_MATCH");
    } else if (!validateMobileNumber(phone!)) {
      throw Exception("INVALID_PHONE_NUMBER");
    } else if (subscribe < 0 || subscribe > 1) {
      throw Exception("INVALID_SUBSCRIPTION");
    }

    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = 10000; //5s
    dio.options.receiveTimeout = 30000;

    Response res =
        await dio.post(getHostName() + "/traders/api/v1/user/register/", data: {
      "email": email,
      "name": name,
      "password": password,
      "phone": phone,
      "branch": branch,
      "subscribe": subscribe,
      "referrer": await getCfgAsync(ConfigKey.installReferrer)
    });
    if (res.data is Map) {
      if (res.data.containsKey("error") && res.data.containsKey("message")) {
        throw Exception("${res.data["error"]}: ${res.data["message"]}");
      }
      if (!res.data.containsKey("error") &&
          res.data.containsKey("message") &&
          res.data["message"] is Map) {
        Map data = res.data["message"];
        if (!data.containsKey("error") &&
            data.containsKey("result") &&
            data.containsKey("enc") &&
            data.containsKey("user")) {
          await updateCfgAsync(ConfigKey.installAff, "");
          bool ul = await setUserLogin(
              data["result"], data["enc"], data["user"],
              arguments: arguments);
          if (ul) {
            firebaseAnalytics
                .setUserId('${jsonDecode(data["user"])["id"]}')
                .then((x) {
              firebaseAnalytics.logSignUp(signUpMethod: "Email");
            });
          }
          return true;
        } else {
          throw Exception("OUTPUT_PROSES_PENDAFTARAN_TIDAK_DIKETAHUI");
        }
      }
    }

    return true;
  }

  Future<bool> registerWithCity(
      {String? email,
      String? name,
      String? password,
      String? passconfirm,
      String? phone,
      String? city,
      String token = "",
      int subscribe = 1,
      dynamic arguments}) async {
    bool emailValid = RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email!.replaceAll(' ', ''));
    if (!emailValid) {
      throw Exception("EMAIL_IS_NOT_VALID");
    } else if (name!.length < 4 || name.length > 50) {
      throw Exception("NAME_MUST_BETWEEN_4_AND_50_CHARACTERS");
    } else if (token == "" && (password!.length < 6 || password.length > 12)) {
      throw Exception("PASSWORD_MUST_BETWEEN_4_AND_12_CHARACTERS");
    } else if (token == "" && password?.compareTo(passconfirm!) != 0) {
      throw Exception("PASSWORD_AND_CONFIRM_DOESNT_MATCH");
    } else if (!validateMobileNumber(phone!)) {
      throw Exception("INVALID_PHONE_NUMBER");
    } else if (city!.isEmpty) {
      throw Exception("PLEASE_SELECT_CITY");
    } else if (subscribe < 0 || subscribe > 1) {
      throw Exception("INVALID_SUBSCRIPTION");
    }

    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = 10000; //5s
    dio.options.receiveTimeout = 30000;

    Response res =
        await dio.post(getHostName() + "/traders/api/v2/user/register/", data: {
      "email": email.replaceAll(' ', ''),
      "name": name,
      "password": password,
      "phone": phone,
      "city": city,
      "subscribe": subscribe,
      "idToken": token,
      "referrer": await getCfgAsync(ConfigKey.installReferrer),
      "aff": await getCfgAsync(ConfigKey.installAff),
    });
    if (res.data is Map) {
      if (res.data.containsKey("error") && res.data.containsKey("message")) {
        throw Exception("${res.data["error"]}: ${res.data["message"]}");
      }
      if (!res.data.containsKey("error") &&
          res.data.containsKey("message") &&
          res.data["message"] is Map) {
        Map data = res.data["message"];
        if (!data.containsKey("error") &&
            data.containsKey("result") &&
            data.containsKey("enc") &&
            data.containsKey("user")) {
          await updateCfgAsync(ConfigKey.installAff, "");
          bool ul = await setUserLogin(
              data["result"], data["enc"], data["user"],
              arguments: arguments);
          if (ul) {
            firebaseAnalytics
                .setUserId('${jsonDecode(data["user"])["id"]}')
                .then((x) {
              firebaseAnalytics.logSignUp(
                  signUpMethod: token == "" ? "Email" : "Google");
            });
          }
          return true;
        } else {
          throw Exception("OUTPUT_PROSES_PENDAFTARAN_TIDAK_DIKETAHUI");
        }
      }
    }

    return true;
  }

  Future<bool> updateProfilePicture(File image) async {
    bool isLogin = hasLogin();
    Response res;

    if (!isLogin) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    Dio dio = Dio(); // with default Options

    var file = MultipartFile.fromBytes(
        encodeJpg(
            copyResize(decodeImage(await image.readAsBytes())!, width: 500),
            quality: 70),
        contentType: MediaType("image", "jpeg"),
        filename: "avatar.jpeg");
    FormData formData = FormData.fromMap({"file": file});

    dio.options.connectTimeout = 50000; //10s
    dio.options.receiveTimeout = 3000;

    int i = 0;
    do {
      i++;
      String? token = await getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      res = await dio.post(
          getHostName() + "/traders/api/v1/user/upload/avatar/",
          data: formData);

      if (res.data is Map) {
        if (res.data.containsKey("error") &&
            res.data["error"] == "UnauthorizedError" &&
            i == 1) {
          await UserModel.instance.refreshLogin();
          continue;
        }

        if (!res.data.containsKey("message")) {
          return false;
        }

        UserInfo? user = appStateController?.users.value;
        user?.avatar = res.data["message"]["avatar"];
        await updateCfgAsync("usrdat", jsonEncode(user?.toMap()));
        break;
      }
    } while (i < 2);
    return true;
  }

  Future<bool> resetPassword(String email) async {
    bool isLogin = hasLogin();
    Response res;
    Map data = {};

    if (isLogin) {
      throw Exception("ALREADY_LOGGED_IN");
    }

    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
    res = await dio.post(getHostName() + "/traders/api/v1/user/forgot/",
        data: {"email": email});
    if (res.data is Map) {
      data = res.data;
      if (data.containsKey("error")) {
        if (data["error"] == "LastResetError") {
          var waitUntil = DateTime.parse(data["message"]);
          var format = DateFormat.Hms().format(waitUntil.toLocal());
          throw Exception("Mohon tunggu hingga pukul " + format +
              " untuk melakukan reset password lagi");
        } else {
          throw Exception("${data["error"]}: ${data["message"]}");
        }
      } else if (data.containsKey("message") && data["message"] == true) {
        return true;
      }
    }

    throw Exception("RESET_PASSWORD_UNKNOWN_RESULT");
  }

  Future<bool> resendVerifyEmail(String email) async {
    bool isLogin = hasLogin();
    Response res;
    Map data = {};

    if (isLogin) {
      throw Exception("ALREADY_LOGGED_IN");
    }

    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
    res = await dio.post(getHostName() + "/traders/api/v1/verify/resend/",
        data: {"email": email});
    if (res.data is Map) {
      data = res.data;
      if (data.containsKey("error")) {
        throw Exception("${data["error"]}: ${data["message"]}");
      } else if (data.containsKey("message") && data["message"] == true) {
        return true;
      }
    }

    throw Exception("RESEND_VERIFY_UNKNOWN_RESULT");
  }

  Future<bool> resendVerifyEmailAuthorized() async {
    Map result = await TF2Request.authorizeRequest(
        url: getHostName() + '/traders/api/v1/verify/resend/authorized/');
    if (result.containsKey("error")) {
      throw Exception(result['message']);
    } else {
      return true;
    }
  }

  Future<bool> verifyEmail({String token = ""}) async {
    if (token == "") {
      return false;
    }
    Map result = await TF2Request.authorizeRequest(
        url: getHostName() + '/traders/api/v1/verify/',
        postParam: {"token": token});
    if (result.containsKey("error")) {
      throw Exception(result['message']);
    } else {
      await refreshUserData();
      return true;
    }
  }

  Future<UserCanSeeSignal> checkCanSeeSignal() async {
    Map fetchData = await TF2Request.authorizeRequest(
        method: 'GET', url: getHostName() + '/traders/api/v1/check/signal/');
    return UserCanSeeSignal.fromMap(fetchData["message"]);
  }

  Future<bool> updateNewsletter() async {
    Map fetchData = await TF2Request.authorizeRequest(
        method: 'POST',
        url: getHostName() + '/traders/api/v1/newsletter/update/');
    return fetchData["message"];
  }

  Future<void> clearCache() async {
    await SharedHelper.instance.clearBox(BoxName.cache);
    // fetch MRG userdata...
    MrgModel.fetchUserData(clearCache: true).then((mrg) {
      print("Fetch ABC Success");
    }).catchError((err) {
      print(err);
    });

    // fetch Askap userdata...
    AskapModel.fetchUserData(clearCache: true).then((askap) {
      print("Fetch DEFGHIJK Success");
    }).catchError((err) {
      print(err);
    });

    await refreshFCMToken();
    await refreshController();
  }
}