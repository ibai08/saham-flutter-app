// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../models/entities/user.dart';

enum HomeTab { home, signal, newSignal, inboxTab, setting }

class AppKeys {
  static final navKey = GlobalKey<NavigatorState>();
}


class AppStateController extends GetxController {

  Rx<UserInfo> users = UserInfo.init().obs;
  Rx<UserInfo> usersEdit = UserInfo.init().obs;
  Rx<HomeTab> homeTab = HomeTab.home.obs;

  HomeTab get currentTab => homeTab.value;

  void setHomeTab(HomeTab tab) {
    homeTab.value = tab;
  }

  void setUser(UserInfo user) {
    users.value = user;
  }

  void setUserEdit(UserInfo userEdit) {
    usersEdit.value = userEdit;
  }


  void clearState() {
    AppKeys.navKey.currentState?.popUntil((route) => route.isFirst);
    setUser(UserInfo.init());
    setUserEdit(UserInfo.init());
    setHomeTab(HomeTab.home);
  }
}