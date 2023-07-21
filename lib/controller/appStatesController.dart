// ignore: file_names
// ignore_for_file: prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/models/entities/firebase.dart';
import 'package:saham_01_app/models/entities/mrg.dart';


import '../models/entities/user.dart';

enum Operation {
  setUser,
  setNewVillage,
  clearState,
  updateAvatar,
  setFCMToken,
  bringToHome,
  setUserMRG,
  setOisSearch,
  setUserAskap,
  pushNamed,
  setInboxCount,
  setInboxCountTag,
}

enum HomeTab { home, signal, newSignal, inboxTab, setting }

class AppKeys {
  static final navKey = GlobalKey<NavigatorState>();
}

class AppStateController extends GetxController {

  Rx<UserInfo> users = UserInfo.init().obs;
  Rx<UserInfo> usersEdit = UserInfo.init().obs;
  Rx<HomeTab> homeTab = HomeTab.home.obs;
  Rx<UserMRG> userMrg = UserMRG.init().obs;

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

  void setAppState(Operation operation, dynamic payload) {
    switch (operation) {
      case Operation.setUser:
        if (payload is Map && payload.containsKey("user") && payload["user"] is Map) {
          setUser(UserInfo.fromMap(payload["user"]));
          setUserEdit(UserInfo.fromMap(payload["user"]));
        } else {
          setUser(UserInfo.init());
          setUserEdit(UserInfo.init());
          setHomeTab(HomeTab.home);
        }
        break;

      case Operation.setNewVillage:
        if (payload is Map &&
            payload.containsKey("village") &&
            payload.containsKey("villageid") &&
            users.value.id! > 0) {
          usersEdit.update((user) {
            user?.village = payload["village"];
            user?.villageid = payload["villageid"];
          });
        }
        break;
        
      case Operation.clearState:
        final newRouteName = "/home";
        bool isFirst = false;

        AppKeys.navKey.currentState?.popUntil((route) {
          isFirst = route.isFirst;
          return true;
        });

        if (!isFirst) {
          AppKeys.navKey.currentState?.popUntil(ModalRoute.withName(newRouteName));
        }

        setUser(UserInfo.init());
        setUserEdit(UserInfo.init());
        setHomeTab(HomeTab.home);
        break;

      case Operation.updateAvatar:
        if (payload is Map && payload.containsKey("avatar") && users.value.id! > 0) {
          usersEdit.update((user) {
            user?.avatar = payload["avatar"];
          });
        }
        break;

      case Operation.setFCMToken:
        if(payload is String) {
          FirebaseState(fcmToken: payload);
        }
        break;

      //MRG Controller
      case Operation.setUserMRG:
        if (payload is Map) {
          try {
            UserMRG.fromMap(payload);
          } catch (xerr) {}
        }
        break;

      //Hometab and navigation controller
      case Operation.bringToHome:
        Get.until((route) => route.isFirst); // Kembali ke halaman beranda
        if (payload is HomeTab) {
          setHomeTab(payload);
        }
        break;
      
      case Operation.pushNamed:
        if (payload is Map) {
          Map data = payload;
          if (data.containsKey("route")) {
            if (data.containsKey("arguments")) {
              Get.toNamed(data["route"], arguments: data["arguments"]); // Push halaman baru dengan argumen
            } else {
              Get.toNamed(data["route"]); // Push halaman baru tanpa argumen
            }
          }
        }
        break;
      default:
        break;
    }
  }

  void clearState() {
    AppKeys.navKey.currentState?.popUntil((route) => route.isFirst);
    setUser(UserInfo.init());
    setUserEdit(UserInfo.init());
    setHomeTab(HomeTab.home);
  }
}

AppStateController? appStateController;