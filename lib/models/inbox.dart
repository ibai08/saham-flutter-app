// ignore_for_file: empty_catches

import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as Get;
import 'package:get/state_manager.dart';
import '../../controller/appStatesController.dart';
import '../../core/config.dart';
import '../../core/getStorage.dart';
import '../../core/http.dart';
import '../../function/helper.dart';
import '../../models/entities/inbox.dart';
import '../../models/user.dart';

class InboxModel {
  InboxModel._privateConstructor();
  static final InboxModel instance = InboxModel._privateConstructor();
  final RxMap<int, dynamic> _obsBox = RxMap<int, dynamic>();
  final AppStateController appStateController =
      Get.Get.put(AppStateController());

  SharedBoxHelper? getBox() {
    return SharedHelper.instance.getBox(BoxName.inbox);
  }

  void addDataToBox(int identifier, dynamic data) {
    _obsBox[identifier] = data;
  }

  void removeDataFromBox(int identifier) {
    _obsBox.remove(identifier);
  }

  Future<void> refreshInboxByIdAsync({int? id}) async {
    try {
      Map res;
      if (appStateController.users.value.id > 0) {
        res = await TF2Request.authorizeRequest(
            method: 'GET',
            url: getHostName() + "/traders/api/v2/my-inbox/$id/");
      } else {
        res = await TF2Request.request(
            method: 'GET', url: getHostName() + "/traders/api/v2/inbox/$id/");
      }
      if (!res.containsKey("error") &&
          res.containsKey("message") &&
          res["message"] is Map) {
        Map data = res["message"];
        if (!data.containsKey("msgid") ||
            !data.containsKey("message") ||
            !data.containsKey("params") ||
            !data.containsKey("baca")) {
          throw Exception("INVALID_INBOX_DATA_RESPONSE");
        }
        // update inbox...
        await updateInboxAsync(
            id: data["msgid"],
            title: data["title"],
            description: data["description"],
            message: data["message"],
            params: data["params"],
            baca: data["baca"],
            created: data["tm_created"]);
      }
    } catch (ex) {}
  }

  Future<void> refreshAllBoxAsync(
      {clearCache = true,
      animateDelay = true,
      load = false,
      InboxType? type}) async {
    try {
      SharedBoxHelper? _inboxBox = SharedHelper.instance.getBox(BoxName.inbox);

      var inbox = await _inboxBox?.getAllMap();

      if (animateDelay) {
        // add null ke streamcontroller biar nanti UI bisa kasih action progress circular
        if (type == null) {
          _obsBox[-1].add(null);
        } else {
          _obsBox[type.index].add(null);
        }
        // tambahin delay 500 ms
        await Future.delayed(const Duration(milliseconds: 500));
      }
      // do somework
      if (clearCache) {
        if (type == null) {
          // clear inbox
          await _inboxBox?.clearBox();
        } else {
          inbox?.forEach((key, v) async {
            Map params = jsonDecode(v["params"]);
            if (enumFromString(params["type"], InboxType.values) == type) {
              _inboxBox?.delete(key);
            }
          });
          await InboxModel.instance.synchronizeInbox(type: type);
        }
      }

      if (inbox!.values.isEmpty ||
          inbox.values.where((v) {
            Map params = jsonDecode(v["params"]);
            if (enumFromString(params["type"], InboxType.values) == type) {
              return true;
            } else {
              return false;
            }
          }).isEmpty) {
        // fetch data dari server
        await InboxModel.instance.synchronizeInbox(type: type);
      }

      if (load) {
        // fetch data dari server
        await InboxModel.instance.synchronizeInbox(
            type: type, loaded: inbox.values.map((v) => v["id"]).toList());
      }

      // sort data sebelum ditampilkan
      Map? sortedData = sortInbox(Map.fromIterable(inbox.values.where((v) {
        Map params = jsonDecode(v["params"]);
        if (enumFromString(params["type"], InboxType.values) == type ||
            type == null) {
          return true;
        } else {
          return false;
        }
      }), key: (v) => v["id"]));

      if (type == null) {
        // masukkan ke streamcontroller
        _obsBox[-1].add(sortedData);
      } else {
        _obsBox[type.index].add(sortedData);
      }
    } catch (xerr) {
      if (type == null) {
        // masukkan ke streamcontroller
        _obsBox[-1].addError(xerr);
      } else {
        _obsBox[type.index].addError(xerr);
      }
    }
  }

