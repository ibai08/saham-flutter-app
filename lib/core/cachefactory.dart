// ignore_for_file: prefer_collection_literals

import 'dart:convert';

import 'package:mutex/mutex.dart';
import 'package:saham_01_app/core/getStorage.dart';

class CacheFactory {
  static Mutex mSync = Mutex();
  static Map<String, Mutex> mapMutex = Map();
  static Mutex? getMutex(String key) {
    mSync.acquire();
    if (!mapMutex.containsKey(key)) {
      mapMutex[key] = Mutex();
    }
    mSync.release();
    return mapMutex[key];
  }

  static releaseAllMutex() {
    mSync.acquire();
    mapMutex.forEach((key, value) {
      value.release();
    });
    mSync.release();
  }

  static Future<dynamic> getCache(String key, Function func, int refreshSeconds) async {
    Map? tmp = Map();
    Mutex? m = getMutex(key);
    dynamic result;
    await m?.acquire();
    try {
      SharedBoxHelper boxCache = SharedHelper.instance.getBox(BoxName.cache);
      tmp = await boxCache.getMap(key);
      double last = tmp != null ? tmp["last"] : 0;
      double now = DateTime.now().millisecondsSinceEpoch / 1000;
      if (((now - last) > refreshSeconds && refreshSeconds > -1) || tmp == null) {
        result = await func();
        Map data = {"last": now, "data": result};
        await boxCache.put(key, jsonEncode(data));
      } else if (tmp.containsKey("data")) {
        result = tmp["data"];
      }
    } catch (x) {
      throw x;
    } finally {
      m?.release();
    }
    return result;
  }

  static Future<dynamic> delete(String key) async {
    SharedBoxHelper cache = SharedHelper.instance.getBox(BoxName.cache);
    await cache.delete(key);
  }
}