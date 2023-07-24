import 'package:saham_01_app/core/cachefactory.dart';
import 'package:saham_01_app/core/getStorage.dart';
import 'package:saham_01_app/core/http.dart';

class Domisili {
  static Future<Map> getDomisili({bool clearCache = false}) async {
    int refreshSecond = 3600 * 5;
    if (clearCache) {
      refreshSecond = 0;
    }
    dynamic data =
        await CacheFactory.getCache(CacheKey.domisiliGrouped, () async {
      Map fetchData = await TF2Request.authorizeRequest(
          method: "GET",
          url: getHostName() + "/traders/api/v1/city/all/grouped/");
      return fetchData["message"];
    }, refreshSecond);
    return data;
  }
}