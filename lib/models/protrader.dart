import 'package:saham_01_app/core/http.dart';

class ProtraderModel {
  static Future<String> submitRegisProtrader({Map? data}) async {
    Map fetchData = await TF2Request.request(
        url: getHostName() + "/traders/api/v1/protrader/register/",
        method: 'POST',
        postParam: data!);
    return fetchData["message"];
  }
}