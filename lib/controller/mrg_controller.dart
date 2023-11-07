import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/controller/app_state_controller.dart';
import 'package:saham_01_app/models/entities/mrg.dart';
import 'package:saham_01_app/models/mrg.dart';
import 'package:saham_01_app/views/widgets/list_tile_action.dart';

import '../views/widgets/list_tile_history.dart';

class MrgController extends GetxController {
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final AppStateController appStateController = Get.find();
  ScrollController scrollController = ScrollController();
  Rx<Color> col = Colors.transparent.obs;
  List<ListTileAction> listRealAccount = [];
  List<ListTileHistory> listHistory = [];

  RxBool isLoading = true.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = "".obs;

  refreshList(UserMRG userMRG) {
    listRealAccount = userMRG.realAccounts!.asMap().map((index, RealAccMrg map) {
      return MapEntry(index, ListTileAction(no: index + 1, data: map));
    }).values.toList();
    listHistory = userMRG.transactions!.map((UserTransactionsMrg map) {
      return ListTileHistory(
        symbol: (map.tipe! < 2 ? "Rp" : "\$"),
        date: map.date?.toLocal().toString(),
        amount: map.nominal,
        status: map.status,
        type: map.tipe,
        no: map.mt4id,
      );
    }).toList();
  }

  scrollListener() {
    if(scrollController.offset <= scrollController.position.minScrollExtent && !scrollController.position.outOfRange) {
      col.value = Colors.white;
    } else {
      col.value = Colors.white.withOpacity(0.0);
    }
  }

  void onRefresh() async {
    await MrgModel.fetchUserData(clearCache: true);
    refreshController.refreshCompleted();
  }

  @override
  void onInit() {
    Future.delayed(const Duration(milliseconds: 0)).then((_) async {
      if (appStateController.users.value.id > 0 && !appStateController.users.value.isProfileComplete() && appStateController.users.value.verify!) {
        Get.offAndToNamed("/forms/editprofile");
        return;
      } else if (appStateController.users.value.id < 1 || !appStateController.users.value.verify!) {
        Get.offAndToNamed("/forms/login");
        return;
      }
      try {
        print("proses1");
        await MrgModel.fetchUserData();
        print("proses2");
        isLoading.value = false;
        print("proses3");
      } catch(e, stack) {
        hasError.value = true;
        errorMessage.value = e.toString();
        // print(e);
        print(stack);
      }
    });

    scrollController.addListener(scrollListener);
    col.value = Colors.white;
    super.onInit();
  }
}