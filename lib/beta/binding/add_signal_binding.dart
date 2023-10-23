import 'package:get/get.dart';
import 'package:saham_01_app/controller/new_signal_controller.dart';

class AddSignalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewSignalController());
  }
}