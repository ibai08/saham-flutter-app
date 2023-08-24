import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/summaryChannelsController.dart';
import '../../../../function/helper.dart';
import '../../../../views/pages/channels/details/component/growthChart.dart';
import '../../../../views/pages/channels/details/component/sqChart.dart';
import '../../../../views/pages/channels/details/component/summaryChart.dart';
import '../../../../views/widgets/info.dart';

class SummaryChannels extends StatelessWidget {
  final int channel;
  final DateTime createdTime;

  final SummaryChannelsController summaryChannelsController = Get.find();

  SummaryChannels(this.channel, this.createdTime);
  @override
  Widget build(BuildContext context) {
    // summaryChannelsController.updateChannelValue(channel);
    return Obx(
      () => Container(
          padding: EdgeInsets.only(top: 15),
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
                        margin: EdgeInsets.only(top: 20),
                        child: SignalFrequencyWidget(
                          data: summaryChannelsController.summaryDetail,
                          onLoading: summaryChannelsController.onLoading,
                        ),
                      )
                  ],
                )
              : summaryChannelsController.hasLoad.value == false &&
                      summaryChannelsController.hasError.value == ''
                  ? Center(
                      child: Text("Tunggu ya"),
                    )
                  : Info(
                      image: SizedBox(),
                      title: "Terjadi Kesalahan",
                      desc: translateFromPattern(
                          summaryChannelsController.hasError.value),
                      onTap: summaryChannelsController.onLoading,
                    )),
    );
  }
}
