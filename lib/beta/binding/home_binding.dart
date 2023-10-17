import 'package:get/get.dart';
import 'package:saham_01_app/beta/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}