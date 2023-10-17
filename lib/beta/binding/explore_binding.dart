import 'package:get/get.dart';
import 'package:saham_01_app/controller/signalTabController.dart';

class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignalDashboardController());
  }
}