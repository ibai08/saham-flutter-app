import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as Get;
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/core/http.dart';
import 'package:saham_01_app/models/user.dart';

class Regional {
  final AppStateController appStateController = Get.Get.put(AppStateController());
  Future<Map> getRegion(String kd) async {
    Response res;
    if (appStateController.users.value.id < 1) {
      throw Exception("PLEASE_LOGIN_FIRST");
    }

    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = Duration(milliseconds: 30000);
    String? token = await UserModel.instance.getUserToken();
    dio.options.headers = {"Authorization": "Bearer " + token!};
    res = await dio.get(getHostName() + "/traders/api/v1/wilayah/",
        queryParameters: {"kd": kd});
    return jsonDecode(res.toString());
  }
}