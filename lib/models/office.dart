import 'package:dio/dio.dart';
import '../../core/cachefactory.dart';
import '../../core/getStorage.dart';
import '../../core/http.dart';
import '../../models/entities/office.dart';

class Office {
  static Future<List<OfficeState>> getOfficeDetails(clearCache) async {
    int refreshSecond = 3600 * 24;
    if (clearCache) {
      refreshSecond = 0;
    }
    List data = await CacheFactory.getCache(CacheKey.tfAddress, () async {
      String link = '/json/officeNew.json';
      Response res;
      // List<OfficeState> list;
      Dio dio = Dio(); // with default Options
      dio.options.connectTimeout = const Duration(milliseconds: 10000); //5s
      dio.options.receiveTimeout = const Duration(milliseconds: 3000);
      res = await dio.get(getMainSite() + link);

      return res.data;
    }, refreshSecond);

    return data.map<OfficeState>((json) {
      return OfficeState.fromJson(json);
    }).toList();
  }
}
