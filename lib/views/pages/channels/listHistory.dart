// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/controller/listHistoryController.dart';
import 'package:saham_01_app/views/widgets/info.dart';

class ListHistorySignal extends StatelessWidget {
  final int channel;
  final bool subscribed;
  ListHistorySignal(this.channel, this.subscribed);

  final ListHistoryController controller = ListHistoryController();

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
            image: SizedBox(),
            title: "Tidak ada riwayat signal",
            onTap: controller.onRefresh,
            desc:
                "Data tidak ditemukan, channel ini tidak memiliki riwayat signal atau Anda belum subscribe channel ini",
          );
        }
        if (controller.hasError.value == true) {
          return ListView(
            children: <Widget>[
              Info(image: SizedBox(), onTap: controller.onLoading),
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
            children: controller
                .getSignals(controller.signalInfo!)
                .map<Widget>((signalWidget) => signalWidget as Widget)
                .toList(),
          ),
        );
      }),
    );
  }
}
