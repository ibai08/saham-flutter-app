import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/signalDetailController.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/function/helper.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/widgets/info.dart';

import '../../../function/showAlert.dart';
import '../../../models/signal.dart';
import '../../widgets/dialogConfirmation.dart';
import '../../widgets/dialogLoading.dart';

class SignalDetail extends StatelessWidget {
  final SignalDetailController controller = Get.put(SignalDetailController());

  SignalDetail({Key? key}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return Obx(() {
      String appTitle = controller.signalCon.value == null ? "Loading..." : controller.signalCon.value!.symbol!;
      Widget bottomSheet, body;
      if (controller.signalCon.value == null && !controller.signalConError.value) {
        bottomSheet = const Center(
          child: Text(
            "Tunggu ya..!!",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
        );
      }
      if (controller.signalConError.value) {
        appTitle = "Oops.. ada Error..";
        bottomSheet = Info(
          title: "Duh...",
          desc: translateFromPattern(controller.errorStatus!.value),
          caption: "Kembali",
          iconButton: Image.asset(
            "assets/icon-refresh.png",
            width: 17,
            height: 17,
          ),
          colorCaption: Colors.black,
          onTap: () {
            Get.back();
          },
        );
        if (controller.errorStatus!.value.contains("REQUESTED_SIGNAL_NOT_FOUND")) {
        bottomSheet = Info(
          title: "Trade Signal tidak ditemukan",
          desc: "Anda tidak memiliki otorisasi untuk melihat signal ini, atau signal sudah terhapus dari sistem...",
          caption: "Kembali",
          iconButton: Image.asset(
            "assets/icon-refresh.png",
            width: 17,
            height: 17,
          ),
          colorCaption: Colors.black,
          onTap: () {
            Get.back();
          },
        );
        } else if (controller.errorStatus!.value.contains("CHANNEL_NOT_FOUND")) {
          bottomSheet = Info(
            title: "Trade Signal tidak ditemukan",
            desc: "Anda tidak memiliki otorisasi untuk melihat signal ini, atau signal sudah terhapus dari sistem...",
            caption: "Kembali",
            iconButton: Image.asset(
              "assets/icon-refresh.png",
              width: 17,
              height: 17,
            ),
            colorCaption: Colors.black,
            onTap: () {
              Get.back();
            },
          );
        } else if (controller.errorStatus!.value.contains("CHANNEL_NOT_SUBSCRIBED")) {
          List detail = controller.errorStatus!.value.split(": ");
          bottomSheet = Info(
            title: "Subscribe channel ini untuk melihat signal",
            desc: "Anda tidak memiliki otorisasi untuk melihat signal ini, silahkan subscribe untuk melihat signal",
            caption: "Lihat Channel",
            iconButton: Image.asset(
              "assets/icon-refresh.png",
              width: 17,
              height: 17,
            ),
            colorCaption: Colors.black,
            onTap: () {
              if (detail.length >= 4) {
                Get.offAndToNamed("/dsc/channels/", arguments: int.parse(detail[3]));
              } else {
                Get.back();
              }
            },
          );
        }
      }

      String txtDialog = "";
      String txt = "COPY SIGNAL";
      Color txtColors = Colors.white;
      Color btnColor = AppColors.primaryGreen;
      Color bgTxtColor = AppColors.accentRed;
      Color txtColor = AppColors.white;
      double safePadding = 120;
      bool isRunning = false;
      Widget editSignal = Container(
        margin: EdgeInsets.only(top: 10),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            Get.toNamed('/dsc/signal/edit',arguments: controller.signalCon.value!.id);
          },
          child: Text(
            "EDIT SIGNAL",
            style: TextStyle(
                color: AppColors.primaryYellow,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  side: BorderSide(color: AppColors.primaryYellow)),
              primary: AppColors.white2,
              padding: EdgeInsets.all(10)),
        ),
      );
      Widget cancelSignal = Container(
        margin: EdgeInsets.only(top: 10),
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () async {
            bool confirm = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => DialogConfirmation(
                      desc: "Yakin ingin membatalkan signal ini?",
                    ));
            if (confirm) {
              DialogLoading dlg = DialogLoading();
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => dlg);
              try {
                await SignalModel.instance
                    .cancelSignal(signalId: controller.signalCon.value!.id);
                
                Get.back();
                showAlert(context, LoadingState.success, "Signal berhasil dibatalkan",thens: (x) {
                  Get.back();
                });
              } catch (ex) {
                Navigator.pop(context);
                showAlert(
                  context,
                  LoadingState.error,
                  ex != null
                      ? translateFromPattern(ex.toString())
                      : translateFromPattern(ex.toString()),
                  thens: (x) {});
              }
            }
          },
          child: Text(
            controller.signalCon.value?.active == 1 ? "CANCEL SIGNAL" : "CLOSE TRADE",
            style: TextStyle(
                color: AppColors.accentRed,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                side: BorderSide(color: AppColors.primaryYellow)),
            padding: EdgeInsets.all(10),
            backgroundColor: AppColors.white2,
            side: BorderSide(
              color: AppColors.accentRed,
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
        ),
      );
      if (controller.signalCon.value != null && !controller.signalConError.value) {
        bool isExCan = true;
        if (controller.signalCon.value!.op! <= 1 && controller.signalCon.value!.closePrice == 0) {
          txt = "SIGNAL RUNNING";
          txtDialog = "Signal is running";
          txtColor = Colors.white;
          btnColor = AppColors.primaryYellow;
          safePadding = 60;
          isRunning = true;
          isExCan = false;
        } else if (controller.signalCon.value!.pips != 0) {
          txt = "LIHAT SIGNAL LAINNYA";
          txtDialog = "Signal closed with ${controller.signalCon.value!.profit! * 10000} IDR";
          txtColor = Colors.white;
          btnColor = AppColors.blue1;
          safePadding = 60;
          isExCan = false;
        } else if (controller.signalCon.value!.closePrice != 0 || controller.signalCon.valu!.active == 0 && controller.signalCon.value!.op! > 1) {
          txt = "LIHAT SIGNAL LAINNYA";
        txtDialog = "Signal is expired / canceled";
        txtColors = Colors.white;
        btnColor = AppColors.blue1;
        safePadding = 60;
        }
      }
      var dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.parse(DateTime.now().toString()).toLocal());
      var validOpenTime = controller.signalCon.value?.openTime ?? dateFormat;
      var m = DateTime.parse(controller.signalCon.value!.createdAt!).add(Duration(hours: 7));
      var expir = DateTime.parse(validOpenTime)
          .add(Duration(hours: 7, seconds: controller.signalCon.value!.expired!));
      var close;
      String closeDate = '';
      if (controller.signalCon.value?.closeTime != null) {
        close = DateTime.parse(controller.signalCon.value!.closeTime!).add(Duration(hours: 7));
        closeDate = DateFormat('dd MMM yyyy HH:mm').format(close) + " WIB";
      }
      String postedDate = DateFormat('dd MMM yyyy HH:mm').format(m) + " WIB";
      var openTime;
      String openDate = "";
      if (controller.signalCon.value?.openTime != null) {
        openTime =
            DateTime.parse(controller.signalCon.value!.openTime!).add(Duration(hours: 7));
        openDate = DateFormat('dd MMM yyyy HH:mm').format(openTime) + " WIB";
      } else {
        openTime = DateTime.parse(validOpenTime).add(Duration(hours: 7));
        openDate = DateFormat('dd MMM yyyy HH:mm').format(openTime) + " WIB";
      }

      String expiredDate = DateFormat('dd MMM yyyy HH:mm').format(expir) + " WIB";
      if (controller.signalCon.value?.expired == 0) {
        expiredDate = "Tidak ada Expired";
      }

      bottomSheet = Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        color: AppColors.white2,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                if (controller.signalCon.value!.closePrice != 0 || controller.signalCon.value!.active == 0 && controller.signalCon.value!.op! > 1) {
                  Get.toNamed('/dsc/channels/', arguments: controller.signalCon.value?.channel?.id);
                } else {
                  if (remoteConfig.getInt("can_link_mt4_to_channel") == 1 || controller.signalCon.value!.op! > 1) {
                    final result = await Get.toNamed('/dsc/copy', arguments: controller.signalCon.value);
                    if (result is bool && result == true) {
                      controller.onRefresh();
                    }
                  }
                }
              },
            )
          ]
        ),
      );
      
      return Scaffold(
        backgroundColor: AppColors.white2,
        appBar: NavTxt(title: ),
        body: ,
        bottomSheet: ,
      );
    });
  }
}