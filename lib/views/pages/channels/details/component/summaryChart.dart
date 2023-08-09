import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/summaryChartControllers.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/views/pages/channels/details/charts/frequence.dart';
import 'package:saham_01_app/views/widgets/info.dart';

class SummaryChartWidget extends StatelessWidget {
  final SummaryChartController controller = Get.put(SummaryChartController());
  final ChannelSummaryDetail? data;
  final Function? onLoading;
  final bool? isAlltime;
  SummaryChartWidget({Key? key, this.data, this.onLoading, this.isAlltime = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.setSummaryDetail(data!);
    return Container(
      child: Obx(() {
        if (controller.channelSummaryDetail == null) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: const Center(
              child: Text(
                "Tunggu ya..!!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )
            ),
          );
        }
        Rx<ChannelSummaryDetail?>? sDetail = controller.channelSummaryDetail;
        var official = [];
        var beta = [];
        sDetail?.value?.signalCount == 773 ? official.add(sDetail) : beta.add(sDetail);
        if (sDetail!.value!.signalCount! < 1) {
          return ListView(
            children: <Widget>[
              Info(
                image: SizedBox(),
                title: "Tidak ada Summary",
                desc: "Signal terlalu sedikit",
                onTap: onLoading,
              )
            ],
          );
        }
        return Column(
          children: <Widget>[
            Text(
              isAlltime! ? 'Signal Frequency Beta Version' : 'Signal Frequency Official Version',
              style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              width: double.infinity,
              height: 200,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SignalFrequence(sDetail),
            )
          ],
        );
      }),
    );
  }
}