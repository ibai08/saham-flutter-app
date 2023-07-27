import 'package:saham_01_app/core/http.dart';
import 'package:saham_01_app/models/entities/tfcampus.dart';
import 'package:saham_01_app/models/user.dart';

class TfcampusModel {
  static Future<List<TFCampusClass>> getClassList() async {
    Map fetchData = await TF2Request.request(
        url: getHostName() + "/traders/api/v1/tfcampus/schedule/",
        method: 'GET');
    return fetchData["message"]
        .map<TFCampusClass>((map) => TFCampusClass.fromMap(map))
        .toList();
  }

  static Future<TFCampusConfig> getConfig() async {
    Map fetchData = await TF2Request.request(
        url: getHostName() + "/traders/api/v1/tfcampus/config/", method: 'GET');
    return TFCampusConfig.fromMap(fetchData["message"]);
  }

  static Future<bool> submitRegisterTFCampus(Map data) async {
    Map fetchData;
    if (UserModel.instance.hasLogin()) {
      fetchData = await TF2Request.authorizeRequest(
          url: getHostName() + "/traders/api/v1/tfcampus/register/",
          method: 'POST',
          postParam: data);
    } else {
      fetchData = await TF2Request.request(
          url: getHostName() + "/traders/api/v1/tfcampus/register/",
          method: 'POST',
          postParam: data);
    }

    return fetchData["message"];
  }
}