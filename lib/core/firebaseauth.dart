import 'package:firebase_auth/firebase_auth.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/core/device.dart';
import 'package:saham_01_app/core/firebasecm.dart';
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
        "fcm": await FCM.instance.getToken(),
        "devid": await DeviceInfo.getId()
      }
    );

    return data["message"];
  }

  Future<void> signInWithCustomToken() async {
    String token = await getFirebaseCustomToken();
    UserCredential fb = await fauth.signInWithCustomToken(token);
    int userid = int.tryParse(fb.user!.uid) ?? 0;

    if (userid < 1) {
      throw Exception("INVALID_CUSTOM_TOKEN");
    }

    String? fcmToken = await FCM.instance.getToken();
    appStateController?.setAppState(Operation.setFCMToken, fcmToken);
  }


}