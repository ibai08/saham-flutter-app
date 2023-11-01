// ignore_for_file: avoid_print

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'get_storage.dart';

var settings = {"mode": "production"};

var remoteConfig = FirebaseRemoteConfig.instance;
const String tableCfg = 'cfg';
const String columnId = 'id';
const String columnParams = 'params';

class Cfg {
  String? id;
  String? params;

  Cfg({this.id, this.params});

  Cfg.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    params = map[columnParams];
  }

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
    SharedBoxHelper? boxs = SharedHelper.instance.getBox(BoxName.config);
    bool res = await boxs!.put(id, params);
    return res;
  } catch (e) {
    print("UpdateCfgAsync Error");
    print(e);
  }
  return false;
}

Future<String?> getCfgAsync(String id) async {
  try {
    SharedBoxHelper? boxs = SharedHelper.instance.getBox(BoxName.config);
    String data = await boxs!.get(id);
    return data;
  } catch (e) {
    print("GetCfgAsync Error");
    print("error disini");
    print(e);
  }
  return null;
}

Future<bool> removeCfgAsync(String id) async {
  try {
    SharedBoxHelper? boxs = SharedHelper.instance.getBox(BoxName.config);
    bool res = await boxs!.delete(id);
    return res;
  } catch (e) {
    print("RemoveCfgAsync Error");
    print(e);
  }
  return false;
}
