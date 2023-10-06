// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../controller/listActiveController.dart';
import '../../../../models/entities/ois.dart';
import '../../../../views/widgets/info.dart';
import '../../../widgets/signalDetail.dart';

class ListActiveSignal extends StatelessWidget {
  final ListActiveController controller = Get.find();

  final int channel;
  final bool subscribed;

  ListActiveSignal(this.channel, this.subscribed, {Key? key}) : super(key: key);

  List<Widget> getSignals(List<SignalInfo> cc) {
    List<Widget> results = [];
    cc.forEach((signal) {
      // print(signal.createdAt);
      // print("signal.createdAt");
      // print(signal.openTime);
      // print("signal.openTime");
      // print(signal.expired);
      // print("signal.expired");
      DateTime expir = DateTime.parse(signal.createdAt!)
          .add(Duration(hours: 7, seconds: signal.expired!));
      DateTime created =
          DateTime.parse(signal.createdAt!).add(Duration(hours: 7));
      String expiredDate =
          DateFormat('dd MMM yyyy HH:mm').format(expir) + " WIB";
      String createdAt =
          DateFormat('dd MMM yyyy HH:mm').format(created) + " WIB";
      var dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss")
          .format(DateTime.parse(DateTime.now().toString()).toLocal());
      var validOpenTime = signal.openTime ?? dateFormat;
      String openTime = DateFormat('dd MMM yyyy HH:mm')
              .format(DateTime.parse(validOpenTime).add(Duration(hours: 7))) +
          " WIB";
      if (signal.expired == 0) {
        expiredDate = "Tidak ada expired";
      }
      int status = signal.active!;
      if (signal.op == 1 || signal.op == 0) {
        status = 2;
      }
      results.add(SignalDetailWidget(
        openTime: openTime,
        createdAt: createdAt,
        expired: expiredDate,
        price: signal.price,
        sl: signal.sl,
        tp: signal.tp,
        symbol: signal.symbol,
        status: status,
        pips: signal.pips,
        type: getTradeCommandString(signal.op!),
        id: signal.id,
      ));
    });
    return results;
  }

  @override
  Widget build(BuildContext context) {
    controller.setChannels(channel);
    print("ini built oyyyy");
    return Container(
      padding: const EdgeInsets.only(top: 15),
      color: Colors.grey[200],
      child: Obx(() {
        if (controller.signalInfo == null &&
            controller.hasError.value == true) {
          print("kena ini1");
          return const Center(
            child: Text(
              "Tunggu ya..!!",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          );
        }
        if (!subscribed) {
          print("kena ini2");
          return Info(
            image: const SizedBox(),
            title: "Belum Subscribe",
            onTap: controller.onRefresh,
            desc:
                "Data tidak ditemukan, channel ini tidak memiliki active signal",
          );
        }
        if (controller.hasError.value == true) {
          print("kena ini3");
          return ListView(
            children: <Widget>[
              Info(
                onTap: controller.onLoading,
                image: const SizedBox(),
              ),
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
            children: getSignals(controller.signalInfo!).map<Widget>((e) => e as Widget).toList(),
          ),
        );
      }),
    );
  }
}
