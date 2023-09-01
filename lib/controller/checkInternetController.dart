import 'dart:io';
import 'package:get/get.dart';

class CheckInternetController extends GetxController {
  RxBool internet = false.obs;

  @override
  void onInit() async {
    super.onInit();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internet.value = true;
      }
      print("connect internet");
    } on SocketException catch (_) {
      internet.value = false;
      print("Gak konek internet"); 
    }
  }
}