  Future<void> removeInboxAsync({int inboxid = 0, animateDelay = true}) async {
    try {
      SharedBoxHelper? _inboxBox = SharedHelper.instance.getBox(BoxName.inbox);

      // var inbox = await _inboxBox.getAllMap();

      if (animateDelay) {
        // add null ke streamcontroller biar nanti UI bisa kasih action progress circular
        _obsBox.forEach((k, v) {
          v.add(null);
        });
        // tambahin delay 500 ms
        await Future.delayed(const Duration(milliseconds: 500));
      }

      Map? itemInbox = await _inboxBox?.getMap(inboxid.toString());
      Map params = jsonDecode(itemInbox?["params"]);
      List<InboxTag> tags = [];
      if (params.containsKey("tags") && params["tags"] is List) {
        tags = (params["tags"] as List)
            .map((tag) => enumFromString(tag, InboxTag.values))
            .toList();
      }

      // do some work...
      await deleteInboxMessageOnServer(inboxid);
      _inboxBox?.delete(inboxid.toString());

      for (InboxTag tag in tags) {
        await refreshAllBoxNewAsync(
            clearCache: false, animateDelay: false, type: tag);
      }
    } catch (xerr) {
      _obsBox.forEach((k, v) {
        v.addError(xerr);
      });
    }
  }

