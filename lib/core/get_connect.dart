// ignore_for_file: avoid_print, unnecessary_null_comparison
import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/request/request.dart';
import 'config.dart';
import 'http.dart';


class TF2Request extends GetConnect {
  // @override
  // void onInit() {
  //   String? token;
  //   httpClient.addRequestModifier<dynamic>((request) async {
  //       print("ada yang request");
  //       print(request.headers);
  //       return request;
  //     } );
  //     httpClient.addResponseModifier((request, response) async {
  //       print("ada respons");
  //       print(response.body);
  //     });
  //   Future.delayed(const Duration(milliseconds: 0), () async {
  //     token = await getCfgAsync("token");
  //     httpClient.baseUrl = getHostName();

  //     httpClient.defaultContentType = "application/json";
  //     httpClient.timeout = const Duration(seconds: 5);
  //     httpClient.addResponseModifier((request, response) async {
  //       print(response.body);
  //     });
  //     httpClient.addRequestModifier<dynamic>((request) async {
  //       print("ada yang request");
  //       print(request.headers);
  //       return request;
  //     } );
  //     var headers = {"Authorization": "Bearer " + token!};
  //     httpClient.addAuthenticator<Object?>((request) async {
  //       request.headers.addAll(headers);
  //       return request;
  //     });
  //   });
  //   //Base url yang akan digunakan

  //   super.onInit();
  // }

  static Future<Map> basicRequest({String method = 'POST', String? url, Map? postParam}) async {
    Response res;
    Map data = {};
    var connect = GetConnect();

    if (method == 'GET') {
      res = await connect.get(url!);
    } else {
      res = await connect.post(url, postParam ?? {});
    }

    data = res.body;

    return data;
  }

  static Future<Map> authorizeRequest({String method = 'POST', String? url, Map? postParam, FormData? formData}) async {
    Response res;
    Map data;
    int reqNo = 0;
    postParam ??= {};
    var connect = GetConnect();
    do {
      reqNo++;
      String? token = await getCfgAsync("token");
      var headers = {"Authorization": "Bearer " + token!};
      connect.httpClient.addRequestModifier<Object?>((request) {
        request.headers.addAll(headers);
        return request;
      });
      connect.httpClient.timeout = const Duration(seconds: 8);
      if (method == 'GET') {
        res = await connect.get(url!);
      } else {
        Map<String, dynamic> temp = {};
        if (formData == null) {
          res = await connect.post(url, (formData ?? postParam));
        } else {
          for (var field in formData.fields) {
            temp[field.key] = field.value;
          }
          for (var file in formData.files) {
            temp[file.key] = file.value;
          }
          FormData fd = FormData(temp);
          res = await connect.post(url!, (formData != null ? fd : postParam), headers: headers);
        }
      }

      data = res.body;
      if (data.containsKey("error")) {
        if (data["error"] == "UnauthorizedError" && reqNo == 1) {
          await refreshLogin();
          continue;
        } else {
          throw Exception("${data["error"]}: ${data["messsage"]}");
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
      GetConnect connect = GetConnect();
      connect.httpClient.timeout = const Duration(seconds: 8);
      res = await connect.post(getHostName() + "/traders/api/v1/refreshlogin", {"enc": enc});
      data = res.body;
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