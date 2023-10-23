// ignore_for_file: prefer_is_empty, must_be_immutable, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/app_state_controller.dart';
import 'package:saham_01_app/controller/signal_detail_controller.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/function/helper.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/widgets/channel_avatar.dart';
import 'package:saham_01_app/views/widgets/expansion_tile_container.dart';
import 'package:saham_01_app/views/widgets/info.dart';
import 'package:saham_01_app/views/widgets/tile_copy_signal.dart';

import '../../../function/show_alert.dart';
import '../../../models/signal.dart';
import '../../widgets/dialog_confirmation.dart';
import '../../widgets/dialog_loading.dart';

class SignalDetail extends StatelessWidget {
  final SignalDetailController controller = Get.put(SignalDetailController());
  final AppStateController appStateController = Get.find();

  var argument = Get.arguments;

  SignalDetail({Key? key}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return Obx(() {
      // print("arguments: ${argument['signalId']}");
      if (argument != null) {
        controller.arguments = argument['signalId'];
      }

      if (controller.isInit.value != true) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      String? appTitle = controller.signalCon.value == null ? "Loading..." : controller.signalCon.value!.symbol!;
      Widget? bottomSheet, body;
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
          desc: translateFromPattern(controller.errorStatus.value),
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
        if (controller.errorStatus.value.contains("REQUESTED_SIGNAL_NOT_FOUND")) {
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
        } else if (controller.errorStatus.value.contains("CHANNEL_NOT_FOUND")) {
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
        } else if (controller.errorStatus.value.contains("CHANNEL_NOT_SUBSCRIBED")) {
          List detail = controller.errorStatus.value.split(": ");
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
                Get.offAndToNamed("/dsc/channels/", arguments: {
                  "channelId": int.parse(detail[3])
                });
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
        margin: const EdgeInsets.only(top: 10),
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
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  side: BorderSide(color: AppColors.primaryYellow)),
              primary: AppColors.white2,
              padding: const EdgeInsets.all(10)),
        ),
      );
      Widget cancelSignal = Container(
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () async {
            bool confirm = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const DialogConfirmation(
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
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                side: BorderSide(color: AppColors.primaryYellow)),
            padding: const EdgeInsets.all(10),
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
        } else if (controller.signalCon.value!.closePrice != 0 || controller.signalCon.value!.active == 0 && controller.signalCon.value!.op! > 1) {
          txt = "LIHAT SIGNAL LAINNYA";
        txtDialog = "Signal is expired / canceled";
        txtColors = Colors.white;
        btnColor = AppColors.blue1;
        safePadding = 60;
        }
        var dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.parse(DateTime.now().toString()).toLocal());
        var validOpenTime = controller.signalCon.value?.openTime ?? dateFormat;
        var m = DateTime.parse(controller.signalCon.value!.createdAt!).add(const Duration(hours: 7));
        var expir = DateTime.parse(validOpenTime)
            .add(Duration(hours: 7, seconds: controller.signalCon.value!.expired!));
        dynamic close;
        String closeDate = '';
        if (controller.signalCon.value?.closeTime != null) {
          close = DateTime.parse(controller.signalCon.value!.closeTime!).add(const Duration(hours: 7));
          closeDate = DateFormat('dd MMM yyyy HH:mm').format(close) + " WIB";
        }
        String postedDate = DateFormat('dd MMM yyyy HH:mm').format(m) + " WIB";
        dynamic openTime;
        String openDate = "";
        if (controller.signalCon.value?.openTime != null) {
          openTime =
              DateTime.parse(controller.signalCon.value!.openTime!).add(const Duration(hours: 7));
          openDate = DateFormat('dd MMM yyyy HH:mm').format(openTime) + " WIB";
        } else {
          openTime = DateTime.parse(validOpenTime).add(const Duration(hours: 7));
          openDate = DateFormat('dd MMM yyyy HH:mm').format(openTime) + " WIB";
        }

        String expiredDate = DateFormat('dd MMM yyyy HH:mm').format(expir) + " WIB";
        if (controller.signalCon.value?.expired == 0) {
          expiredDate = "Tidak ada Expired";
        }

