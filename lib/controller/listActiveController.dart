import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/entities/ois.dart';
import '../../models/signal.dart';
import '../../views/widgets/signalDetail.dart';

class ListActiveController extends GetxController {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final RxList<SignalInfo>? signalInfo = RxList<SignalInfo>([]);
  List<SignalInfo> listSignal = [];
  RxInt channels = 0.obs;

  RxBool hasError = false.obs;

  void setChannels(int channel) {
    channels.value = channel;
  }

  List<SignalDetailWidget> getSignals(List<SignalInfo> cc) {
    List<SignalDetailWidget> results = [];
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

  void onLoading() async {
    int offset = 0;
    try {
      offset = listSignal.length;
      List<SignalInfo> activeSignal = await SignalModel.instance
          .getChannelSignals(channels.value, 1, offset);
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
      List<SignalInfo> activeSignal =
          await SignalModel.instance.getChannelSignals(channels.value, 1, 0);
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
