import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/summaryChannelsController.dart';
import 'package:saham_01_app/function/helper.dart';
import 'package:saham_01_app/views/pages/channels/details/component/growthChart.dart';
import 'package:saham_01_app/views/pages/channels/details/component/sqChart.dart';
import 'package:saham_01_app/views/pages/channels/details/component/summaryChart.dart';
import 'package:saham_01_app/views/widgets/info.dart';

class SummaryChannels extends StatelessWidget {
  final int channel;
  final DateTime createdTime;

  final SummaryChannelsController summaryChannelsController = Get.put(SummaryChannelsController());

  SummaryChannels(this.channel, this.createdTime);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      color: Colors.grey[200],
      child: summaryChannelsController.hasError == ''
        ? ListView(
          shrinkWrap: true,
          children: [
            GrowthChartComponentWidget(
              data: summaryChannelsController.chartDetail,
              onLoading: summaryChannelsController.onLoading,
            ),
            if (summaryChannelsController.summaryDetail != null) 
              SummaryChartWidget(data: summaryChannelsController.summaryDetail, onLoading: summaryChannelsController.onLoading),
            if (summaryChannelsController.summaryDetail != null) 
              Container(
                margin: EdgeInsets.only(top: 20),
                child: SignalFrequencyWidget(
                  data: summaryChannelsController.summaryDetail, onLoading: summaryChannelsController.onLoading,
                ),
              )
          ],
        ) : Info(
          image: SizedBox(),
          title: "Terjadi Kesalahan",
          desc: translateFromPattern(summaryChannelsController.hasError),
          onTap: summaryChannelsController.onLoading,
        )
    );
  }
}