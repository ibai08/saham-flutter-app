import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/inbox.dart';
import 'package:saham_01_app/models/ois.dart';

class PaymentStatusController extends GetxController {
  final RefreshController refreshController = RefreshController();
  final Rx<PaymentDetails> paymentDetail = Rx<PaymentDetails>(PaymentDetails());
  RxInt count = 0.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = "".obs;

  Future<void> refreshStatusPayment(BuildContext context) async {
    Map args = Get.arguments as Map;
    int billNo = int.parse(args["billNo"].toString());
    try {
      paymentDetail.value = await OisModel.instance.getPaymetDetail(billNo);
    } catch(er) {
      if (er.toString().contains("PendingPaymentError")) {
        Get.back();
      } else {
        hasError.value = true;
        errorMessage.value = er.toString();
        // paymentDetail.addError(er.toString());
      }
    }
  }

  onRefresh(BuildContext context) {
    refreshStatusPayment(context).then((_) {
      refreshController.refreshCompleted();
    });
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 0)).then((x) async {
      refreshStatusPayment(Get.context!).then((_) {});

      Map arg = Get.arguments;
      if (arg.containsKey("inboxid")) {
        await InboxModel.instance.setReadInboxMessageOnServer(arg["inboxid"]);
      }
    });
  }
}