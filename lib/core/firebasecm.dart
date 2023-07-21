import 'package:firebase_messaging/firebase_messaging.dart';


Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print("onBackgroundMessage: $message");
  await MessageProcessor.onBackgroundMessage(message);
  return Future<void>.value();
}