  Map? sortInbox(Map data) {
    try {
      var sortedKeys = data.keys.toList(growable: false)
        ..sort((k1, k2) => data[k2]["created"].compareTo(data[k1]["created"]));
      LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys,
          key: (k) => k, value: (k) => data[k]);
      return sortedMap;
    } catch (xerr) {}
    return null;
  }

  Future<bool> deleteInboxMessageOnServer(int inboxid) async {
    Response res;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = Duration(milliseconds: 30000);
    Map data;
    int reqNo = 0;
    do {
      reqNo++;
      String? token = await UserModel.instance.getUserToken();
      dio.options.headers = {"Authorization": "Bearer " + token!};
      Map postParam = {"deleted": 1, "id": inboxid};
      res = await dio.post(getHostName() + "/traders/api/v1/my-inbox/delete/",
          data: postParam);
      data = res.data;

      if (data.containsKey("error")) {
        if (data["error"] == "UnauthorizedError" && reqNo == 1) {
          await UserModel.instance.refreshLogin();
          continue;
        } else {
          throw Exception("${data["error"]}: ${data["message"]}");
        }
      }
      break;
    } while (reqNo < 2);

    if (!data.containsKey("error")) {
      await updateInboxCountAsync();
      return true;
    }

    return false;
  }

  Future<bool> setReadInboxMessageOnServer(int inboxid) async {
    if (appStateController.users.value.id > 0) {
      Map data = await TF2Request.authorizeRequest(
          url: getHostName() + "/traders/api/v1/my-inbox/read/",
          method: 'POST',
          postParam: {"baca": 1, "id": inboxid});

      if (data.containsKey("error")) {
        return false;
      }
    }

    // buat inbox count guest
    SharedBoxHelper? cache = SharedHelper.instance.getBox(BoxName.cache);
    Map? inboxRead = await cache?.getMap(CacheKey.inboxRead);
    inboxRead ??= {};
    inboxRead[inboxid.toString()] = 1;
    await cache?.putMap(CacheKey.inboxRead, inboxRead);

    SharedBoxHelper? box = SharedHelper.instance.getBox(BoxName.inbox);
    Map? itemInbox = await box?.getMap(inboxid.toString());
    itemInbox?["baca"] = 1;
    await box?.put(inboxid.toString(), jsonEncode(itemInbox));
    Map params = jsonDecode(itemInbox?["params"]);
    List<InboxTag> tags = [];
    if (params.containsKey("tags") && params["tags"] is List) {
      tags = (params["tags"] as List)
          .map((tag) => enumFromString(tag, InboxTag.values))
          .toList();
    }
    for (InboxTag tag in tags) {
      await refreshAllBoxNewAsync(
          clearCache: false, animateDelay: false, type: tag);
    }
    await updateInboxCountAsync();
    return true;
  }

  Future<bool> setReadAllInboxMessageOnServer() async {
    Map data = await TF2Request.authorizeRequest(
        url: getHostName() + "/traders/api/v1/my-inbox/read/all/",
        method: 'POST',
        postParam: {"baca": 1});

    if (!data.containsKey("error")) {
      _obsBox.forEach((key, value) async {
        await refreshAllBoxNewAsync(
            clearCache: true, animateDelay: false, type: InboxTag.values[key]);
      });
      await updateInboxCountAsync();
      return true;
    }

    return false;
  }

  Future<int> synchronizeInbox(
      {int limit = 10, List<dynamic>? loaded, InboxType? type}) async {
    Map postParam = {"limit": limit};
    if (loaded != null) {
      postParam["loaded"] = loaded;
    }
    if (type != null) {
      postParam["type"] = enumToString(type);
    }

    Map data = await TF2Request.authorizeRequest(
        method: 'POST',
        url: getHostName() + "/traders/api/v1/my-inbox/",
        postParam: postParam);

    if (!data.containsKey("error") &&
        data.containsKey("message") &&
        data["message"] is List) {
      int msglength = data["message"].length;
      if (msglength == 0) {
        return 0;
      } else {
        int success = 0;
        for (int i = 0; i < msglength; i++) {
          if ((data["message"][i] is Map)) {
            throw Exception("INVALID_INBOX_DATA_RESPONSE");
          }
          Map row = data["message"][i];
          if (!row.containsKey("msgid") ||
              !row.containsKey("message") ||
              !row.containsKey("params") ||
              !row.containsKey("baca")) {
            throw Exception("INVALID_INBOX_DATA_RESPONSE");
          }
          // update inbox...
          if (await updateInboxAsync(
              id: row["msgid"],
              title: row["title"],
              description: row["description"],
              message: row["message"],
              params: row["params"],
              baca: row["baca"],
              created: row["tm_created"])) {
            success++;
          }
        }
        await updateInboxCountAsync();
        return success;
      }
    }

    return 0;
  }

  Future<void> refreshAllBoxNewAsync(
      {clearCache = true,
      animateDelay = true,
      load = false,
      InboxTag? type}) async {
    try {
      if (type == null) {
        _obsBox.forEach((key, value) async {
          await refreshAllBoxNewAsync(type: InboxTag.values[key]);
        });
        return;
      }

      SharedBoxHelper? _inboxBox = SharedHelper.instance.getBox(BoxName.inbox);

      var inbox = await _inboxBox?.getAllMap();

      if (animateDelay) {
        // add null ke streamcontroller biar nanti UI bisa kasih action progress circular
        if (type == null) {
          _obsBox[-1].add(null);
        } else {
          _obsBox[type.index].add(null);
        }
        // tambahin delay 500 ms
        await Future.delayed(const Duration(milliseconds: 500));
      }
      // do somework
      if (clearCache) {
        if (type == null) {
          // clear inbox
          await _inboxBox?.clearBox();
        } else {
          inbox?.forEach((key, v) async {
            Map params = jsonDecode(v["params"]);
            List<InboxTag> tags = [];
            if (params.containsKey("tags") && params["tags"] is List) {
              tags = (params["tags"] as List)
                  .map((tag) => enumFromString(tag, InboxTag.values))
                  .toList();
            }
            if (tags.contains(type)) {
              _inboxBox?.delete(key);
            }
          });
          await InboxModel.instance.synchronizeInboxNew(type: type);
        }
      }

      if (inbox!.values.isEmpty ||
          inbox.values.where((v) {
            Map params = jsonDecode(v["params"]);
            List<InboxTag> tags = [];

            if (params.containsKey("tags") && params["tags"] is List) {
              tags = (params["tags"] as List)
                  .map((tag) => enumFromString(tag, InboxTag.values))
                  .toList();
            }

            if (tags.contains(type) || type == null) {
              return true;
            } else {
              return false;
            }
          }).isEmpty) {
        // fetch data dari server
        await InboxModel.instance.synchronizeInboxNew(type: type);
      }

      if (load) {
        // fetch data dari server
        await InboxModel.instance.synchronizeInboxNew(
            type: type, loaded: inbox.values.map((v) => v["id"]).toList());
      }

      inbox = await _inboxBox?.getAllMap();

      // sort data sebelum ditampilkan
      Map? sortedData = sortInbox(Map.fromIterable(
          inbox!.values.where((v) {
            Map params = jsonDecode(v["params"]);
            List<InboxTag> tags = [];

            if (params.containsKey("tags") && params["tags"] is List) {
              tags = (params["tags"] as List)
                  .map((tag) => enumFromString(tag, InboxTag.values))
                  .toList();
            }

            if (tags.contains(type) || type == null) {
              return true;
            } else {
              return false;
            }
          }),
          key: (v) => v["id"]));

      if (type == null) {
        // masukkan ke streamcontroller
        _obsBox[-1].add(sortedData);
      } else if (_obsBox.containsKey(type.index)) {
        _obsBox[type.index].add(sortedData);
      }
    } catch (xerr) {
      if (type == null) {
        // masukkan ke streamcontroller
        _obsBox[-1].addError(xerr);
      } else if (_obsBox.containsKey(type.index)) {
        _obsBox[type.index].addError(xerr);
      }
    }
  }

  Future<int> synchronizeInboxNew(
      {int limit = 10, List<dynamic>? loaded, InboxTag? type}) async {
    Map postParam = {"limit": limit};
    if (loaded != null) {
      postParam["loaded"] = loaded;
    }
    if (type != null) {
      postParam["type"] = enumToString(type);
    }

    Map data;

    if (appStateController.users.value.id > 0) {
      data = await TF2Request.authorizeRequest(
          method: 'POST',
          url: getHostName() + "/traders/api/v2/my-inbox/",
          postParam: postParam);
    } else {
      data = await TF2Request.request(
          method: 'POST',
          url: getHostName() + "/traders/api/v2/inbox/",
          postParam: postParam);
    }

    if (!data.containsKey("error") &&
        data.containsKey("message") &&
        data["message"] is List) {
      int msglength = data["message"].length;
      if (msglength == 0) {
        return 0;
      } else {
        int success = 0;
        for (int i = 0; i < msglength; i++) {
          if (data["message"][i] is Map) {
            throw Exception("INVALID_INBOX_DATA_RESPONSE");
          }
          Map row = data["message"][i];
          if (!row.containsKey("msgid") ||
              !row.containsKey("message") ||
              !row.containsKey("params") ||
              !row.containsKey("baca")) {
            throw Exception("INVALID_INBOX_DATA_RESPONSE");
          }
          // update inbox...
          if (await updateInboxAsync(
              id: row["msgid"],
              title: row["title"],
              description: row["description"],
              message: row["message"],
              params: row["params"],
              baca: row["baca"],
              created: row["tm_created"])) {
            success++;
          }
        }
        await updateInboxCountAsync();
        return success;
      }
    }

    return 0;
  }

  Future<bool> updateInboxAsync(
      {int? id,
      String? title,
      String? description,
      String? message,
      String? params,
      int? baca,
      int? created}) async {
    SharedBoxHelper? box = SharedHelper.instance.getBox(BoxName.inbox);
    await box?.put(
        id.toString(),
        jsonEncode({
          "id": id,
          "title": title,
          "description": description,
          "message": message,
          "params": params,
          "baca": baca,
          "created": created
        }));

    String lastInbox = await getCfgAsync("lastInbox") ?? "0";
    int tsLastInbox = int.tryParse(lastInbox) ?? 0;
    if (tsLastInbox < created!) {
      await updateCfgAsync("lastInbox", created.toString());
    }
    return true;
  }

  Future<void> updateInboxCountAsync() async {
    if (UserModel.instance.hasLogin()) {
      Map data = await TF2Request.authorizeRequest(
          method: 'GET',
          url: getHostName() + "/traders/api/v2/my-inbox/unread/tag/");
      if (!data.containsKey("error") &&
          data.containsKey("message") &&
          data["message"] is Map) {
        appStateController.setAppState(
            Operation.setInboxCountTag, InboxCount.fromMap(data["message"]));
      }
    } else {
      SharedBoxHelper? box = SharedHelper.instance.getBox(BoxName.inbox);

      Map inboxRead = await getInboxRead();

      var inboxes = await box?.getAllMap();

      var inboxCount = InboxCount.init();

      inboxes?.forEach((key, value) {
        if (inboxRead.containsKey(value["id"].toString()) &&
            inboxRead[value["id"].toString()] == 1) {
        } else {
          Map params = jsonDecode(value["params"]);
          if (params.containsKey("tag") && params["tags"] is List) {
            for (var tag in params["tags"]) {
              var tg = enumFromString(tag, InboxTag.values);
              switch (tg) {
                case InboxTag.important:
                  inboxCount.important++;
                  break;
                case InboxTag.must:
                  inboxCount.mustRead++;
                  break;
                case InboxTag.trending:
                  inboxCount.trending++;
                  break;
                case InboxTag.updates:
                  break;
                case InboxTag.payment:
                  inboxCount.payment++;
                  break;
              }
            }
          }
        }
      });

      appStateController.setAppState(Operation.setInboxCountTag, inboxCount);
    }
  }

  Future<Map> getInboxRead() async {
    SharedBoxHelper? cache = SharedHelper.instance.getBox(BoxName.cache);

    Map? inboxRead = await cache?.getMap(CacheKey.inboxRead);

    inboxRead = inboxRead ?? {};
    return inboxRead;
  }
}
