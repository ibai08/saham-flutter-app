import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saham_01_app/core/http.dart';


class FAuth {
  static final FAuth instance = FAuth._internal();

  FirebaseAuth fauth = FirebaseAuth.instance;
  FAuth._internal();

  Future<String> getFirebaseCustomToken() async {
    Map data = await TF2Request.authorizeRequest(
      url: getHostName() + "/traders/api/v1/fb-custom-token/",
      method: 'POST',
      postParam: {
        "fcm": await FCM
      }
    )
  }
}