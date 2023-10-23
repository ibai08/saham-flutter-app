import 'package:get/get.dart';
import 'package:saham_01_app/controller/signal_tab_controller.dart';

class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignalDashboardController());
  }
}