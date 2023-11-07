import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/models/entities/ois.dart';

class MySubscriberController extends GetxController {
  RefreshController refreshController = RefreshController(initialRefresh: false);
  Rx<List<ChannelSubscriber>> subsController =  Rx<List<ChannelSubscriber>>([]);
  late List<ChannelSubscriber> allSubscriber;
  late List<ChannelSubscriber> filteredSubscriber;
  final TextEditingController filterUsername = TextEditingController();
  RxBool hasError = false.obs;
  RxString errorMessage = "".obs;
  RxBool hasLoad = false.obs;

  void onRefresh() async {
    try {
      allSubscriber = await ChannelModel.instance.getMySubscribers(clearCache: true);
      filterSubs(filterUsername.text);
      refreshController.refreshCompleted();
      hasError.value = false;
      errorMessage.value = "";
    } catch(e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      refreshController.refreshFailed();
    }
  }

  filterSubs(text) {
    if (allSubscriber != null || allSubscriber != []) {
      filteredSubscriber = allSubscriber;
      if (text != "") {
        filteredSubscriber = allSubscriber.where((test) => test.username!.contains(text)).toList();
      }
      subsController.value = filteredSubscriber;
    }
  }

  @override
  void onInit() {
    ChannelModel.instance.getMySubscribers().then((subs) {
      allSubscriber = subs;
      filterSubs("");
      subsController.value = allSubscriber;
      hasLoad.value = true;
    }).catchError((err) {
      hasError.value = true;
      errorMessage.value = err.toString();
      hasLoad.value = false;
    });
    super.onInit();
  }
}