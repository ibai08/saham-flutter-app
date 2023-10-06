import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/controller/listHistoryNewController.dart';
import 'package:saham_01_app/views/widgets/signalDetail.dart';

import '../../../../models/entities/ois.dart';
import '../../../widgets/info.dart';

class ListHistorySignal extends StatelessWidget {
  ListHistorySignal({Key? key}) : super(key: key);

  final ListHistoryController controller = Get.find();

  List<Widget> getSignals(List<SignalInfo> cc) {
    List<Widget> result = [];
    cc.forEach((signal) {
      try {
      DateTime expire = DateTime.parse(signal.openTime!).add(Duration(hours: 7, seconds: signal.expired!));
      DateTime dtCloseTime = DateTime.parse(signal.closeTime!).add(const Duration(hours: 7));
      String expiredDate = DateFormat("dd MMM yyyy HH:mm").format(expire);
      String closeTime = DateFormat("dd MMM yyyy HH:mm").format(dtCloseTime);
      String createdAt = DateFormat("dd MMM yyyy HH:mm").format(DateTime.parse(signal.createdAt!).add(const Duration(hours: 7)));
      String openTimed = DateFormat("dd MMM yyyy HH:mm").format(DateTime.parse(signal.openTime!).add(const Duration(hours: 7)));
      int status = signal.active!;
      if (signal.expired == 0) {
        expiredDate = "Tidak ada expired";
      }
      if (expire.isAfter(dtCloseTime) && signal.pips == 0) {
        status = 3;
      }
      result.add(SignalDetailWidget(
        expired: expiredDate + " WIB",
        closeTime: closeTime + " WIB",
        openTime: openTimed + " WIB",
        createdAt: createdAt + " WIB",
        price: signal.price,
        sl: controller.subscribed.value ? signal.sl : 0,
        tp: controller.subscribed.value ? signal.tp : 0,
        symbol: signal.symbol,
        status: status,
        pips: signal.pips,
        profit: signal.profit,
        type: getTradeCommandString(signal.op!),
      ));
      } catch (e, stack) {
        print("error: $e");
        print("stack: $stack");
      }
      
    });
    return result;
  }
  

  @override
  Widget build(BuildContext context) {
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
        if (controller.hasError.value == false && controller.hasLoad.value == true && controller.noActiveSignal.value == true) {
          return Center(
            child: Info(
              image: const SizedBox(),
              title: "Tidak ada riwayat signal",
              onTap: controller.onRefresh,
              desc: "Data tidak ditemukan, channel ini tidak memiliki riwayat signal atau Anda belum subscribe channel ini",
            ),
          );
        }
        if (controller.hasError.value == true && controller.hasLoad.value == false) {
          return Center(
            child: Info(
              image: const SizedBox(),
              title: "Terjadi Error",
              onTap: controller.onRefresh,
              desc: controller.errorMessage.value,
            ),
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