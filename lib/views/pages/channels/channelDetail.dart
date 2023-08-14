import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/controller/channelDetailController.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/pages/channels/details/summary.dart';
import 'package:saham_01_app/views/pages/channels/listActive.dart';
import 'package:saham_01_app/views/pages/channels/listHistory.dart';

class ChannelDetail extends StatelessWidget {
  final ChannelDetailController controller = Get.put(ChannelDetailController());

  final AppStateController appStateController = Get.put(AppStateController());

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments is int) {
      controller.channel = ModalRoute.of(context)?.settings.arguments as int;
      controller.getChannel();
    }

    return Scaffold(
        appBar: NavTxt.getx(title: controller.titleObs),
        body: Obx(() {
          if (controller.channelObs == null) {
            return const Center(
              child: Text(
                "Tunggi ya..!!",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            );
          }
          if (controller.hasError.value) {
            return const Center(
              child: Text(
                "Maaf.. data tidak ditemukan",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            );
          }
          controller.tabController =
              TabController(length: 4, vsync: controller);
          List<Widget> tabs = [
            Tab(
              text: "SUMMARY",
            ),
            Tab(
              text: "ACTIVE SIGNAL",
            ),
            Tab(
              text: "HISTORY SIGNAL",
            ),
            Tab(
              text: "STATISTICS",
            ),
          ];
          if (controller.channelDetail.username !=
                  appStateController.users.value.username &&
              controller.channelDetail.isPrivate! &&
              !controller.channelDetail.subscribed!) {
            controller.tabController =
                TabController(length: 1, vsync: controller);
            tabs = [
              Tab(
                text: "CONTACT",
              )
            ];
          }
          List<Widget> tabsView = [
            SummaryChannels(
                controller.channel, controller.channelObs!.value!.createdTime!),
            ListActiveSignal(
                controller.channel,
                controller.channelObs?.value?.subscribed != null ||
                    controller.channelObs?.value?.username ==
                        appStateController.users.value.username),
            ListHistorySignal(
                controller.channel,
                controller.channelObs!.value!.subscribed! ||
                    controller.channelObs!.value!.username ==
                        appStateController.users.value.username),
          ];

          return Text("");
        }));
  }
}
