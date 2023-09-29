// ignore_for_file: sized_box_for_whitespace, unnecessary_string_escapes, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../controller/sqChartController.dart';
import '../../../../../models/entities/ois.dart';
import '../../../../../views/widgets/info.dart';
import '../../../../../views/widgets/tileBox.dart';

class SignalFrequencyWidget extends StatelessWidget {
  final ChannelSummaryDetail? data;
  final Function? onLoading;
  final bool isAllTime;

  final SignalFrequencyController controller =
      Get.put(SignalFrequencyController());

  SignalFrequencyWidget(
      {Key? key, this.data, this.onLoading, this.isAllTime = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.setChannelDetail(data!);
    return Obx(() {
      if (controller.channelDetail == null) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: const Center(
            child: Text(
              "Tunggu ya..!!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        );
      }
      Rx<ChannelSummaryDetail?>? sDetail = controller.channelDetail;
      if (sDetail!.value!.signalCount! < 1) {
        return ListView(
          children: <Widget>[
            Info(
              image: const SizedBox(),
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
            isAllTime
                ? "Summary Channel Beta Version"
                : "Summary Channel Official Version",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Container(
            width: double.infinity,
            height: 80,
            margin: const EdgeInsets.only(bottom: 0, top: 10),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 15, right: 15),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 200,
                    child: TileBox(
                      title: "Total P/L (Profit)",
                      subtitle: sDetail.value!.pips! / 10 >= 1 ||
                              sDetail.value!.pips! / 10 <= -1
                          ? NumberFormat("#,###.0", "ID")
                              .format(sDetail.value!.pips! / 10)
                          : sDetail.value!.avgPips!.toStringAsFixed(1),
                    ),
                  ),
                  Container(
                    width: 200,
                    child: TileBox(
                      title: "Avg. Profit",
                      subtitle: sDetail.value!.avgPips! / 10 >= 1 ||
                              sDetail.value!.avgPips! / 10 <= -1
                          ? NumberFormat("#,###.0", "ID")
                              .format(sDetail.value!.avgPips! / 10)
                          : sDetail.value!.avgPips!.toStringAsFixed(1),
                      txtColor: sDetail.value!.avgPips! > 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  Container(
                    width: 200,
                    child: TileBox(
                      title: "Average Monthly (Profit)",
                      subtitle: sDetail.value!.avgPipsMonthly! / 10 >= 1 ||
                              sDetail.value!.avgPipsMonthly! / 10 <= -1
                          ? NumberFormat("#,###.0", "ID")
                              .format(sDetail.value!.avgPipsMonthly! / 10)
                          : sDetail.value!.avgPipsMonthly!.toStringAsFixed(1),
                      txtColor: sDetail.value!.avgPipsMonthly! > 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  Container(
                    width: 200,
                    child: TileBox(
                      title: "Gross Profit",
                      subtitle:
                          "\IDR ${NumberFormat("#,###.##", "ID").format(sDetail.value!.profitTotal! * 10000)}",
                      txtColor: Colors.green,
                    ),
                  ),
                  Container(
                    width: 200,
                    child: TileBox(
                      title: "Loss Profit",
                      subtitle:
                          "\IDR ${NumberFormat("#,###.##", "ID").format(sDetail.value!.lossTotal! * 10000)}",
                      txtColor: Colors.red,
                    ),
                  ),
                  Container(
                    width: 230,
                    child: TileBox(
                      title: "Consecutive Profit",
                      subtitle:
                          "${sDetail.value!.consecutiveProfitCount}x (\IDR ${NumberFormat("#,###.##", "ID").format(sDetail.value!.consecutiveProfitSum! * 10000)})",
                      txtColor: Colors.green,
                    ),
                  ),
                  Container(
                    width: 230,
                    child: TileBox(
                      trailing: const Text(""),
                      title: "Consecutive Loss",
                      subtitle:
                          "${sDetail.value!.consecutiveLossCount}x (\IDR ${NumberFormat("#,###.##", "ID").format(sDetail.value!.consecutiveLossSum! * 10000)})",
                      txtColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
