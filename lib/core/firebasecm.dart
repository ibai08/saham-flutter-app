import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/core/http.dart';
import 'package:saham_01_app/core/msgproc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print("onBackgroundMessage: $message");
  await MessageProcessor.onBackgroundMessage(message);
  return Future<void>.value();
}

class FCM {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool init = false;
  FirebaseAuth fauth = FirebaseAuth.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static final FCM instance = FCM._internal();
  FCM._internal();

  Future<void> deleteInstanceID() {
    return _fcm.deleteToken();
  }

  Future<void> initializeFcmNotification() async {
    if(init) {
      return;
    }

    if (Platform.isIOS) {
      _fcm.requestPermission();
    }
    _saveDeviceToken();

    _fcm.onTokenRefresh.listen((newToken) async {
      try {
        print(newToken);
        await userSetFCMToken(newToken);
      } catch (x) {
        print("onTokenRefresh $x");
      }
    });

    if (Platform.isIOS) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true
      );
    } else if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max
      );

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>().createNotificationChannel(channel);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                playSound: true
              )
            )
          );
        }
      }, onError: (error) {
        print("onMessage: $error");
      });
    }

    if(Platform.isIOS) {
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onResume: $message");
      MessageProcessor.onMessage(MessageEvent.onResume, message)
          .catchError((onError) {
        print("onResume: $onError");
      });
    }, onError: (error) {
      print("onResume: $error");
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("onLaunch: $message");
      if (message != null) {
        MessageProcessor.onMessage(MessageEvent.onLaunch, message)
            .catchError((onError) {
          print("onLaunch: $onError");
        });
      }
    }, onError: (onError) {
      print("onLaunch: $onError");
    });

    await _fcm.subscribeToTopic("announcement");

    print("initializeFcmNotification Success");
    init = true;
  }

   _saveDeviceToken() async {
    await _fcm.getToken();
  }

  Future<String> getToken() {
    return _fcm.getToken();
  }

  Future<void> userSetFCMToken(String token) async {
    String userJWT = await getCfgAsync("token");
    if (userJWT != null && userJWT != '') {
      try {
        await updateCfgAsync("fcm_token", token);
        await TF2Request.authorizeRequest(
            method: 'POST',
            url: getHostName() + "/traders/api/v1/user/userSetFCMToken/",
            postParam: {"token": token});
        await updateCfgAsync("fcm_token_saved", "1");
      } catch (x) {
        print(x);
      }
    }
  }
}