// ignore_for_file: avoid_print, unnecessary_cast

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../function/helper.dart';
import '../../function/showAlert.dart';
import '../../models/channel.dart';
import '../../models/entities/ois.dart';
import '../../models/ois.dart';
import '../../views/widgets/dialogConfirmation.dart';
import '../../views/widgets/dialogLoading.dart';
import '../../views/widgets/dialogTokenSubscription.dart';
import 'package:get/get.dart' as Get;

Future<void> subscribe(ChannelCardSlim channel, BuildContext context,
    RefreshController refreshController) async {
  DialogLoading dlg = DialogLoading();
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return dlg;
      });
  try {
    await OisModel.instance.subscribe(channel);
    Get.Get.back();
    showAlert(context, LoadingState.success, "Subscribe Berhasil");
    // dlg.setProgress(LoadingState.success, "Subscribe Berhasil");
    // await Future.delayed(Duration(seconds: 2));
  } catch (xerr) {
    if (xerr.toString().contains("CHANNEL_IS_NOT_FREE")) {
      Get.Get.back();
      await confirmPayment(channel, context, refreshController);
    } else if (xerr.toString().contains("CHANNEL_IS_PRIVATE")) {
      Get.Get.back();
      DialogTokenSubscription dialogToken =
          DialogTokenSubscription(channel: channel);
      await showDialog(context: context, builder: (ctx) => dialogToken);
      refreshController.requestRefresh(needMove: false);
    } else {
      Get.Get.back();
      showAlert(
          context, LoadingState.error, translateFromPattern(xerr.toString()));
      // dlg.setError(xerr.message);
      // await Future.delayed(Duration(seconds: 2));
      // Navigator.pop(context);
    }
  }
}

Future<void> confirmPayment(ChannelCardSlim channel, BuildContext context,
    RefreshController refreshController) async {
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
      DialogLoading dlg = DialogLoading();
      try {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return dlg;
            }).catchError((err) {
          throw err;
        });
        channel =
            await ChannelModel.instance.getDetail(channel.id, clearCache: true);
        await Navigator.pushNamed(context, "/dsc/payment", arguments: channel);
        Navigator.pop(context);
      } catch (ex) {
        Navigator.pop(context);
        showAlert(
            context, LoadingState.error, translateFromPattern(ex.toString()));
      }
    }
  }
}

subcribeChannel(ChannelCardSlim channels, BuildContext context,
    RefreshController refreshController) async {
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
                Navigator.pop(context);
              },
            );
          });
      print("Sukses unsubscribe");
    } catch (e) {
      print(e);
      print("gagal unsub");
      Navigator.pop(context);
    }

    if (lanjut == 0) return;

    DialogLoading dlg = DialogLoading();
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return dlg as Widget;
          }).catchError((err) {
        throw err;
      });
      await OisModel.instance.unSubscribe(channels);
      if (refreshController != null) {
        refreshController.requestRefresh(needMove: false);
      }

      Navigator.pop(context);
      showAlert(
          context, LoadingState.success, "Berhenti berlangganan berhasil");
      // dlg.setProgress(LoadingState.success, "Berhenti berlangganan berhasil");
      // await Future.delayed(Duration(seconds: 2));
      // Navigator.pop(context);
    } catch (xerr) {
      Navigator.pop(context);
      showAlert(
          context, LoadingState.error, translateFromPattern(xerr.toString()));
      // dlg.setError(xerr.message);
      // await Future.delayed(Duration(seconds: 2));
      // Navigator.pop(context);
    }
  } else {
    //SUBSCRIBE
    try {
      await subscribe(channels, context, refreshController);
      if (refreshController != null) {
        refreshController.requestRefresh(needMove: false);
      }
    } catch (e) {
      print(e);
      // Navigator.pop(context);
    }
  }
}
