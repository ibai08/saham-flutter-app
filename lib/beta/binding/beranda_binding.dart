import 'package:get/get.dart';
import 'package:saham_01_app/controller/homeTabController.dart';

class BerandaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeTabController());
  }
}