import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/summary_channels_controller.dart';
import 'package:saham_01_app/function/helper.dart';
import 'package:saham_01_app/views/pages/channels/details/component/growth_chart.dart';
import 'package:saham_01_app/views/pages/channels/details/component/sq_chart.dart';
import 'package:saham_01_app/views/pages/channels/details/component/summary_chart.dart';
import 'package:saham_01_app/views/widgets/info.dart';

class SummaryChannels extends StatelessWidget {
  SummaryChannels({Key? key}) : super(key: key);

  final SummaryChannelsController summaryChannelsController = Get.find();

  @override
  Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.only(top: 15),
        color: Colors.grey[200],
        child: Obx(() {
          if (!summaryChannelsController.hasLoad.value && !summaryChannelsController.hasError.value) {
            return const Center(
              child: Text("Tunggu Ya..."),
            );
          } else if (!summaryChannelsController.hasLoad.value && summaryChannelsController.hasError.value) {
            return Info(
              image: const SizedBox(),
              title: "Terjadi Kesalahan",
              desc: translateFromPattern(summaryChannelsController.errorMessage.value),
              onTap: summaryChannelsController.onLoading,
              caption: "Refresh",
            );
          }
            return ListView(
              shrinkWrap: true,
              children: [
                GrowthChartComponentWidget(
                  data: summaryChannelsController.chartDetail,
                  onLoading: summaryChannelsController.onLoading,
                ),
                if (summaryChannelsController.summaryDetail != null) 
                  SummaryChartWidget(
                    data: summaryChannelsController.summaryDetail,
                    onLoading: summaryChannelsController.onLoading,
                  ),
                if (summaryChannelsController.summaryDetail != null) 
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: SignalFrequencyWidget(
                      data: summaryChannelsController.summaryDetail,
                      onLoading: summaryChannelsController.onLoading,
                    ),
                  ),
                const SizedBox(
                  height: 15,
                )
              ],
            );
          }
        ),
      );
  }
}