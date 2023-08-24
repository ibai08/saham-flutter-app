import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../controller/listActiveController.dart';
import '../../../../views/widgets/info.dart';

class ListActiveSignal extends StatelessWidget {
  final ListActiveController controller = Get.put(ListActiveController());

  final int channel;
  final bool subscribed;

  ListActiveSignal(this.channel, this.subscribed);

  @override
  Widget build(BuildContext context) {
    controller.setChannels(channel);
    return Container(
      padding: const EdgeInsets.only(top: 15),
      color: Colors.grey[200],
      child: Obx(() {
        if (controller.signalInfo == null &&
            controller.hasError.value == true) {
          return const Center(
            child: Text(
              "Tunggu ya..!!",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          );
        }
        if (!subscribed) {
          return Info(
            image: const SizedBox(),
            title: "Belum Subscribe",
            onTap: controller.onRefresh,
            desc:
                "Data tidak ditemukan, channel ini tidak memiliki active signal",
          );
        }
        if (controller.hasError.value == true) {
          return ListView(
            children: <Widget>[
              Info(
                onTap: controller.onLoading,
                image: const SizedBox(),
              )
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
