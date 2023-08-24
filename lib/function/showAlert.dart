// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../views/widgets/dialogLoading.dart';

showAlert(BuildContext context, LoadingState? state, String caps,
    {FutureOr<dynamic> Function(dynamic)? thens}) {
  // DialogLoading load = DialogLoading();
  state ??= LoadingState.success;
  thens ??= (x) => Future.value(null);
  final DialogLoadingController dialogLoadingController =
      Get.find<DialogLoadingController>();
  dialogLoadingController.setProgress(state, caps);
  print("state: $state");
  print("capse: $caps");
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return DialogLoading();
      }).then(thens);
}
