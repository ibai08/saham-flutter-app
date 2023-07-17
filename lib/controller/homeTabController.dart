import 'package:get/get.dart';
import 'package:saham_01_app/utils/store/route.dart';

class HomeTabController extends GetxController {
  var homeTab = HomeTab.home.obs;

  void setHomeTab(HomeTab tab) {
    homeTab.value = tab;
  }

  HomeTab get currentTab => homeTab.value;
}