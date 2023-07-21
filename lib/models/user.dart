import 'dart:convert';

import 'package:saham_01_app/controller/appStateController.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/core/http.dart';

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
        bool ul = await 
      }
    }
  }
}