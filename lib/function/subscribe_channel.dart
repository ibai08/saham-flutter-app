// ignore_for_file: avoid_print, unnecessary_cast, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/controller/channel_detail_controller.dart';
import 'package:saham_01_app/views/widgets/get_alert.dart';
import '../../function/helper.dart';
import '../../models/channel.dart';
import '../../models/entities/ois.dart';
import '../../models/ois.dart';
import '../views/widgets/dialog_confirmation.dart';
import '../views/widgets/dialog_token_subscription.dart';
import 'package:get/get.dart';

Future<void> subscribe(ChannelCardSlim channel, BuildContext context,
    RefreshController? refreshController) async {
  final DialogController dialogController = Get.find();
  // DialogLoading dlg = DialogLoading();
  // showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return dlg;
  //     });
  dialogController.setProgress(LoadingState.progress, "Mohon Tunggu",  null, null, null);
  try {
    /// TODOs: Ganti alert jadi GetALert
    await OisModel.instance.subscribe(channel);
    Get.back();
    // showAlert(context, LoadingState.success, "Subscribe Berhasil");
    dialogController.setProgress(LoadingState.success, "Subscribe Berhasil", null, null, null);
    // dlg.setProgress(LoadingState.success, "Subscribe Berhasil");
    // await Future.delayed(Duration(seconds: 2));
  } catch (xerr) {
    if (xerr.toString().contains("CHANNEL_IS_NOT_FREE")) {
      Get.back();
      await confirmPayment(channel, context, refreshController);
    } else if (xerr.toString().contains("CHANNEL_IS_PRIVATE")) {
      Get.back();
      DialogTokenSubscription dialogToken =
          DialogTokenSubscription(channel: channel);
      await showDialog(context: context, builder: (ctx) => dialogToken);
      refreshController?.requestRefresh(needMove: false);
    } else {
      Get.back();
      dialogController.setProgress(LoadingState.error, translateFromPattern(xerr.toString()), null, null, null);
      // showAlert(
      //     context, LoadingState.error, translateFromPattern(xerr.toString()));
      // dlg.setError(xerr.message);
      // await Future.delayed(Duration(seconds: 2));
      // Navigator.pop(context);
    }
  }
}

Future<void> confirmPayment(ChannelCardSlim channel, BuildContext context,
    RefreshController? refreshController) async {
  final DialogController dialogController = Get.find();
  bool confirmPay;
  if (channel.subscribed!) {
    confirmPay = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const DialogConfirmation(
            desc: "Yakin ingin mensubscribe channel ini?"));
  } else {
    confirmPay = true;
  }
  if (confirmPay) {
    int? paymentPendingId = await OisModel.instance.isPending();
    if (paymentPendingId != null) {
      await Navigator.popAndPushNamed(context, '/dsc/payment/status',
          arguments: {
            "billNo": paymentPendingId,
            "message": "Pending Payment"
          });
    } else {
      // DialogLoading dlg = DialogLoading();
      dialogController.setProgress(LoadingState.progress, "Mohon Tunggu", null, null, null);
      try {
        // showDialog(
        //     context: context,
        //     barrierDismissible: false,
        //     builder: (context) {
        //       return dlg;
        //     }).catchError((err) {
        //   throw err;
        // });

        channel =
            await ChannelModel.instance.getDetail(channel.id, clearCache: true);
        await Navigator.pushNamed(context, "/dsc/payment", arguments: channel);
        // Navigator.pop(context);
        Get.back();
      } catch (ex) {
        // Navigator.pop(context);
        Get.back();
        dialogController.setProgress(LoadingState.error, translateFromPattern(ex.toString()), null, null, null);
        // showAlert(
        //     context, LoadingState.error, translateFromPattern(ex.toString()));
      }
    }
  }
}

subcribeChannel(ChannelCardSlim channels, BuildContext context,
    RefreshController? refreshController) async {
  final DialogController dialogController = Get.find();
  if (channels.subscribed!) {
    //UNSUBSCRIBE
    int lanjut = 0;
    try {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return DialogConfirmation(
              desc:
                  "Anda sudah subscribe channel ini, yakin ingin unsubscribe?",
              action: () {
                lanjut = 1;
                // Navigator.pop(context);
                Get.back();
              },
              caps: "Unsubs",
            );
          });
      print("Sukses unsubscribe");
    } catch (e) {
      print(e);
      print("gagal unsub");
      // Navigator.pop(context);
      Get.back();
    }

    if (lanjut == 0) return;

    // DialogLoading dlg = DialogLoading();
    dialogController.setProgress(LoadingState.progress, "Mohon Tunggu", null, null, null);
    try {
      // showDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (context) {
      //       return dlg as Widget;
      //     }).catchError((err) {
      //   throw err;
      // });
      await OisModel.instance.unSubscribe(channels);
      if (refreshController != null) {
        print("kena");
        print(ModalRoute.of(context)?.settings.name);
        if (ModalRoute.of(context)!.settings.name == '/dsc/channels') {
          ChannelDetailController channelDetailController = Get.find();
          await channelDetailController.refreshController.requestRefresh(needMove: false);
        }
        await refreshController.requestRefresh(needMove: false);
      }

      // Navigator.pop(context);
      Get.back();
      // showAlert(
      //     context, LoadingState.success, "Berhenti berlangganan berhasil");
      dialogController.setProgress(LoadingState.success, "Berhenti berlangganan berhasil", null, null, null);
      // await Future.delayed(const Duration(seconds: 2));
      Get.back();
      // dlg.setProgress(LoadingState.success, "Berhenti berlangganan berhasil");
      // Navigator.pop(context);
    } catch (xerr) {
      // Navigator.pop(context);
      // showAlert(
      //     context, LoadingState.error, translateFromPattern(xerr.toString()));
      Get.back();
      dialogController.setProgress(LoadingState.error, translateFromPattern(xerr.toString()), null, null, null);
      // dlg.setError(xerr.message);
      // await Future.delayed(Duration(seconds: 2));
      // Navigator.pop(context);
    }
  } else {
    //SUBSCRIBE
    try {
      await subscribe(channels, context, refreshController);
      print("cekkk");
      if (refreshController != null) {
        if (ModalRoute.of(context)!.settings.name == '/dsc/channels') {
          ChannelDetailController channelDetailController = Get.find();
          print("kenaa");
          await channelDetailController.refreshController.requestRefresh(needMove: false);
        }
        refreshController.requestRefresh(needMove: false);
      }
    } catch (e) {
      print(e);
      // Navigator.pop(context);
    }
  }
}
