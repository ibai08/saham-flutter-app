// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/models/entities/ois.dart';

class MySubscriptionController extends GetxController {
  final RxBool hasError = false.obs;
  final RxBool hasLoad = false.obs;
  final RxString errorMessage =  "".obs;
  final Rx<List<ChannelCardSlim>> mySubsController = Rx<List<ChannelCardSlim>>([]);
  final TextEditingController filterChannel = TextEditingController();
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  late List<ChannelCardSlim> allChannel;

  void onRefresh() async {
    try {
      allChannel = await ChannelModel.instance.getMySubscriptions(clearCache: true);
      filterSubs(filterChannel.text);
      refreshController.refreshCompleted();
      hasError.value = false;
      errorMessage.value = "";
    } catch(err) {
      hasError.value = true;
      errorMessage.value = err.toString();
      refreshController.loadFailed();
    }
  }

  void tapCallback() async {
    try {
      allChannel = await ChannelModel.instance.getMySubscriptions();
      filterSubs(filterChannel.text);
      refreshController.refreshCompleted();
      hasError.value = false;
      errorMessage.value = "";
    } catch(err) {
      hasError.value = true;
      errorMessage.value = err.toString();
      refreshController.loadFailed();
    }
  }

  void filterSubs(String text) {
    if (allChannel != null || allChannel != []) {
      List<ChannelCardSlim> filtered = allChannel;
      if (text != "") {
        filtered = allChannel.where((subscription) {
          return subscription.name!.toLowerCase().contains(text.toLowerCase());
        }).toList();
      }
      mySubsController.value = filtered;
    }
  }

  @override
  void onInit() {
    super.onInit();
    ChannelModel.instance.getMySubscriptions().then((value) async {
      if (value.length == 0) {
        value = await ChannelModel.instance.getMySubscriptions(clearCache: true);
      }
      allChannel = value;
      filterSubs("");
      mySubsController.value = allChannel;
      hasLoad.value = true;
      hasError.value = false;
      errorMessage.value = "";
    }).catchError((err) {
      hasLoad.value = false;
      hasError.value = true;
      errorMessage.value = err.toString();
    });
  }
}