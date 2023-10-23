import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/summary_channels_controller_old.dart';
import '../../../../function/helper.dart';
import 'component/growth_chart.dart';
import 'component/sq_chart.dart';
import 'component/summary_chart.dart';
import '../../../../views/widgets/info.dart';

class SummaryChannels extends StatelessWidget {
  final int channel;
  final DateTime createdTime;

  final SummaryChannelsController summaryChannelsController = Get.find();

  SummaryChannels(this.channel, this.createdTime, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // summaryChannelsController.updateChannelValue(channel);
    return Obx(
      () => Container(
          padding: const EdgeInsets.only(top: 15),
          color: Colors.grey[200],
          child: summaryChannelsController.hasLoad.value == true
              ? ListView(
                  shrinkWrap: true,
                  children: [
                    GrowthChartComponentWidget(
                      data: summaryChannelsController.chartDetail,
                      onLoading: summaryChannelsController.onLoading,
                    ),
                    if (summaryChannelsController.summaryDetail != null)
                      SummaryChartWidget(
                          data: summaryChannelsController.summaryDetail,
                          onLoading: summaryChannelsController.onLoading),
                    if (summaryChannelsController.summaryDetail != null)
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: SignalFrequencyWidget(
                          data: summaryChannelsController.summaryDetail,
                          onLoading: summaryChannelsController.onLoading,
                        ),
                      )
                  ],
                )
              : summaryChannelsController.hasLoad.value == false &&
                      summaryChannelsController.hasError.value == ''
                  ? const Center(
                      child: Text("Tunggu ya"),
                    )
                  : Info(
                      image: const SizedBox(),
                      title: "Terjadi Kesalahan",
                      desc: translateFromPattern(
                          summaryChannelsController.hasError.value),
                      onTap: summaryChannelsController.onLoading,
                    )),
    );
  }
}
