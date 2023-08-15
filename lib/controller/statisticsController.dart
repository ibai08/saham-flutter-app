import 'package:get/get.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/models/entities/ois.dart';

class StatisticsChannelController extends GetxController {
  final Rx<ChannelStat?>? statChannelObs = Rx<ChannelStat?>(null);
  late ChannelStat channelStat;

  final RxInt channel = 0.obs;

  RxBool hasError = false.obs;

  void setChannelValue(int value) {
    channel.value = value;
  }

  void onLoading() async {
    try {
      channelStat = await ChannelModel.instance.getStatistic(channel.value);
      statChannelObs?.update((val) {
        val?.listSymbolStat = channelStat.listSymbolStat;
      });
    } catch (e) {
      statChannelObs?.addError(e);
      hasError.value = true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    onLoading();
  }
}