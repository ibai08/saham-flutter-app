// ignore_for_file: prefer_is_empty, file_names, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../controller/list_history_controller_old.dart';
import '../../../../models/entities/ois.dart';
import '../../../../views/widgets/info.dart';
import '../../../widgets/signal_detail.dart';

class ListHistorySignal extends StatelessWidget {
  final int channel;
  final bool subscribed;
  ListHistorySignal(this.channel, this.subscribed, {Key? key}) : super(key: key);

  final ListHistoryController controller = Get.find();

  List<Widget> getSignals(List<SignalInfo> cc) {
    List<Widget> result = [];
    cc.forEach((signal) {
      DateTime expir = DateTime.parse(signal.openTime!)
          .add(Duration(hours: 7, seconds: signal.expired!));
      DateTime dtCloseTime =
          DateTime.parse(signal.closeTime!).add(const Duration(hours: 7));
      String expiredDate = DateFormat('dd MMM yyyy HH:mm').format(expir);
      String closeTimed = DateFormat('dd MMM yyyy HH:mm').format(dtCloseTime);
      String createdAt = DateFormat('dd MMM yyyy HH:mm')
          .format(DateTime.parse(signal.createdAt!).add(const Duration(hours: 7)));
      String openTimed = DateFormat('dd MMM yyyy HH:mm')
          .format(DateTime.parse(signal.openTime!).add(const Duration(hours: 7)));
      int status = signal.active!;
      if (signal.expired == 0) {
        expiredDate = "Tidak ada expired";
      }
      if (expir.isAfter(dtCloseTime) && signal.pips == 0) {
        status = 3;
      }
      try {
        result.add(SignalDetailWidget(
          expired: expiredDate + " WIB",
          closeTime: closeTimed + " WIB",
          openTime: openTimed + " WIB",
          createdAt: createdAt + " WIB",
          price: signal.price,
          sl: subscribed ? signal.sl : 0,
          tp: subscribed ? signal.tp : 0,
          symbol: signal.symbol,
          status: status,
          pips: signal.pips,
          profit: signal.profit,
          type: getTradeCommandString(signal.op!),
        ));
      } catch (_) {}
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      color: Colors.grey[200],
      child: Obx(() {
        if (controller.signalInfo == null &&
            !controller.hasError.value == true) {
          return const Center(
              child: Text(
            "Tunggu ya..!!",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ));
        }
        if (controller.signalInfo?.length == 0 &&
            !controller.hasError.value == true) {
          return Info(
            image: const SizedBox(),
            title: "Tidak ada riwayat signal",
            onTap: controller.onRefresh,
            desc:
                "Data tidak ditemukan, channel ini tidak memiliki riwayat signal atau Anda belum subscribe channel ini",
          );
        }
        if (controller.hasError.value == true) {
          return ListView(
            children: <Widget>[
              Info(image: const SizedBox(), onTap: controller.onLoading),
            ],
          );
        }
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: controller.signalInfo!.length > 4 ? true : false,
          controller: controller.refreshController,
          onLoading: controller.onLoading,
          onRefresh: controller.onRefresh,
          child: ListView(
            children: getSignals(controller.signalInfo!).map<Widget>((e) => e).toList(),
          ),
        );
      }),
    );
  }
}
