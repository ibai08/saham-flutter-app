import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/core/msgdef.dart';
import 'package:saham_01_app/function/helper.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/models/entities/inbox.dart';
import 'package:saham_01_app/models/inbox.dart';
import 'package:saham_01_app/models/signal.dart';
import 'package:saham_01_app/models/user.dart';

enum MessageEvent {
  onMessage,
  onResume,
  onLaunch,
  onBackgroundMessage,
  onLocalNotif
}

class MessageProcessor {
  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    Map data = message.data;
    if (!data.containsKey("cmd")) {
      throw Exception("UNKNOWN_COMMAND");
    }
  }

  static Future<void> onMessage(MessageEvent event, RemoteMessage message) async {
    Map data = message.data;

    if(!data.containsKey("cmd")) {
      throw Exception("UNKNOWN_COMMAND");
    }
    String cmd = data["cmd"];
    switch(cmd) {
      case MessageDefinition.logout:
        await UserModel.instance.logout(destroyToken: false);
        break;
      case MessageDefinition.updateSignal:
      case MessageDefinition.newSignal:
        {
          int signalid = int.tryParse(data["signalid"].toString()) ?? 0;

          if (cmd == MessageDefinition.updateSignal) {
            SignalModel.instance.deleteSignalCache(signalid);
          }

          if (event == MessageEvent.onResume || event == MessageEvent.onLaunch || event == MessageEvent.onLocalNotif) {
            if (signalid == 0) {
              return;
            }
            if (event == MessageEvent.onLaunch) {
              await Future.delayed(Duration(seconds: 2));
            }
            appStateController?.setAppState(Operation.pushNamed, {"route": "/dsc/signal/", "arguments": signalid});
          } else if (event == MessageEvent.onMessage) {

          }
          InboxModel.instance.refreshAllBoxAsync(clearCache: true);
        }
        break;
      case MessageDefinition.paymentChannelSucceed:
        {
          int channelid = int.tryParse(data["channelid"].toString()) ?? 0;
          ChannelModel.instance.getDetail(channelid, clearCache: true);

          if (event == MessageEvent.onResume || event == MessageEvent.onLaunch || event == MessageEvent.onLocalNotif) {
            if (channelid == 0) {
              return;
            }
            if (event == MessageEvent.onLaunch) {
              await Future.delayed(Duration(seconds: 2));
            }

            appStateController?.setAppState(Operation.pushNamed, {"route": "/dsc/signal/", "arguments": channelid});
          } else if (event == MessageEvent.onMessage) {

          }
        }
        break;
      case MessageDefinition.mrgDepoVerifyRefuse:
      case MessageDefinition.mrgWDVerifySuccess:
      case MessageDefinition.mrgWDVerifyRefuse:
        {
          InboxModel.instance.refreshAllBoxAsync(clearCache: true);
          MrgModel.getLatestTransactions(clearCache: true);
          MrgModel.fetchUserData();

          if (event == MessageEvent.onResume || event == MessageEvent.onLaunch || event == MessageEvent.onLocalNotif) {
            if (event == MessageEvent.onLaunch) {
              await Future.delayed(Duration(seconds: 2));
            }
            appStateController?.setAppState(Operation.pushNamed, {"route": "/more/mrg"});
          } else if (event == MessageEvent.onMessage) {

          }
        }
        break;
      case MessageDefinition.askapDepoVerifySuccess:
      case MessageDefinition.askapDepoVerifyRefuse:
      case MessageDefinition.askapWDVerifySuccess:
      case MessageDefinition.askapWDVerifyRefuse:
        {
          InboxModel.instance.refreshAllBoxAsync(clearCache: true);
          AskapModel.getLatestTransactions(clearCache: true);
          AskapModel.fetchUserData();

          if (event == MessageEvent.onResume || event == MessageEvent.onLaunch || event == MessageEvent.onLocalNotif) {
            if (event == MessageEvent.onLaunch) {
              await Future.delayed(Duration(seconds: 2));
            }
            appStateController?.setAppState(Operation.pushNamed, {"route": "/more/askap"});
          } else if (event == MessageEvent.onMessage) {

          }
        }
        break;
      case MessageDefinition.newInbox: 
        {
          if (event == MessageEvent.onResume || event == MessageEvent.onLaunch || event == MessageEvent.onLocalNotif) {
            if (event == MessageEvent.onLaunch) {
              await Future.delayed(Duration(seconds: 2));
            }

            appStateController?.setAppState(Operation.bringToHome, HomeTab.home);

            String inboxType = data["inboxType"];
            InboxType type = enumFromString(inboxType, InboxType.values);
            int inboxId = int.tryParse(data["inboxId"]) ?? 0;

            if (inboxId > 0 && type != null) {
              await InboxModel.instance.refreshInboxByIdAsync(id: inboxId);
              Map? valueMap = await InboxModel.instance.getBox().getMap(inboxId.toString());

              switch (type) {
                case InboxType.wptfpost:
                  Map message = jsonDecode(valueMap["message"]);
                  appStateController?.setAppState(Operation.pushNamed, {
                    "route": '/inbox/wptfpost',
                    "arguments": {
                      "inboxid": valueMap["id"],
                      "postid": message["postId"]
                    }
                  });
                  break;
                case InboxType.html:
                  appStateController?.setAppState(Operation.bringToHome, {
                    "route": '/inbox/html',
                    "arguments": valueMap
                  });
                  break;
                case InboxType.signal:
                  Map tmpData = jsonDecode(valueMap["message"]);
                  Map params = jsonDecode(valueMap["params"]);

                  if (params is Map && params.containsKey("type") && params["type"] == "signal") {
                    int signalid = 0;
                    if (tmpData["signalid"] is String || tmpData["signalid"] is int) {
                      signalid = int.tryParse(tmpData["signalid"].toString()) ?? 0;
                    }
                    appStateController?.setAppState(Operation.pushNamed, {
                      "route": '/dsc/signal',
                      "arguments": {
                        "signalid": signalid,
                        "inboxid": valueMap["id"],
                        "baca": valueMap["baca"]
                      }
                    });
                  }
                  break;
                case InboxType.payment:
                  Map message = jsonDecode(valueMap["message"]);
                  appStateController?.setAppState(Operation.pushNamed, {
                    "route": '/dsc/payment/status',
                    "arguments": {
                      "inboxid": valueMap["id"],
                      "billNo": message["billNo"]
                    }
                  });
                  break;
              }
            }
          } else if (event == MessageEvent.onMessage) {

          }
        }
        break;
        default:
        break;
    }
  }
}