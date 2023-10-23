import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/beta/binding/add_signal_binding.dart';
import 'package:saham_01_app/beta/binding/beranda_binding.dart';
import 'package:saham_01_app/beta/binding/explore_binding.dart';
import 'package:saham_01_app/controller/app_state_controller.dart';
import 'package:saham_01_app/views/pages/add_new_signal.dart';
import 'package:saham_01_app/views/pages/home.dart';
import 'package:saham_01_app/views/pages/market.dart';
import 'package:saham_01_app/views/pages/setting.dart';
import 'package:saham_01_app/views/pages/signal_page.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  static HomeController get to => Get.find();

  late TabController tabController;

  Rx<HomeTab> tab = Rx<HomeTab>(HomeTab.home);

  var currentIndex = 0.obs;

  final pages = <String>['/beranda', '/explore', '/addsignal', '/market', '/settings'];

  void changePage(int index) {
    currentIndex.value = index;
    FirebaseCrashlytics.instance.log("Home Screen: ${HomeTab.values[index]}");
    tab.value = HomeTab.values[index];
    tabController.animateTo(index);
    Get.offAndToNamed(pages[index]);
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == "/beranda") {
      return GetPageRoute(
        settings: settings,
        page: () => Home(),
        binding: BerandaBinding()
      );
    }
    if (settings.name == "/explore") {
      return GetPageRoute(
        settings: settings,
        page: () => SignalDashboard(),
        binding: ExploreBinding()
      );
    }
    if (settings.name == "/addsignal") {
      return GetPageRoute(
        settings: settings,
        page: () => AddNewSignal(),
        binding: AddSignalBinding()
      );
    }
    if (settings.name == "/market") {
      return GetPageRoute(
        settings: settings,
        page: () => const  MarketPage()
      );
    }
    if (settings.name == "/settings") {
      return GetPageRoute(
        settings: settings,
        page: () => Setting()
      );
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: pages.length, vsync: this);
    tabController.animateTo(tab.value.index);
  }
}