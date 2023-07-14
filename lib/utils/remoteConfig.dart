import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:saham_01_app/utils/storage.dart';

var settings = {"mode": "development"};

RemoteConfig remoteConfig;
// database table and column names
final String tableCfg = 'cfg';
final String columnId = 'id';
final String columnParams = 'params';

// data model class
class Cfg {
  String id;
  String params;

  Cfg({this.id, this.params});

  // convenience constructor to create a Word object
  Cfg.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    params = map[columnParams];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnParams: params};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

Future<bool> updateCfgAsync(String id, String params) async {
  try {
    SharedBox prefs = SharedHelper.instance.getBox(BoxName.config);
    bool res = await prefs.put(id, params);
    return res;
  } catch (x) {
    print("UpdateCfgAsync Error");
    print(x);
  }
  return false;
}

Future<String> getCfgAsync(String id) async {
  try {
    SharedBox prefs = SharedHelper.instance.getBox(BoxName.config);
    String data = await prefs.get(id);
    return data;
  } catch (x) {
    print("GetCfgAsync Error");
    print(x);
  }
  return 'null';
}

Future<bool> removeCfgAsync(String id) async {
  try {
    SharedBox prefs = SharedHelper.instance.getBox(BoxName.config);
    bool res = await prefs.delete(id);
    return res;
  } catch (x) {}
  return false;
}
