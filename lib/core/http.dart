// ignore_for_file: unnecessary_null_comparison

import 'package:dio/dio.dart';
import '../../core/config.dart';

String getHostName() {
  return settings["mode"] == "production"
      ? remoteConfig.getString('tf2_production_host')
      : remoteConfig.getString('tf2_development_host');
}

String getMainSite() {
  return remoteConfig.getString('main_site');
}

class TF2Request {
  static Future<Map> request(
      {String method = 'POST', String? url, Map? postParam}) async {
    Response res;
    Map data = {};
    Dio dio = Dio();
    dio.options.connectTimeout = const Duration(milliseconds: 10000);
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    if (method == 'GET') {
      res = await dio.get(url!);
    } else {
      res = await dio.post(url!, data: postParam ?? {});
    }
    data = res.data;

    if (data.containsKey("error")) {
      throw Exception("${data["error"]}: ${data["message"]}");
    }

    return data;
  }

  static Future<Map> authorizeRequest(
      {String method = 'POST',
      String? url,
      Map? postParam,
      FormData? formData}) async {
    Response res;
    Dio dio = Dio();
    dio.options.connectTimeout = const Duration(milliseconds: 10000);
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    Map data;
    int reqNo = 0;
    postParam ??= {};
    do {
      reqNo++;
      String? token = await getCfgAsync("token");
      dio.options.headers = {"Authorization": "Bearer " + token!};
      if (method == 'GET') {
        res = await dio.get(url!);
      } else {
        Map<String, dynamic> temp = {};
        if (formData == null) {
          res = await dio.post(url!, data: (formData ?? postParam));
        } else {
          for (var field in formData.fields) {
            temp[field.key] = field.value;
          }
          for (var file in formData.files) {
            temp[file.key] = file.value;
          }
          FormData fd = FormData.fromMap(temp);
          /// TODOs: Cek ini
          res = await dio.post(url!, data: (formData != null ? fd : postParam));
        }
      }

      data = res.data;
      print("datatest: $data");
      if (data.containsKey("error")) {
        if (data["error"] == "UnauthorizedError" && reqNo == 1) {
          await refreshLogin();
          continue;
        } else {
          throw Exception("${data["error"]}: ${data["message"]}");
        }
      }
      break;
    } while (reqNo < 2);

    if (!data.containsKey("error") && data.containsKey("message")) {
      return data;
    }

    throw Exception(res.toString());
  }

  static Future<bool> refreshLogin() async {
    String? enc = await getCfgAsync("crd");
    Map data = {};
    if (enc != null) {
      Response res;
      Dio dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      dio.options.receiveTimeout = const Duration(seconds: 3);
      res = await dio.post(getHostName() + "/traders/api/v1/refreshlogin/",
          data: {"enc": enc});
      data = res.data;
      if (data.containsKey("message") && !data.containsKey("error")) {
        bool result = await updateCfgAsync("token", data["message"]["result"]);
        bool crd = await updateCfgAsync("crd", data["message"]["enc"]);
        if (result && crd) {
          return true;
        }
      }
    }

    throw Exception("CREDENTIALS_IS_EMPTY_PLEASE_MANUAL_LOGIN");
  }
}