        bottomSheet = Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: AppColors.white2,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  if (controller.signalCon.value!.closePrice != 0 || controller.signalCon.value!.active == 0 && controller.signalCon.value!.op! > 1) {
                    Get.toNamed('/dsc/channels/', arguments: {
                      "channelId": controller.signalCon.value?.channel?.id
                    });
                  } else {
                    if (remoteConfig.getInt("can_link_mt4_to_channel") == 1 || controller.signalCon.value!.op! > 1) {
                      final result = await Get.toNamed('/dsc/copy', arguments: controller.signalCon.value);
                      if (result is bool && result == true) {
                        controller.onRefresh();
                      }
                    }
                  }
                },
                child: Text(
                  txt,
                  style: TextStyle(
                    color: txtColors,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    side: BorderSide(color: btnColor),
                  ),
                  primary: btnColor,
                  padding: const EdgeInsets.all(10)
                ),
              ),
              controller.signalCon.value?.closePrice == 0 && appStateController.users.value.id == controller.signalCon.value?.channel?.userid ? Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  !isRunning ? editSignal : remoteConfig.getInt("ois_can_update_running_signal") == 1 ? editSignal : const SizedBox(),
                  !isRunning ? cancelSignal : remoteConfig.getInt("ois_can_cancel_running_signal") == 1 ? cancelSignal : const SizedBox()
                ],
              ) : const SizedBox(height: 0)
            ]
          ),
        );

        body = Obx(() {
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  color: AppColors.darkGreen,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed('/dsc/channels/', arguments: {
                        "channelId": controller.signalCon.value?.channel?.id
                      });
                    },
                    child: ListTile(
                      leading: ChannelAvatar(
                        width: 65,
                        imageUrl: controller.signalCon.value?.channel?.avatar,
                      ),
                      title: Text(
                        controller.signalCon.value != null ? controller.signalCon.value!.channel!.title! : "",
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    children: [
                      controller.signalCon.value?.closePrice != 0 || controller.signalCon.value?.active == 0 && controller.signalCon.value!.op! > 1 ? Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: bgTxtColor,
                              borderRadius: const BorderRadius.all(Radius.circular(4)), 
                            ),
                            child: Text(
                              txtDialog,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: txtColor,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          )
                        ],
                      ) : const SizedBox(),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Row(
                          children: <Widget>[
                            const Expanded(
                              flex: 3,
                              child: Text("Created at:"),
                            ),
                            Expanded(
                              flex: 7,
                              child: Text(
                                postedDate,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                      !isExCan ? Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: <Widget>[
                            const Expanded(
                              flex: 3,
                              child: Text("Opened at:"),
                            ),
                            Expanded(
                              flex: 7,
                              child: Text(
                                openDate,
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                      ) : const SizedBox(),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    controller.signalCon.value!.symbol!,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    getTradeCommandString(controller.signalCon.value!.op!),
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: <Widget>[
                                const Expanded(
                                  child: Text(
                                    "Price",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    controller.digit > -1 ? controller.signalCon.value!.price!.toStringAsFixed(controller.digit) :  controller.signalCon.value!.price.toString(),
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: <Widget>[
                                const Expanded(
                                  child: Text(
                                    "Take Profit",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    controller.digit > -1 ? controller.signalCon.value!.tp!.toStringAsFixed(controller.digit) : controller.signalCon.value!.tp.toString(),
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: <Widget>[
                                const Expanded(
                                  child: Text(
                                    "Stop Loss",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    controller.digit > -1 ? controller.signalCon.value!.sl!.toStringAsFixed(controller.digit) : controller.signalCon.value!.sl.toString(),
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                            !isRunning && controller.signalCon.value?.closeTime == null ? Container(
                              padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
                              child: Row(
                                children: <Widget>[
                                  const Expanded(
                                    flex: 3,
                                    child: Text("Expired at:"),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      expiredDate,
                                      textAlign: TextAlign.right,
                                    ),
                                  )
                                ],
                              ),
                            ) : const SizedBox(),
                            controller.signalCon.value?.closeTime != null ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              child: Row(
                                children: <Widget>[
                                  const Expanded(
                                    flex: 3,
                                    child: Text("Close at:"),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      closeDate,
                                      textAlign: TextAlign.right,
                                    ),
                                  )
                                ],
                              ),
                            ) : const SizedBox(),
                            Obx(() {
                              if (controller.listTrade.value == null && !controller.listTradeError.value) {
                                return const Center();
                              }
                              if (controller.listTradeError.value) {
                                return Center(
                                  child: Text(
                                    translateFromPattern(controller.errorStatus.value),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18
                                    ),
                                  ),
                                );
                              }
                              if (controller.listTrade.value!.length < 1) {
                                return const Center();
                              }

                              return Column(
                                children: <Widget>[
                                  ExpansionTileContainer(
                                    title: "Transaksi Signal ini",
                                    children: controller.listTrade.value!.map<TileCopySignal>((trade) => TileCopySignal(
                                      symbol: trade.symbol!,
                                      account: trade.mt4ID.toString(),
                                      date: DateTime.parse(trade.createdAt!),
                                      lot: trade.volume! / 100,
                                      name: trade.channelName!,
                                      signalId: trade.signalID!,
                                    )).toList(),
                                  )
                                ],
                              );
                            }),
                            SizedBox(
                              height: safePadding,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
      }
 
      return Scaffold(
        backgroundColor: AppColors.white2,
        appBar: NavTxt(title: appTitle),
        body: body,
        bottomSheet: bottomSheet,
      );
    });
  }
}