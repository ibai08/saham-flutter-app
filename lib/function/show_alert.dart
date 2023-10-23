// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import '../views/widgets/dialog_loading.dart';

showAlert(BuildContext context, LoadingState? state, String caps,
    {FutureOr<dynamic> Function(dynamic)? thens}) {
  // DialogLoading load = DialogLoading();
  state ??= LoadingState.success;
  thens ??= (x) => Future.value(null);

  DialogLoading load = DialogLoading();
  load.loadingController.setProgress(state, caps);
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return load;
      }).then((result) {
        thens;
      });
}
