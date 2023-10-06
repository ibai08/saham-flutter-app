import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/controller/listActiveNewController.dart';
import 'package:saham_01_app/views/widgets/signalDetail.dart';

import '../../../../models/entities/ois.dart';
import '../../../widgets/info.dart';

class ListActiveSignal extends StatelessWidget {
  ListActiveSignal({Key? key}) : super(key: key);

  final ListActiveController controller = Get.find();

  List<Widget> getSignals(List<SignalInfo> cc) {
    List<Widget> result = [];
    cc.forEach((signal) {
      DateTime expire = DateTime.parse(signal.createdAt!).add(Duration(hours: 7, seconds: signal.expired!));
      DateTime created = DateTime.parse(signal.createdAt!).add(const Duration(hours: 7));
      String expiredDate = DateFormat('dd MMM yyyy HH:mm').format(expire) + " WIB";
      String createdAt = DateFormat('dd MMM yyyy HH:mm').format(created) + " WIB";
      String dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.parse(DateTime.now().toString()).toLocal());
      String validOpenTime = signal.openTime ?? dateFormat;
      String openTime = DateFormat("dd MMM yyyy HH:mm").format(DateTime.parse(validOpenTime).add(Duration(hours: 7))) + " WIB";
      if (signal.expired == 0) {
        expiredDate = "Tidak ada expired";
      }
      int status = signal.active!;
      if (signal.op == 1 || signal.op == 0) {
        status = 2;
      }
      result.add(SignalDetailWidget(
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
    return result;
  }

  @override
  Widget build(BuildContext context) {
    print(controller.subscribed.value);
    return Container(
      padding: const EdgeInsets.only(top: 15),
      color: Colors.grey[200],
      child: Obx(() {
        if (controller.hasLoad.value == false && controller.hasError.value == false) {
          return const Center(
            child: Text(
              "Tunggu ya..!!",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
              ),
            ),
          );
        }
        if (controller.subscribed.value == false) {
          return Info(
            image: const SizedBox(),
            title: "Belum Subscribe",
            onTap: controller.onRefresh,
            desc: "Anda belum subscribe channel ini",
          );
        }
        if (controller.hasError.value == false && controller.hasLoad.value == true && controller.noActiveSignal.value == true) {
          return Info(
            image: const SizedBox(),
            title: "Tidak ada active signal",
            onTap: controller.onRefresh,
            desc: "Data tidak ditemukan, channel ini tidak memiliki active signal",
          );
        }
        if (controller.hasError.value == true && controller.hasLoad.value == false) {
          return Info(
            image: const SizedBox(),
            title: "Terjadi Error",
            onTap: controller.onRefresh,
            desc: controller.errorMessage.value,
          );
        }

        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: controller.signalInfo.value.length > 4 ? true : false,
          controller: controller.refreshController,
          onLoading: controller.onLoading,
          onRefresh: controller.onRefresh,
          child: ListView(
            children: getSignals(controller.signalInfo.value),
          ),
        );
      }),
    );
  }
}