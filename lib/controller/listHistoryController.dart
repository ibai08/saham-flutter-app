import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/signal.dart';
import 'package:saham_01_app/views/widgets/signalDetail.dart';

class ListHistoryController extends GetxController {
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final RxList<SignalInfo>? signalInfo = RxList<SignalInfo>([]);
  List<SignalInfo> listSignal = [];
  RxInt channels = 0.obs;
  RxBool subscribed = false.obs;
  RxBool hasError = false.obs;

  void setChannels(int channel) {
    channels.value = channel;
  }

  void setSubscribed(bool subs) {
    subscribed.value = subs;
  }

  List<SignalDetailWidget> getSignals(List<SignalInfo> cc) {
    List<SignalDetailWidget> result = [];
    cc.forEach((signal) {
      DateTime expir = DateTime.parse(signal.openTime!).add(Duration(hours: 7, seconds: signal.expired!));
      DateTime dtCloseTime = DateTime.parse(signal.closeTime!).add(Duration(hours: 7));
      String expiredDate = DateFormat('dd MMM yyyy HH:mm').format(expir);
      String closeTimed = DateFormat('dd MMM yyyy HH:mm').format(dtCloseTime);
      String createdAt = DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(signal.createdAt!).add(Duration(hours: 7)));
      String openTimed = DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(signal.openTime!).add(Duration(hours: 7)));
      int status = signal.active!;
      if (signal.expired == 0) {
        expiredDate = "Tidak ada expired";
      }
      if (expir.isAfter(dtCloseTime) && signal.pips == 0) {
        status = 3;
      }
      try {
        result.add(SignalDetailWidget(
          expired: expiredDate + " WIB",
          closeTime: closeTimed + " WIB",
          openTime: openTimed + " WIB",
          createdAt: createdAt + " WIB",
          price: signal.price,
          sl: subscribed.value ? signal.sl : 0,
          tp: subscribed.value ? signal.tp : 0,
          symbol: signal.symbol,
          status: status,
          pips: signal.pips,
          profit: signal.profit,
          type: getTradeCommandString(signal.op!),
        ));
      } catch (e) {

      }
    });
    return result;
  }

  void onLoading() async {
    int offset = 0;
    try {
      offset = listSignal.length;
      List<SignalInfo> activeSignal = await SignalModel.instance.getChannelSignals(channels.value, 1, offset);
      if (activeSignal.length > 0) {
        listSignal.addAll(activeSignal);
        signalInfo?.addAll(listSignal);
        refreshController.loadComplete();
      } else {
        signalInfo?.addAll(listSignal);
        refreshController.loadNoData();
      }
    } catch (xerr) {
      if (offset == 0) {
        hasError.value = true;
      }
      refreshController.loadFailed();
    }
  }

  void onRefresh() async {
    listSignal.clear();
    try {
      List<SignalInfo> activeSignal = await SignalModel.instance.getChannelSignals(channels.value, 1, 0);
      if (activeSignal.length > 0) {
        listSignal.addAll(activeSignal);
        signalInfo?.addAll(listSignal);
      } else {
        signalInfo?.addAll(listSignal);
      }
      refreshController.refreshCompleted();
    } catch (xerr) {
      refreshController.refreshCompleted();
    }
  }

  @override
  void onInit() {
    super.onInit();
    onLoading;
  }
}